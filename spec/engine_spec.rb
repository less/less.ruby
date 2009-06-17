require File.dirname(__FILE__) + '/spec_helper'

module LessEngineSpecHelper
  def lessify(string)
    return Less::Engine.new(string)
  end
end

describe Less::Engine do
  include LessEngineSpecHelper

  describe "to_css" do
    it "should return p {} for p {}" do
      lessify('p {}').to_css(:desc).should == 'p { }'
    end

    it "should return p {} for p {}" do
      lessify("@brand_color: #4D926F; \n#header { color: @brand_color; }").to_css(:desc).should == "#header { color: #4D926F; }"
    end

    it "should return p {} for p {}" do
      lessify("#header { \n  color: red;\n  a {\n    font-weight: bold;\n    text-decoration: none;\n  }\n}").to_css(:desc).should == "#header a { font-weight: bold; text-decoration: none; }\n#header { color: red; }"
    end
  end
end


