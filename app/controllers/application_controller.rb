class ApplicationController < ActionController::API
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :verify_token
  before_action :current_user

  def verify_token
    token = request.headers['Authorization']
    return render json: { }, status: :unauthorized unless token
    @payload = SessionToken.verify(token.split('Bearer ').last)
    return render json: { }, status: :unauthorized unless @payload && tenant
  end

  def tenant
    @tenant ||= begin
      Tenant.live.find_by(sub_domain: @payload[:tenant_sub_domain]) if @payload[:tenant_sub_domain] == Apartment::Tenant.current
    end
  end

  def current_user
    @current_user ||= User.active.find(@payload[:user_id])
  end

  private

  def user_not_authorized
    render json: { error: 'Not Authorized' }, status: :unauthorized
  end
end
