#! /usr/bin/env ruby
#
#   check-flannel-subnet-count
#
# DESCRIPTION:
#   This plugin checks that the number of flannel subnets is within limits
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: rest-client
#
# USAGE:
#   #YELLOW
#
# NOTES:
#
# LICENSE:
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'rest-client'
require 'openssl'
require 'uri'
require 'json'

#
# Etcd Node Status
#
class FlannelSubnetStatus < Sensu::Plugin::Check::CLI
  option :server,
         description: 'Etcd host, defaults to localhost',
         short: '-h HOST',
         long: '--host HOST',
         default: 'localhost'

  option :port,
         description: 'Etcd port, defaults to 2379',
         short: '-p PORT',
         long: '--port PORT',
         default: '2379'

  option :cert,
         description: 'client SSL cert',
         long: '--cert CERT',
         default: nil

  option :key,
         description: 'client SSL key',
         long: '--key KEY',
         default: nil

  option :passphrase,
         description: 'passphrase of the SSL key',
         long: '--passphrase PASSPHRASE',
         default: nil

  option :ca,
         description: 'SSL CA file',
         long: '--ca CA',
         default: nil

  option :insecure,
         description: 'change SSL verify mode to false',
         long: '--insecure'

  option :ssl,
         description: 'use HTTPS (default false)',
         long: '--ssl'

  option :warncount,
         description: 'Warn when number of subnets exceeds the max minus this threshold',
         short: '-w COUNT',
         long: '--warn COUNT',
         default: 20,
         proc: proc(&:to_i)

  def run
    begin # Get the network configuration
      flannel_config = request('v2/keys/coreos.com/network/config', config[:server])
      # The value is stored as a json string within the json, so we have to parse, pull out the string and re-parse...
      num_address = JSON.parse(JSON.parse(flannel_config.to_str)['node']['value'])['Network']
      subnet_len = JSON.parse(JSON.parse(flannel_config.to_str)['node']['value'])['SubnetLen']
    rescue StandardError => e
      critical "Could not fetch network configuration: #{e.message}"
    end

    begin # Calculate the number of available subnets
      network_cidr = num_address[num_address.index('/') + 1..-1]
      num_addresses = 2**(32 - network_cidr.to_i)
      num_subnets = num_addresses / (2**(32 - subnet_len.to_i))
    rescue StandardError => e
      critical "Could not parse network configuration: #{e.message}"
    end

    begin # Calculate the  actual number of subnets in use
      data = JSON.parse(request('v2/keys/coreos.com/network/subnets', config[:server]))
      num_address_used = data['node']['nodes'].size
    rescue StandardError => e
      critical "Could not fetch subnet information: #{e.message}"
    end

    if num_address_used >= num_subnets
      critical "Number of subnets has hit max capacity. Threshold: #{num_subnets} Actual: #{num_address_used}"
    elsif num_address_used >= num_subnets - config[:warncount]
      warning "Subnet threshold count exceeded. Threshold: #{num_subnets - config[:warncount]} Actual: #{num_address_used}"
    else
      ok "Number of subnets below threshold. #{num_address_used} total subnets"
    end
  end

  def request(path, server)
    protocol = config[:ssl] ? 'https' : 'http'
    RestClient::Resource.new(
      "#{protocol}://#{server}:#{config[:port]}/#{path}",
      timeout: 5,
      ssl_client_cert: (OpenSSL::X509::Certificate.new(File.read(config[:cert])) unless config[:cert].nil?),
      ssl_client_key: (OpenSSL::PKey.read(File.read(config[:key]), config[:passphrase]) unless config[:key].nil?),
      ssl_ca_file:  config[:ca],
      verify_ssl:  config[:insecure] ? 0 : 1
    ).get
  end
end
