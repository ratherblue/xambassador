require 'sinatra/base'

# Fake GitHub api
class FakeGitHub < Sinatra::Base
  set :show_exceptions, false

  get '/repos/:owner/:repo/issues/:number' do
    # 27 is the good pull request
    if params[:number] == '27'
      json_response(200, 'pull_request/all_pass/issues.json')
    elsif params[:number] == '28'
      json_response(200, 'pull_request/all_fail/issues.json')
    elsif params[:number] == '29'
      json_response(200, 'pull_request/all_pending/issues.json')
    end
  end

  post '/repos/:owner/:repo/statuses/:ref' do
  end

  get '/repos/:owner/:repo/git/trees/:sha' do
    if params[:sha] == 'good-sha'
      json_response(200, 'pull_request/all_pass/tree.json')
    elsif params[:sha] == 'bad-sha'
      json_response(200, 'pull_request/all_fail/tree.json')
    elsif params[:sha] == 'pending-sha'
      json_response(200, 'pull_request/all_pending/tree.json')
    end
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
