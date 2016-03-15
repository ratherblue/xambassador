require 'xambassador/pull_request'
require 'json'
require_relative '../../spec_helper'
require_relative '../../fake_github'

describe Xambassador::PullRequest do
  subject { Xambassador::PullRequest }

  before do
    stub_request(:any, /api.github.com/).to_rack(FakeGitHub)
  end

  it 'should pass an open pull request' do
    payload = File.read(
      File.expand_path('./test/fixtures/pull_request/all_pass/payload.json')
    )

    responses = []
    signatures = []

    WebMock.after_request do |request_signature, response|
      signatures.push(request_signature)
      responses.push(response.body)
    end

    payload = JSON.parse(payload)
    subject.new(payload)

    # Check number of responses
    responses.length.must_equal(5)

    # Make sure fixture didn't change...
    payload['pull_request']['head']['sha'].must_equal('good-sha')
    payload['pull_request']['head']['ref'].must_equal('story-12343')

    # Peer Review
    body = JSON.parse(signatures[1].body)
    body['context'].must_equal('Peer Review')
    body['description'].must_equal('')
    body['state'].must_equal('success')

    # Branch Name
    body = JSON.parse(signatures[2].body)
    body['context'].must_equal('Branch Name')
    body['description'].must_equal('')
    body['state'].must_equal('success')

    # Protected Files
    body = JSON.parse(signatures[4].body)
    body['context'].must_equal('No Protected Files')
    body['description'].must_equal('')
    body['state'].must_equal('success')
  end

  it 'should fail all statuses' do
    payload = File.read(
      File.expand_path('./test/fixtures/pull_request/all_fail/payload.json')
    )

    responses = []
    signatures = []

    WebMock.after_request do |request_signature, response|
      signatures.push(request_signature)
      responses.push(response.body)
    end

    payload = JSON.parse(payload)
    subject.new(payload)

    # Check number of responses
    responses.length.must_equal(6)

    # Make sure fixture didn't change...
    payload['pull_request']['head']['sha'].must_equal('bad-sha')
    payload['pull_request']['head']['ref'].must_equal('test-web-hook')

    # Peer Review
    body = JSON.parse(signatures[1].body)
    body['context'].must_equal('Peer Review')
    body['description'].must_equal('Needs work')
    body['state'].must_equal('failure')

    # Branch Name
    body = JSON.parse(signatures[2].body)
    body['context'].must_equal('Branch Name')
    body['description'].must_equal('Branches must start '\
                                   'with bug-##### or story-#####.')
    body['state'].must_equal('failure')

    # Protected Files
    body = JSON.parse(signatures[5].body)
    body['context'].must_equal('No Protected Files')
    body['description'].must_equal('You edited ["web.config"]')
    body['state'].must_equal('failure')
  end

  it 'should be pending where applicable' do
    payload = File.read(
      File.expand_path('./test/fixtures/pull_request/all_pending/payload.json')
    )

    responses = []
    signatures = []

    WebMock.after_request do |request_signature, response|
      signatures.push(request_signature)
      responses.push(response.body)
    end

    payload = JSON.parse(payload)
    subject.new(payload)

    # Check number of responses
    responses.length.must_equal(6)

    # Make sure fixture didn't change...
    payload['pull_request']['head']['sha'].must_equal('pending-sha')
    payload['pull_request']['head']['ref'].must_equal('bug-1234')

    # Peer Review
    body = JSON.parse(signatures[1].body)
    body['context'].must_equal('Peer Review')
    body['description'].must_equal('Labels \'backend approved\''\
                                   ' and \'frontend approved\' are required')
    body['state'].must_equal('pending')

    # Branch Name
    body = JSON.parse(signatures[2].body)
    body['context'].must_equal('Branch Name')
    body['description'].must_equal('')
    body['state'].must_equal('success')

    # Protected Files
    body = JSON.parse(signatures[5].body)
    body['context'].must_equal('No Protected Files')
    body['description'].must_equal('')
    body['state'].must_equal('success')
  end
end
