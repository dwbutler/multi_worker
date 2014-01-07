require 'sidekiq'
require 'sidekiq/testing'
::Sidekiq::Testing.inline!

require 'test_workers'

describe TestWorker do
  it_behaves_like "a worker"

  it { should be_a ::Sidekiq::Worker }
end

describe MultiWorker do
  context "when Sidekiq is loaded" do
    it "defaults to the :sidekiq adapter" do
      MultiWorker.default_adapter_name.should == :sidekiq
    end
  end

  context "when using the :sidekiq adapter" do
    it "performs the work using Sidekiq" do
      pending
      expect(TestWorker).to receive(:perform).exactly(3).times.with("foo")
      TestWorker.perform_async("foo")
      MultiWorker.enqueue(TestWorker, "foo")
      TestWorker.perform("foo")
    end
  end
end