module Less
  module Node
    class Literal < Entity
      def unit
        nil
      end
    end
  
    #
    # rgb(255, 0, 0) #f0f0f0
    #
    class Color < Literal
      def initialize color = nil, opacity = 1.0
        @color = if color.is_a? Array
          rgba color
        elsif color.is_a? ::String
          color.delete! unit
          (color * ( color.length < 6 ? 6 / color.length : 1 ))
        else
          color <= 0 ? '0' * 6 : color.to_s(16)
        end
        super @color
      end
    
      def unit
        '#'
      end
    
      def inspect; to_s end
      def to_css;  to_s end
    
      def to_ruby
        to_i 16
      end
    
      def to_s
        "##{super}"
      end
    end
  
    #
    # 6 10px 125%
    #
    class Number < Literal # inherit form Fixnum?
      attr_accessor :unit
    
      def initialize value, unit = nil
        super value
        @unit = (unit.nil? || unit.empty?) ? nil : unit
      end
    
      def to_s
        "#{self}#{@unit}"
      end
    
      def to_ruby
        self
      end
      
      def inspect
        to_s
      end
    
      def to_css
        to_s
      end
    end
  
    #
    # "hello world"
    #
    class String < Literal
      attr_reader :quotes, :content
      
      def initialize str
        @quotes, @content = unless str.nil? or str.empty?
          str.match(/('|")(.*?)(\1)/).captures
        else
          [nil, ""]
        end
        super @content
      end
      
      def to_css
        "#@quotes#{@content}#@quotes"
      end
    end
  
    class Font < Literal; end
  
    class FontFamily < Literal
      def initialize family = []
        @fonts = family
        super family.to_s
      end
    
      def to_css
        @fonts.map(&:to_css) * ', '
      end
    end
  
    #
    # red small border-collapse
    #
    class Keyword < Entity
      def to_css
        self
      end
    
      def inspect
        "#{self}"
      end
    end
  end
end