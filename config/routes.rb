# Configure Sidekiq-specific session middleware
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use Rails.application.config.session_store, Rails.application.config.session_options

Rails.application.routes.draw do
  root 'pages#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :v5, defaults: { format: 'json' } do
    resources :demos, only: [:index, :show] do
      collection do
        get :demo
      end
    end
    
    resources :counselor_dashboard, only: %i[index] do
      collection do
        get :assesments_list
        get :last_sign_in_list
        get :lists_list
        get :unregistered_list
        get :student_auth_list
        get :da_funnel_list
        get :da_app_result_list
        get :da_documents_list
        get :common_app_status_list
        get :recommendations_requested_list
        get :unauthorized_student_reminder
        get :supporting_documents_sent_list
      end
    end
  end

  mount Sidekiq::Web => '/sidekiq'
end
