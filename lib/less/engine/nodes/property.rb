module Less
  module Node
    class Property < Entity  
      attr_accessor :value
    
      def initialize key, value = nil
        super key
        log "\n[new] #{self.class} `#{key}`\n"
        @value = Expression.new(value ? [value] : [])
        @eval = false # Store the first evaluation in here
      end
  
      def << token
        log "[adding] to #{self.to_s}: '#{token.to_s}' <#{token.class}>\n"
        token = Node::Base.new(*token) unless token.is_a? Node::Base
        @value << token
      end
  
      def empty?; !@value || @value.empty? end
      def eval?;  @eval end

      def inspect
        self + (empty?? "" : ": `#{value.map(&:to_s) * ' | '}`")
      end
 
      def to_s
        super
      end
    
      def evaluate    
        @eval || @eval = value.evaluate
      end
    
      def to_css
        "#{self}: #{evaluate.to_css};"
      end
    end

    class Variable < Property
      def initialize key, value = nil      
        super key.delete('@'), value
      end
  
      def inspect
        "@#{super}"
      end
    
      def to_s
        "@#{super}"
      end
    
      def evaluate
        @eval || @eval = value.evaluate
      end
    
      def to_ruby
        value.evaluate.to_ruby
      end
    
      def to_css
        value.evaluate.to_css
      end
    end
  
    class Expression < Array
      def operators; select {|i| i.is_a? Operator }   end
      def entities;  select {|i| i.kind_of? Entity }  end
      def literals;  select {|i| i.kind_of? Literal } end
    
      def inspect
        '[' + map {|i| i.inspect }.join(', ') + ']'
      end
    
      def to_css
        map {|i| i.to_css } * ' '
      end
    
      #
      # Evaluates the expression and instantiates a new Literal with the result
      # ex: [#111, +, #111] will evaluate to a Color node, with value #222
      #
      def evaluate
        if size > 2 && (entities.size == operators.size + 1)
        
          # Create a sub-expression with all the variables/properties evaluated
          evaluated = Expression.new map {|e| e.respond_to?(:evaluate) ? e.evaluate : e }
        
          unit = evaluated.literals.map do |node|
            node.unit
          end.compact.uniq.tap do |ary|
            raise MixedUnitsError, self * ' ' if ary.size > 1
          end.join
        
          entity = evaluated.literals.find {|e| e.unit == unit } || evaluated.first        
          ruby = map {|e| e.to_ruby if e.respond_to? :to_ruby }
        
          unless ruby.include? nil
            log "ruby(#{unit}): " + ruby.join(' ') + "\n"
      
            if entity
              log "\n# => #{eval(ruby.join)} <#{entity.class}>\n"
              entity.class.new(eval(ruby.join), *(unit if entity.class == Node::Number))
            else
              log "\n# => not evaluated"
              first
            end
          else
            self
          end
        elsif size == 1
          first
        else
          self
        end
      end
    end
  end
end