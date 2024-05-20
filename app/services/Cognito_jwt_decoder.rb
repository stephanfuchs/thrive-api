class CognitoJwtDecoder
  def initialize
    @jwks_url = "https://cognito-idp.us-west-2.amazonaws.com/us-west-2_tAuKrxgXB/.well-known/jwks.json"
  end

  def fetch_jwks
    JSON.parse('{"keys":[{"alg":"RS256","e":"AQAB","kid":"sHsOSyQuyuT7j9GFoVGOlG0XAhtudeG0M5XbpYkjVg4=","kty":"RSA","n":"tj05fHe3qJpyaNOQaqtlr6ltl5nwnmCwuuBh2-gVpAQGBpAT-CzvXTnReuYm-LuDxnaiJn9j-fAZ21TZI3i2sxQl4-w1xrY-E2On4FORl4Hgm_gmsnxLgvUD7pH9p6ETOnNFy2HTMC1Th0OsIfHwrtX6il6ZF0AsaN1O_p2it-KlUlcfyJHgIkoas7lWrjA03yMNwp53HRB2ocFjNPXV4F27zfvbpPheGqTqDjZZu31CSM9NXS4Qf4UpgAr1AzFLeaVcWnvz5uJu5PsTPXQ-V0gq6Wfyx3VWK0SXLgXrNcs7zK3J4_L67E-DMt88dmM7lG3lzo8y0ln8EkJ7H28lrw","use":"sig"},{"alg":"RS256","e":"AQAB","kid":"lsSApuCe/DzpMeXLc2BbvUOyEaTy1Quc+m6InW75Cfs=","kty":"RSA","n":"5e_1-hwksUQTMbjm3C_D9Mq5GYMNoOAIKr7gRheOQbsqxZ5QTJ0g-jX_Csb0MRv12xmvMwGqp6_mHTajqv56DoEd5ItSD5ER8Rbcqm6S5poCyzf-4UhrY8hd6VIheD14JIRqLxB0PuAOLyyKW230ugqxwI5wUXXHTe6oPYBfqVMb30-hkzrl4fiaoa7Uf5vYs3riTba-qhiMvLCXUfo6OQgD0iSnM9_L5Yj3-If_FZq4yz7ByAIPvkyK06iV0v3Pk40T-JwrG7IhT-g_2F8R3rDo0a_4ZefJFP84_J7TlbPPtQeVTtCJCaVHyHbrzad1eeuhC8UlgrpVrUs5kesQnQ","use":"sig"}]}')
  end

  def decode_token(token)
    jwks = fetch_jwks
    public_keys = jwks['keys'].each_with_object({}) do |key, hash|
      binding.pry
      hash[key['kid']] = OpenSSL::X509::Certificate.new(
        Base64.decode64(key['x5c'].first)
      ).public_key
    end

    decoded_token = JWT.decode(token, nil, true, {
      algorithms: ['RS256'],
      jwks: public_keys,
      verify_iat: true,  # Verify issued at
      verify_expiration: true # Verify expiration
    }) do |header|
      public_keys[header['kid']]
    end

    decoded_token
  rescue JWT::DecodeError => e
    puts "Token verification failed: #{e.message}"
    nil
  end
end

# Example usage:
# user_pool_id = 'us-east-1_XXXXXX'
# region = 'us-east-1'
# token = 'your-jwt-token'
# decoder = CognitoJwtDecoder.new
# decoded_content = decoder.decode_token(token)
# puts decoded_content


# jwks_hash = {"keys":[{"alg":"RS256","e":"AQAB","kid":"sHsOSyQuyuT7j9GFoVGOlG0XAhtudeG0M5XbpYkjVg4=","kty":"RSA","n":"tj05fHe3qJpyaNOQaqtlr6ltl5nwnmCwuuBh2-gVpAQGBpAT-CzvXTnReuYm-LuDxnaiJn9j-fAZ21TZI3i2sxQl4-w1xrY-E2On4FORl4Hgm_gmsnxLgvUD7pH9p6ETOnNFy2HTMC1Th0OsIfHwrtX6il6ZF0AsaN1O_p2it-KlUlcfyJHgIkoas7lWrjA03yMNwp53HRB2ocFjNPXV4F27zfvbpPheGqTqDjZZu31CSM9NXS4Qf4UpgAr1AzFLeaVcWnvz5uJu5PsTPXQ-V0gq6Wfyx3VWK0SXLgXrNcs7zK3J4_L67E-DMt88dmM7lG3lzo8y0ln8EkJ7H28lrw","use":"sig"},{"alg":"RS256","e":"AQAB","kid":"lsSApuCe/DzpMeXLc2BbvUOyEaTy1Quc+m6InW75Cfs=","kty":"RSA","n":"5e_1-hwksUQTMbjm3C_D9Mq5GYMNoOAIKr7gRheOQbsqxZ5QTJ0g-jX_Csb0MRv12xmvMwGqp6_mHTajqv56DoEd5ItSD5ER8Rbcqm6S5poCyzf-4UhrY8hd6VIheD14JIRqLxB0PuAOLyyKW230ugqxwI5wUXXHTe6oPYBfqVMb30-hkzrl4fiaoa7Uf5vYs3riTba-qhiMvLCXUfo6OQgD0iSnM9_L5Yj3-If_FZq4yz7ByAIPvkyK06iV0v3Pk40T-JwrG7IhT-g_2F8R3rDo0a_4ZefJFP84_J7TlbPPtQeVTtCJCaVHyHbrzad1eeuhC8UlgrpVrUs5kesQnQ","use":"sig"}]}
# jwks = JWT::JWK::Set.new(jwks_hash)
# jwks_hash = jwks.export


