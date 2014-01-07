module MultiWorker
  module Adapters
    class TorqueboxBackgroundable
      def self.configure(base, opts={})
        base.class_eval do
          include ::TorqueBox::Messaging::Backgroundable

          def self.perform(*args)
            self.new.perform(*args)
          end

          def self.perform_async(*args)
            perform(*args)
          end

          def perform_async(*args)
            perform(*args)
          end

          always_background :perform_async
        end
      end
    end
  end
end