class API::V1::SessionsController < API::V1::BaseController
  requires_auth only: [:destroy]

  def create

    user = User.find_for_database_authentication(email: params[:email])
    return invalid_login_attempt unless user

    if user.valid_password?(params[:password])
      sign_in("user", user)
      @token = JwtService.new.build_token user_id: user.id
      return
    end
    invalid_login_attempt
  end

  private

  private
  def login_params
    params.permit(:email, :password)
  end

  def invalid_login_attempt
    warden.custom_failure!
    add_error(I18n.t(:invalid, scope: [:devise, :failure]))
    set_status 401
    render template: 'api/v1/empty'
  end
end
