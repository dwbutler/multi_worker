module MultiWorker
  module Adapters
    class Sidekiq
      def self.configure(base, opts={})
        base.class_eval do
          if opts[:status]
            require 'sidekiq_status'
            include ::SidekiqStatus::Worker
          else
            include ::Sidekiq::Worker
          end
          
          @sidekiq_options = ::Sidekiq.default_worker_options.symbolize_keys
          @sidekiq_options.merge! queue: opts[:queue]

          if opts.has_key?(:backtrace)
            @sidekiq_options.merge! backtrace: opts[:backtrace]
          end

          if opts.has_key?(:retry)
            @retry = opts[:retry]
            case @retry
            when Hash
              @sidekiq_options.merge!(retry: @retry[:limit])
              sidekiq_retry_in(&@retry[:delay])
            when true, false, Fixnum
              @sidekiq_options.merge!(retry: @retry)
            end
          end

          if opts[:lock]
            require 'sidekiq-lock'
            include ::Sidekiq::Lock::Worker

            @sidekiq_options.merge!(lock: opts[:lock])
          end

          if opts[:unique]
            require "sidekiq-unique-jobs"
            @sidekiq_options.merge!(unique: true)
          end

          sidekiq_options @sidekiq_options

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