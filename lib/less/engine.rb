module Less
  class Engine < String
    class SyntaxError < RuntimeError; end
    attr_reader :css
    
    def initialize less
      super less.dup
      @parser = LessParser.new
      @tree = nil
      self
    end
    
    def parse
      return @css if @css # only run once
      
      # Parse!
      @root = @parser.parse(self.prepare)
            
      if @root
        @tree = @root.build Element.new
      else
        raise SyntaxError, [
          @parser.failure_column, 
          @parser.failure_line, 
          @parser.failure_reason
        ].join(" -- ")
      end
      
      puts @tree.inspect
            
      @tree
    end
    
    def to_css
      "/* Generated with Less #{Less.version} */\n\n" +  
      self.parse.to_css
    end
    
    def to_tree
      self.parse
    end
    
    def prepare
      self.gsub(/\r\n/, "\n").                                                     # m$
           gsub(/\n+/, "\n").
           gsub(/\t/, '  ').
           gsub(/"/, "'").                                                         # " to '
           gsub(/'(.*?)'/) { "'" + CGI.escape( $1 ) + "'" }.                       # Escape string values
           gsub(/\/\/.*\n/, '').                                                   # Comments //
           gsub(/\/\*.*?\*\//m, '')                                                # Comments /*
    end
  end
end