require 'json'
require 'octokit'
require 'renegade'
require 'net/https'
require 'uri'

require_relative 'connection'

module Xambassador
  # Pull Request helpers
  class PullRequest
    attr_reader :payload, :connection

    def initialize(payload)
      action = payload['action']

      if action == 'opened' || action == 'synchronize' || action == 'reopened'
        handle_opened_pull_request(payload['pull_request'])
      end
    end

    def handle_opened_pull_request(pull_request)
      @connection = Xambassador::Connection.new

      name = pull_request['base']['repo']['full_name']
      sha = pull_request['head']['sha']

      check_labels(pull_request, name, sha)
    end

    def check_labels(pull_request, name, sha)
      # connection.client.create_status(name, sha, 'pending',
      #   context: 'Peer Review',
      #   description: 'This needs work'
      # )
      puts 'before get issues'
      labels = fetch_labels(pull_request['issue_url'])
      puts labels
    end

    def fetch_labels(url)
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.request(Net::HTTP::Get.new(url))

      body = JSON.parse(response.body)
      body['labels']
    end
  end
end
