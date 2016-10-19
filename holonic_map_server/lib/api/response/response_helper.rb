require "#{Rails.root}/lib/api/response/response_state.rb"

module API
  module Response
    module ResponseHelper
      extend ActiveSupport::Concern

      included do
        helper_method :envelope, :response_state
        before_action :read_redirect_params

        original_render = instance_method(:render)

        @status_code ||= 200

        define_method(:render) do |*args|

          return if redirected?

          if args.first.is_a?(Hash)
            args.first.merge!({status: @status_code})
            original_render.bind(self).(*args)
          else
            original_render.bind(self).(*args, status: @status_code)
          end

        end
      end

      def envelope json, state
        json.meta do

          json.errors state.errors do |error|
            json.message error[:message]
            json.exception error[:exception] if error[:exception] && Rails.env.development?
            json.trace error[:trace] if error[:trace] && Rails.env.development?
          end

          json.validation state.validation_errors do |validation_info|
            json.field validation_info[:field]
            json.messages validation_info[:message]
          end

          state.info.each do |key, value|
            json.set! key, value
          end

        end

        json.data do
          yield if block_given?
        end
      end

      def response_state
        @response_state ||= API::Response::ResponseState.new
      end

      # Convenience methods

      def set_status(code = 500)
        @status_code = code
      end

      def add_error(message, exception=nil)
        response_state.add_error(message, exception)
      end

      def add_validation_info(entity)
        entity.errors.each do |field, messages|
          response_state.add_validation_error(field,
                                              entity.errors.full_messages_for(field))
        end
      end

      def add_info(key, value)
        response_state.add_info(key, value)
      end

      def read_redirect_params
        @redirect_url = request.query_parameters['redirect_success']
        @error_url    = request.query_parameters['redirect_error']
      end

      def redirected?
        if @response_state && @response_state.has_errors?
          url = @error_url || @redirect_url
          if url
            redirect_to redirect_url_with_error(url), status: 303
            return true
          end
        end
        if @redirect_url
          add_resource_id_to_redirect_url if request.post?
          redirect_to @redirect_url, status: 303
          return true
        end
        false
      end

      private

      def redirect_url_with_error(redirect_url)
        url = "#{redirect_url}?"
        redirect_params = { error: true }
        url += redirect_params.merge(@response_state.errors[0]).to_query
        url += '&' + @response_state.validation_errors.to_query(:validation_errors)
      end

      def add_resource_id_to_redirect_url
        @redirect_url.gsub!(/:id/, resource_id.to_s)
      end

      def resource_id
        instance_variable_get("@#{resource_name}").try(:id)
      end

      def resource_name
        request.path.split('/').last.singularize
      end


    end
  end
end
