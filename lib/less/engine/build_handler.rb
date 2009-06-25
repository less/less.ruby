module Less
  # When treetop parses a document, it hands around an instance of BuildHandler
  # to the various rules. The rules adds the data we want to get parsed out of
  # the less stylesheet to this BuildHandler instance.
  class BuildHandler
    attr_reader :variables, :rules
    
    def initialize
      @variables = {}
      @rules = []
    end
    
    def to_css
      rules.map {|r| r.to_css }.join("\n")
    end
  end
end