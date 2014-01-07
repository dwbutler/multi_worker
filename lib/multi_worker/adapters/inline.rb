module MultiWorker
  module Adapters
    class Inline
      def self.configure(base, opts={})
        base.instance_eval do
          def self.perform(*args)
            self.new.perform(*args)
          end

          def self.perform_async(*args)
            perform(*args)
          end

          def perform_async(*args)
            perform(*args)
          end
        end
      end
    end
  end
end