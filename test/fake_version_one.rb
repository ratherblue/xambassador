require 'sinatra/base'

# Fake GitHub api
class FakeVersionOne < Sinatra::Base
  set :show_exceptions, false

  get "#{ENV['VERSION_ONE_URL']}/Data/Story" do
    # get "#{ENV['VERSION_ONE_URL']}/rest-1.v1/Data/Story" do
  end
end
