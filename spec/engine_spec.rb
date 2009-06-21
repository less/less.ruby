require File.dirname(__FILE__) + '/spec_helper'

module LessEngineSpecHelper
  def lessify(string)
    return Less::Engine.new(string).to_css(:desc)
  end
end

describe Less::Engine do
  include LessEngineSpecHelper

  describe "to_css" do
    it "should return an empty string for p {}" do
      lessify('p {}').should == ''
    end

    it "should return css with variable usage" do
      lessify("@brand_color: #4D926F;\n #header { color: @brand_color; }").should == "#header { color: #4D926F; }"
    end

    it "should return css as shown on home page" do
      lessify("#header { \n  color: red;\n  a {\n    font-weight: bold;\n    text-decoration: none;\n  }\n}").should == "#header { color: red; }\n#header a { font-weight: bold; text-decoration: none; }"
    end

    it "should handle :hover" do
      lessify("a:hover {\n color: red; }").should == "a:hover { color: red; }"
    end

    it "should handle instances of double-quotes" do
      lessify("blockquote:before, blockquote:after, q:before, q:after {\n content: \"\"; }").should == "blockquote:before, blockquote:after, q:before, q:after { content: ''; }"
    end
    
    it "should parse tag attributes" do
      lessify("input[type=text] { color: red; }").should == "input[type=text] { color: red; }"
    end
  end
end


