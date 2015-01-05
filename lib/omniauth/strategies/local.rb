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
        return fail!(:invalid_credentials) unless identity.try(:authenticate, user_secret)
        super
      end

      def identity
        @identity ||= Identity.find_by(provider_id: provider.id, account_id: account.id) if provider.present? and account.present?
      end

      def provider
        @provider ||= Provider.find_by(strategy: :local)
      end

      def account
        @account ||= Account.send("find_by_#{options[:user_key]}", user_key)
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
        identity.uid
      end

    end
  end
end
