require 'qu'
require 'qu-immediate'

require 'test_workers'

describe TestWorker do
  it_behaves_like "a worker"
end

describe MultiWorker do
  context "when Qu is loaded" do
    it "defaults to the :qu adapter" do
      MultiWorker.default_adapter.should == :qu
    end
  end

  context "when using the :qu adapter" do
    it "performs the work using Qu's backend" do
      expect(TestWorker).to receive(:perform).exactly(3).times.with("foo")
      TestWorker.perform_async("foo")
      MultiWorker.enqueue(TestWorker, "foo")
      TestWorker.perform("foo")
    end

    it "exposes the Qu rake task" do
      MultiWorker.adapter.rake_task.name.should == "qu:work"
    end
  end
end