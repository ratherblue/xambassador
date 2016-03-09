module Xambassador
  # Connection helpers
  class Connection
    attr_reader :client

    def initialize
      @client ||= Octokit::Client.new(access_token: token)
    end

    def token
      ENV['GITHUB_AUTH_TOKEN']
    end
  end
end
