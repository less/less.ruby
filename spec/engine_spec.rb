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
    it "should work with import" do
      lessify(File.new("spec/test-import.less")).should == <<-CSS
.test-import {
  height: 10px;
  width: 98px;
}
CSS
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


