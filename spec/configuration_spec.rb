describe MultiWorker do
  context 'configuration' do
    it 'yields itself in a configuration block' do
      MultiWorker.configure { self.should == MultiWorker }
    end

    it 'allows the default adapter to be set' do
      MultiWorker.default_adapter = :foo
      MultiWorker.default_adapter.should == :foo
      MultiWorker.default_adapter = nil
    end

    it 'picks a default adapter automatically' do
      MultiWorker.default_adapter.should_not be_nil
    end
  end
end