module Less
  class Engine < String
    class SyntaxError < RuntimeError; end
    attr_reader :css
    attr_reader :parser, :build_handler, :root_node
    
    def initialize less
      super less.dup
      @parser = LessParser.new
      @build_handler = BuildHandler.new
    end
    
    def to_css
      return @css if @css # only run once
      
      # Parse!
      @root = @parser.parse(self.prepare)
      puts @root.inspect.gsub("SyntaxNode", "|").gsub(/offset=\d+,/, '')
      puts "*" * 20
      
      if @root
        #p @root.methods - Object.instance_methods
        @root.build :depth => 0
      end
      
      return 1
      
      if @root
        @root.build(@build_handler)
      else
        raise SyntaxError, [parser.failure_column, parser.failure_index, parser.failure_line, parser.failure_reason].join(" -- ")
      end
      
      @css = build_handler.to_css
      return @css
    end
    
    def prepare
      self.gsub(/\r\n/, "\n").                                                     # m$
           gsub(/\n+/, "\n").
           gsub(/\t/, '  ').
           gsub(/"/, "'").                                                         # " to '
           gsub(/'(.*?)'/) { "'" + CGI.escape( $1 ) + "'" }.                       # Escape string values
           gsub(/\/\/.*\n/, '').                                                   # Comments //
           gsub(/\/\*.*?\*\//m, '').                                                # Comments /*
           gsub(/ ?> ?/, '>').                                                     # `div > a` to `div>a`
           gsub(/ ?, ?/, ',')                                                      # `div, a` to `div,a`
    end
  end
end