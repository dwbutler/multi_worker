shared_examples_for "a worker" do
  context "class" do
    subject { described_class }

    it { should respond_to(:perform) }
    it { should respond_to(:perform_async) }

    it "delegates ::perform to #perform" do
      expect_any_instance_of(TestWorker).to receive(:perform).once.with("foo")
      TestWorker.perform("foo")
    end
  end

  context "instance" do
    it { should respond_to(:perform) }
    it { should respond_to(:perform_async) }
  end
end