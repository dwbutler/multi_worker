module MultiWorker
  module Adapters
    class SuckerPunch
      def self.configure(base, opts={})
        base.class_eval do
          @queue = opts[:queue]

          include ::SuckerPunch::Job

          def self.perform(*args)
            self.new.perform(*args)
          end

          def self.perform_async(*args)
            self.new.async.perform(*args)
          end

          def perform_async(*args)
            async.perform(*args)
          end
        end
      end
    end
  end
end