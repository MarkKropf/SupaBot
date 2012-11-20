require 'eventmachine'

module Supabot
  class Robot

    def initialize(adapter_path, adapter)
      EM.run do
        load_adapter adapter
      end     
    end

    def load_adapter
      require File.join(adapter_pather, adapter)
      @adapter = adapter.new
    end



  end
end