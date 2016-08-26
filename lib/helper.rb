require 'sinatra/base'
require 'net/https'
require 'json'
require 'securerandom'

module SlackOauth
  module Driver
    module Helper

      def request_oauth_access(code)
        uri = URI.parse('https://slack.com/api/oauth.access')
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        req = Net::HTTP::Post.new(uri.path)

        params = {client_id: settings.slack_client_id,
                  client_secret: settings.slack_secret_key,
                  code: code}

        if has_settings(:slack_redirect_uri)
          params[:redirect_uri] = settings.slack_redirect_uri
        end

        req.set_form_data(params)
        body = http.request(req).body
        JSON.parse(body)
      end

      def authorize(code)
        credential = request_oauth_access(code)
        session[:slack_authorized] = credential['ok'] && settings.slack_allowed_teams.include?(credential['team_name'])
        
        if session[:slack_authorized]
          session[:slack_team] = credential['team_name']
          session[:slack_access_token] = credential['access_token']
          session[:slack_user_id] = credential['user_id']
          session[:slack_team_id] = credential['team_id']
        end

        session[:slack_authorized]
      end

      def authorized?
        session[:slack_authorized]
      end

      def validate_state(state)
        session[:slack_state] == state
      end

      def get_params
        params = []

        params << "client_id=#{settings.slack_client_id}"
        params << "scope=#{settings.slack_scope}"

        if has_settings(:slack_team)
          params << "team=#{settings.slack_team}"
        end

        if has_settings(:slack_redirect_uri)
          params << "redirect_uri=#{settings.slack_redirect_uri}"
        end

        @slack_state_generator ||= has_settings(:slack_state_generator) ?  settings.slack_state_generator : ->{
          SecureRandom.hex(32)
        }

        session[:slack_state] = @slack_state_generator.call
        params << "state=#{session[:slack_state]}"

        "?#{params.join('&')}"
      end

      def get_authentication_url
        "https://slack.com/oauth/authorize#{get_params}"
      end

      private

      def has_settings(name)
        !!settings.methods.include?(name) && settings.send((name.to_s + '?').to_sym)
      end

    end
  end
end
