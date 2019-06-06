#! /usr/bin/env ruby
#
#   check-etcd
#
# DESCRIPTION:
#   This plugin checks that the stats/self url returns 200 OK.
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
#   Copyright 2014 Sonian, Inc. and contributors. <support@sensuapp.org>
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
class EtcdNodeStatus < Sensu::Plugin::Check::CLI
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

  option :allmembers,
         description: 'check health of all etcd members',
         long: '--all',
         short: '-a',
         default: false

  def run
    if config[:allmembers]
      members = JSON.parse(request('/v2/members', config[:server]).to_str)['members']
      bad_peers = []
      members.each do |member|
        client_host = URI.parse(member['clientURLs'][0]).host
        begin
          r = request('/health', client_host)
          unless r.code == 200 && JSON.parse(r.to_str)['health'] == 'true'
            bad_peers += [client_host]
          end
        rescue StandardError
          bad_peers += [client_host]
        end
      end
      if bad_peers.count != 0
        critical "Found bad etcd peers: #{bad_peers}"
      else
        ok 'Etcd healthly'
      end
    else
      r = request('/health', config[:server])
      if r.code == 200 && JSON.parse(r.to_str)['health'] == 'true'
        ok 'Etcd healthy'
      else
        critical 'Etcd unhealthy'
      end
    end

  rescue Errno::ECONNREFUSED => e
    critical 'Etcd is not responding' + e.message
  rescue RestClient::RequestTimeout
    critical 'Etcd Connection timed out'
  rescue StandardError => e
    unknown 'A exception occurred:' + e.message
  end

  def request(path, server)
    protocol = config[:ssl] ? 'https' : 'http'
    RestClient::Resource.new("#{protocol}://#{server}:#{config[:port]}/#{path}",
                             timeout: 5,
                             ssl_client_cert: (OpenSSL::X509::Certificate.new(File.read(config[:cert])) unless config[:cert].nil?),
                             ssl_client_key: (OpenSSL::PKey.read(File.read(config[:key]), config[:passphrase]) unless config[:key].nil?),
                             ssl_ca_file:  config[:ca],
                             verify_ssl:  config[:insecure] ? 0 : 1).get
  end
end
