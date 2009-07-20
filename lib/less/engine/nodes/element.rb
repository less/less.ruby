module Less
  module Node
    #
    # Element
    #
    # div {...}
    #
    # TODO: Look into making @rules its own hash-like class
    # TODO: Look into whether selector should be child by default
    #
    class Element < ::String
      include Enumerable
      include Entity
  
      attr_accessor :rules, :selector, :partial, :file, :set
  
      def initialize name = "", selector = ''
        super name   
        
        @set = []
        @rules = [] # Holds all the nodes under this element's hierarchy
        @selector = Selector[selector.strip].new  # descendant | child | adjacent
      end
    
      def class?;     self =~ /^\./ end
      def id?;        self =~ /^#/  end
      def universal?; self == '*'   end
  
      def tag? 
        not id? || class? || universal?
      end
  
      # Top-most node?
      def root?
        parent.nil?
      end
    
      def empty?
        @rules.empty?
      end
  
      def leaf?
        elements.empty?
      end
      
      # Group similar rulesets together
      # This is horrible, horrible code,
      # but it'll have to do until I find
      # a proper way to do it.
      def group
        matched = false
        stack, result = elements.dup, []
        return self unless elements.size > 1
        
        elements.each do
          e = stack.first
          result << e unless matched
          
          matched = stack[1..-1].each do |ee|
            if e.rules.size == ee.rules.size and 
               e.elements.size == 0 and
              !e.rules.zip(ee.rules).map {|a, b| 
                a.to_css == b.to_css
              }.include?(false)
              
              # Add to set unless it's a duplicate
              if e == ee
                # Do something with dups
              else
                self[e].set << ee
              end
              stack.shift
            else
              stack.shift
              break false
            end
          end if stack.size > 1
        end
        @rules -= (elements - result)
        self
      end
  
      #
      # Accessors for the different nodes in @rules
      #
      def identifiers; @rules.select {|r| r.kind_of?     Property } end
      def properties;  @rules.select {|r| r.instance_of? Property } end
      def variables;   @rules.select {|r| r.instance_of? Variable } end
      def elements;    @rules.select {|r| r.instance_of? Element  } end
  
      # Select a child element
      # TODO: Implement full selector syntax & merge with descend()
      def [] key
        @rules.find {|i| i.to_s == key }
      end
    
      # Same as above, except with a specific selector
      # TODO: clean this up or implement it differently
      def descend selector, element
        if selector.is_a? Child
          s = self[element].selector
          self[element] if s.is_a? Child or s.is_a? Descendant
        elsif selector.is_a? Descendant
          self[element]
        else
          self[element] if self[element].selector.class == selector.class
        end
      end
  
      #
      # Add an arbitrary node to this element
      #
      def << obj
        if obj.kind_of? Node::Entity
          obj.parent = self
          @rules << obj
        else
          raise ArgumentError, "argument can't be a #{obj.class}"
        end
      end
    
      def last;  elements.last  end
      def first; elements.first end
      def to_s; root?? '*' : super end
      
      #
      # Entry point for the css conversion
      #
      def to_css path = []
        path << @selector.to_css << self unless root?

        content = properties.map do |i|
          ' ' * 2 + i.to_css
        end.compact.reject(&:empty?) * "\n"
        
        content = content.include?("\n") ? 
          "\n#{content}\n" : " #{content.strip} "
        ruleset = !content.strip.empty?? 
          "#{[path.reject(&:empty?).join.strip, *@set] * ', '} {#{content}}\n" : ""
      
        css = ruleset + elements.map do |i|
          i.to_css(path)
        end.reject(&:empty?).join        
        path.pop; path.pop
        css
      end
  
      #
      # Find the nearest variable in the hierarchy or raise a NameError
      #
      def nearest ident
        ary = ident =~ /^[.#]/ ? :elements : :variables
        path.map do |node|
          node.send(ary).find {|i| i.to_s == ident }
        end.compact.first.tap do |result|
          raise VariableNameError, ident unless result
        end
      end
    
      #
      # Traverse the whole tree, returning each leaf (recursive)
      #
      def each path = [], &blk
        elements.each do |element|                            
          path << element                         
          yield element, path if element.leaf?                
          element.each path, &blk                                        
          path.pop                    
        end
        self
      end
  
      def inspect depth = 0
        indent = lambda {|i| '.  ' * i }
        put    = lambda {|ary| ary.map {|i| indent[ depth + 1 ] + i.inspect } * "\n"}

        (root?? "\n" : "") + [
          indent[ depth ] + (self == '' ? '*' : self.to_s),
          put[ properties ],
          put[ variables ],
          elements.map {|i| i.inspect( depth + 1 ) } * "\n"
        ].reject(&:empty?).join("\n") + "\n" + indent[ depth ]
      end
    end
  end
end