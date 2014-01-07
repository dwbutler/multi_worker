module MultiWorker
  module Adapters
    class Resque
      def self.configure(base, opts={})
        base.class_eval do
          @queue = opts[:queue]

          @loner = opts.fetch(:loner, false) || opts.fetch(:unique, false)
          @retry = opts.fetch(:retry, false)
          @backtrace = opts.fetch(:backtrace, false)

          if opts.fetch(:lockable, false)
            extend ::Resque::Plugins::LockTimeout

            if lock_timeout = opts[:lock_timeout]
              @lock_timeout = lock_timeout.to_i
            end
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
    end
  end
end