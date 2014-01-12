require 'backburner'
require 'test_workers'

describe TestWorker do
  it_behaves_like "a worker"

  it { should be_a ::Backburner::Queue }
end

describe MultiWorker do
  context "when Backburner is loaded" do
    it "defaults to the :backburner adapter" do
      MultiWorker.default_adapter.should == :backburner
    end
  end

  context "when using the :backburner adapter" do
    it "::perform_async uses Backburner" do
      Backburner.should_receive(:enqueue).once.with(TestWorker, "foo")
      TestWorker.perform_async("foo")
    end

    it "MultiWorker.enqueue uses Backburner" do
      Backburner.should_receive(:enqueue).once.with(TestWorker, "foo")
      MultiWorker.enqueue(TestWorker, "foo")
    end

    it "exposes the Backburner rake task" do
      MultiWorker.adapter.rake_task.name.should == "backburner:work"
    end
  end
end