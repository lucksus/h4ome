module API
  module Request
    module Authentication
      extend ActiveSupport::Concern

      included do
        before_action :init_auth
      end

      def init_auth

        return true if request.method == 'OPTIONS' || request.method == :options

        jwt = request.headers['JWT']

        # Also read tokens in from params
        jwt ||= request.params['JWT']

        if jwt.present?
          user_id = JwtService.new.user_id jwt
          @current_user = User.find user_id unless user_id.nil?
        end

        true
      end

      def require_user
        unless @current_user
          render_error(I18n.t('.errors.unauthorized_user'), 401)
        end
      end

      module ClassMethods

        def requires_auth(args)
          before_action :require_user, args
        end

      end

    end
  end
end
