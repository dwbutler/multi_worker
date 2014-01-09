module MultiWorker
  module Adapters
    class Qu
      def self.configure(base, opts={})
        base.class_eval do
          @queue = opts[:queue]

          def self.perform(*args)
            self.new.perform(*args)
          end

          def self.perform_async(*args)
            ::Qu.enqueue(self, *args)
          end

          def perform_async(*args)
            self.class.perform_async(*args)
          end
        end
      end

      def self.rake_task
        require 'rake'
        require 'qu/tasks'

        ::Rake::Task['qu:work']
      end
    end
  end
end