require "bundler/gem_tasks"
require "multi_worker"

require 'rspec/core/rake_task'

desc "Run RSpec"
RSpec::Core::RakeTask.new do |t|
  t.verbose = true
  t.pattern = "spec/*_spec.rb"
end

MultiWorker::AdapterNames.each do |adapter_name|
  namespace :spec do
    desc "Run #{adapter_name} adapter spec"
    RSpec::Core::RakeTask.new(adapter_name) do |t|
      t.verbose = true
      t.pattern = "spec/adapters/#{adapter_name}_spec.rb"
    end
  end
end

task :default => [:spec].concat(MultiWorker::AdapterNames.map {|adapter_name| "spec:#{adapter_name}"})