module OmniAuth
  module Strategies
    class Local
      include OmniAuth::Strategy

      option :model, nil
      option :identifier, :email

      def model
        options[:model] || ::Passport
      end

      def passport
        @passport ||= model.send("find_by_#{options[:identifier]}", identifier)
      end

      def identifier
        return nil unless request[:identity]
        request[:identity][options[:identifier].to_s].send(:to_s)
      end

      def password
        return nil unless request[:identity]
        request[:identity]['password']
      end

      def request_phase
        redirect "/sign-in"
      end

      def callback_phase
        return fail!(:missing_identifier) unless identifier.present?
        return fail!(:missing_password) unless password.present?
        return fail!(:invalid_credentials) unless passport.try(:authenticate, password)
        super
      end

      uid do
        passport.account_id
      end

    end
  end
end
