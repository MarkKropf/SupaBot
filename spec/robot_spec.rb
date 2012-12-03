require 'spec_helper'

describe Supabot::Robot do

  describe 'creating' do
  
  it 'does a thing' do
    a = Supabot::Robot.new( [
     # { :path => "connectors/test2.rb", :name => "Test2Connector" },
      { :path => "supabot/connectors/irc.rb", 
        :name => "Irc",
        :opts => {:host => '127.0.0.1', :port => "6667", :channels => ['#test'] }
      }, 
      # { :path => "supabot/connectors/shell.rb", 
      #   :name => "Shell",
      #   :opts => {:host => '127.0.0.1', :port => "6667", :channels => ['#test'] }
      # }         
    ])
    a.run
    
    #sleep
  end
    
  end
  
end