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

  def run
    protocol = config[:ssl] ? 'https' : 'http'

    r = RestClient::Resource.new("#{protocol}://#{config[:server]}:#{config[:port]}/health",
                                 timeout: 5,
                                 ssl_client_cert: (OpenSSL::X509::Certificate.new(File.read(config[:cert])) unless config[:cert].nil?),
                                 ssl_client_key: (OpenSSL::PKey::RSA.new(File.read(config[:key]), config[:passphrase]) unless config[:key].nil?),
                                 ssl_ca_file:  config[:ca],
                                 verify_ssl:  config[:insecure] ? 0 : 1
                                ).get
    if r.code == 200 && JSON.parse(r.to_str)['health'] == 'true'
      ok 'Etcd healthy'
    else
      critical 'Etcd unhealthy'
    end
  rescue Errno::ECONNREFUSED
    critical 'Etcd is not responding'
  rescue RestClient::RequestTimeout
    critical 'Etcd Connection timed out'
  end
end
