require File.dirname(__FILE__) + '/spec_helper'

module LessCommandSpecHelper
  def required_options
    {:source => File.dirname(__FILE__) + '/less/css.less', :destination => File.dirname(__FILE__) + '/spec.css' }
  end

  def valid_options
    {:destination => File.dirname(__FILE__) + '/spec.css', :watch => true, :debug => false}.merge(required_options)
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

    it "should set the debug" do
      @command.options[:debug].should == valid_options[:debug]
    end

    it "should set the options with what was passed" do
      @command.options.should == valid_options
    end
  end

  describe "executing run!" do
    before(:each) do
      @command = Less::Command.new(required_options)
    end
    after(:each) do
      @command.run!
    end

    describe "when not watching" do
      describe "and the destination file doesn't exist" do
        before(:each) do
          @command.stub!(:watch?).and_return(false)
        end

        it "should verify if we need to watch the file or not" do
          @command.should_receive(:watch?).and_return(false)
        end

        it "should attempt to re-compile" do
          @command.should_receive(:parse).with().once
        end
      end

      describe "and the destination file does exist" do
        it "should not attempt to create a new file"
        it "should attempt to re-compile"
      end
    end

    describe "when watching" do
      describe "and the destination file doesn't exist" do
        it "should attempt to compile to a new file"
        it "should begin to watch the file"
      end

      describe "and the destination file does exist" do
        it "should not attempt to compile to a new file"
        it "should begin to watch the existing file"
        it "should re-compile when the existing file changes"
      end
    end
  end
end