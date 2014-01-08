require 'test_workers'

describe MultiWorker do
  context "when no other adapter is available" do
    it "defaults to the :inline adapter" do
      MultiWorker.default_adapter.should == :inline
    end
  end

  context "when using the :inline adapter" do
    it "performs the work immediately" do
      expect(TestWorker).to receive(:perform).exactly(3).times.with("foo")
      TestWorker.perform_async("foo")
      MultiWorker.enqueue(TestWorker, "foo")
      TestWorker.perform("foo")
    end
  end
end