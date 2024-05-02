# frozen_string_literal: true

# INFO: (Stephan) run for testing `CialfoOldCoApi::Jobs::HelloRails4Job.perform_async('yes', 'no')`
module CialfoOldCoApi::Jobs
  class HelloRails4Job
    @@queue = 'default'
    include PerformConnector
  end
end
