module MultiWorker
  module Configuration
    @default_options = {:queue => :default}
    @inline = false

    class << self
      attr_accessor :default_options
      attr_accessor :inline  
    end
  end
end