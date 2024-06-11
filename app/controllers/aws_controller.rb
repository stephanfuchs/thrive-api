# AwsController is used to handle aws sns webhook,
# we need to set webhook url on aws sns like
#
#     https://api2-dev.asense.dev/aws/123456/event
#     http://localhost:8086/aws/123456/event
#
# 123456 is the key, it must be equal to `ENV AWS_PRIMARY_KEY or AWS_SECONDARY_KEY`,
class AwsController < ActionController::API
  before_action :validate_key

  def events_received
    HelloRails6Job.perform_async(params[:payload])
    head :ok
  end

  private

  def validate_key
    if [ENV.fetch('AWS_PRIMARY_KEY', ''),
        ENV.fetch('AWS_SECONDARY_KEY', '')].exclude?(params[:key])
      render nothing: true, status: :forbidden
    end
  end
end
