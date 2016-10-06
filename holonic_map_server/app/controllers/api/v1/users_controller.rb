class API::V1::UsersController < API::V1::BaseController
  def index
    @users = User.all
  end
end
