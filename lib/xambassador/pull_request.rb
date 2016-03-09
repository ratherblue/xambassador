require 'json'
require 'octokit'
require 'xambassador/connection'

module Xambassador
  # Pull Request helpers
  class PullRequest
    attr_reader :payload

    def initialize(payload)
      action = payload['action']
      puts action
    end
  end
end
