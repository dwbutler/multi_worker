shared_examples_for "a worker" do
  context "class" do
    subject { described_class }

    it { should respond_to(:perform) }
    it { should respond_to(:perform_async) }
  end

  context "instance" do
    it { should respond_to(:perform) }
    it { should respond_to(:perform_async) }
  end
end