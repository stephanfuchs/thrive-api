class ReindexV2Job
  include Sidekiq::Job
  sidekiq_options queue: :core_api_searchkick

  def perform(user_id)
    Searchkick::ReindexV2Job.perform_now('User', user_id)
  end
end