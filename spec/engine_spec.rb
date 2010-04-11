require 'spec/spec_helper'

module LessEngineSpecHelper
  def lessify arg
    if arg.is_a? String or arg.is_a? File
      return Less::Engine.new(arg).to_css
    else
      lessify File.new("spec/less/#{arg.to_s.gsub('_', '-')}.less")
    end
  end
  
  def css file
    File.read("spec/css/#{file.to_s.gsub('_', '-')}.css")
  end
end

describe Less::Engine do
  include LessEngineSpecHelper

  describe "to_css" do
    it "should parse css" do
      lessify(:css).should == css(:css)
    end
    
    it "should group selectors when it can" do
      lessify(:selectors).should == css(:selectors)
    end
    
    it "should parse css 3" do
      lessify(:css_3).should == css(:css_3)
    end
    
    it "should handle properties prefixed with a dash" do
      lessify(:dash_prefix).should == css(:dash_prefix)
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
    
    it "should parse parens" do
      lessify(:parens).should == css(:parens)
    end
    
    it "should parse strings" do
      lessify(:strings).should == css(:strings)
    end
    
    it "should parse accessors" do
      lessify(:accessors).should == css(:accessors)
    end
    
    it "should parse colors in hex" do
      lessify(:colors).should == css(:colors)
    end
    
    it "should parse mixins" do
      lessify(:mixins).should == css(:mixins)
    end
    
    it "should parse mixins with arguments" do
      lessify(:mixins_args).should == css(:mixins_args)
    end
    
    it "should evaluate variables lazily" do
      lessify(:lazy_eval).should == css(:lazy_eval)
    end

    it "should handle custom functions" do
      module Less::Functions
        def color args
          arg = args.first
          Less::Node::Color.new("99", "99", "99") if arg == "evil red"
        end
        
        def increment a
          Less::Node::Number.new(a.evaluate.to_i + 1)
        end
        
        def add a, b
          Less::Node::Number.new(a.evaluate + b.evaluate)
        end
      end
      lessify(:functions).should == css(:functions)
    end
    
    it "should work with import" do
      lessify(:import).should == css(:import)
    end

    it "should work tih import using extra paths" do
      lambda {
        lessify(:import_with_extra_paths).should == css(:import_with_extra_paths)
      }.should raise_error(Less::ImportError)
      # finding a partial in another location
      $LESS_LOAD_PATH = ["spec/less/extra_import_path"]
      lessify(:import_with_extra_paths).should == css(:import_with_extra_paths)
      # overriding a partial in another location so this takes priority over the same named partial in the same directory
      lessify(:import).should == css(:import_with_partial_in_extra_path)
    end
    
    it "should parse a big file"
    it "should handle complex color operations"
  end
end


