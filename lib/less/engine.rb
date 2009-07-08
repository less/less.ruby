$:.unshift File.dirname(__FILE__)

require 'engine/builder'
require 'engine/nodes'

module Less
  class Engine
    attr_reader :css, :less
    
    def initialize obj
      @less = if obj.is_a? File
        @path = File.expand_path obj.path
        obj.read
      elsif obj.is_a? String
        obj.dup
      else
        raise ArgumentError, "argument must be an instance of File or String!"
      end
      
      begin
        require Less::PARSER
      rescue LoadError
        Treetop.load Less::GRAMMAR
      end
      
      @parser = LessParser.new
    end
    
    def parse
      root = @parser.parse(self.prepare)
      
      if root
        @tree = root.build Node::Element.new
      else
        raise SyntaxError, @parser.failure_message
      end
      
      log @tree.inspect
            
      @tree
    end
    alias :to_tree :parse
    
    def to_css
      "/* Generated with Less #{Less.version} */\n\n" +  
      (@css || @css = self.parse.to_css)
    end
    
    def prepare
      @less.gsub(/\r\n/, "\n").                                      # m$
            gsub(/\t/, '  ')                                        # Tabs to spaces
            #gsub(/('|")(.*?)(\1)/) { $1 + CGI.escape( $2 ) + $1 }   # Escape string values
           # gsub(/\/\/.*\n/, '').                                    # Comments //
          #  gsub(/\/\*.*?\*\//m, '')                                 # Comments /*
    end
  end
end