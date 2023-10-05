Rails.application.routes.draw do
  post '/upload_template', to: 'templates#create', as: 'upload_template'
  get '/templates', to: 'templates#index', as: 'templates'
  get '/templates/:template_id', to: 'templates#templatesid', as: 'templatesid'

end