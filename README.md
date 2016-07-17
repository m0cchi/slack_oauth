# SlackOauth

oauth client library for sinatra

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slack_oauth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install slack_oauth

## Usage

```ruby
require 'sinatra/base'
require 'slack_oauth'

register SlackOauth::Driver

use Rack::Session::Cookie,
    :expire_after => 3600,
    :secret => 'change'

configure do
  set :slack_token, 'xxxxx-xxxxx-xxxx-xxxx'
  set :slack_client_id, 'nnnnnn.nnnnn'
  set :slack_secret_key, 'xxxxxxxxxxxxxxxxxx'
  set :logined_uri, '/'
  set :error_uri, '/'
  set :slack_redirect_uri, 'http://yourhost:4567/oauth'
  set :slack_team, 'your-team' # or nil
  set :slack_allowed_teams, ['allowed team']
  set :slack_scope, 'identify'
  use Rack::Session::Cookie,
      :expire_after => 3600,
      :secret => 'change'
end

get '/' do
 <<-EOS
<html>
<body>
#{(authorized?) ? 'Authorized<br>' : ''}
<a href="#{get_authentication_url}">sign in</a>
</body>
</html>
EOS
end

get '/signout' do
  session.clear
end

```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/m0cchi/slack_oauth.
