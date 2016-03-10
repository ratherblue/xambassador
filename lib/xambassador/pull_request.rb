require 'json'
require 'octokit'
require 'renegade'
require 'net/https'
require 'uri'

require_relative 'connection'
require_relative 'status_checks/peer_review'

module Xambassador
  # Pull Request helpers
  class PullRequest
    attr_reader :payload, :connection

    def initialize(payload)
      action = payload['action']

      if action == 'labeled' || action == 'unlabeled'
        handle_opened_pull_request(payload['pull_request'])
      elsif action == 'opened' ||
            action == 'synchronize' ||
            action == 'reopened'
        handle_opened_pull_request(payload['pull_request'])
      end
    end

    def handle_opened_pull_request(pull_request)
      @connection = Xambassador::Connection.new

      Xambassador::PeerReview.new(@connection, pull_request)
    end
  end
end
