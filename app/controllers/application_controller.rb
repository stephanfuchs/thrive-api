class ApplicationController < ActionController::API
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    @current_user ||=
      JwtUser.new(CognitoJwtDecoder.new.decode_token(request.headers['Authorization'])).call
  end

  private

  def user_not_authorized
    render json: { error: 'Not Authorized' }, status: :unauthorized
  end
end
