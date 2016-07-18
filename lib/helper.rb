require 'sinatra/base'
require 'net/https'
require 'json'

module SlackOauth
  module Driver
    module Helper

      def authorize(code)
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
        res = JSON.parse(http.request(req).body)
        session[:authorized] = res['ok'] && settings.slack_allowed_teams.include?(res['team_name'])
        if session[:authorized]
          session[:slack_team] = res['team_name']
          session[:slack_access_token] = res['access_token']
          session[:slack_user_id] = res['user_id']
          session[:slack_team_id] = res['team_id']
        end
        session[:authorized]
      end

      def authorized?
        session[:authorized]
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
