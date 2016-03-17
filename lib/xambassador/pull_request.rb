require 'json'
require 'octokit'
require 'net/https'
require 'uri'

require_relative 'connection'
require_relative 'status_checks/peer_review'
require_relative 'status_checks/branch_name'
require_relative 'status_checks/protected_files'
require_relative 'update_title'

module Xambassador
  # Pull Request helpers
  class PullRequest
    def initialize(payload)
      action = payload['action']

      if open?(action)
        handle_opened_pull_request(action, payload['pull_request'])
      elsif action == 'closed'
        handle_closed_pull_request(payload['pull_request'])
      end
    end

    def open?(action)
      action == 'labeled' ||
        action == 'unlabeled' ||
        action == 'opened' ||
        action == 'synchronize' ||
        action == 'reopened'
    end

    def handle_opened_pull_request(action, pull_request)
      @connection = Xambassador::Connection.new

      # StatusChecks
      Xambassador::PeerReview.new(@connection, pull_request)
      Xambassador::BranchName.new(@connection, pull_request)
      Xambassador::ProtectedFiles.new(@connection, pull_request)

      # Updates
      Xambassador::UpdateTitle.new(@connection, pull_request, action)
    end

    def handle_closed_pull_request(pull_request)
      Xambassador::UpdateManifest.new(pull_request)
    end
  end
end
