require 'json'
require 'net/https'
require 'uri'

require_relative '../status_check'

module Xambassador
  # Check peer review status
  class PeerReview < StatusCheck
    BACKEND_APPROVED = 'Backend Approved'.freeze
    FRONTEND_APPROVED = 'Frontend Approved'.freeze

    def initialize(connection, pull_request)
      super(connection, pull_request, 'Peer Review asdfs')

      @description_pending = 'Pending'
      @description_success = 'Success'
      @description_failure = "Labels '#{BACKEND_APPROVED}' \
        and '#{FRONTEND_APPROVED}' are required"

      pending
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

      labels.each do |label|
        label_name = label['name']
        if label_name == BACKEND_APPROVED || label_name == FRONTEND_APPROVED
          count += 1
        end
      end

      report_status(count)
    end

    def report_status(count)
      if count == 2
        success
      else
        pending
      end
    end
  end
end
