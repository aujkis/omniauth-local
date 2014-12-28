module OmniAuth
  module Strategies
    class Local
      include OmniAuth::Strategy

      option :identifier, :email

      def request_phase
        redirect "/sign-in"
      end

      def callback_phase
        return fail!(:invalid_credentials) unless identity.try(:authenticate, password)
        super
      end

      def account
        @account ||= Account.send("find_by_#{options[:identifier]}", identifier)
      end

      def identity
        @identity ||= Identity.find_by(strategy: :local, account_id: account.id) if account.present?
      end

      def identifier
        return nil unless request[:identity]['account_attributes']
        request[:identity]['account_attributes'][options[:identifier].to_s].send(:to_s)
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
