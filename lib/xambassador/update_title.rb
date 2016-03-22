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
        fetch_bug_data(bug_url(data['id']))
      end
    end

    def bug_url(bug_id)
      ENV['BUGZILLA_URL'] + "/bug/#{bug_id}?"\
        "Bugzilla_api_key=#{ENV['BUGZILLA_API_KEY']}"
    end

    def story_url(story_id)
      ENV['VERSION_ONE_URL'] + "/Data/Story"\
        "?sel=Number,Estimate,Name&where=Number='B-#{story_id}'"
    end

    def fetch_story_data(url)
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request['Authorization'] = "Bearer #{ENV['VERSION_ONE_TOKEN']}"
      response = http.request(request)
      title = extract_story_title(response.body)
      update_title(title)
    end

    def update_title(title)
      number = @pull_request['number']
      repo = @pull_request['head']['repo']['full_name']

      @connection.client.update_pull_request(repo, number, title: title)
    end

    def extract_story_title(xml)
      doc = Nokogiri::XML(xml)

      if doc.at_xpath('//Assets')['total'] == '1'
        story_title(doc)
      else
        'INVALID STORY ID'
      end
    end

    def estimate_format(estimate)
      ", #{estimate} pts" unless estimate.nil?
    end

    def story_title(xml_doc)
      story_name = xml_doc.css('Attribute[name=Name]').text
      estimate = estimate_format(xml_doc.css('Attribute[name=Estimate]').text)
      number = xml_doc.css('Attribute[name=Number]').text

      "(Story: #{number}) #{story_name}#{estimate}"
    end

    def fetch_bug_data(url)
      uri = URI.parse(url)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = false
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      response = http.request(request)

      update_title(bug_title(JSON.parse(response.body)))
    end

    def bug_title(json)
      bug = json['bugs'][0]

      severity = bug['severity']
      severity = " [#{severity}]" unless severity == ''

      "(Bug: #{bug['id']}) #{bug['summary']}#{severity}"
    end
  end
end
