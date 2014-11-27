module OmniAuth
  module Strategies
    class Local
      include OmniAuth::Strategy

      option :user_model, nil
      option :login_field, :email
      option :login_transform, :to_s

      def request_phase
        redirect "/sign-in"
      end

      def callback_phase
        return fail!(:invalid_credentials) unless user.try(:authenticate, password)
        super
      end

      def user
        @user ||= user_model.send("find_by_#{options[:login_field]}", login)
      end

      def user_model
        options[:user_model] || ::User
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
        user.account_id
      end

    end
  end
end
