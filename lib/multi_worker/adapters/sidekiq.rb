module MultiWorker
  module Adapters
    class Sidekiq
      def self.configure(base, opts={})
        base.class_eval do
          
          include ::Sidekiq::Worker
          @sidekiq_options = {:queue => opts[:queue], :backtrace => opts[:backtrace]}

          if @retry = opts[:retry]
            @sidekiq_options.merge!(:retry => @retry[:limit])

            sidekiq_retry_in(&@retry[:delay])
          end

          if opts[:lock]
            require 'sidekiq-lock'
            include ::Sidekiq::Lock::Worker

            @sidekiq_options.merge!(:lock => opts[:lock])
          end

          if opts[:unique]
            require "sidekiq-unique-jobs"
            @sidekiq_options.merge!(:unique => true)
          end

          if opts[:status]
            require 'sidekiq_status'
            include ::SidekiqStatus::Worker
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