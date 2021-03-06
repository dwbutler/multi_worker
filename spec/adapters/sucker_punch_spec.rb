require 'sucker_punch'
require 'sucker_punch/testing/inline'

require 'test_workers'

describe TestWorker do
  it_behaves_like "a worker"

  it { should be_a ::SuckerPunch::Job }
end

describe MultiWorker do
  context "when Sucker Punch is loaded" do
    it "defaults to the :sucker_punch adapter" do
      expect(MultiWorker.default_adapter).to eq(:sucker_punch)
    end
  end

  context "when using the :sucker_punch adapter" do
    before(:each) do
      expect_any_instance_of(TestWorker).to receive(:perform).once.with("foo")
    end

    it "::perform_async uses Sucker Punch" do
      TestWorker.perform_async("foo")
    end

    it "MultiWorker.enqueue uses Sucker Punch" do
      MultiWorker.enqueue(TestWorker, "foo")
    end

    it "::perform delegates to #perform" do
      TestWorker.perform("foo")
    end
  end
end