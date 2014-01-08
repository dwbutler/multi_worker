require 'sneakers'
Sneakers.configure(:env => 'test')

require 'test_workers'

describe TestWorker do
  it_behaves_like "a worker"

  it { should be_a ::Sneakers::Worker }
end

describe MultiWorker do
  context "when Sneakers is loaded" do
    it "defaults to the :qu adapter" do
      MultiWorker.default_adapter_name.should == :sneakers
    end
  end

  context "when using the :sneakers adapter" do
    let(:worker) { TestWorker.new }

    context "when calling #perform_async" do
      it "publishes a message to the queue" do
        expect(::Sneakers).to receive(:publish).once
        worker.perform_async("foo")
      end
    end

    context "when Sneakers calls #work" do
      it "calls #perform" do
        expect(worker).to receive(:perform).once.with("foo")
        worker.work(["foo"].to_json)
      end
    end
  end
end