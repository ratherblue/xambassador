require "xambassador/pull_request"
require "json"
require_relative "../../spec_helper"

describe Xambassador::PullRequest do
  subject { Xambassador::PullRequest }

  payload = ""
  url_prefix = "https://api.github.com/repos/ratherblue/git-hooks"
  sha = "d79da21d5d8330332895dcff4b49400705de78c9"
  headers = {
    "Accept" => "application/vnd.github.v3+json",
    "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
    "Authorization" => "token " + ENV["GITHUB_AUTH_TOKEN"],
    "Content-Type" => "application/json",
    "User-Agent" => "Octokit Ruby Gem 4.3.0" }

  it "should run an open pull request" do
    payload = File.read(
      File.expand_path("./test/fixtures/pull_request/opened.json")
    )

    payload = JSON.parse(payload)

    labels = File.read(
      File.expand_path("./test/fixtures/pull_request/labels/good.json")
    )

    stub_request(:post, "#{url_prefix}/statuses/#{sha}")
      .with(body: '{"context":"Peer Review","description"'\
        ':"Success","state":"success"}',
            headers: headers)
      .to_return(status: 200, body: "", headers: {})

    stub_request(:post, "#{url_prefix}/statuses/#{sha}")
      .with(body: '{"context":"Branch Name","description"'\
        ':"","state":"success"}',
            headers: headers)
      .to_return(status: 200, body: "", headers: {})

    stub_request(:get, "#{url_prefix}/issues/27")
      .with(headers: { "Accept" => "*/*", "User-Agent" => "Ruby" })
      .to_return(status: 200, body: labels, headers: {})

    subject.new(payload)
  end

  it "should be pending" do
    labels = File.read(
      File.expand_path("./test/fixtures/pull_request/labels/pending.json")
    )
    stub_request(:post, "#{url_prefix}/statuses/#{sha}")
      .with(body: '{"context":"Peer Review","description"'\
        ':"Labels \'backend approved\' and \'frontend approved\''\
        ' are required","state":"pending"}',
            headers: headers)
      .to_return(status: 200, body: "", headers: {})

    stub_request(:post, "#{url_prefix}/statuses/#{sha}")
      .with(body: '{"context":"Branch Name","description"'\
        ':"","state":"success"}',
            headers: headers)
      .to_return(status: 200, body: "", headers: {})

    stub_request(:get, "#{url_prefix}/issues/27")
      .with(headers: { "Accept" => "*/*", "User-Agent" => "Ruby" })
      .to_return(status: 200, body: labels, headers: {})

    payload = File.read(
      File.expand_path("./test/fixtures/pull_request/opened.json")
    )

    payload = JSON.parse(payload)

    subject.new(payload)
  end

  it "should run a labeled pull request" do
    payload = File.read(
      File.expand_path("./test/fixtures/pull_request/labeled.json")
    )

    payload = JSON.parse(payload)

    labels = File.read(
      File.expand_path("./test/fixtures/pull_request/labels/needs_work.json")
    )
  
    stub_request(:post, "#{url_prefix}/statuses/#{sha}")
      .with(body: '{"context":"Peer Review","description"'\
        ':"Needs work","state":"failure"}',
            headers: headers)
      .to_return(status: 200, body: "", headers: {})

    stub_request(:post, "#{url_prefix}/statuses/#{sha}")
      .with(body: '{"context":"Branch Name","description"'\
        ':"Branches must start with bug-##### or story-#####.",'\
        '"state":"failure"}',
            headers: headers)
      .to_return(status: 200, body: "", headers: {})

    stub_request(:get, "#{url_prefix}/issues/27")
      .with(headers: { "Accept" => "*/*", "User-Agent" => "Ruby" })
      .to_return(status: 200, body: labels, headers: {})

    subject.new(payload)
  end
end
