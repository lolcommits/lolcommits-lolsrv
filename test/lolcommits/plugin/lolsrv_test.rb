require "test_helper"

describe Lolcommits::Plugin::Lolsrv do

  include Lolcommits::TestHelpers::GitRepo
  include Lolcommits::TestHelpers::FakeIO

  def plugin_name
    "lolsrv"
  end

  it "should have a name" do
    ::Lolcommits::Plugin::Lolsrv.name.must_equal plugin_name
  end

  it "should run on post capturing" do
    ::Lolcommits::Plugin::Lolsrv.runner_order.must_equal [:capture_ready]
  end

  describe "with a runner" do
    def runner
      # a simple lolcommits runner with an empty configuration Hash
      @runner ||= Lolcommits::Runner.new(
        main_image: Tempfile.new,
        config: OpenStruct.new(
          read_configuration: {},
          loldir: File.expand_path("#{__dir__}../../../images")
        )
      )
    end

    def plugin
      @plugin ||= Lolcommits::Plugin::Lolsrv.new(runner: runner)
    end

    def valid_enabled_config
      @config ||= OpenStruct.new(
        read_configuration: {
          "lolsrv" => {
            "enabled" => true,
            server: "https://lolsrv.com"
          }
        }
      )
    end

    before { commit_repo_with_message }
    after { teardown_repo }

    describe "initalizing" do
      it "should assign runner and an enabled option" do
        in_repo do
          plugin.runner.must_equal runner
          plugin.options.must_equal ["enabled"]
        end
      end
    end

    describe "#enabled?" do
      it "should be false by default" do
        in_repo { plugin.enabled?.must_equal false }
      end

      it "should true when configured" do
        in_repo do
          plugin.config = valid_enabled_config
          plugin.enabled?.must_equal true
        end
      end
    end

    describe "run_capture_ready" do
      it "should sync lolcommits" do
        in_repo do
          plugin.config = valid_enabled_config
          existing_sha  = "sha123"

          stub_request(:get, "https://lolsrv.com/lols").
            to_return(status: 200, body: [{ sha: existing_sha }].to_json)

          stub_request(:post, "https://lolsrv.com/uplol").to_return(status: 200)

          plugin.run_capture_ready(do_fork: false)

          assert_requested :get, "https://lolsrv.com/lols", times: 1
          assert_requested :post, "https://lolsrv.com/uplol", times: 1,
            headers: {'Content-Type' => /multipart\/form-data/} do |req|
            req.body.must_match /sha456/
            req.body.must_match /plugin-test-repo/
            req.body.must_match %r{name=\"lol\"; filename=}
          end
        end
      end
    end

    describe "configuration" do
      it "should not be configured by default" do
        in_repo { plugin.configured?.must_equal false }
      end

      it "should indicate when configured" do
        in_repo do
          plugin.config = valid_enabled_config
          plugin.configured?.must_equal true
        end
      end

      it "should allow plugin options to be configured" do
        # enabled and server option
        inputs = ["true", "https://my-lolsrv.com"]

        configured_plugin_options = {}

        in_repo do
          fake_io_capture(inputs: inputs) do
            configured_plugin_options = plugin.configure_options!
          end
        end

        configured_plugin_options.must_equal({
          "enabled" => true,
          server: "https://my-lolsrv.com"
        })
      end

      describe "#valid_configuration?" do
        it "should be false for an invalid configuration" do
          in_repo do
            plugin.config = OpenStruct.new(read_configuration: {
              "lolsrv" => { server: "gibberish" }
            })
            plugin.valid_configuration?.must_equal false
          end
        end

        it "should be true for a valid configuration" do
          in_repo do
            plugin.config = valid_enabled_config
            plugin.valid_configuration?.must_equal true
          end
        end
      end
    end
  end
end
