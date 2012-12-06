require 'spec_helper'

describe Supabot::Robot do

  describe 'creating' do

  it 'does a thing' do
    a = Supabot::Robot.new( [
     # { :path => "connectors/test2.rb", :name => "Test2Connector" },
      { :path => "supabot/connectors/irc.rb",
        :name => "Irc",
        # :opts => {:host => '127.0.0.1', :port => "6667", :channels => ['#test'] }
        :opts => {:host => 'chat.freenode.net', :port => "6667", :channels => ['#supabot'] }
      },
      { :path => "supabot/connectors/shell.rb",
        :name => "Shell",
        :opts => {:host => '127.0.0.1', :port => "6667", :channels => ['#test'] }
      },
      { :path => "supabot/connectors/http.rb",
        :name => "Http",
        :opts => {:ip => '0.0.0.0', :port => "8080", :channels => ['#test'] }
      },
    ])
    a.run

    #sleep
  end

  end

end