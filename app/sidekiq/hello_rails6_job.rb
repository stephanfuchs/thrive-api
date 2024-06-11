class HelloRails6Job
  include Sidekiq::Job
  sidekiq_options queue: :default

  def perform(*args)
    # Do something (TO BE DELETED LATER)
    puts "Hello from Rails 7 #{args}"
    # sleep 60
  end
end
