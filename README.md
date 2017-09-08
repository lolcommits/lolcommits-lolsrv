# Lolcommits Lolsrv

[![Gem Version](https://img.shields.io/gem/v/lolcommits-lolsrv.svg?style=flat)](http://rubygems.org/gems/lolcommits-lolsrv)
[![Travis Build Status](https://travis-ci.org/lolcommits/lolcommits-lolsrv.svg?branch=master)](https://travis-ci.org/lolcommits/lolcommits-lolsrv)
[![Coverage Status](https://coveralls.io/repos/github/lolcommits/lolcommits-lolsrv/badge.svg?branch=master)](https://coveralls.io/github/lolcommits/lolcommits-lolsrv)
[![Code Climate](https://codeclimate.com/github/lolcommits/lolcommits-lolsrv/badges/gpa.svg)](https://codeclimate.com/github/lolcommits/lolcommits-lolsrv)
[![Gem Dependency Status](https://gemnasium.com/badges/github.com/lolcommits/lolcommits-lolsrv.svg)](https://gemnasium.com/github.com/lolcommits/lolcommits-lolsrv)

[lolcommits](https://lolcommits.github.io/) takes a snapshot with your webcam
every time you git commit code, and archives a lolcat style image with it. Git
blame has never been so much fun!

This plugin syncs lolcommits to a remote server. After enabling, your next
lolcommit will be uploaded, along with all existing lolcommits images that
you've already captured. This sync is then performed after each commit, only
uploading images that have not already been synced.

You configure the plugin setting the base url of the remote server. This server
must respond to the following requests.

**POST /uplol**

The following params are submitted as `multipart/form-data`.

* `lol`  - captured lolcommit image file
* `url`  - remote repository URL (with commit SHA appended)
* `repo` - repository name e.g. mroth/lolcommits
* `date` - UTC date time for the commit (ISO8601)
* `sha`  - commit SHA

**GET /lols**

Must return a JSON array of all lols already uploaded. The commit `sha` is the
only required JSON attribute and is used to identify the already synced
lolcommit.

## Requirements

* Ruby >= 2.0.0
* A webcam
* [ImageMagick](http://www.imagemagick.org)
* [ffmpeg](https://www.ffmpeg.org) (optional) for animated gif capturing

## Installation

After installing the lolcommits gem, install this plugin with:

    $ gem install lolcommits-lolsrv

Then configure the plugin to enable it and set the server url with:

    $ lolcommits --config -p lolsrv
    # set enabled to `true`
    # set the server base url (must begin with http(s)://)

That's it! Provided the endpoints are responding correctly, lolcommits will
now be synced to the remote server. To disable use:

    $ lolcommits --config -p lolsrv
    # and set enabled to `false`

## Development

Check out this repo and run `bin/setup`, to install all dependencies and
generate docs. Run `bundle exec rake` to run all tests and generate a coverage
report.

You can also run `bin/console` for an interactive prompt that will allow you to
experiment with the gem code.

## Tests

MiniTest is used for testing. Run the test suite with:

    $ rake test

## Docs

Generate docs for this gem with:

    $ rake rdoc

## Troubles?

If you think something is broken or missing, please raise a new
[issue](https://github.com/lolcommits/lolcommits-lolsrv/issues). Take
a moment to check it hasn't been raised in the past (and possibly closed).

## Contributing

Bug [reports](https://github.com/lolcommits/lolcommits-lolsrv/issues) and [pull
requests](https://github.com/lolcommits/lolcommits-lolsrv/pulls) are welcome on
GitHub.

When submitting pull requests, remember to add tests covering any new behaviour,
and ensure all tests are passing on [Travis
CI](https://travis-ci.org/lolcommits/lolcommits-lolsrv). Read the
[contributing
guidelines](https://github.com/lolcommits/lolcommits-lolsrv/blob/master/CONTRIBUTING.md)
for more details.

This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the [Contributor
Covenant](http://contributor-covenant.org) code of conduct. See
[here](https://github.com/lolcommits/lolcommits-lolsrv/blob/master/CODE_OF_CONDUCT.md)
for more details.

## License

The gem is available as open source under the terms of
[LGPL-3](https://opensource.org/licenses/LGPL-3.0).

## Links

* [Travis CI](https://travis-ci.org/lolcommits/lolcommits-lolsrv)
* [Test Coverage](https://coveralls.io/github/lolcommits/lolcommits-lolsrv)
* [Code Climate](https://codeclimate.com/github/lolcommits/lolcommits-lolsrv)
* [RDoc](http://rdoc.info/projects/lolcommits/lolcommits-lolsrv)
* [Issues](http://github.com/lolcommits/lolcommits-lolsrv/issues)
* [Report a bug](http://github.com/lolcommits/lolcommits-lolsrv/issues/new)
* [Gem](http://rubygems.org/gems/lolcommits-lolsrv)
* [GitHub](https://github.com/lolcommits/lolcommits-lolsrv)
