class API::V1::BaseController < ApplicationController
  include API::Response::ResponseHelper
  include API::Request::Authentication
  skip_before_action :verify_authenticity_token

  def render_error(message, status=500)
    add_error(message)
    set_status status
    render template: 'api/v1/empty'
  end

  def render_errors(object)
    if object.errors.any?
      add_error("Validation Error")
      add_validation_info(object)
    else
      add_error("Could not save #{object.class}")
    end
    set_status 400
    render template: 'api/v1/empty'
  end

end
