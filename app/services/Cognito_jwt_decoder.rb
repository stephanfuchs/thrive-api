# INFO: (Stephan) Links
#   https://medium.com/@victor.leong.17/decoding-aws-cognito-jwt-in-rails-f88c1c4db9ec
# More context
#   https://github.com/jwt/ruby-jwt?tab=readme-ov-file#support-for-reserved-claim-names
#   'exp' (Expiration Time) Claim
#   'nbf' (Not Before Time) Claim
#   'iss' (Issuer) Claim
#   'aud' (Audience) Claim
#   'jti' (JWT ID) Claim
#   'iat' (Issued At) Claim
#   'sub' (Subject) Claim
class CognitoJwtDecoder
  attr_reader :jwks_url

  def initialize
    @jwks_url = "https://cognito-idp.#{ENV.fetch('AWS_COGNITO_REGION', '')}.amazonaws.com/#{ENV.fetch('AWS_COGNITO_POOL_ID', '')}/.well-known/jwks.json"
  end

  def jwt_config
    @jwt_config ||= begin
      Rails.cache.fetch("jwt_config_#{Rails.env}_#{Digest::MD5.hexdigest(ENV.fetch('AWS_COGNITO_POOL_ID', ''))}", expires_in: 12.hours) do
        JSON.parse(Net::HTTP.get(URI.parse(jwks_url)))
      end
    end
  end

  def decode_token(token)
    # TODO: (Stephan) reevaluate if additional security parameters should be added
    decoded_token = JWT.decode(token, nil, true, {
      jwks: jwt_config,
      algorithms: ['RS256'],
      verify_iat: true,
      required_claims: [
        "sub",
        "cognito:groups",
        "email_verified",
        "iss",
        "cognito:username",
        "origin_jti",
        "aud",
        "account_id",
        "event_id",
        "user_id",
        "token_use",
        "auth_time",
        "timezone_id",
        "name",
        "custom:account_id",
        "exp",
        "iat",
        "jti",
        "email"
      ],
    })

    decoded_token
  rescue JWT::DecodeError => e
    puts "Token verification failed: #{e.message}"
    nil
  end
end
