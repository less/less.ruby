require 'spec/spec_helper'

module LessEngineSpecHelper
  def lessify arg
    if arg.is_a? String or arg.is_a? File
      Less::Engine.new(arg).to_css
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
  end
end


