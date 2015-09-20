require 'action_controller'
require 'active_support/hash_with_indifferent_access'

require 'weak_headers/base_validator'
require 'weak_headers/optional_validator'
require 'weak_headers/requires_validator'
require 'weak_headers/controller'
require 'weak_headers/validation_error'
require 'weak_headers/validator'
require 'weak_headers/version'

# Provides `validates_headers` DSL to controllers to validate request headers.
#
# Examples
#
#   class AuthController < ApplicationController
#     rescue_from WeakHeaders::ValidationError do |exception|
#       render text: exception.message, status: 400
#     end
#
#     validates_headers :create do
#       requires 'X-Test-Token'
#       optional 'X-Test-Id'
#     end
#
#     def create
#       respond_with Auth.authenticate(token: request.headers['X-Test-Token'])
#     end
#   end
#
module WeakHeaders
  def self.stats
    @stats ||= ActiveSupport::HashWithIndifferentAccess.new do |hash, key|
      hash[key] = ActiveSupport::HashWithIndifferentAccess.new
    end
  end

  class Railties < ::Rails::Railtie
    initializer 'weak_headers' do
      ActiveSupport.on_load :action_controller do
        ActionController::Base.extend WeakHeaders::Controller
      end
    end
  end
end
