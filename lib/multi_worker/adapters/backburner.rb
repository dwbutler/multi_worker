module MultiWorker
  module Adapters
    class Backburner
      def self.configure(base, opts={})
        base.class_eval do
          @queue = opts[:queue]
          include ::Backburner::Queue
          queue @queue

          def self.perform(*args)
            self.new.perform(*args)
          end

          def self.perform_async(*args)
            ::Backburner.enqueue(self, *args)
          end

          def perform_async(*args)
            self.class.perform_async(*args)
          end
        end
      end

      def self.rake_task
        require 'rake'
        require 'backburner/tasks'

        ::Rake::Task['backburner:work']
      end
    end
  end
end