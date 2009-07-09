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
    class Color < DelegateClass(Fixnum)
      include Literal
      attr_reader :color
      
      def initialize color = nil, opacity = 1.0
        @color = if color.is_a? Array
          rgba color
        elsif color.is_a? ::String
          color.delete! unit
          (color * ( color.length < 6 ? 6 / color.length : 1 )).to_i 16
        else
          color
        end
        super @color.to_i
      end
    
      def unit
        '#'
      end
    
      def to_css
        unit + (self <= 0 ? '0' * 6 : self.to_i.to_s(16))
      end
    
      def to_ruby
        color
      end
    
      def to_s
        "#{unit}#{super}"
      end
      
      def inspect; to_s end
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
    
      def to_ruby
        self.to_f
      end
      
      def inspect
        to_s
      end
    
      def to_css
        "#{(self % 1).zero?? self.to_i.to_s : self.to_s}#@unit"
      end
    end
  
    #
    # "hello world"
    #
    class String < ::String
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
  
    class FontFamily < Array
      include Literal
      
      def initialize family = []
        super family
      end
    
      def to_css
        self.map(&:to_css) * ', '
      end
    end
  
    #
    # Any un-quoted word
    #   
    #   ex: red, small, border-collapse
    #
    class Keyword < ::String
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