module OmniAuth
  module Strategies
    class Local
      include OmniAuth::Strategy

      option :user_key, :email
      option :user_secret, :password

      def request_phase
        redirect "/sign-in"
      end

      def callback_phase
        env['omniauth.identity'] = request[:identity]
        return fail!(:invalid_credentials) unless identity.try(:authenticate, user_secret)
        super
      end

      def identity
        @identity ||= Crossties::Identity.find_by(strategy: 'local', account_id: account.id) if account.present?
      end

      def account
        @account ||= Crossties::Account.send("find_by_#{options[:user_key]}", user_key)
      end

      def user_key
        return nil unless request[:identity]
        return nil unless request[:identity]['account_attributes']
        request[:identity]['account_attributes'][options[:user_key].to_s].send(:to_s)
      end

      def user_secret
        return nil unless request[:identity]
        request[:identity][options[:user_secret].to_s].send(:to_s)
      end

      uid do
        identity.oauth_uid
      end

    end
  end
end
