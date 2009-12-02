module Less
  #
  # Functions useable from within the style-sheet go here
  #
  module Functions
    def rgb *rgb
      rgba rgb, 1.0
    end

    def hsl *args
      hsla *[args, 1.0].flatten
    end

    #
    # RGBA to Node::Color
    #
    def rgba *rgba
      Node::Color.new *rgba.flatten
    end
    
    #
    # HSLA to RGBA
    #
    def hsla h, s, l, a = 1.0
      m2 = ( l <= 0.5 ) ? l * ( s + 1 ) : l + s - l * s
      m1 = l * 2 - m2;

      hue = lambda do |h|
        h = h < 0 ? h + 1 : (h > 1 ? h - 1 : h)
        if    h * 6 < 1 then m1 + (m2 - m1) * h * 6
        elsif h * 2 < 1 then m2 
        elsif h * 3 < 2 then m1 + (m2 - m1) * (2/3 - h) * 6 
        else m1
        end
      end

      rgba hue[ h + 1/3 ], hue[ h ], hue[ h - 1/3 ], a
    end
    
    def self.available
      self.instance_methods.map(&:to_sym)
    end
  end
  
  module Node
    #
    # A CSS function, like rgb() or url()
    #
    #   it calls functions from the Functions module
    #
    class Function < String
      include Entity
      include Functions
    
      def initialize name, args
        @args = if args.is_a? Array
          args.map {|e| e.is_a?(Expression) ? e : Expression.new(e, self)}
        else
          [args]
        end
        
        super name
      end
      
      def to_css env = nil
        self.evaluate(env).to_css
      end
      
      def nearest node
        parent.nearest node
      end
      
      #
      # Call the function
      #
      # If the function isn't found, we just print it out,
      # this is the case for url(), for example,
      #
      def evaluate context = nil
        if Functions.available.include? self.to_sym
          send to_sym, *@args
        else
          args = @args.map { |e|
            e.parent = self.parent
            e = e.evaluate(context) if e.respond_to?(:evaluate)
            e.to_css
          }  * ', '
          Node::Anonymous.new("#{to_sym}(#{args})")
        end
      end
    end
  end
end
