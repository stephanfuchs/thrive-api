# Configure Sidekiq-specific session middleware
if Rails.env.development?
  Sidekiq::Web.use ActionDispatch::Cookies
  Sidekiq::Web.use Rails.application.config.session_store, Rails.application.config.session_options
end

Rails.application.routes.draw do
  root 'pages#index'

  # webhook
  post '/aws/:key/event', to: 'aws#events_received'

  if Rails.env.development?
    mount Sidekiq::Web => '/sidekiq'
  end
end
