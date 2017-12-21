require 'rest_client'
require 'lolcommits/plugin/base'

module Lolcommits
  module Plugin
    class Lolsrv < Base

      ##
      # Returns the name of the plugin. Identifies the plugin to lolcommits.
      #
      # @return [String] the plugin name
      #
      def self.name
        'lolsrv'
      end

      ##
      # Returns position(s) of when this plugin should run during the capture
      # process. Sync/uploading happens when a new capture is ready.
      #
      # @return [Array] the position(s) (:capture_ready)
      #
      def self.runner_order
        [:capture_ready]
      end

      ##
      # Returns true/false indicating if the plugin has been correctly
      # configured. The `server` option must be set with a URL beginning with
      # http(s)://
      #
      # @return [Boolean] true/false indicating if plugin is correctly
      # configured
      #
      def valid_configuration?
        !!(configuration['server'] =~ /^http(s)?:\/\//)
      end

      ##
      # Prompts the user to configure text options.
      #
      # @return [Hash] of configured plugin options
      #
      def configure_options!
        options = super
        if options['enabled']
          print "server: "
          options.merge!('server' => parse_user_input(gets.strip))
          puts '---------------------------------------------------------------'
          puts '  Lolsrv - Sync lolcommits to a remote server'
          puts ''
          puts '  Handle POST /uplol with these request params'
          puts ''
          puts '    `lol`  - captured lolcommit image file'
          puts '    `url`  - remote repository URL (with commit SHA appended)'
          puts '    `repo` - repository name e.g. mroth/lolcommits'
          puts '    `date` - UTC date time for the commit (ISO8601)'
          puts '    `sha`  - commit SHA'
          puts ''
          puts '  Handle GET /lols with JSON response'
          puts ''
          puts '  * Must return a JSON array of all lols already uploaded.'
          puts '    The commit `sha` is the only required JSON attribute.'
          puts ''
          puts '---------------------------------------------------------------'
        end
        options
      end

      ##
      #
      # Post-capture hook, runs after lolcommits captures a snapshot.
      #
      # Syncs lolcommit images to the remote server (forked and detached)
      #
      # @return [Integer] forked process id
      #
      def run_capture_ready(do_fork: true)
        if do_fork
          pid = fork { sync }
          Process.detach(pid)
        else
          sync
        end
      end


      private

      ##
      #
      # Syncs lolcommmit images to the remote server
      #
      # Fetches from /lols and iterates over shas in the JSON array. For each
      # image found in the local loldir folder, check if it has already been
      # uploaded. If not, upload the image with a POST request and
      # upload_params.
      #
      # Upload requests that fail abort the sync.
      #
      def sync
        print "Syncing lols ... "
        raise 'failed fetching existing lols' unless existing_shas

        Dir[runner.config.loldir + '/*.{jpg,gif}'].each do |image|
          sha = File.basename(image, '.*')
          unless existing_shas.include?(sha) || sha == 'tmp_snapshot'
            response = upload(image, sha)
            raise "failed uploading #{image}" if response.nil?
          end
        end

        print "done!\n"
      rescue StandardError => e
        print "#{e.message} (try again with --debug)\n"
        nil
      end

      ##
      #
      # Fetch and parse JSON response from `server/lols`, returning an array of
      # commit SHA's. Logs and returns nil on NET/HTTP and JSON parsing errors.
      #
      # @return [Array] containing commit SHA's
      # @return [Nil] if an error occurred
      #
      def existing_shas
        @existing_shas ||= begin
          lols = JSON.parse(RestClient.get(lols_endpoint))
          lols.map { |lol| lol['sha'] }
        rescue JSON::ParserError, SocketError, RestClient::RequestFailed => e
          log_error(e, "ERROR: existing lols could not be retrieved #{e.class} - #{e.message}")
          nil
        end
      end

      ##
      #
      # Upload the lolcommit image to `server/uplol` with commit params. Logs
      # and returns nil on NET/HTTP errors.
      #
      # @return [RestClient::Response] response object from POST request
      #
      def upload(image, sha)
        RestClient.post(upload_endpoint, upload_params_for(image, sha))
      rescue SocketError, RestClient::RequestFailed => e
        log_error(e, "ERROR: Upload of lol #{sha} to #{upload_endpoint} FAILED #{e.class} - #{e.message}")
        nil
      end

      ##
      #
      # Hash of params to send with lolcommit upload. Built from repositiory and
      # commit info.
      #
      # `lol`  - captured lolcommit image file
      # `url`  - remote repository URL (with commit SHA appended)
      # `repo` - repository name e.g. mroth/lolcommits
      # `date` - UTC date time for the commit (ISO8601)
      # `sha`  - commit SHA
      #
      # @return [Hash]
      #
      def upload_params_for(image, sha)
        params = {
          lol: File.new(image),
          repo: runner.vcs_info.repo,
          date: runner.vcs_info.commit_date.iso8601,
          sha: sha
        }

        if runner.vcs_info.url
          params.merge!(url: runner.vcs_info.url + sha)
        end

        params
      end

      ##
      #
      # Endpoint requested for POST-ing lolcommits
      #
      # @return [String] `server` config option + '/uplol'
      #
      def upload_endpoint
        configuration['server'] + '/uplol'
      end

      ##
      #
      # Endpoint requested for GET-ing lolcommits. It must return a JSON array
      # of all lols already uploaded, the commit `sha` is the only required JSON
      # attribute.
      #
      # @return [String] `server` config option + '/lols'
      #
      def lols_endpoint
        configuration['server'] + '/lols'
      end
    end
  end
end
