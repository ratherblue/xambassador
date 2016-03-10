require 'json'
require 'octokit'
require 'renegade'
require 'net/https'
require 'uri'

require_relative '../status_check'

module Xambassador
  # Pull Request helpers
  class PeerReview < StatusCheck
    def run(pull_request)
      fetch_labels(pull_request['issue_url'])
    end

    def fetch_labels(url)
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.request(Net::HTTP::Get.new(url))

      body = JSON.parse(response.body)
      check_labels(body['labels'])
    end

    def check_labels(labels)
      
    end
  end
end
