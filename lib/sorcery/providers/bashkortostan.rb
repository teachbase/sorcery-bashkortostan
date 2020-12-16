require 'sorcery/providers/base'

module Sorcery
  module Providers
    class Bashkortostan < Base
      include Protocols::Oauth2

      attr_accessor :auth_path, :token_path, :scope, :user_info

      def initialize
        super

        @auth_path  = '/oauth/authorize.php'
        @token_path = '/oauth/token.php'
        @grant_type = 'authorization_code'
        @user_info  = '/oauth/userinfo.php'
      end

      def get_user_hash(token)
        token_response = token.params
        response = access_token.get(user_info_url)
        {
          user_info: {},
          uid: rand(10000)
        }
      end

      def login_url(params, session)
        authorize_url(authorize_url: auth_path)
      end

      def process_callback(params, _session)
        args = {}.tap do |a|
          a[:code] = params[:code] if params[:code]
        end

        get_access_token(args, token_url: token_path, token_method: :post)
      end
    end
  end
end
