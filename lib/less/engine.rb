$:.unshift File.dirname(__FILE__)

require 'engine/builder'
require 'engine/nodes'

begin
  require 'engine/parser'
rescue LoadError
  Treetop.load LESS_GRAMMAR
end

module Less
  class Engine
    attr_reader :css, :less
    
    def initialize obj
      @less = if obj.is_a? File
        @path = File.dirname File.expand_path(obj.path)
        obj.read
      elsif obj.is_a? String
        obj.dup
      else
        raise ArgumentError, "argument must be an instance of File or String!"
      end
      
      @parser = LessParser.new
    end
    
    def parse env = Node::Element.new
      root = @parser.parse(self.prepare)
      
      if root
        @tree = root.build env.tap {|e| e.file = @path }
      else
        raise SyntaxError, @parser.failure_message
      end

      @tree
    end
    alias :to_tree :parse
    
    def to_css
      @css || @css = self.parse.group.to_css
    end
    
    def prepare
      @less.gsub(/\r\n/, "\n").gsub(/\t/, '  ')
    end
  end
end