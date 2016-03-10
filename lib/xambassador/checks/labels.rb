require 'json'
require 'octokit'
require 'renegade'
require 'net/https'
require 'uri'

module Xambassador
  # Pull Request helpers
  class CheckLabels
    def initialize(pull_request, name, sha)
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
