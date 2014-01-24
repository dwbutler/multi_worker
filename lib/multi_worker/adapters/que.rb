module MultiWorker
  module Adapters
    class Que
      def self.configure(base, opts={})
        base.class_eval do
          @queue = opts[:queue]

          def self.perform(*args)
            self.new.perform(*args)
          end

          def self.perform_async(*args)
            @job_klass.queue(*args)
          end

          def perform_async(*args)
            self.class.perform_async(*args)
          end

          worker_klass = self

          @job_klass = Class.new(::Que::Job)
          @job_klass.class_eval do
            @worker_klass = worker_klass

            class << self
              attr_reader :worker_klass
            end

            def run(*args)
              self.class.worker_klass.new.perform(*args)
            end
          end

          const_set :Job, @job_klass
        end
      end

      def self.rake_task
        require 'rake'
        require 'que/rake_tasks'

        ::Rake::Task['que:work']
      end
    end
  end
end