lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lolcommits/lolsrv/version'

Gem::Specification.new do |spec|
  spec.name     = "lolcommits-lolsrv"
  spec.version  = Lolcommits::Lolsrv::VERSION
  spec.authors  = ["Matthew Hutchinson"]
  spec.email    = ["matt@hiddenloop.com"]
  spec.summary  = %q{Sync lolcommits to a remote server}
  spec.homepage = "https://github.com/lolcommits/lolcommits-lolsrv"
  spec.license  = "LGPL-3.0"

  spec.description = <<-DESC
  Sync lolcommits to a remote server. After enabling, your next
  lolcommit will be uploaded, along with all existing lolcommits images
  that you've already captured. Each lolcommit is then sync'd after
  capturing.
  DESC

  spec.metadata = {
    "homepage_uri"      => "https://github.com/lolcommits/lolcommits-lolsrv",
    "changelog_uri"     => "https://github.com/lolcommits/lolcommits-lolsrv/blob/master/CHANGELOG.md",
    "source_code_uri"   => "https://github.com/lolcommits/lolcommits-lolsrv",
    "bug_tracker_uri"   => "https://github.com/lolcommits/lolcommits-lolsrv/issues",
    "allowed_push_host" => "https://rubygems.org"
  }

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(assets|test|features)/}) }
  spec.test_files    = `git ls-files -- {test,features}/*`.split("\n")
  spec.bindir        = "bin"
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.3"

  spec.add_runtime_dependency "rest-client", ">= 2.1.0"
  spec.add_runtime_dependency "lolcommits", "0.16.1"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "simplecov"
end
