module MultiWorker
	module Interface
    # Configures queueing for a class or module.
    # Options:
    # :queue => name of the queue to use (defaults to :default)
    # :mailer => Queue mail messages (only for ActionMailer) (defaults to false)
    # :lockable => Use locking on the job (defaults to true)
    # :lock_timeout => Optional lock timeout
    # :loner => Make this job unique in the queue (defaults to false)
    # :status => Turn on status tracking (defaults to false)
    #
    # Example:
    #
    # class WorkerClass
    # worker :queue => :processing, :loner => true
    def worker(opts={})
      opts = MultiWorker.default_options.merge(opts)
      adapter_klass = MultiWorker.adapter(opts[:adapter])
      adapter_klass.configure(self, opts)
    end
  end
end

Class.send :include, MultiWorker::Interface