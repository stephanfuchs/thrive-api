class SessionToken < ApplicationRecord
  belongs_to :user
  enum platform: %i[web mobile]

  class << self
    def read_from_cache(decoded_token)
      Rails.cache.read(cache_key(decoded_token))
    end

    def verify(token)
      begin
        read_from_cache(JsonWebToken.decode(token))&.with_indifferent_access
      rescue => exception
        nil
      end
    end

    private

    def cache_key(decoded_token)
      "session_token_#{decoded_token[:tenant_id]}_#{decoded_token[:user_id]}_#{decoded_token[:platform]}"
    end
  end
end
