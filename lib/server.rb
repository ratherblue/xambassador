require 'sinatra'
require 'json'

require_relative 'xambassador/pull_request'

post '/event_handler' do
  case request.env['HTTP_X_GITHUB_EVENT']
  when 'pull_request'
    payload = JSON.parse(request.body.read)
    Xambassador::PullRequest.new(payload)
  end
end
