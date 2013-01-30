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

    def initialize(connectors, botlet_paths, name=nil, logger=nil)
      @name         = name         || 'Cher'
      @botlet_paths = botlet_paths || []
      @logger       = logger       || Logger.new(STDOUT)
      @logger.level = Logger::DEBUG
      @connectors   = []
      @listeners    = []

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
      @listeners.each do |l|
        l.call message
        break if message.done
      end
    end

    def send(message)
      @connectors.each { |c| c.send message }
    end

    def hear(regex, &callback)
      @logger.debug regex.to_s
      @listeners.push TextListener.new(self, regex, callback)
    end

    def respond(regex, &callback)
       re = regex.inspect.split('/')
       re.shift  # remove empty first item
       re.pop    # pop off modifiers

       if re[0] and re[0][0] == '^'
         @logger.warning "Anchors don't work well with respond, perhaps you want to use 'hear'"
         @logger.warning "The regex in question was #{regex.toString()}"
       end

       pattern = re.join('/') # combine the pattern back again

       # if @alias
       #   alias = @alias.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&') # escape alias for regexp
       #   newRegex = new RegExp("^(?:#{alias}[:,]?|#{@name}[:,]?)\\s*(?:#{pattern})", modifiers)
       # else
       newRegex = Regexp.new("^#{@name}[:,]?\\s*(?:#{pattern})", regex.options)

       @logger.debug newRegex.to_s
       @listeners.push TextListener.new(self, newRegex, callback)
    end

    # Note: The ObjectSpace will continue to hold a 'memory' of old versions of botlet classes,
    #       I don't believe it will have any real impact on memory usage
    def reload
      @listeners.clear

      botlets = ObjectSpace.each_object(Class).to_a
      botlets.select! { |klass| klass.included_modules.include? Supabot::Botlet }

      botlets.each do |botlet|
        names     = botlet.to_s.split('::')
        to_remove = names.pop.to_sym

        remove_from = names.inject(Object) do |parent, child|
          parent.const_get(child.to_sym)
        end

        remove_from.instance_eval { remove_const(to_remove) if const_defined?(to_remove) }
      end

      load_botlets
    end

    private

      def load_connector(connector_path, connector_name, opts={})
        require connector_path
        @connectors.push Supabot.const_get(connector_name).new(self, opts)
      rescue => err
        @logger.error "Failed to load #{connector_name} at #{connector_path} because: #{err.message}. Continuing anyways."
      end

      def load_botlets()
       @botlet_paths.each { |p| load_botlets_from_path(p) }
      end

      def load_botlets_from_path(path)
        Dir.foreach(path) do |f|
          next unless f.end_with?('.rb')

          file = File.join(path, f)

          begin
            existing_classes = ObjectSpace.each_object(Class).to_a
            load file
            new_classes = ObjectSpace.each_object(Class).to_a - existing_classes

            new_classes.keep_if { |k| k.included_modules.include? Supabot::Botlet }.each do |klass|
              k = klass.new(self)
              k.load
            end
          rescue => err
            @logger.error "Failed to load botlet #{file} because: #{err.message}. Continuing anyways."
          end
        end
      end

  end
end