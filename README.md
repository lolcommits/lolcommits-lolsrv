# Lolcommits Lolsrv

[![Gem Version](https://img.shields.io/gem/v/lolcommits-lolsrv.svg?style=flat)](http://rubygems.org/gems/lolcommits-lolsrv)
[![Travis Build Status](https://travis-ci.org/lolcommits/lolcommits-lolsrv.svg?branch=master)](https://travis-ci.org/lolcommits/lolcommits-lolsrv)
[![Coverage Status](https://coveralls.io/repos/github/lolcommits/lolcommits-lolsrv/badge.svg?branch=master)](https://coveralls.io/github/lolcommits/lolcommits-lolsrv)
[![Code Climate](https://codeclimate.com/github/lolcommits/lolcommits-lolsrv/badges/gpa.svg)](https://codeclimate.com/github/lolcommits/lolcommits-lolsrv)
[![Gem Dependency Status](https://gemnasium.com/badges/github.com/lolcommits/lolcommits-lolsrv.svg)](https://gemnasium.com/github.com/lolcommits/lolcommits-lolsrv)

[lolcommits](https://lolcommits.github.io/) takes a snapshot with your webcam
every time you git commit code, and archives a lolcat style image with it. Git
blame has never been so much fun!

This plugin annotates each lolcommit with the commit message and sha text. You
can style and position these however you like, or add a transparent overlay
color that covers the entire image.

By default your lolcommit will look something like this (maybe without the
horse):

![horse
commit](https://github.com/lolcommits/lolcommits-lolsrv/raw/master/assets/images/horse.jpg)

You can easily change the plugin options to achieve something like this:

![hipster
commit](https://github.com/lolcommits/lolcommits-lolsrv/raw/master/assets/images/hipster.jpg)

See [below](https://github.com/lolcommits/lolcommits-lolsrv#configuration) for
more information on the options available.

## Requirements

* Ruby >= 2.0.0
* A webcam
* [ImageMagick](http://www.imagemagick.org)
* [ffmpeg](https://www.ffmpeg.org) (optional) for animated gif capturing

## Installation

By default, this plugin is automatically included with the main lolcommits gem.
If you have uninstalled this gem, install it again with:

    $ gem install lolcommits-lolsrv

That's it! Every lolcommit will now be stamped with your commit message and sha.
This plugin is enabled by default (if no configuration for it exists). To
disable (so no text or overlay is applied) use:

    $ lolcommits --config -p lolsrv
    # and set enabled to `false`

### Configuration

Configure this plugin with:

    $ lolcommits --config -p lolsrv
    # set enabled to `true` (then set your own options or choose the defaults)

The following options are available:

* text color
* text font
* text position
* uppercase text?
* size (point size for the font)
* stroke color (font outline color, or none)
* transparent overlay (cover the image with a random background color)
* transparent overlay % (sets the fill colorize strength)

Please note that:

* The message and sha text can have different text options
* Any blank options will use the default (indicated when prompted for an option)
* Always use the full absolute path to font files
* Valid text positions are NE, NW, SE, SW, S, C (centered)
* Colors can be hex values (#FC0) or strings (white, red etc.)
* You can set one or more `overlay_colors` to pick from, separated with commas

With these options it is possible to create your own unique lolcommit format.
To achieve these '[hipster
styled](https://twitter.com/matthutchin/status/738411190343368704)' 🕶 commits,
try the following:

```
lolsrv:
  enabled: true
  :message:
    :color: white
    :font: "/Users/matt/Library/Fonts/Raleway-Light.ttf"
    :position: C
    :size: 30
    :stroke_color: none
    :uppercase: true
  :sha:
    :color: white
    :font: "/Users/matt/Library/Fonts/Raleway-Light.ttf"
    :position: S
    :size: 20
    :stroke_color: none
    :uppercase: false
  :overlay:
    :enabled: true
```

**NOTE**: you can grab the '_Raleway-Light_' font for free from
[fontsquirrel](https://www.fontsquirrel.com/fonts/Raleway).

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
