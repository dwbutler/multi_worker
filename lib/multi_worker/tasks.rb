require 'rake'
require 'multi_worker'

# No-op task in case it doesn't already exist
task :environment

namespace :multi_worker do
  desc "Start a new worker for #{MultiWorker.default_adapter}"
  task :work => :environment do
    rake_task = MultiWorker.adapter.rake_task rescue fail("No rake task available for #{MultiWorker.default_adapter}")
    rake_task.execute
  end
end