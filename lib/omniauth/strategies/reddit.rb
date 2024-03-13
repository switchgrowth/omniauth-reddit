require 'omniauth/strategies/oauth2'
require 'base64'
require 'rack/utils'

module OmniAuth
  module Strategies
    class Reddit < OmniAuth::Strategies::OAuth2
      option :name, 'reddit'
      option :authorize_options, %i[scope duration]

      option :client_options, {
        site: 'https://ads-api.reddit.com',
        authorize_url: 'https://www.reddit.com/api/v1/authorize',
        token_url: 'https://www.reddit.com/api/v1/access_token'
      }

      uid { raw_info['data']['id'] }

      info do
        {
          username: raw_info['data']['reddit_username'],
          first_name: raw_info['data']['firstname'],
          last_name: raw_info['data']['lastname'],
          email: raw_info['data']['email'],
          phone: raw_info['data']['phone']
        }
      end

      extra do
        { 'raw_info' => raw_info }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/v3/me').parsed || {}
      end

      def build_access_token
        options.token_params.merge!(headers: { 'Authorization' => basic_auth_header })
        super
      end

      def basic_auth_header
        auth = Base64.strict_encode64("#{options[:client_id]}:#{options[:client_secret]}")
        "Basic #{auth}"
      end

      def callback_url
        options[:redirect_uri] || (full_host + script_name + callback_path)
      end
    end
  end
end
