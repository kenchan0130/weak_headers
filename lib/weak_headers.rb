require 'action_controller'
require 'active_support/hash_with_indifferent_access'

require 'weak_headers/base_validator'
require 'weak_headers/optional_validator'
require 'weak_headers/requires_validator'
require 'weak_headers/controller'
require 'weak_headers/validation_error'
require 'weak_headers/validator'
require 'weak_headers/version'

# Provides `header_validates` DSL to controllers to validate request headers.
#
# Examples
#
#   class AuthController < ApplicationController
#     rescue_from WeakHeaders::ValidationError do |e|
#       render text: e.message, status: 400
#     end
#
#     header_validates :create do
#       requires 'X-Test-Token'
#       optional 'X-Test-Id' do |value|
#         value =~ /\A\d+\z/
#       end
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
        ActionController::API.extend WeakHeaders::Controller if Object.const_defined?('ActionController::API')
      end
    end
  end
end
