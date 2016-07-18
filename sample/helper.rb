require 'sinatra/base'
require 'slack_oauth'

helpers SlackOauth::Driver::Helper

configure do
  set :slack_token, 'xxxxx-xxxxx-xxxx-xxxx'
  set :slack_client_id, 'nnnnnn.nnnnn'
  set :slack_secret_key, 'xxxxxxxxxxxxxxxxxx'
  set :logined_uri, '/'
  set :error_uri, '/'
  set :slack_redirect_uri, 'http://yourhost:4567/your-path'
  set :slack_team, 'your-team' # or nil
  set :slack_allowed_teams, ['allowed team']
  set :slack_scope, 'identify'
  use Rack::Session::Pool,
      :expire_after => 3600
end

get '/your-path' do
  if !params[:error].nil?
    redirect settings.error_uri
  elsif !params[:code].nil?
    if authorize(params[:code])
      redirect settings.logined_uri
    else
      redirect settings.error_uri
    end
  end
end

get '/signin' do
  if authorized?
    redirect settings.logined_uri
  else
    redirect get_authentication_url
  end
end

get '/' do
  <<-EOS
<html>
<body>
#{(authorized?) ? 'Authorized<br>' : ''}
<a href="/signin">sign in</a>
</body>
</html>
EOS
end

get '/signout' do
  session.clear
end
