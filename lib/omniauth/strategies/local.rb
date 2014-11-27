module OmniAuth
  module Strategies
    class Local
      include OmniAuth::Strategy

      option :model, nil
      option :identifier, :email

      def request_phase
        redirect "/sign-in"
      end

      def callback_phase
        return fail!(:invalid_credentials) unless passport.try(:authenticate, password)
        super
      end

      def passport
        @passport ||= model.send("find_by_#{options[:identifier]}", identifier)
      end

      def model
        options[:model] || ::Passport
      end

      def identifier
        if request[:identity]
          request[:identity][options[:identifier].to_s].send(:to_s)
        else
          ''
        end
      end

      def password
        if request[:identity]
          request[:identity]['password']
        else
          ''
        end
      end

      uid do
        passport.account_id
      end

    end
  end
end
