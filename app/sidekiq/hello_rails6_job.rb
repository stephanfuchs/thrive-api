class HelloRails6Job
  include Sidekiq::Job
  sidekiq_options queue: :default

  def perform(arg1, arg2)
    # Do something (TO BE DELETED LATER)
    puts "Hello from Rails 6"
    sleep 60
  end
end
