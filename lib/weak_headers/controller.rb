module WeakHeaders
  module Controller
    def validates_header(action_name = nil, &block)
      filter_option = {}
      filter_option.merge!(only: action_name) unless action_name.nil?

      before_filter filter_option do
        validator = WeakHeaders::Validator.new(self, &block)
        WeakHeaders.stats[params[:controller]][params[:action]] = validator
        WeakHeaders.stats[params[:controller]][params[:action]].validate
      end
    end
  end
end
