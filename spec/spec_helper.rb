ENV['RAILS_ENV'] ||= 'test'

require 'bundler/setup'
require 'action_controller/railtie'
require 'rspec/rails'

Bundler.require(:default, ENV['RAILS_ENV'])

require 'weak_headers'

class DummyApplication < Rails::Application
  config.secret_key_base = 'test'
end

Rails.application = DummyApplication

RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
end
