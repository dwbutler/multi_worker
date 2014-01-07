exit unless jruby?

require 'torquebox/messaging'
require 'torquebox/messaging/backgroundable'
require 'torquebox/core'
#java_import 'org.torquebox.core.util.StringUtils'

require 'test_workers'

describe TestWorker do
  it_behaves_like "a worker"

  it { should be_a ::TorqueBox::Messaging::Backgroundable}
end

describe MultiWorker do
  context "when TorqueBox::Messaging::Backgroundable is loaded" do
    it "defaults to the :sidekiq adapter" do
      MultiWorker.default_adapter_name.should == :torquebox_backgroundable
    end
  end

  context "when using the :torquebox_backgroundable adapter" do
    before(:each) do
      @queue = mock('queue')
      @queue.stub(:publish)
      TorqueBox::Messaging::Queue.stub(:new).and_return(@queue)
      TorqueBox::Messaging::Future.stub(:unique_id).and_return('1234')
    end

    it "puts a message on the queue" do
      @queue.should_receive(:publish).exactly(2).times
      TestWorker.perform_async("foo")
      MultiWorker.enqueue(TestWorker, "foo")
    end
  end
end