require 'resque'
Resque.inline = true

require 'test_workers'

describe TestWorker do
  it_behaves_like "a worker"
end

describe MultiWorker do
  context "when Resque is loaded" do
    it "defaults to the :resque adapter" do
      expect(MultiWorker.default_adapter).to eq(:resque)
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

        expect(retry_worker).to be_a ::Resque::Plugins::Retry
        expect(retry_worker.instance_variable_get(:@retry_limit)).to eq(10)
        expect(retry_worker.instance_variable_get(:@retry_delay)).to eq(5)
      end

      it "configures :lock option" do
        locking_worker = Class.new do
          worker :lock => {:timeout => 5}
        end

        expect(locking_worker).to be_a ::Resque::Plugins::LockTimeout
        expect(locking_worker.instance_variable_get(:@lock_timeout)).to eq(5)
      end

      it "configures :unique option with :lock" do
        unique_worker = Class.new do
          worker :lock => true, :unique => true
        end

        expect(unique_worker.instance_variable_get(:@loner)).to be_true
      end

      it "configures :unique option without :lock" do
        unique_worker = Class.new do
          worker :unique => true
        end

        expect(unique_worker).to include ::Resque::Plugins::UniqueJob
      end

      it "configures :status option" do
        status_worker = Class.new do
          worker :status => true
        end

        expect(status_worker).to include ::Resque::Plugins::Status
      end
    end

    it "exposes the Resque rake task" do
      expect(MultiWorker.adapter.rake_task.name).to eq("resque:work")
    end
  end
end