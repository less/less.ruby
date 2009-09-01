module Less
  module Node
    class Property < ::String
      include Entity
      
      attr_accessor :value
      
      def initialize key, value = nil, parent = nil
        super key, parent

        value = if value.is_a? Array
          value.each {|v| v.parent = self if v.respond_to? :parent }
        elsif value.nil?
          []
        else
          value
        end

        @value = value.is_a?(Value) ? value : Value.new(value, self)
        @eval = false # Store the first evaluation in here
      end
      
      def parent= obj
        @parent = obj
        value.parent = self
      end
      
      def copy
        clone.tap {|c| c.value = value.copy }
      end
      
      def << token
        token = Node::Anonymous.new(*token) unless token.is_a? Entity or token.respond_to? :to_ruby
        token.parent = self if token.respond_to? :parent
        @value << token
      end
  
      def empty?; !@value || @value.empty? end
      def eval?;  @eval end

      def inspect
        self + (empty?? "" : ": `#{value.map {|i| i.to_s } * ' | '}`")
      end
      
      def == other
        self.to_s == other.to_s
      end
      
      def eql? other
        self == other and value.eql? other.value
      end
 
      def to_s
        super
      end
      
      def nearest node
        parent.nearest node
      end
        
      # TODO: @eval and @value should be merged
      def evaluate
        @eval ||= value.is_a?(Value) ? value.map {|e| e.evaluate } : [value.evaluate]
      end
          
      def to_css
        "#{self}: #{evaluate.map {|i| i.to_css }.join(", ")};"
      end
    end

    class Variable < Property
      attr_reader :declaration
        
      def initialize key, value = nil, parent = nil   
        @declaration = value ? true : false 
        super key.delete('@'), value, parent
      end
  
      def inspect
        "@#{super}"
      end
    
      def to_s
        "@#{super}"
      end
    
      def evaluate
        if declaration
          @eval ||= value.evaluate
        else          
          @eval ||= self.parent.nearest(to_s).evaluate
        end
      end
       
      def to_ruby
        evaluate.to_ruby
      end
    
      def to_css
        evaluate
        if @eval.respond_to? :to_css
          @eval.to_css
        else
          @eval.map {|i| i.to_css }.join ', '
        end
      end
    end
    
    class Value < Array
      attr_reader :parent
      
      def initialize ary, parent = nil
        @parent = parent
        if ary.size == 1 && !ary.first.is_a?(Array)
          super [Expression.new([ary.first])]
        else
          super ary.map {|e| p e.class;e.is_a?(Expression) ? e : Expression.new(e, self) }
        end
      end
      
      def parent= obj
        @parent = obj
        each {|e| e.parent = obj if e.respond_to? :parent }
      end
      
      def evaluate
        map {|e| e.evaluate }.dissolve
      end
      
      def copy
        first.copy
      end
      
      def to_css
        map {|e| e.to_css } * ', '
      end
    end
  
    class Expression < Array
      attr_reader :parent
      
      def initialize ary, parent = nil
        self.parent = parent
        super ary.dup
      end
      
      def expressions; select {|i| i.kind_of? Expression } end
      def operators;   select {|i| i.is_a? Operator }      end
      def entities;    select {|i| i.kind_of? Entity }     end
      def literals;    select {|i| i.kind_of? Literal }    end
        
      def parent= obj
        @parent = obj
        each {|e| e.parent = obj if e.respond_to? :parent }
      end
      
      def inspect
        '[' + map {|i| i.inspect }.join(', ') + ']'
      end
      
      def flatten
        self
      end
      
      def terminal?
        expressions.empty?
      end
      
      def copy
        self.class.new(map {|i| i.dup }, parent)
      end
      
      def to_css
        map do |i| 
          i.respond_to?(:to_css) ? i.to_css : i.to_s
        end * ' '
      end
      
      def to_ruby
        map do |i|
          i.respond_to?(:to_ruby) ? i.to_ruby : i.to_s
        end
      end
    
      #
      # Evaluates the expression and instantiates a new Literal with the result
      # ex: [#111, +, #111] will evaluate to a Color node, with value #222
      # 
      def evaluate
        if size > 2 or !terminal?
          # Replace self with an evaluated sub-expression
          replace map {|e| e.respond_to?(:evaluate) ? e.evaluate : e }

          unit = literals.map do |node|
            node.unit
          end.compact.uniq.tap do |ary|
            raise MixedUnitsError, self * ' ' if ary.size > 1 && !operators.empty?
          end.join
          
          entity = literals.find {|e| e.unit == unit } || literals.first || entities.first
          result = operators.empty?? self : eval(to_ruby.join)
          
          case result
            when Entity     then result
            when Expression then result.one?? result.first : self.class.new(result)
            else entity.class.new(result, *(unit if entity.class == Node::Number))
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