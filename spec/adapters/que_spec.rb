require 'que'
require 'active_record'
::Que.mode = :sync

require 'test_workers'

describe TestWorker do
  it_behaves_like "a worker"

  it { expect(TestWorker::Job).to be < ::Que::Job }
end

describe MultiWorker do
  context "when Que is loaded" do
    it "defaults to the :que adapter" do
      expect(MultiWorker.default_adapter).to eq(:que)
    end
  end

  context "when using the :que adapter" do
    before(:each) do
      Que::Job.any_instance.stub(destroy: true)
    end

    it "forwards ::perform to #perform" do
      expect_any_instance_of(TestWorker).to receive(:perform).once.with("foo")
      TestWorker.perform("foo")
    end

    it "::perform_async performs the work using Que" do
      expect_any_instance_of(TestWorker).to receive(:perform).once
      TestWorker.perform_async("foo")
    end

    it "MultiWorker.enqueue performs the work using Que" do
      expect_any_instance_of(TestWorker).to receive(:perform).once
      MultiWorker.enqueue(TestWorker, "foo")
    end

    it "exposes the Que rake task" do
      expect(MultiWorker.adapter.rake_task.name).to eq("que:work")
    end
  end
end