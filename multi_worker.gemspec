# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'multi_worker/version'

Gem::Specification.new do |spec|
  spec.name          = "multi_worker"
  spec.version       = MultiWorker::VERSION
  spec.authors       = ["David Butler"]
  spec.email         = ["dwbutler@ucla.edu"]
  spec.summary       = %q{Provides a common interface to Ruby worker/queue libraries.}
  spec.description   = %q{Provides a common interface to Ruby worker/queue libraries.}
  spec.homepage      = "https://github.com/dwbutler/multi_worker"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_development_dependency "resque"
  spec.add_development_dependency "resque-retry"
  spec.add_development_dependency "resque-status"
  spec.add_development_dependency "resque-loner"
  spec.add_development_dependency "resque-lock-timeout"
  spec.add_development_dependency "resque-delay"

  spec.add_development_dependency "sidekiq"
  spec.add_development_dependency "sidekiq-lock"
  spec.add_development_dependency "sidekiq_status"
  spec.add_development_dependency "sidekiq-unique-jobs"
  spec.add_development_dependency "sidekiq-delay"

  spec.add_development_dependency "delayed_job"
  spec.add_development_dependency "delayed_job_active_record"

  spec.add_development_dependency "qu", "0.2.0"

  spec.add_development_dependency "queue_classic" unless (RUBY_ENGINE == "jruby")

  spec.add_development_dependency "sneakers"

  spec.add_development_dependency "threaded_in_memory_queue"

  spec.add_development_dependency "torquebox-messaging" if (RUBY_ENGINE == "jruby")
end
