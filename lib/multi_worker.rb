require "multi_worker/version"
require "multi_worker/configuration"
require "multi_worker/interface"

module MultiWorker
  @adapters = {}

  AdapterNames = [
    :resque,
    :sidekiq,
    :delayed_job,
    :qu,
    :queue_classic,
    :sneakers,
    :torquebox_backgroundable,
    :threaded_in_memory_queue,
    :inline
  ]

  class << self
    def enqueue(worker_klass, *args)
      worker_klass.perform_async(*args)
    end

    def configure(&block)
      MultiWorker::Configuration.class_eval do
        yield
      end
    end

    def default_adapter_name
      return :resque if defined?(::Resque)
      return :sidekiq if defined?(::Sidekiq)
      return :delayed_job if defined?(::Delayed::Worker)
      return :qu if defined?(::Qu)
      return :queue_classic if defined?(::QC::Queue)
      return :sneakers if defined?(::Sneakers::Worker)
      return :torquebox_backgroundable if defined?(::TorqueBox::Messaging::Backgroundable)
      return :threaded_in_memory_queue if defined?(::ThreadedInMemoryQueue)

      return :inline
    end

    def adapter(name=nil)
      name ||= default_adapter_name
      @adapters[name] ||= begin
        require "multi_worker/adapters/#{name}"
        klass_name = name.to_s.split('_').map(&:capitalize) * ''
        MultiWorker::Adapters.const_get(klass_name)
      end
    end 
  end
end
