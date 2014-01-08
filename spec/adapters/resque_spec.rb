require 'resque'
Resque.inline = true

require 'test_workers'

describe TestWorker do
  it_behaves_like "a worker"
end

describe MultiWorker do
  context "when Resque is loaded" do
    it "defaults to the :resque adapter" do
      MultiWorker.default_adapter.should == :resque
    end
  end

  context "when using the :resque adapter" do
    it "performs the work using Resque" do
      expect(TestWorker).to receive(:perform).exactly(3).times.with("foo")
      TestWorker.perform_async("foo")
      MultiWorker.enqueue(TestWorker, "foo")
      TestWorker.perform("foo")
    end
  end
end