# jwt_config = {"keys":[{"alg":"RS256","e":"AQAB","kid":"sHsOSyQuyuT7j9GFoVGOlG0XAhtudeG0M5XbpYkjVg4=","kty":"RSA","n":"tj05fHe3qJpyaNOQaqtlr6ltl5nwnmCwuuBh2-gVpAQGBpAT-CzvXTnReuYm-LuDxnaiJn9j-fAZ21TZI3i2sxQl4-w1xrY-E2On4FORl4Hgm_gmsnxLgvUD7pH9p6ETOnNFy2HTMC1Th0OsIfHwrtX6il6ZF0AsaN1O_p2it-KlUlcfyJHgIkoas7lWrjA03yMNwp53HRB2ocFjNPXV4F27zfvbpPheGqTqDjZZu31CSM9NXS4Qf4UpgAr1AzFLeaVcWnvz5uJu5PsTPXQ-V0gq6Wfyx3VWK0SXLgXrNcs7zK3J4_L67E-DMt88dmM7lG3lzo8y0ln8EkJ7H28lrw","use":"sig"},{"alg":"RS256","e":"AQAB","kid":"lsSApuCe/DzpMeXLc2BbvUOyEaTy1Quc+m6InW75Cfs=","kty":"RSA","n":"5e_1-hwksUQTMbjm3C_D9Mq5GYMNoOAIKr7gRheOQbsqxZ5QTJ0g-jX_Csb0MRv12xmvMwGqp6_mHTajqv56DoEd5ItSD5ER8Rbcqm6S5poCyzf-4UhrY8hd6VIheD14JIRqLxB0PuAOLyyKW230ugqxwI5wUXXHTe6oPYBfqVMb30-hkzrl4fiaoa7Uf5vYs3riTba-qhiMvLCXUfo6OQgD0iSnM9_L5Yj3-If_FZq4yz7ByAIPvkyK06iV0v3Pk40T-JwrG7IhT-g_2F8R3rDo0a_4ZefJFP84_J7TlbPPtQeVTtCJCaVHyHbrzad1eeuhC8UlgrpVrUs5kesQnQ","use":"sig"}]}
# token = "eyJraWQiOiJzSHNPU3lRdXl1VDdqOUdGb1ZHT2xHMFhBaHR1ZGVHME01WGJwWWtqVmc0PSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiJjNmU2Zjg4Yy04YTdmLTQxYTMtODY4OC0xMTIzODlhNjhhNWYiLCJjb2duaXRvOmdyb3VwcyI6WyJBZG1pbiJdLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLXdlc3QtMi5hbWF6b25hd3MuY29tXC91cy13ZXN0LTJfdEF1S3J4Z1hCIiwiY29nbml0bzp1c2VybmFtZSI6ImM2ZTZmODhjLThhN2YtNDFhMy04Njg4LTExMjM4OWE2OGE1ZiIsIm9yaWdpbl9qdGkiOiI5NDE3NThmNy1iZWZiLTRkMDItODcyYS0wMDY3MGZjYjk5YTgiLCJhdWQiOiI3M3JlZnZxMWd1YTU5bGxicWI0dGJ1dXEwcSIsImFjY291bnRfaWQiOiIxIiwiZXZlbnRfaWQiOiJiMGViMzI0Ny03ZTA5LTQ0YTctYTNkYi1lNTQyYzM5NTY0N2EiLCJ1c2VyX2lkIjoiMTk3IiwidG9rZW5fdXNlIjoiaWQiLCJhdXRoX3RpbWUiOjE3MTU5MzUwNjksInRpbWV6b25lX2lkIjoiMjk0IiwibmFtZSI6IlN0ZXBoYW4gRnVjaHMiLCJjdXN0b206YWNjb3VudF9pZCI6IjEiLCJleHAiOjE3MTYwNDE3MjgsImlhdCI6MTcxNjAzODEzMSwianRpIjoiOGM2ODlmZWMtOTIwYi00ZDFkLWI3Y2EtNGVmNGJhZjhhYTljIiwiZW1haWwiOiJzdGVwaGFuZnVjaHNAdGhyaXZlYWx0cy5jb20ifQ.tPqm41qTLeTlUUJW4nIqMP3TWayONOtfJBMyuyL-tr4cmhxHEVXRKnqapw9MxcO-T-dUwagey2ErTZ2A4gODdu1Vra78Q-cf0c_X6BtjfBk5BBEtVxzEliuc8Fu11grPIss78j16PAs_UV3kOD6ZVzPNSHClT9Z6KNdF4WbUnLlenWX05YAyz493TQZjkyB4EuThMrLNF_smBq7LD8tFJSGjKVpR5Cab23vjT_iJnUxmoy_VFw2PbzZ2EryTo3sNBc4-Kr7SUtOYfhra5uWD47OdeSCUvBJknJTK6ePFd8LJrnesR35BEtpwU-bk7dNIxNQGTzNEnx8nrnzqWYBdxw"
# JWT.decode(token, nil, true, {jwks: jwt_config, algorithms: ['RS256'] , required_claims: [ "sub", "cognito:groups", "email_verified", "iss", "cognito:username", "origin_jti", "aud", "account_id", "event_id", "user_id", "token_use", "auth_time", "timezone_id", "name", "custom:account_id", "exp", "iat", "jti", "email" ], verify_iat: true })
# https://github.com/jwt/ruby-jwt?tab=readme-ov-file#support-for-reserved-claim-names

# 'exp' (Expiration Time) Claim
# 'nbf' (Not Before Time) Claim
# 'iss' (Issuer) Claim
# 'aud' (Audience) Claim
# 'jti' (JWT ID) Claim
# 'iat' (Issued At) Claim
# 'sub' (Subject) Claim
