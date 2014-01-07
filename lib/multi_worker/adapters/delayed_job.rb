module MultiWorker
  module Adapters
    class DelayedJob
      def self.configure(base, opts={})
        base.class_eval do
          @queue = opts[:queue]

          def self.perform(*args)
            self.new.perform(*args)
          end

          def self.perform_async(*args)
            delay(:queue => @queue).perform(*args)
          end

          def perform_async(*args)
            self.class.perform_async(*args)
          end
        end
      end
    end
  end
end