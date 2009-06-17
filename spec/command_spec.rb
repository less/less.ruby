require File.dirname(__FILE__) + '/spec_helper'

module LessCommandSpecHelper
  def required_options
    {:source => File.dirname(__FILE__) + '/spec.less'}
  end

  def valid_options
    {:destination => File.dirname(__FILE__) + '/spec.css', :watch => true, :chain => true, :debug => false}.merge(required_options)
  end
end

describe Less::Command do
  include LessCommandSpecHelper

  describe "required options" do
    before(:each) do
      @command = Less::Command.new(required_options)
    end

    it "should set the source" do
      @command.source.should == required_options[:source]
    end

    it "should set the destination using a gsub" do
      @command.destination.should == valid_options[:destination]
    end

    it "should set the options with what was passed" do
      @command.options.should == required_options
    end
  end

  describe "valid options" do
    before(:each) do
      @command = Less::Command.new(valid_options)
    end

    it "should set the @source" do
      @command.source.should == required_options[:source]
    end

    it "should set the @destionation" do
      @command.destination.should == valid_options[:destination]
    end

    it "should set the watch" do
      @command.options[:watch].should == valid_options[:watch]
    end

    it "should set the chain" do
      @command.options[:chain].should == valid_options[:chain]
    end

    it "should set the debug" do
      @command.options[:debug].should == valid_options[:debug]
    end

    it "should set the options with what was passed" do
      @command.options.should == valid_options
    end
  end

  describe "run! (" do
    before(:each) do
      @command = Less::Command.new(required_options)
    end

    describe "without a destination file already exiting" do
      before(:each) do
        @command.stub!(:watch?).and_return(false)
      end

      it "should attempt to compile a new file" do
        @command.should_receive(:compile).with(true).once
        @command.run!
      end
    end

    describe "with a destination file already existing" do
    end
  end
end