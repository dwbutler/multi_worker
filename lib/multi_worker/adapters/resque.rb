module MultiWorker
  module Adapters
    class Resque
      def self.configure(base, opts={})
        base.class_eval do
          @queue = opts[:queue]

          if @retry = opts[:retry]
            require "resque-retry"
            extend ::Resque::Plugins::Retry

            @retry_limit = @retry[:limit]
            @retry_delay = @retry[:delay]
          end

          if @lock = opts[:lock]
            require "resque-lock-timeout"
            extend ::Resque::Plugins::LockTimeout

            if @lock.is_a?(Hash) && @lock[:timeout]
              @lock_timeout = @lock[:timeout].to_i
            end

            if opts[:unique]
              @loner = true
            end
          elsif opts[:unique]
            require "resque-loner"
            include ::Resque::Plugins::UniqueJob
          end

          if opts[:status]
            require "resque-status"
            include ::Resque::Plugins::Status
          end

          def self.perform(*args)
            self.new.perform(*args)
          end

          def self.perform_async(*args)
            ::Resque.enqueue(self, *args)
          end

          def perform_async(*args)
            self.class.perform_async(*args)
          end
        end
      end

      def self.rake_task
        require 'rake'
        require 'resque/tasks'

        ::Rake::Task['resque:work']
      end
    end
  end
end