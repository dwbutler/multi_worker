describe MultiWorker do
  context 'configuration' do
    it 'yields itself in a configuration block' do
      configuration = MultiWorker.configure do
        self
      end

      expect(configuration).to eq MultiWorker
    end

    it 'allows the default adapter to be set' do
      MultiWorker.configure do
        default_adapter :foo
      end

      expect(MultiWorker.default_adapter).to eq(:foo)
      
      MultiWorker.instance_variable_set(:@default_adapter, nil)
    end

    it 'picks a default adapter automatically' do
      expect(MultiWorker.default_adapter).not_to be_nil
    end

    it 'provides default options' do
      expect(MultiWorker.default_options[:queue]).to eq(:default)
      expect(MultiWorker.default_options[:retry]).to eq(false)
      expect(MultiWorker.default_options[:lock]).to eq(false)
      expect(MultiWorker.default_options[:unique]).to eq(false)
      expect(MultiWorker.default_options[:status]).to eq(false)
    end

    it 'allows default options to be customized' do
      MultiWorker.configure do
        default_options :retry => true, :unique => true
      end

      expect(MultiWorker.default_options[:retry]).to eq(true)
      expect(MultiWorker.default_options[:lock]).to eq(false)
      expect(MultiWorker.default_options[:unique]).to eq(true)
      expect(MultiWorker.default_options[:status]).to eq(false)

      MultiWorker.instance_variable_set(:@default_options, nil)
    end

    it 'allows default options to be overriden on the worker' do
      MultiWorker.configure do
        default_adapter :foo
      end

      require 'multi_worker/adapters/inline'
      expect(MultiWorker::Adapters::Inline).to receive(:configure) do |klass, opts|
        expect(opts[:queue]).to eq(:background)
      end

      custom_worker = Class.new do
        worker :adapter => :inline, :queue => :background
      end
    end
  end
end