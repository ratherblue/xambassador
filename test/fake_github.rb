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

  patch '/repos/:owner/:repo/pulls/:number' do
  end

  get '/repos/:owner/:repo/pulls/:number/files' do
    if params[:number] == '27'
      json_response(200, 'pull_request/all_pass/files.json')
    elsif params[:number] == '28'
      json_response(200, 'pull_request/all_fail/files.json')
    elsif params[:number] == '29'
      json_response(200, 'pull_request/all_pending/files.json')
    end
  end

  post '/repos/:owner/:repo/statuses/:ref' do
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
