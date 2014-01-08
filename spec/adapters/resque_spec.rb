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

    context "with advanced options" do
      it "configures :retry option" do
        retry_worker = Class.new do
          worker :retry => {:limit => 10, :delay => 5 }
        end

        retry_worker.should be_a ::Resque::Plugins::Retry
        retry_worker.instance_variable_get(:@retry_limit).should == 10
        retry_worker.instance_variable_get(:@retry_delay).should == 5
      end

      it "configures :lock option" do
        locking_worker = Class.new do
          worker :lock => {:timeout => 5}
        end

        locking_worker.should be_a ::Resque::Plugins::LockTimeout
        locking_worker.instance_variable_get(:@lock_timeout).should == 5
      end

      it "configures :unique option with :lock" do
        unique_worker = Class.new do
          worker :lock => true, :unique => true
        end

        unique_worker.instance_variable_get(:@loner).should be_true
      end

      it "configures :unique option without :lock" do
        unique_worker = Class.new do
          worker :unique => true
        end

        unique_worker.should include ::Resque::Plugins::UniqueJob
      end

      it "configures :status option" do
        status_worker = Class.new do
          worker :status => true
        end

        status_worker.should include ::Resque::Plugins::Status
      end
    end
  end
end