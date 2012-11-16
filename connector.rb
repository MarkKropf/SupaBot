module Supabot
  # Base class for all connectors
  module Connector
    def self.included(base)
      base.extend ClassMethods
    end
    
    module ClassMethods
    end
    
  end
end