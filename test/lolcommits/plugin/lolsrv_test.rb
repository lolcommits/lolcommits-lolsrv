# frozen_string_literal: true

require "test_helper"
require "webmock/minitest"

describe Lolcommits::Plugin::Lolsrv do
  include Lolcommits::TestHelpers::GitRepo
  include Lolcommits::TestHelpers::FakeIO

  describe "with a runner" do
    def runner
      # a simple lolcommits runner with an empty configuration Hash
      @runner ||= Lolcommits::Runner.new(
        config: TestConfiguration.new(OpenStruct.new)
      )
    end

    def plugin
      @plugin ||= Lolcommits::Plugin::Lolsrv.new(runner: runner)
    end

    def valid_enabled_config
      {
        enabled: true,
        server: "https://lolsrv.com"
      }
    end

    describe "#enabled?" do
      it "it is disabled by default" do
        _(plugin.enabled?).must_equal false
      end

      it "is true when configured" do
        plugin.configuration = valid_enabled_config
        _(plugin.enabled?).must_equal true
      end
    end

    describe "run_capture_ready" do
      before do
        commit_repo_with_message
      end

      after { teardown_repo }

      it "syncs lolcommits" do
        in_repo do
          plugin.configuration = valid_enabled_config
          existing_sha  = "sha123"

          stub_request(:get, "https://lolsrv.com/lols").
            to_return(status: 200, body: [ { sha: existing_sha } ].to_json)

          stub_request(:post, "https://lolsrv.com/uplol").
            to_return(status: 200)

          output = fake_io_capture do
            plugin.run_capture_ready(do_fork: false)
          end

          assert_equal output, "Syncing lols ... done!\n"
          assert_requested :get, "https://lolsrv.com/lols", times: 1
          assert_requested :post, "https://lolsrv.com/uplol", times: 1,
            headers: { "Content-Type" => /multipart\/form-data/ } do |req|
            _(req.body).must_match "sha456"
            _(req.body).must_match "plugin-test-repo"
            _(req.body).must_match "name=\"lol\"; filename="
          end
        end
      end

      it "shows error and aborts on failed lols endpoint" do
        in_repo do
          plugin.configuration = valid_enabled_config
          stub_request(:get, "https://lolsrv.com/lols").to_return(status: 404)

          output = fake_io_capture do
            plugin.run_capture_ready(do_fork: false)
          end

          assert_equal output, "Syncing lols ... failed fetching existing lols (try again with --debug)\n"
          assert_not_requested :post, "https://lolsrv.com/uplol"
        end
      end
    end

    describe "configuration" do
      it "allows plugin options to be configured" do
        # enabled and server option
        inputs = [ "true", "https://my-lolsrv.com" ]
        configured_plugin_options = {}

        fake_io_capture(inputs: inputs) do
          configured_plugin_options = plugin.configure_options!
        end

        _(configured_plugin_options).must_equal({
          enabled: true,
          server: "https://my-lolsrv.com"
        })
      end

      describe "#valid_configuration?" do
        it "returns false for an invalid configuration" do
          plugin.configuration = { server: "gibberish" }
          _(plugin.valid_configuration?).must_equal false
        end

        it "returns true with a valid configuration" do
          plugin.configuration = valid_enabled_config
          _(plugin.valid_configuration?).must_equal true
        end
      end
    end
  end
end

class TestConfiguration < Lolcommits::Configuration
  def loldir
    @loldir ||= File.expand_path("#{__dir__}../../../images")
  end
end
