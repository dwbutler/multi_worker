require 'threaded_in_memory_queue'
ThreadedInMemoryQueue.inline = true

require 'test_workers'

describe TestWorker do
  it_behaves_like "a worker"
end

describe MultiWorker do
  context "when ThreadedInMemoryQueue is loaded" do
    it "defaults to the :threaded_in_memory_queue adapter" do
      expect(MultiWorker.default_adapter).to eq(:threaded_in_memory_queue)
    end
  end

  context "when using the :threaded_in_memory_queue adapter" do
    it "performs the work using ThreadedInMemoryQueue" do
      expect(TestWorker).to receive(:perform).exactly(3).times.with("foo")
      TestWorker.perform_async("foo")
      MultiWorker.enqueue(TestWorker, "foo")
      TestWorker.perform("foo")
    end
  end
end