# AwsController is used to handle aws sns webhook,
# we need to set webhook url on aws sns like
#
#     https://api2-dev.asense.dev/aws/123456/event
#     http://localhost:8086/aws/123456/event
#
# 123456 is the key, it must be equal to `ENV AWS_PRIMARY_KEY or AWS_SECONDARY_KEY`,
#
# Links
#   https://www.helldoradoteam.com/2019/09/24/handling-aws-sns-notifications-in-ruby-on-rails/
#
# Getting started for debugging
#   0. Start Grok via `ngrok http localhost:8086`
#   1. Go to https://us-west-2.console.aws.amazon.com/sns/v3/home?region=us-west-2#/topic/arn:aws:sns:us-west-2:657325794363:thrivedrivethrivedevmessagebusthrivedrivethrivedevmessagebusMessageBusFC8A9E38-EventBusTopicD165DC44-AeDQTLc8dWjz
#   2. Create subscription with protocol HTTPS and point at grok endpoint. I.e. https://38ea-220-255-198-16.ngrok-free.app/aws/123456/event
#   3. Test endpoint via https://38ea-220-255-198-16.ngrok-free.app/aws/123456/event
class AwsController < ActionController::API
  before_action :validate_key

  def events_received
    # TODO:(Stephan) Improve on this HAXX to confirm subscription
    Net::HTTP.get(URI.parse(message_body['SubscribeURL'])) if message_body['SubscribeURL']
    ReindexJob.perform_async(message_body)
    head :ok
  end

  private

  def message_body
    @message_body ||= JSON.parse(request.raw_post)
  end

  private

  def validate_key
    if [ENV.fetch('AWS_PRIMARY_KEY', ''),
        ENV.fetch('AWS_SECONDARY_KEY', '')].exclude?(params[:key])
      render nothing: true, status: :forbidden
    end
  end
end
