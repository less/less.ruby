require 'spec/spec_helper'

module LessEngineSpecHelper
  def lessify arg
    if arg.is_a? String
      return Less::Engine.new(arg).to_css
    else
      lessify File.read("spec/less/#{arg}-1.0.less")
    end
  end
  
  def css file
    File.read("spec/css/#{file}-1.0.css")
  end
end

describe Less::Engine do
  include LessEngineSpecHelper

  describe "to_css" do
    it "should parse css" do
      lessify(:css).should == css(:css)
    end
    
    it "should parse comments" do
      lessify(:comments).should == css(:comments)
    end
    
    it "should deal with whitespace" do
      lessify(:whitespace).should == css(:whitespace)
    end
    
    it "should parse nested rules" do
      lessify(:rulesets).should == css(:rulesets)
    end
    
    it "should parse variables" do
      lessify(:variables).should == css(:variables)
    end
    
    it "should parse operations" do
      lessify(:operations).should == css(:operations)
    end
    
    it "should manage scope" do
      lessify(:scope).should == css(:scope)
    end
    
    it "should parse strings" do
      lessify(:strings).should == css(:strings)
    end
    
    it "should parse accessors" do
      lessify(:accessors).should == css(:accessors)
    end
    
    it "should parse mixins" do
      lessify(:mixins).should == css(:mixins)
    end

    it "should handle custom functions" do
      module Less::Functions
        def color arg
          Less::Node::Color.new("#999999") if arg == "evil red"
        end
        
        def increment a
          Less::Node::Number.new(a.to_i + 1)
        end
        
        def add a, b
          Less::Node::Number.new(a + b)
        end
      end
      lessify(:functions).should == css(:functions)
    end
    
    it "should work with import"
    it "should parse a big file"
    it "should handle complex color operations"
  end
end


