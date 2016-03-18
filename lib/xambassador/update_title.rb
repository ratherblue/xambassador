require 'renegade/branch_name'
require 'net/https'
require 'uri'
require 'nokogiri'

module Xambassador
  # Update manifest after merge complete
  class UpdateTitle
    def initialize(connection, pull_request, action)
      @connection = connection
      @pull_request = pull_request
      # only update newly opened requests
      run(pull_request) if action == 'opened' || action == 'reopened'
    end

    def run(pull_request)
      data = Renegade::BranchName.extract_id(pull_request['head']['ref'])
      if data['type'] == 'story'
        fetch_story_data(story_url(data['id']))
      elsif data['type'] == 'bug'
        fetch_bug_data(data['id'])
      end
    end

    def story_url(story_id)
      ENV['VERSION_ONE_URL'] +
        "/rest-1.v1/Data/Story?sel=Name&where=Number='B-#{story_id}'"
    end

    def fetch_story_data(url)
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request['Authorization'] = "Bearer #{ENV['VERSION_ONE_TOKEN']}"
      response = http.request(Net::HTTP::Get.new(url))

      update_title(response.body)
    end

    def update_title(xml)
      title = extract_title(xml)
      number = @pull_request['number']
      repo = @pull_request['head']['repo']['full_name']

      @connection.client.update_pull_request(repo, number, title)
    end

    def extract_title(xml)
      doc = Nokogiri::XML(xml)

      if doc.at_xpath('//Assets')['total'] == '1'
        doc.at_xpath('/Assets/Asset/Attribute/text()')
      else
        'INVALID STORY ID'
      end
    end

    def fetch_bug_data(bug_id)
    end
  end
end
