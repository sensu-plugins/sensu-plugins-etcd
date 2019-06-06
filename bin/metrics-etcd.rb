#! /usr/bin/env ruby
#
#   etcd-metrics
#
# DESCRIPTION:
#   This plugin pulls stats out of an etcd node
#
# OUTPUT:
#    metric data
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: etcd
#
# USAGE:
#   #YELLOW
#
# NOTES:
#
# LICENSE:
#   Copyright (c) 2014, Sean Clerkin
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/metric/cli'
require 'etcd'
require 'socket'

#
# Etcd Metrics
#
class EtcdMetrics < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme',
         short: '-s SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.etcd"

  option :etcd_host,
         description: 'Etcd host, defaults to localhost',
         short: '-h HOST',
         long: '--host HOST',
         default: 'localhost'

  option :etcd_port,
         description: 'Etcd port, defaults to 2379',
         short: '-p PORT',
         long: '--port PORT',
         default: '2379'

  option :leader_stats,
         description: 'Show leader stats',
         short: '-l',
         long: '--leader-stats',
         boolean: true,
         default: false

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
    if config[:ssl]
      client = Etcd.client(
        host: config[:etcd_host],
        port: config[:etcd_port],
        use_ssl: config[:ssl],
        verify_mode: (config[:insecure] ? OpenSSL::SSL::VERIFY_NONE : OpenSSL::SSL::VERIFY_PEER),
        ca_file: config[:ca],
        ssl_cert: (OpenSSL::X509::Certificate.new(File.read(config[:cert])) unless config[:cert].nil?),
        ssl_key:  (OpenSSL::PKey.read(File.read(config[:key]), config[:passphrase]) unless config[:key].nil?)
      )
    else
      client = Etcd.client(host: config[:etcd_host], port: config[:etcd_port])
    end
    client.stats(:self).each do |k, v|
      output([config[:scheme], 'self', k].join('.'), v) if v.is_a? Integer
    end
    client.stats(:store).each do |k, v|
      output([config[:scheme], 'store', k].join('.'), v)
    end
    if config[:leader_stats]
      client.stats(:leader)['followers'].each do |follower, fv|
        fv.each do |metric, mv|
          mv.each do |submetric, sv|
            output([config[:scheme], 'leader', follower, metric, submetric].join('.'), sv)
          end
        end
      end
    end
    ok
  end
end
