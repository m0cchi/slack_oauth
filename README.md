# SlackOauth

oauth client library for sinatra

# Coverage
- Whether authorized with allowed team
- authorized user's token(slack)
- team id(slack) using the authorization
- team name(slack) using the authorization

# Caution
don't use Rack::Session::Cookie

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

configure do
  set :slack_token, 'xxxxx-xxxxx-xxxx-xxxx' # required
  set :slack_client_id, 'nnnnnn.nnnnn' # required
  set :slack_secret_key, 'xxxxxxxxxxxxxxxxxx' # required
  set :logined_uri, '/' # required if use register
  set :error_uri, '/' # required if use register
  set :slack_redirect_uri, 'http://yourhost:4567/oauth'
  set :slack_team, 'your-team' # or nil
  set :slack_allowed_teams, ['allowed team'] # required
  set :slack_scope, 'identify' # required
  use Rack::Session::Pool, # slack_oauth use session
      :expire_after => 3600
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

## simple access control
```ruby
before do
  redirect_page = '/oauth'
  other_page = '/top_page'
  unless authorized? || [redirect_page, other_page].include?(request.path_info)
    redirect get_authentication_url
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/m0cchi/slack_oauth.
