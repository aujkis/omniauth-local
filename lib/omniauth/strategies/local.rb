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
        # if request[:identity]
        #   request[:identity][options[:identifier].to_s].send(:to_s)
        # else
        #   ''
        # end
      end

      def password
        return '' unless request[:identity]
        request[:identity]['password']
        # if request[:identity]
        #   request[:identity]['password']
        # else
        #   ''
        # end
      end

      def request_phase
        redirect "/sign-in"
      end

      def callback_phase
        return fail!(:identifier_missing) unless identifier == ''
        return fail!(:password_missing) unless password == ''
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
