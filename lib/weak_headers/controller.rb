module WeakHeaders
  module Controller
    def validates_headers(action_name = nil, &block)
      filter_options = {}
      filter_options.merge!(only: action_name) unless action_name.nil?

      before_filter filter_options do
        validator = WeakHeaders::Validator.new(self, &block)
        WeakHeaders.stats[params[:controller]][params[:action]] = validator
        WeakHeaders.stats[params[:controller]][params[:action]].validate
      end
    end
  end
end
