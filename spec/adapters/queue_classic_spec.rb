exit if jruby?

ENV["DATABASE_URL"] ||= "postgres:///queue_classic_test"
require 'queue_classic'

module QC
  class Queue
    def enqueue(method, *args)
      klass = eval(method.split(".").first)
      message = method.split(".").last
      klass.send(message, *args)
    end
  end
end

require 'test_workers'

describe TestWorker do
  it_behaves_like "a worker"
end

describe MultiWorker do
  context "when Queue Classic is loaded" do
    it "defaults to the :sidekiq adapter" do
      MultiWorker.default_adapter.should == :queue_classic
    end
  end

  context "when using the :queue_classic adapter" do
    it "performs the work using Queue Classic" do
      expect(TestWorker).to receive(:perform).exactly(3).times.with("foo")
      TestWorker.perform_async("foo")
      MultiWorker.enqueue(TestWorker, "foo")
      TestWorker.perform("foo")
    end
  end
end