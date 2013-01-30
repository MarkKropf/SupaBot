require 'spec_helper'

describe Supabot::Listener do

  class ImplementedListener
    include Supabot::Listener
    attr_accessor :callback
    def initialize
      @matcher = lambda { |message|  /^valid$/.match(message.text) }
    end
  end

  describe "#call" do
    context "when caring about the message" do
      let (:listener) {
        listener = ImplementedListener.new
        listener.callback = double(:call => nil)
        listener
      }
      let (:message) { double(:hear => true, :text => 'valid') }

      it 'calls message#hear' do
        message.should_receive(:hear)
        listener.call(message)
      end

      it 'calls @callback#call with a Supabot::Response' do
        listener.callback.should_receive(:call).with(an_instance_of(Supabot::Response))
        listener.call(message)
      end
    end

    context "when ignoring the message" do
      let (:listener) { ImplementedListener.new }
      let (:message) { double(:hear => true, :text => 'not valid') }

      it 'does not call message#hear' do
        message.should_not_receive(:hear)
        listener.call(message)
      end

      it 'does not call @callback#call' do
        listener.callback.should_not_receive(:call).with(an_instance_of(Supabot::Response))
        listener.call(message)
      end
    end
  end
end