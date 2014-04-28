module MultiWorker
  module Adapters
    class Toro
      def self.configure(base, opts={})
        base.class_eval do
          include ::Toro::Worker

          @queue = opts[:queue]
          @toro_options = {queue: @queue}

          if opts.has_key?(:retry)
            @retry = opts[:retry]
            case @retry
              when Hash
                @toro_options.merge!(:retry_interval => @retry[:delay])
              when Fixnum, ActiveSupport::Duration
                @toro_options.merge!(:retry_interval => @retry)
            end
          end

          toro_options @toro_options

          def self.perform(*args)
            self.new.perform(*args)
          end

          def perform_async(*args)
            self.class.perform_async(*args)
          end
        end
      end

      def self.rake_task
        require 'rake'
        require 'toro'
        require 'tasks/tasks'
        ::Rake::Task["toro"]
      end
    end
  end
end

