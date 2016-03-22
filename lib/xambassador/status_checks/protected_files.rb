require 'json'
require 'net/https'
require 'uri'
require 'renegade/branch_name'
require 'uri_template'

require_relative '../status_check'

module Xambassador
  # Check peer review status
  class ProtectedFiles < StatusCheck
    def initialize(connection, pull_request)
      super(connection, pull_request, 'No Protected Files')

      @description_success = ''
      @description_failure = 'Edited protected files'

      url = pull_request['url'] + '/files'
      fetch_changed_files(url)
    end

    def fetch_changed_files(url)
      response = Xambassador::Connection.request(url)
      check_files(JSON.parse(response.body))
    end

    def check_files(files)
      protected_files = ['app.config', 'web.config']
      changed_protected_files = []

      unless files.empty?
        files.each do |file|
          if protected_files.include?(File.basename(file['filename']).downcase)
            changed_protected_files.push(file['filename'])
          end
        end
      end

      report_status(changed_protected_files)
    end

    def report_status(files)
      if files.empty?
        success
      else
        fetch_labels(@pull_request['issue_url'], files)
      end
    end

    def fetch_labels(url, files)
      response = Xambassador::Connection.request(url)

      body = JSON.parse(response.body)
      check_labels(body['labels'], files)
    end

    def check_labels(labels, files)
      pass = false

      labels.each do |label|
        pass = true if label['name'] == 'edited .config'
      end

      if pass
        success
      else
        @description_failure = "You edited #{files}"
        failure
      end
    end
  end
end
