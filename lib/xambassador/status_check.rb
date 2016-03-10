require 'json'
require 'octokit'
require 'renegade'
require 'net/https'
require 'uri'

require_relative 'connection'
require_relative 'checks/labels'

module Xambassador
  # Status Check class
  class StatusCheck
    def initialize(connection, name, sha)
      @name = name
      @sha = sha
      @connection = connection
      @context = 'Default context'
      @description_pending = 'Pending'
      @description_success = 'Success'
      @description_failure = 'Failure'
    end

    def pending
      options = {
        context: @context,
        description: @description_pending
      }

      @connection.client.create_status(@name, @sha, 'pending', options)
    end
  end
end
