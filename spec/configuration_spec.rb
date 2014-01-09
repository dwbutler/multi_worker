describe MultiWorker do
  context 'configuration' do
    it 'yields itself in a configuration block' do
      MultiWorker.configure do
        self.should == MultiWorker
      end
    end

    it 'allows the default adapter to be set' do
      MultiWorker.configure do
        default_adapter :foo
      end

      MultiWorker.default_adapter.should == :foo
      
      MultiWorker.instance_variable_set(:@default_adapter, nil)
    end

    it 'picks a default adapter automatically' do
      MultiWorker.default_adapter.should_not be_nil
    end

    it 'provides default options' do
      MultiWorker.default_options[:queue].should == :default
      MultiWorker.default_options[:retry].should == false
      MultiWorker.default_options[:lock].should == false
      MultiWorker.default_options[:unique].should == false
      MultiWorker.default_options[:status].should == false
    end

    it 'allows default options to be customized' do
      MultiWorker.configure do
        default_options :retry => true, :unique => true
      end

      MultiWorker.default_options[:retry].should == true
      MultiWorker.default_options[:lock].should == false
      MultiWorker.default_options[:unique].should == true
      MultiWorker.default_options[:status].should == false

      MultiWorker.instance_variable_set(:@default_options, nil)
    end

    it 'allows default options to be overriden on the worker' do
      MultiWorker.configure do
        default_adapter :foo
      end

      require 'multi_worker/adapters/inline'
      MultiWorker::Adapters::Inline.should_receive(:configure) do |klass, opts|
        opts[:queue].should == :background
      end

      custom_worker = Class.new do
        worker :adapter => :inline, :queue => :background
      end
    end
  end
end