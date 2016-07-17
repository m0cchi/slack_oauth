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
        req.set_form_data({client_id: settings.slack_client_id,
                           client_secret: settings.slack_secret_key,
                           code: code,
                           redirect_uri: settings.slack_redirect_uri})
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

        unless settings.slack_client_id.nil?
          params << "client_id=#{settings.slack_client_id}"
        end

        unless settings.slack_team.nil?
          params << "team=#{settings.slack_team}"
        end

        unless settings.slack_scope.nil?
          params << "scope=#{settings.slack_scope}"
        end

        unless settings.slack_redirect_uri.nil?
          params << "redirect_uri=#{settings.slack_redirect_uri}"
        end
        "?#{params.join('&')}"
      end

      def get_authentication_url
        "https://slack.com/oauth/authorize#{get_params}"
      end

    end
  end
end
