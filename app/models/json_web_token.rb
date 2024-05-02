# frozen_string_literal: true
require 'jwt'

class JsonWebToken
  class << self

    ALGO = 'HS512'

    def encode(payload, exp = 1.years.from_now)
      # currently we are not using the JWT token expiry to invalidate the token, but we are using the session expiry to invalidate the token, for now this expiry is set to 1 year and doesn't mean anything
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.credentials.secret_key_base, ALGO)
    end

    def decode(token)
      body = JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: ALGO)[0]
      HashWithIndifferentAccess.new(body)
    end
  end
end
