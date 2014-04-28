require "multi_worker/version"
require "multi_worker/interface"

module MultiWorker
  @adapters = {}
  @default_queue = :default

  AdapterNames = [
    :resque,
    :sidekiq,
    :delayed_job,
    :qu,
    :queue_classic,
    :que,
    :sneakers,
    :torquebox_backgroundable,
    :threaded_in_memory_queue,
    :sucker_punch,
    :backburner,
    :inline
  ]

  class << self
    def enqueue(worker_klass, *args)
      worker_klass.perform_async(*args)
    end

    def configure(&block)
      instance_eval &block
    end

    def default_options(opts={})
      @default_options ||= {
        :adapter => default_adapter,
        :queue => default_queue,
        :status => false,
        :retry => false,
        :lock => false,
        :unique => false
      }

      if opts && !opts.empty?
        @default_options.merge!(opts)
      end

      @default_options
    end

    attr_accessor :default_queue

    def default_adapter(adapter_name=nil)
      return (@default_adapter = adapter_name) if (adapter_name && !adapter_name.empty?)

      @default_adapter ||= case
        when defined?(::Resque) then :resque
        when defined?(::Sidekiq) then :sidekiq
        when defined?(::Delayed::Worker) then :delayed_job
        when defined?(::Qu) then :qu
        when defined?(::QC::Queue) then :queue_classic
        when defined?(::Que) then :que
        when defined?(::Sneakers::Worker) then :sneakers
        when defined?(::TorqueBox::Messaging::Backgroundable) then :torquebox_backgroundable
        when defined?(::ThreadedInMemoryQueue) then :threaded_in_memory_queue
        when defined?(::SuckerPunch::Job) then :sucker_punch
        when defined?(::Backburner) then :backburner
        when defined?(::Toro) then :toro
        else :inline
      end
    end

    def adapter(adapter_name=nil)
      adapter_name ||= default_adapter
      @adapters[adapter_name] ||= begin
        require "multi_worker/adapters/#{adapter_name}"
        klass_name = adapter_name.to_s.split('_').map(&:capitalize) * ''
        MultiWorker::Adapters.const_get(klass_name)
      end
    end
  end
end
