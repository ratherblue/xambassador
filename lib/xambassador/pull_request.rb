require 'json'
require 'octokit'
require 'renegade'
require 'net/https'
require 'uri'

require_relative 'connection'
require_relative 'checks/labels'

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

      Xambassador::CheckLabels.new(pull_request, name, sha)
    end
  end
end
