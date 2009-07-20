module Less
  module Node
    class Property < ::String
      include Entity
      
      attr_accessor :value
      
      def initialize key, value = nil
        super key
        @value = Expression.new(value ? [value].flatten : [])
        @eval = false # Store the first evaluation in here
      end
  
      def << token
        token = Node::Anonymous.new(*token) unless token.is_a? Entity or token.is_a? Operator
        token.parent = self if token.respond_to? :parent
        @value << token
      end
  
      def empty?; !@value || @value.empty? end
      def eval?;  @eval end

      def inspect
        self + (empty?? "" : ": `#{value.map {|i| i.to_s } * ' | '}`")
      end
 
      def to_s
        super
      end
      
      def nearest node
        parent.nearest node
      end
        
      # TODO: @eval and @value should be merged
      def evaluate    
        @eval ||= value.evaluate
      end
          
      def to_css
        "#{self}: #{evaluate.to_css};"
      end
    end

    class Variable < Property
      attr_reader :declaration
        
      def initialize key, value = nil   
        @declaration = value ? true : false 
        #puts "new var #{key} #{@declaration}"
        super key.delete('@'), value
      end
  
      def inspect
        "@#{super}"
      end
    
      def to_s
        "@#{super}"
      end
    
      def evaluate
        #puts "#{self}::"
        if declaration
         # puts "VALUE: #{value} #{value.class}"
          @eval ||= value.evaluate

        else
          #puts "#{self}=#{value} #{value.class}"
          
          @eval ||= self.parent.nearest(to_s).evaluate
          
        end
      end
       
      def to_ruby
        evaluate.to_ruby
      end
    
      def to_css
        evaluate.to_css
      end
    end
  
    class Expression < Array
      def initialize ary
        super [ary].flatten
      end
      
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
      # TODO: refactor the conditionals
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
            if entity
              result = eval(ruby.join)
              if result.is_a? Entity
                result
              else
                entity.class.new(result, *(unit if entity.class == Node::Number))
              end
            else
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