# frozen_string_literal: true

module CialfoOldCoApi::Jobs
  module PerformConnector
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def perform_async(*args)
        Sidekiq::Client.new.push({ queue: class_variable_get(:@@queue), class: name.demodulize, args: args }.with_indifferent_access)
      end
    end
  end
end
