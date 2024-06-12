class ApplicationController < ActionController::API
  # include Pundit::Authorization
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_current_user

  def set_current_user
    @current_user ||= CognitoJwtDecoder.new.decode_token(request.headers['Authorization'])
    return render json: { }, status: :unauthorized unless @current_user
  end

  # private

  # def user_not_authorized
  #   render json: { error: 'Not Authorized' }, status: :unauthorized
  # end
end
