module MultiWorker
  module Adapters
    class Sidekiq
      def self.configure(base, opts={})
        base.class_eval do
          @queue = opts[:queue]

          @loner = opts.fetch(:loner, false) || opts.fetch(:unique, false)
          @retry = opts.fetch(:retry, false)

          include ::Sidekiq::Worker
          sidekiq_options :queue => @queue, :retry => @retry, :unique => @loner, :backtrace => @backtrace

          if opts.fetch(:status, false)
            include ::SidekiqStatus::Worker
          end

          def self.perform(*args)
            self.new.perform(*args)
          end

          def perform_async(*args)
            self.class.perform_async(*args)
          end
        end
      end
    end
  end
end