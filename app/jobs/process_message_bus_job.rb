class ProcessMessageBusJob < ApplicationJob
  self.queue_adapter = :amazon_sqs
  queue_as :message_bus
  # queue_as :default

  def perform(*args)
    puts "Hello from Rails #{args}"
    # Do something later
  end
end
