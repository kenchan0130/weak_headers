module WeakHeaders
  class Validator
    def initialize(controller, &block)
      @controller = controller
      instance_eval(&block)
    end

    def validate
      validators.each(&:validate)
    end

    def validators
      @validators ||= []
    end

    private

    def with_validators(&block)
      old_validators = @validators

      begin
        @validators = []
        block.call
        @validators
      ensure
        @validators = old_validators
      end
    end

    def requires(key, options = {}, &block)
      validators << WeakHeaders::RequiresValidator.new(@controller, key, options, &block)
    end

    def optional(key, options = {}, &block)
      validators << WeakHeaders::OptionalValidator.new(@controller, key, options, &block)
    end
  end
end
