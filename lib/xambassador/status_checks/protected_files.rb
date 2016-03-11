require "json"
require "net/https"
require "uri"
require "renegade/branch_name"
require "uri_template"

require_relative "../status_check"

module Xambassador
  # Check peer review status
  class ProtectedFiles < StatusCheck
    def initialize(connection, pull_request)
      super(connection, pull_request, "No Protected Files")

      @description_success = ""
      @description_failure = "Edited protected files"

      sha = pull_request['head']['sha']
      url = pull_request['head']['repo']['trees_url']

      url_template = URITemplate.new(url)
      fetch_changed_files(url_template.expand('sha' => sha))
    end

    def fetch_changed_files(url)
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.request(Net::HTTP::Get.new(url))

      body = JSON.parse(response.body)
      check_files(body['tree'])
    end

    def check_files(files)
      protected_files = ['app.config', 'web.config']
      changed_protected_files = []

      unless files.empty?
        files.each do |file|
          if protected_files.include?(File.basename(file['path']).downcase)
            changed_protected_files.push(file['path'])
          end
        end
      end

      report_status(changed_protected_files)
    end

    def report_status(files)
      if files.empty?
        success
      else
        @description_failure = "You edited #{files}"
        failure
      end
    end
  end
end
