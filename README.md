# Lolcommits Lolsrv

[![Gem](https://img.shields.io/gem/v/lolcommits-lolsrv.svg?style=flat)](http://rubygems.org/gems/lolcommits-lolsrv)
[![Travis](https://img.shields.io/travis/com/lolcommits/lolcommits-lolsrv/master.svg?style=flat)](https://travis-ci.com/lolcommits/lolcommits-lolsrv)
[![Depfu](https://img.shields.io/depfu/lolcommits/lolcommits-lolsrv.svg?style=flat)](https://depfu.com/github/lolcommits/lolcommits-lolsrv)
[![Maintainability](https://api.codeclimate.com/v1/badges/309c4d765a49dddebbc9/maintainability)](https://codeclimate.com/github/lolcommits/lolcommits-lolsrv/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/309c4d765a49dddebbc9/test_coverage)](https://codeclimate.com/github/lolcommits/lolcommits-lolsrv/test_coverage)

[lolcommits](https://lolcommits.github.io/) takes a snapshot with your
webcam every time you git commit code, and archives a lolcat style image
with it. Git blame has never been so much fun!

This plugin syncs lolcommits to a remote server. After enabling, your
next lolcommit will be uploaded, along with all existing lolcommits that
you've already captured. Syncing is then performed after each commit,
only uploading files that have not already been synced.

You configure the plugin by setting the base url of the remote server.
The server must respond at these paths:

**GET /lols**

Returns a JSON array of all lolcommits already synced. The commit `sha`
is the only required JSON attribute (used to identify the already synced
lolcommit).

**POST /uplol**

The following upload params are `multipart/form-data` encoded:

* `lol`  - captured lolcommit file
* `url`  - remote repository URL (with commit SHA appended)
* `repo` - repository name e.g. lolcommits/lolcommits
* `date` - UTC date time for the commit (ISO8601)
* `sha`  - commit SHA

## Requirements

* Ruby >= 2.3
* A webcam
* [ImageMagick](http://www.imagemagick.org)
* [ffmpeg](https://www.ffmpeg.org) (optional) for animated gif capturing

## Installation

After installing the lolcommits gem, install this plugin with:

    $ gem install lolcommits-lolsrv

Then configure to enable it and set the server url:

    $ lolcommits --config -p lolsrv
    # set enabled to `true`
    # set the server base url (must begin with http(s)://)

That's it! Provided the endpoints are responding correctly, your
lolcommits will be synced to the remote server. To disable use:

    $ lolcommits --config -p lolsrv
    # and set enabled to `false`

## Development

Check out this repo and run `bin/setup`, this will install all
dependencies and generate docs. Run `bundle exec rake` to run all tests
and generate a coverage report.

You can also run `bin/console` for an interactive prompt that will allow
you to experiment with the gem code.

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

Bug [reports](https://github.com/lolcommits/lolcommits-lolsrv/issues)
and [pull
requests](https://github.com/lolcommits/lolcommits-lolsrv/pulls) are
welcome on GitHub.

When submitting pull requests, remember to add tests covering any new
behaviour, and ensure all tests are passing on [Travis
CI](https://travis-ci.com/lolcommits/lolcommits-lolsrv). Read the
[contributing
guidelines](https://github.com/lolcommits/lolcommits-lolsrv/blob/master/CONTRIBUTING.md)
for more details.

This project is intended to be a safe, welcoming space for
collaboration, and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.
See
[here](https://github.com/lolcommits/lolcommits-lolsrv/blob/master/CODE_OF_CONDUCT.md)
for more details.

## License

The gem is available as open source under the terms of
[LGPL-3](https://opensource.org/licenses/LGPL-3.0).

## Links

* [Travis CI](https://travis-ci.com/lolcommits/lolcommits-lolsrv)
* [Code Climate](https://codeclimate.com/github/lolcommits/lolcommits-lolsrv)
* [Test Coverage](https://codeclimate.com/github/lolcommits/lolcommits-lolsrv/coverage)
* [RDoc](http://rdoc.info/projects/lolcommits/lolcommits-lolsrv)
* [Issues](http://github.com/lolcommits/lolcommits-lolsrv/issues)
* [Report a bug](http://github.com/lolcommits/lolcommits-lolsrv/issues/new)
* [Gem](http://rubygems.org/gems/lolcommits-lolsrv)
* [GitHub](https://github.com/lolcommits/lolcommits-lolsrv)
