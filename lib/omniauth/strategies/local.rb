module OmniAuth
  module Strategies
    class Local
      include OmniAuth::Strategy

      def request_phase
        redirect "/sign-in"
      end

      def callback_phase
        return fail!(:invalid_credentials) unless identity.try(:authenticate, password)
        super
      end

      def provider
        @provider ||= Provider.find_by(strategy: :local)
      end

      def account
        @account ||= Account.find_by(email: email)
        # @account ||= Account.send("find_by_#{options[:identifier]}", identifier)
      end

      def identity
        @identity ||= Identity.find_by(provider_id: provider.id, account_id: account.id) if provider.present? and account.present?
      end

      def email
        return nil unless request[:identity]['account_attributes']
        request[:identity]['account_attributes']['email'].send(:to_s)
        # request[:identity]['account_attributes'][options[:identifier].to_s].send(:to_s)
      end

      def password
        return nil unless request[:identity]
        request[:identity]['password']
      end

      uid do
        identity.provider_id
      end

    end
  end
end
