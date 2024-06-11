# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use Rails.application.config.session_store, Rails.application.config.session_options

Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  root 'pages#index'
  mount Sidekiq::Web => '/sidekiq'

  # webhook
  post '/aws/:key/event', to: 'aws#events_received'

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
end
