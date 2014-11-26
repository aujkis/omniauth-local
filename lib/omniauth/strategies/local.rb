module OmniAuth
  module Strategies
    class Local
      include OmniAuth::Strategy

      option :login_field, :email
      option :login_transform, :to_s

      def request_phase
        redirect "/sign-in"
      end

      def callback_phase
        return fail!(:invalid_credentials) unless Account.try(:authenticate, password)
        super
      end

      def user
        @user ||= user_model.send("find_by_#{options[:login_field]}", login)
      end

      def login
        if request[:identity]
          request[:identity][options[:login_field].to_s].send(options[:login_transform])
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
        user.password_digest
      end

    end
  end
end
