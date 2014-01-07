module MultiWorker
  module Adapters
    class ThreadedInMemoryQueue
      def self.configure(base, opts={})
        base.class_eval do
          @queue = opts[:queue]

          def self.call(*args)
            perform(*args)
          end

          def self.perform(*args)
            self.new.perform(*args)
          end

          def self.perform_async(*args)
            ::ThreadedInMemoryQueue.enqueue(self, *args)
          end

          def perform_async(*args)
            self.class.perform_async(*args)
          end
        end
      end
    end
  end
end