## Sensu-Plugins-etcd

[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-etcd.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-etcd)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-etcd.svg)](http://badge.fury.io/rb/sensu-plugins-etcd)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-etcd/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-etcd)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-etcd/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-etcd)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-etcd.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-etcd)

## Functionality

## Files
 * bin/check-etcd
 * bin/metrics-etcd

## Usage

## Installation

Add the public key (if you haven’t already) as a trusted certificate

```
gem cert --add <(curl -Ls https://raw.githubusercontent.com/sensu-plugins/sensu-plugins.github.io/master/certs/sensu-plugins.pem)
gem install sensu-plugins-etcd -P MediumSecurity
```

You can also download the key from /certs/ within each repository.

#### Rubygems

`gem install sensu-plugins-etcd`

#### Bundler

Add *sensu-plugins-disk-checks* to your Gemfile and run `bundle install` or `bundle update`

#### Chef

Using the Sensu **sensu_gem** LWRP
```
sensu_gem 'sensu-plugins-etcd' do
  options('--prerelease')
  version '0.0.1.alpha.4'
end
```

Using the Chef **gem_package** resource
```
gem_package 'sensu-plugins-etcd' do
  options('--prerelease')
  version '0.0.1.alpha.4'
end
```

## Notes

[1]:[https://travis-ci.org/sensu-plugins/sensu-plugins-etcd]
[2]:[http://badge.fury.io/rb/sensu-plugins-etcd]
[3]:[https://codeclimate.com/github/sensu-plugins/sensu-plugins-etcd]
[4]:[https://codeclimate.com/github/sensu-plugins/sensu-plugins-etcd]
[5]:[https://gemnasium.com/sensu-plugins/sensu-plugins-etcd]