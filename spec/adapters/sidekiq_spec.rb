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
      expect(MultiWorker.default_adapter).to eq(:sidekiq)
    end
  end

  context "when using the :sidekiq adapter" do
    it "performs the work using Sidekiq" do
      TestWorker.perform_async("foo")
      MultiWorker.enqueue(TestWorker, "foo")
      expect(TestWorker.jobs.size).to eq(2)
    end

    it "forwards ::perform to #perform" do
      expect(TestWorker).to receive(:perform).once.with("foo")
      TestWorker.perform("foo")
    end

    context "with advanced options" do
      context "when configuring the :retry option" do
        context "with a hash" do
          it "configures limit and delay" do
            retry_worker = Class.new do
              worker retry: {limit: 10, delay: lambda {|count| count*5} }
            end

            expect(retry_worker.get_sidekiq_options['retry']).to eq(10)
            expect(retry_worker.sidekiq_retry_in_block.call(3)).to eq(15)
          end
        end

        context "with a number" do
          it "configures limit" do
            retry_worker = Class.new do
              worker retry: 15
            end

            expect(retry_worker.get_sidekiq_options['retry']).to eq(15)
          end
        end

        context "with a boolean" do
          it "configures retry" do
            retry_worker = Class.new do
              worker retry: true
            end

            expect(retry_worker.get_sidekiq_options['retry']).to eq(true)
          end
        end
      end

      it "configures :lock option" do
        locking_worker = Class.new do
          worker lock: true
        end

        expect(locking_worker.get_sidekiq_options['lock']).to eq(true)
      end

      it "configures :unique option" do
        unique_worker = Class.new do
          worker unique: true
        end

        expect(unique_worker.get_sidekiq_options['unique']).to eq(true)
      end

      it "configures :status option" do
        status_worker = Class.new do
          worker status: true
        end

        expect(status_worker.new).to be_a ::SidekiqStatus::Worker
      end
    end
  end
end