require 'spec_helper'

describe Supabot::Message do

  class ImplementedMessage
    include Supabot::Message
  end

  context "when creating" do
    subject { ImplementedMessage.new('userObject', 'connectorObject') }

    its(:user) { should eq 'userObject' }
    its(:connector) { should eq 'connectorObject' }
    its(:done?) { should be_false }
    its(:heard?) { should be_false }
    its(:unheard?) { should be_true }
  end

  describe "#finish" do
    let (:message) {
      message = ImplementedMessage.new(nil,nil)
      message.finish
      message
    }

    it 'sets #done? to true' do
      message.done?.should be_true
    end
  end

  describe "#hear" do
    let(:message) {
      message = ImplementedMessage.new(nil,nil)
      message.hear
      message
    }

    it 'sets #heard? to true' do
      message.heard?.should be_true
    end

    it 'sets #unheard? to false' do
      message.unheard?.should be_false
    end
  end

  describe "#ignored" do
    let(:message) { ImplementedMessage.new(nil,nil) }
    it 'does not raise an error' do
      expect { message.ignored }.to_not raise_error
    end
  end

end