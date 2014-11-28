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
        return '' unless request[:identity]
        request[:identity][options[:identifier].to_s].send(:to_s)
      end

      def password
        return '' unless request[:identity]
        request[:identity]['password']
      end

      def request_phase
        redirect "/sign-in"
      end

      def callback_phase
        return fail!(:identifier_missing) if identifier == ''
        return fail!(:password_missing) if password == ''
        return fail!(:instance_missing) unless passport.present?
        return fail!(:invalid_credentials) unless passport.try(:authenticate, password)
        super
      end

      uid do
        passport.account_id
      end

    end
  end
end
