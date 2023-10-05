# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:8080'
      resource '*', headers: :any, methods: [:get, :post, :options]
      resource '/upload_template', headers: :any, methods: [:post]
      resource '/templates', headers: :any, methods: [:get, :post, :delete]
      resource '/rails/active_storage/disk/*', headers: :any, methods: [:get]
    end
  end
  

  