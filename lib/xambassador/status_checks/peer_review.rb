require 'json'
require 'net/https'
require 'uri'

require_relative '../status_check'

module Xambassador
  # Check peer review status
  class PeerReview < StatusCheck
    BACKEND_OK = 'backend approved'.freeze
    FRONTEND_OK = 'frontend approved'.freeze
    NEEDS_WORK = 'needs work'.freeze

    def initialize(connection, pull_request)
      super(connection, pull_request, 'Peer Review')

      @description_pending = "Labels '#{BACKEND_OK}' \
        and '#{FRONTEND_OK}' are required"
      @description_success = 'Success'
      @description_failure = 'Needs work'

      fetch_labels(pull_request['issue_url'])
    end

    def fetch_labels(url)
      puts 'fetch_labels'
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.request(Net::HTTP::Get.new(url))

      body = JSON.parse(response.body)
      check_labels(body['labels'])
    end

    def check_labels(labels)
      count = 0
      needs_work = false

      labels.each do |label|
        if label['name'] == BACKEND_OK || label['name'] == FRONTEND_OK
          count += 1
        elsif label['name'] == NEEDS_WORK
          needs_work = true
        end
      end

      report_status(count, needs_work)
    end

    def report_status(count, needs_work)
      if needs_work == true
        failure
      elsif count == 2
        success
      else
        pending
      end
    end
  end
end
