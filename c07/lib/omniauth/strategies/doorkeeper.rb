module OmniAuth
  module Strategies
    class Doorkeeper < OmniAuth::Strategies::OAuth2
      option :name, :doorkeeper
      option :client_options, site: ENV['DOORKEEPER_APP_URL'], authorize_path: '/oauth/authorize'

      uid  { raw_info['uid'] }
      info { { email: raw_info['email'] } }

      def raw_info
        @raw_info ||= access_token.get('/api/v1/me.json').parsed
      end
    end
  end
end
