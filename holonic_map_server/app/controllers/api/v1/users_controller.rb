class API::V1::UsersController < API::V1::BaseController
  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render 'api/v1/empty'
    else
      render_errors(@user)
    end
  end

  private
  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end

end
