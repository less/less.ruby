module Less
  module Node
    module Literal
      include Entity
      
      def unit
        nil
      end
    end
  
    #
    # rgb(255, 0, 0) #f0f0f0
    #
    class Color
      include Literal
      attr_reader :r, :g, :b, :a

      def initialize r, g, b, a = 1.0
        @r, @g, @b = [r, g, b].map do |c|
          normalize(c.is_a?(String) ? c.to_i(16) : c)
        end
        @a = normalize(a, 1.0)
      end
      
      def alpha v
        self.class.new r, g, b, v
      end
      
      def rgb
        [r, g, b]
      end
      
      def operate op, other
        color = if other.is_a? Numeric
          rgb.map {|c| c.send(op, other) }
        else
          rgb.zip(other.rgb).map {|a, b| a.send(op, b) }
        end
        self.class.new *[color, @a].flatten # Ruby 1.8 hack
      end
      
      def + other; operate :+, other end
      def - other; operate :-, other end
      def * other; operate :*, other end
      def / other; operate :/, other end
      
      def coerce other
        return self, other
      end

      def to_s
        if a < 1.0
          "rgba(#{r.to_i}, #{g.to_i}, #{b.to_i}, #{a})"
        else
          "#%02x%02x%02x" % [r, g, b]
        end
      end

      def inspect
        if a < 1.0
          "rgba(#{r}, #{g}, #{b}, #{a})"
        else
          "rgb(#{r}, #{g}, #{b})"
        end
      end

      def to_css
        to_s
      end
      
      def to_ruby
        "#{self.class}.new(#{r},#{g},#{b},#{a})"
      end
      
    protected
      def normalize(v, max = 255, min = 0)
        [[min, v].max, max].min
      end
    end
  
    #
    # 6 10px 125%
    #
    class Number < DelegateClass(Float)
      include Literal
      
      attr_accessor :unit
    
      def initialize value, unit = nil
        super value.to_f
        @unit = (unit.nil? || unit.empty?) ? nil : unit
      end
    
      def to_s
        "#{super}#@unit"
      end
      
      def dup
        self
      end
      
      def to_ruby
        self.to_f
      end
      
      def inspect
        to_s
      end
    
      def to_css
        "#{(self % 1).zero?? "#{self.to_i}#@unit" : self}"
      end
    end
  
    #
    # "hello world"
    #
    class Quoted < String
      include Literal
      
      attr_reader :quotes, :content
      
      # Strip quotes if necessary, and save them in @quotes
      def initialize str
        @quotes, @content = unless str.nil? or str.empty?
          str.match(/('|")(.*?)(\1)/).captures rescue [nil, str]
        else
          [nil, ""]
        end
        super @content
      end
      
      def to_css
        "#@quotes#{@content}#@quotes"
      end
    end
  
    class Font
      include Literal
    end
  
    class FontFamily
      include Literal
      
      def initialize family = []
        @family = family
      end
    
      def to_css
        @family.map(&:to_css) * ', '
      end
    end
  
    #
    # Any un-quoted word
    #   
    #   ex: red, small, border-collapse
    #
    class Keyword < String
      include Entity
      
      def to_css
        self
      end
    
      def inspect
        "#{self}"
      end
    end
  end
end