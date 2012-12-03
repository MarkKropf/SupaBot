require 'spec_helper'

describe Supabot::Robot do

  describe 'creating' do
  
  it 'does a thing' do
    a = Supabot::Robot.new( [
     # { :path => "connectors/test2.rb", :name => "Test2Connector" },
      { :path => "supabot/connectors/test.rb", :name => "TestConnector" }
    ])
    a.run
    
    #sleep
  end
    
  end
  
end