require 'delayed_job'
require 'delayed/backend/test'
Delayed::Worker.backend = :test
#require 'delayed_job_active_record'
Delayed::Worker.delay_jobs = false

require 'test_workers'

describe TestWorker do
  it_behaves_like "a worker"
end

describe MultiWorker do
  context "when Delayed::Job is loaded" do
    it "defaults to the :delayed_job adapter" do
      MultiWorker.default_adapter_name.should == :delayed_job
    end
  end

  context "when using the :delayed_job adapter" do
    it "performs the work using Delayed::Job" do
      expect(TestWorker).to receive(:perform).exactly(3).times.with("foo")
      TestWorker.perform_async("foo")
      MultiWorker.enqueue(TestWorker, "foo")
      TestWorker.perform("foo")
    end
  end
end