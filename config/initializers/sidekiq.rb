# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq/web'

sidekiq_redis_settings = {
  url: "redis://#{ENV['REDIS_SIDEKIQ_HOST']}:6379/0",
  network_timeout: 5
}

Sidekiq.configure_server do |config|
  config.redis = sidekiq_redis_settings
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_redis_settings
end

if !Rails.env.development?
  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == [ENV['SIDEKIQ_USERNAME'], ENV['SIDEKIQ_PASSWORD']]
  end
end
