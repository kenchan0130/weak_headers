module WeakHeaders
  module Controller
    def validates_headers(*args, &block)
      filter_options = {}
      filter_options.merge!(only: args.flatten) unless args.empty?

      before_filter filter_options do
        validator = WeakHeaders::Validator.new(self, &block)
        WeakHeaders.stats[params[:controller]][params[:action]] = validator
        WeakHeaders.stats[params[:controller]][params[:action]].validate
      end
    end
  end
end
