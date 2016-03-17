require 'sinatra/base'

# Fake GitHub api
class FakeVersionOne < Sinatra::Base
  set :show_exceptions, false

  get "https://www15.v1host.com/KelleyBlueBook/rest-1.v1/Data/Story?sel=Number&where=Number='B-51609'" do
    # get "#{ENV['VERSION_ONE_URL']}/rest-1.v1/Data/Story" do
  end
end
