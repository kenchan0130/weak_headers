module WeakHeaders
  class BaseValidator
    def initialize(controller, key, options = {}, &block)
      @controller = controller
      @key        = key.to_s
      @options    = options
      @block      = block
    end

    def validate
      handle_failure unless valid?
    end

    def type
      self.class.name.split('::').last.sub(/Validator\z/, '').underscore.to_sym
    end

    private

    def valid?
      case
      when requires? && blank?
        false
      when present? && exceptional?
        false
      when requires? && @block && !@block.call(value)
        false
      when optional? && present? && @block && !@controller.instance_exec(value, &@block)
        false
      else
        true
      end
    end

    def headers
      @controller.request.headers
    end

    def value
      headers[@key]
    end

    def handle_failure
      if has_handler?
        @controller.send(@options[:handler])
      else
        raise_error
      end
    end

    def blank?
      headers.nil? || headers[@key].blank?
    end

    def present?
      !blank?
    end

    def requires?
      type == :requires
    end

    def optional?
      type == :optional
    end

    def exceptional?
      case
      when @options[:only].try(:exclude?, value)
        true
      when @options[:except].try(:include?, value)
        true
      else
        false
      end
    end

    def raise_error
      raise WeakHeaders::ValidationError, error_message
    end

    def error_message
      "request.headers[#{@key.inspect}] must be a valid value"
    end

    def has_handler?
      !!@options[:handler]
    end
  end
end
