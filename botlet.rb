module Supabot
  # Base class for all connectors
  module Botlet    
    def self.included(base)           
      base.extend ClassMethods
    end
    
    module ClassMethods
    end   
    
  end
end