require 'sorcery/providers/base'

module Sorcery
  module Providers
    # This class adds support for OAuth with hh.ru.
    #
    #   config.bcs.key = <key>
    #   config.bcs.secret = <secret>
    #   ...
    #
    class Tochkabank < Base
      include Protocols::Oauth2

      attr_accessor :auth_path, :token_path, :scope, :response_type

      def initialize
        super

        @scope          = "default"
        @site           = "https://auth-test.tochka-tech.com"
        @auth_path      = '/authorize'
        @token_path     = '/token'
        @grant_type     = 'authorization_code'
      end

      def get_user_hash(token)
        token_response = token.params
        {
          user_info: token_response.fetch("user"),
          uid: token_response.fetch("login").gsub(%r{^*.//}, "").downcase
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
