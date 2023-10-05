require_relative 'boot'
require 'image_processing/mini_magick'
require 'rails/all'
require 'rack/cors'

Bundler.require(*Rails.groups)

module RailsForms
  class Application < Rails::Application
    config.load_defaults 5.2
    
    # Set Content Security Policy (CSP) headers
    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'ALLOWALL',
      'Content-Security-Policy' => "frame-ancestors 'self' http://localhost:8080"
    }
    

    # Allow Cross-Origin Resource Sharing (CORS) from all origins
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://localhost:8080'# Replace with the actual origin of your web application
        resource '/rails/active_storage/disk/*', headers: :any, methods: [:get]
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end
  end
end