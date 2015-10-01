require_relative 'spec_helper'

RSpec.describe 'Anything', type: :controller do
  controller do
    extend WeakHeaders::Controller
    include Rails.application.routes.url_helpers

    def index
      render text: 'dummy'
    end

    def update
      render text: 'dummy'
    end

    def destory
      render text: 'dummy'
    end

    rescue_from WeakHeaders::ValidationError do |e|
      render text: e.message, status: 400
    end

    validates_headers :index do
      requires 'X-Test-Token'
      optional 'X-Test-Id' do |value|
        value =~ /\A\d+\z/
      end
    end

    validates_headers :update, :destory do
      requires 'X-Test-Id'
    end
  end

  context 'with incorrect headers' do
    it 'should return 400' do
      get :index

      expect(response).to have_http_status(400)
    end

    context 'with block' do
      before do
        request.headers['X-Test-Id'] = 'test'
      end

      it 'should return 400' do
        get :index

        expect(response).to have_http_status(400)
      end
    end
  end

  context 'with correct headers' do
    before do
      request.headers['X-Test-Token'] = 'token'
    end

    it 'should return 200' do
      get :index

      expect(response).to have_http_status(200)
    end
  end

  context 'given array arguments' do
    before do
      routes.draw do
        put 'update' => 'anonymous#update'
        delete 'destory' => 'anonymous#destory'
      end
    end

    it 'should return 400' do
      put :update

      expect(response).to have_http_status(400)
    end

    it 'should return 400' do
      delete :destory

      expect(response).to have_http_status(400)
    end
  end
end
