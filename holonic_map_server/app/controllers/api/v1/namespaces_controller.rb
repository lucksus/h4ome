class API::V1::NamespacesController < API::V1::BaseController
  def index
  end

  def show
    path
    if @path[0] == 'home'
      user = User.find_by username: @path[1]
      @hash = user.home_hash if user
    end

    render_error 'namespace not found', 404 unless @hash
  end

  def update
    path
    if @path[0] == 'home'
      user = User.find_by username: @path[1]
      unless user.nil? then
        @found = true
        if @current_user && @current_user.id == user.id
          user.home_hash = params[:hash]
          user.save!
          @hash = params[:hash]
        else
          render_error 'write not allowed', 401
        end
      end
    end

    unless @found then
      render_error 'namespace not found', 404
    end
  end

  protected

  def path
    path = params[:path]
    path = path + "." + params[:format].to_s unless params[:format] == :json
    @path = path.split('/')
  end
end
