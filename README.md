# xambassador

[![Build Status](https://img.shields.io/travis/ratherblue/xambassador.svg?style=flat-square)](https://travis-ci.org/ratherblue/xambassador)
[![Coverage Status](https://img.shields.io/coveralls/ratherblue/xambassador/master.svg?style=flat-square)](https://coveralls.io/r/ratherblue/xambassador?branch=master)

GitHub webhook written in Ruby

## Usage

Xambassador is intended to be used with Sinatra.

1. First install Xambassador with `gem install xambassador`

2. Create a new Sinatra webapp and in your `server.rb` file add the following code:

```rb
require 'sinatra'
require 'json'

require 'xambassador/pull_request'

post '/event_handler' do
  case request.env['HTTP_X_GITHUB_EVENT']
  when 'pull_request'
    payload = JSON.parse(request.body.read)
    Xambassador::PullRequest.new(payload)
  end
end
```
