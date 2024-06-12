# frozen_string_literal: true

Searchkick.redis = ConnectionPool.new { Redis.new(host: ENV['REDIS_SIDEKIQ_HOST']) }
Searchkick.search_method_name = :elastic_search
Searchkick.queue_name = :searchkick
