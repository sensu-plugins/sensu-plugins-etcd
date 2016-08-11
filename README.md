## Sensu-Plugins-etcd

[ ![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-etcd.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-etcd)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-etcd.svg)](http://badge.fury.io/rb/sensu-plugins-etcd)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-etcd/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-etcd)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-etcd/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-etcd)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-etcd.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-etcd)

## Functionality

## Files
 * bin/check-etcd.rb
 * bin/check-etcd-peer-count.rb
 * bin/check-flannel-subnet-count.rb
 * bin/metrics-etcd.rb

## Usage

    Usage: check-etcd.rb (options)
           --ca CA                      SSL CA file
           --cert CERT                  client SSL cert
           --insecure                   change SSL verify mode to false
           --key KEY                    client SSL key
           --passphrase PASSPHRASE      passphrase of the SSL key
       -p, --port PORT                  Etcd port, defaults to 2379
       -h, --host HOST                  Etcd host, defaults to localhost
           --ssl                        use HTTPS (default false)

## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)

## Notes
