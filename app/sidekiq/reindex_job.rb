class ReindexJob
  include Sidekiq::Job
  sidekiq_options queue: :default

  def perform(message_body)
    DynamicReindex.new(message_body).call
  end
end
