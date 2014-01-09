module MultiWorker
  module Adapters
    class QueueClassic
      def self.configure(base, opts={})
        base.class_eval do
          @queue = ::QC::Queue.new(opts[:queue])

          def self.perform(*args)
            self.new.perform(*args)
          end

          def self.perform_async(*args)
            @queue.enqueue("#{self}.perform", *args)
          end

          def perform_async(*args)
            self.class.perform_async(*args)
          end
        end
      end

      def self.rake_task
        require 'rake'
        require 'queue_classic/tasks'
        ::Rake::Task["qc:work"]
      end
    end
  end
end