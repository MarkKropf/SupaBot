require 'logger'
require 'eventmachine'
require 'supabot/version'
require 'supabot/connector'
require 'supabot/botlet'
require 'supabot/listener'
require 'supabot/response'
require 'supabot/message'


module Supabot
  class Robot

    attr_reader :name, :logger

    def initialize(connectors, name='Cher', logger=nil)
      @name         = name
      @connectors   = []
      @logger       = logger || Logger.new(STDOUT)
      @logger.level = Logger::DEBUG
      @listeners    = []      
      @botlets      = []

      connectors.each { |c| load_connector(c[:path], c[:name], c[:opts]) }
      load_botlets
    end

    def run
      EventMachine.run do
        Signal.trap("INT")  { EventMachine.stop }
        Signal.trap("TERM") { EventMachine.stop }

        @connectors.each { |c| c.run }
      end                                        
    end

    def stop
      @connectors.each { |c| c.stop }
      EventMachine.stop
    end

    def receive(message)      
      @listeners.each { |l| l.call message }
    end

    def send(message)
      @connectors.each { |c| c.send message }
    end

    def hear(regex, &callback)
      @listeners.push TextListener.new(self, regex, callback) 
    end
    
    
    private

    def load_connector(connector_path, connector_name, opts={})
      require connector_path
      @connectors.push Supabot.const_get(connector_name).new self, opts
    rescue => err
      @logger.error "Failed to load #{connector_name} at #{connector_path} because: #{err.message}. Continuing anyways."
    end
    
    def load_botlets(path="#{File.dirname(__FILE__)}/supabot/botlets/")
      Dir.foreach(File.absolute_path(path)) do |f|
        file = File.join(path, f)
        begin
          existing_classes = ObjectSpace.each_object(Class).to_a            
          require file
          new_classes = ObjectSpace.each_object(Class).to_a - existing_classes

          new_classes.keep_if { |k| k.included_modules.include? Supabot::Botlet }.each do |klass|
            k = klass.new self
            k.load
            @botlets << k          
          end
        rescue => err
          @logger.error "Failed to load botlet #{file} because: #{err.message}. Continuing anyways."
        end if file.end_with? '.rb'
      end
    end

  end
end