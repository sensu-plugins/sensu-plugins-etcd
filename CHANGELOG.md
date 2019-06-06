# Change Log
This project adheres to [Semantic Versioning](http://semver.org/).

This CHANGELOG follows the format listed at [Keep A Changelog](http://keepachangelog.com/)

## [Unreleased]
### Changed
- Updated Travis configuration to include Ruby 2.4.1
- Updated to be compatible with other type of private keys than RSA

### Removed
- Ruby 1.9.3 from deploy-time testing (@eheydrick)

## [1.0.0] - 2016-08-10
### Changed
- Removed Ruby 1.9 support
- Updated sensu-plugin dependency from `= 1.2.0` to `~> 1.3`

### Added
- Added full cluster health check option for check-etcd
- Added healthy peer count check
- Adding flanneld subnet check for etcd
- Added missing require 'json'

## [0.1.0] - 2015-08-27
### Added
- SSL support

## [0.0.3] - 2015-07-14
### Changed
- updated sensu-plugin gem to 1.2.0

## [0.0.2] - 2015-06-02
### Fixed
- added binstubs

### Changed
- removed cruft from /lib

## 0.0.1 - 2015-04-30
### Added
- initial release

[Unreleased]: https://github.com/sensu-plugins/sensu-plugins-etcd/compare/1.0.0...HEAD
[1.0.0]: https://github.com/sensu-plugins/sensu-plugins-etcd/compare/0.1.0...1.0.0
[0.1.0]: https://github.com/sensu-plugins/sensu-plugins-etcd/compare/0.0.3...0.1.0
[0.0.3]: https://github.com/sensu-plugins/sensu-plugins-etcd/compare/0.0.2...0.0.3
[0.0.2]: https://github.com/sensu-plugins/sensu-plugins-etcd/compare/0.0.1...0.0.2
