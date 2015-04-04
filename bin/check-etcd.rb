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

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/check/cli'
require 'rest-client'

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

  def run
    r = RestClient::Resource.new("http://#{config[:server]}:#{config[:port]}/v2/stats/self", timeout: 5).get
    if r.code == 200
      ok 'etcd is up'
    else
      critical 'Etcd is not responding'
    end
  rescue Errno::ECONNREFUSED
    critical 'Etcd is not responding'
  rescue RestClient::RequestTimeout
    critical 'Etcd Connection timed out'
  end
end
