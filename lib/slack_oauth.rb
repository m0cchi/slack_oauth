require_relative 'version'
require_relative 'helper.rb'
require 'sinatra/base'
require 'net/https'
require 'json'

module SlackOauth
  module Driver

    def self.registered(app)
      app.helpers SlackOauth::Driver::Helper

      app.get '/oauth' do
        if authorized?
          redirect app.settings.logined_uri
        elsif !params[:error].nil?
          redirect settings.error_uri
        elsif !params[:code].nil?
          if authorize(params[:code])
            redirect settings.logined_uri
          else
            redirect settings.error_uri
          end
        else
          redirect get_authentication_url
        end
      end

    end

  end
end
