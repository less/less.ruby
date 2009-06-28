#
# Element
#
# TODO: Use delegate class -> @rules
#
# Class hierarchy
#
# - Node
#   - Mixin
#   - Rule
#   - Property
#     - Variable
#
# Data hierarchy
#
# Rule
#   @rules
#     :desc
#       Rule
#       ...
#     :child
#       Rule
#       ...
#   @properties
#     Property
#     ...
        
module Less
  class Node < String
    def initialize s
      super
    end
  end
  
  class Mixin < Node # < Element???
    def to_css
      "/* mixin: #{self} */"
      # Look up path and point to data
    end
    
    def inspect
      to_s
    end
  end
  
  #
  # div {...}
  #
  class Element < Node
    include Enumerable
    
    attr_accessor :rules, :selector
    
    Selectors = {
      '' => ' ',
      '>' => ' > ',
      '+' => ' + ',
      ':' => ':'
    }
    
    def initialize name = "", selector = ' '
      super name
        
      @rules = []   # Holds all the nodes under this element's hierarchy
      @selector = Selectors[selector.strip]  # descendant | child | adjacent
      self
    end
    
    def class?;     self =~ /^\./ end
    def id?;        self =~ /^#/  end
    def universal?; self == '*'   end
    
    def tag? 
      not id? || class? || universal?
    end
    
    # Top-most node?
    def root?
      self == ''
    end
    
    def empty?
      @rules.empty?
    end
    
    def leaf?
      elements.flatten.empty?
    end
    
    #
    # Accessors for the different nodes in @rules
    #
    def identifiers; @rules.select {|r| r.kind_of?     Property } end
    def properties;  @rules.select {|r| r.instance_of? Property } end
    def variables;   @rules.select {|r| r.instance_of? Variable } end
    def mixins;      @rules.select {|r| r.is_a?        Mixin    } end
    def elements;    @rules.select {|r| r.is_a?        Element  } end
    
    # Select a child element
    def [] key
      elements.find {|i| i == key }
    end
    
    def flatten
      elements.map(&:flatten)
    end
    
    # Add an arbitrary node to this element
    def << obj
      @rules << if obj.respond_to? :flatten
        key, value = *obj.flatten
        (key =~ /^@/ ? Variable : Property).new(key, value)
      elsif obj.is_a? Node
        obj
      else
        raise ArgumentError, "argument can't be a #{obj.class}"
      end
    end
    
    def to_s
      super
    end
    
    def to_css path = []
      path << @selector << self unless root?

      content = properties.map do |i|
        ' ' * 2 + i.to_css
      end.compact.reject(&:empty?) * "\n"
      
      content = content.include?("\n") ? 
        "\n#{content}\n" : " #{content.strip} "
      ruleset = !content.strip.empty?? 
        "#{path.reject(&:empty?).join.strip} {#{content}}\n" : ""
      
      css = ruleset + elements.map do |i|
        i.to_css(path)
      end.reject(&:empty?).join
      path.pop 2
      css
    end
    
    def each path = [], &blk
    #
    # Traverse the whole tree, returning each leaf or branch (recursive)
    #
    ###
      #   Aside from the key & value, we yield the full path of the leaf,  
      #   aswell as the branch which contains it (self).
      #   Note that in :branch mode, we only return 'twigs', branches which contain leaves.
      #
      elements.each do |element|                            
        path << element                         
        yield element, path if element.leaf?                
        element.each path, &blk                                        
        path.pop                    
      end
      self
    end
    alias :traverse :each
    
    def inspect depth = 0
      indent = lambda {|i| '.  ' * i }
      put    = lambda {|ary| ary.map {|i| indent[ depth + 1 ] + i.inspect } * "\n"}

      (root?? "\n" : "") + [
        indent[ depth ] + (self == '' ? '*' : self.to_s),
        put[ properties ],
        put[ variables ],
        elements.map {|i| i.inspect( depth + 1 ) } * "\n",
        put[ mixins ]
      ].reject(&:empty?).join("\n") + "\n" + indent[ depth ]
    end
  end
  
  class Property < Node
    attr_accessor :value
    
    def initialize key, value
      super key
      @value = value
      @eval = false # Was the value evaluated?
    end
    
    def eval?; @eval end
  
    def inspect
      "#{self}: `#{value}`"
    end
    
    def to_css
      "#{self}: #{value};"
    end
  end
  
  class Variable < Property
    def initialize key, value
      super key.delete('@'), value
    end
    
    def inspect
      "@#{super}"
    end
    
    def to_css
      ""
    end
  end
end