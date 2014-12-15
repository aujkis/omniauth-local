module OmniAuth
  module Strategies
    class Local
      include OmniAuth::Strategy

      option :identifier, :email

      def request_phase
        redirect "/sign-in"
      end

      def callback_phase
        return fail!(:invalid_credentials) unless passport.try(:authenticate, password)
        super
      end

      def account
        @account ||= Account.send("find_by_#{options[:identifier]}", identifier)
      end

      def passport
        @passport ||= Passport.find_by(strategy: :local, account_id: account.id) if account.present?
      end

      def identifier
        return nil unless request[:passport]
        request[:passport]['account_attributes'][options[:identifier].to_s].send(:to_s)
      end

      def password
        return nil unless request[:passport]
        request[:passport]['password']
      end

      uid do
        account.id
      end

    end
  end
end
