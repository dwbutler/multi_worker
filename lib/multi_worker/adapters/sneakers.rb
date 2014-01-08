module MultiWorker
  module Adapters
    class Sneakers
      def self.configure(base, opts={})
        require 'json'

        base.class_eval do
          include ::Sneakers::Worker
          from_queue opts[:queue], opts.fetch(:adapter_opts, {})

          def work(msg)
            args = JSON.parse(msg)
            perform(*args)
          end

          def self.perform(*args)
            self.new.perform(*args)
          end

          def self.perform_async(*args)
            ::Sneakers.publish(args.to_json, :to_queue => @queue)
          end

          def perform_async(*args)
            self.class.perform_async(*args)
            #@queue.exchange.publish(args.to_json, :to_queue => @queue)
          end
        end
      end
    end
  end
end