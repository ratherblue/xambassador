require 'xambassador/pull_request'
require 'json'
require_relative '../../spec_helper'

describe Xambassador::PullRequest do
  subject { Xambassador::PullRequest }

  payload = ''

  before do
    payload = File.read(
      File.expand_path('./test/fixtures/pull_request/opened.json')
    )

    payload = JSON.parse(payload)
  end

  it 'should run an open pull request' do
    labels = File.read(
      File.expand_path('./test/fixtures/pull_request/labels/good.json')
    )
    stub_request(:post, 'https://api.github.com/repos/ratherblue/git-hooks/statuses/d79da21d5d8330332895dcff4b49400705de78c9')
      .with(body: '{"context":"Peer Review","description"'\
        ':"Success","state":"success"}',
            headers: {
              'Accept' => 'application/vnd.github.v3+json',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization' => 'token ' + ENV['GITHUB_AUTH_TOKEN'],
              'Content-Type' => 'application/json',
              'User-Agent' => 'Octokit Ruby Gem 4.3.0' })
      .to_return(status: 200, body: '', headers: {})

    stub_request(:get, 'https://api.github.com/repos/ratherblue/git-hooks/issues/27')
      .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
      .to_return(status: 200, body: labels, headers: {})

    subject.new(payload)
  end

  it 'should be pending' do
    labels = File.read(
      File.expand_path('./test/fixtures/pull_request/labels/pending.json')
    )
    stub_request(:post, 'https://api.github.com/repos/ratherblue/git-hooks/statuses/d79da21d5d8330332895dcff4b49400705de78c9')
      .with(body: '{"context":"Peer Review","description"'\
        ':"Labels \'backend approved\' and \'frontend approved\''\
        ' are required","state":"pending"}',
            headers: {
              'Accept' => 'application/vnd.github.v3+json',
              'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Authorization' => 'token ' + ENV['GITHUB_AUTH_TOKEN'],
              'Content-Type' => 'application/json',
              'User-Agent' => 'Octokit Ruby Gem 4.3.0' })
      .to_return(status: 200, body: '', headers: {})

    stub_request(:get, 'https://api.github.com/repos/ratherblue/git-hooks/issues/27')
      .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
      .to_return(status: 200, body: labels, headers: {})

    subject.new(payload)
  end
end