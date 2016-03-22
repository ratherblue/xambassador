require 'octokit'

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

    def self.request(url)
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request['Authorization'] = "token #{ENV['GITHUB_AUTH_TOKEN']}"
      http.request(request)
    end
  end
end
