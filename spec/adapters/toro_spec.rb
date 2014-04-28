exit if jruby?

ENV["DATABASE_URL"] ||= "postgres:///queue_classic_test"
require 'toro'

require 'test_workers'

describe TestWorker do
  it_behaves_like "a worker"
end

describe MultiWorker do
  context "when Toro is loaded" do
    it "defaults to the :toro adapter" do
      expect(MultiWorker.default_adapter).to eq(:toro)
    end
  end

  context "when using the :toro adapter" do
    it "performs the work using Toro" do
      expect(Toro::Client).to receive(:create_job).exactly(2).times.with({class_name:"TestWorker", name:nil, args:["foo"], queue::default})
      TestWorker.perform_async("foo")
      MultiWorker.enqueue(TestWorker, "foo")
    end

    it "exposes the Toro rake task" do
      expect(MultiWorker.adapter.rake_task.name).to eq("toro")
    end

    context "with advanced options" do
      context "when configuring the :retry option" do
        context "with a hash" do
          it "configures retry interval" do
            retry_worker = Class.new do
              worker retry: {delay: 2.minutes}
            end

            expect(retry_worker.toro_options[:retry_interval]).to eq(2.minutes)
          end
        end

        context "with an ActiveSupport::Duration" do
          it "configures retry interval" do
            retry_worker = Class.new do
              worker retry: 15.seconds
            end

            expect(retry_worker.toro_options[:retry_interval]).to eq(15.seconds)
          end
        end

        context "with a number" do
          it "configures retry interval" do
            retry_worker = Class.new do
              worker retry: 20
            end

            expect(retry_worker.toro_options[:retry_interval]).to eq(20)
          end
        end
      end
    end
  end
end