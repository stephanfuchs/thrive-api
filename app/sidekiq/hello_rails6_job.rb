class HelloRails6Job
  include Sidekiq::Job
  sidekiq_options queue: :core_api_default

  def perform(arg1, arg2)
    # Do something (TO BE DELETED LATER)
    puts "Hello from Rails 6"
    puts "what is current tenant: #{Apartment::Tenant.current}, #{arg1}, #{arg2}"
    sleep 60
  end
end
