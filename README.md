# WeakHeaders
Validates `request.headers` in your rails controller.

## Installation
```ruby
gem 'weak_headers'
```

## Usage
```ruby
class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from WeakHeaders::ValidationError do |e|
    render json: { message: e.message }, status: 400
  end
end

# WeakHeaders provides `validates_headers` class method to define validations.
class AuthController < ApplicationController
  validates_headers :create do
    requires 'X-App-Client-Id', except: ["token", "123456"]
    optional :'X-App-Id', only: '1'
    requires 'X-App-Client-Secret' do |value|
      value =~ /\A\w{64}\z/
    end
  end

  def create
    auth = Application.authenticate(uid: request.headers['X-App-Client-Id'], secret: request.headers['X-App-Client-Secret'])
    render json: { token: auth.token }
  end
end
```

### Available validators
- requires
- optional

### Available options
- only
- except
- handler

## Inspired By
- [weak_parameters](https://github.com/r7kamura/weak_parameters)

