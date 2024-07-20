# Configure Sidekiq-specific session middleware
if Rails.env.development?
  Sidekiq::Web.use ActionDispatch::Cookies
  Sidekiq::Web.use Rails.application.config.session_store, Rails.application.config.session_options
end

Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  root 'pages#index'

  # webhook
  post '/aws/:key/event', to: 'aws#events_received'

  namespace :v1, defaults: { format: 'json' } do
    resources :demos, only: [:index, :show] do
      collection do
        get :demo
      end
    end
  end

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
    mount Sidekiq::Web => '/sidekiq'
  end
end
