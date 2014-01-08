require 'sidekiq'
require 'sidekiq/testing'
::Sidekiq::Testing.fake!

require 'test_workers'

describe TestWorker do
  it_behaves_like "a worker"

  it { should be_a ::Sidekiq::Worker }
end

describe MultiWorker do
  context "when Sidekiq is loaded" do
    it "defaults to the :sidekiq adapter" do
      MultiWorker.default_adapter.should == :sidekiq
    end
  end

  context "when using the :sidekiq adapter" do
    it "performs the work using Sidekiq" do
      TestWorker.perform_async("foo")
      MultiWorker.enqueue(TestWorker, "foo")
      TestWorker.jobs.size.should == 2
    end

    it "forwards ::perform to #perform" do
      expect(TestWorker).to receive(:perform).once.with("foo")
      TestWorker.perform("foo")
    end
  end
end