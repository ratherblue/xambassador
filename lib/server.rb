require 'sinatra'

require 'xambassador/pull_request'

post '/event_handler' do
  payload = JSON.parse(params[:payload])

  case request.env['HTTP_X_GITHUB_EVENT']
  when 'pull_request'
    new Xambassador::PullRequest(payload)
  end
end
