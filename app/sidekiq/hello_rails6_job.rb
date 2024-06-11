class HelloRails6Job
  include Sidekiq::Job
  sidekiq_options queue: :default

  def perform(*args)
    # Do something (TO BE DELETED LATER)
    # binding.pry
    # puts "Hello from Rails 7 #{args}"
    puts "Hello from Rails 7 #{JSON.parse(args[0]['Message'])}"
    # sleep 60
  end
end
