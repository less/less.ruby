module Less
  class Engine
    class SyntaxError < RuntimeError; end
    attr_reader :css
    attr_reader :parser, :build_handler, :root_node
    
    def initialize(less)
      @less = less.dup # because we gsub! the string later on
      @parser = LessGrammarParser.new
      @build_handler = BuildHandler.new
    end
    
    def to_css
      return @css if @css # only run once
      
      # Remove comments
      @less.gsub!(/\/\*[^\/\*]+\*\//, "")
      
      # Remove void whitespace
      @less.gsub!(/\s+/, " ")
      
      # Parse!
      @root_node = parser.parse(@less)
      if @root_node
        @root_node.build(build_handler)
      else
        raise SyntaxError, [parser.failure_column, parser.failure_index, parser.failure_line, parser.failure_reason].join(" -- ")
      end
      
      @css = build_handler.to_css
      return @css
    end
  end
end