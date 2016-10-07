module API
  module Response
    class ResponseState

      attr_accessor :errors, :validation_errors, :info

      def initialize
        @errors ||= Array.new
        @validation_errors ||= Array.new

        @info ||= Hash.new
      end

      def add_error(message, exception=nil)
        @errors.push({
                         message: message,
                         exception: exception.try(:inspect),
                         trace: exception.try(:backtrace)
                     })
      end

      def add_validation_error(field, message)
        @validation_errors.push({
                                    field: field,
                                    message: message
                                })
      end

      def add_info(key, value)
        info[key.to_s.camelize(:lower)] = value
      end

      def has_errors?
        @errors.any? || @validation_errors.any?
      end

    end
  end
end
