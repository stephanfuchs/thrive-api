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

    # Example decoded token
    # [ { "sub" => "c6e6f88c-8a7f-41a3-8688-112389a68a5f", "cognito:groups" => [ "Admin" ], "email_verified" => true, "iss" => "https://cognito-idp.us-west-2.amazonaws.com/us-west-2_tAuKrxgXB", "cognito:username" => "c6e6f88c-8a7f-41a3-8688-112389a68a5f", "origin_jti" => "cabecb9e-d3a8-4694-a613-0d05a805a6fc", "aud" => "73refvq1gua59llbqb4tbuuq0q", "account_id" => "1", "event_id" => "408a332e-7855-4adc-9ad7-1c3eecaf14ec", "user_id" => "197", "token_use" => "id", "auth_time" => 1717311176, "timezone_id" => "294", "name" => "Stephan Fuchs", "custom:account_id" => "1", "exp" => 1719064254, "iat" => 1719060656, "jti" => "ebebafe4-96e0-4f08-941f-4733f1807b67", "email" => "stephanfuchs@thrivealts.com" }, { "kid" => "sHsOSyQuyuT7j9GFoVGOlG0XAhtudeG0M5XbpYkjVg4=", "alg" => "RS256" } ]

    decoded_token
  rescue JWT::DecodeError => e
    puts "Token verification failed: #{e.message}"
    nil
  end
end
