module Less
  module Node
    class Property < String
      include Entity

      attr_accessor :value

      def initialize key, value = nil, parent = nil
        super key, parent
        value = if value.is_a? Array
          value.each {|v| v.parent = self if v.respond_to? :parent }.
                map  {|v| v.is_a?(Expression) ? v : Expression.new(v, self) }
        elsif value.nil?
          []
        else
          value
        end
        @value = value.is_a?(Expression) ? value : Expression.new(value, self)
        @value.parent = self
        @value.delimiter = ','
#        puts "new property #{to_s}: #{value} => #{@value}, contains: #{@value[0].class}"
#        puts
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

      def evaluate env = nil
#        puts "evaluating property `#{to_s}`: #{value.inspect}"
        if value.is_a?(Expression) #Value
#          puts "value is a Value"
          value.map {|e| e.evaluate(env) } #6
        else
#          puts "value is a #{value.class}"
          [value.evaluate(env)]
        end


      end

      def to_css env = nil
#        puts "property.to_css `#{to_s}` env:#{env ? env.variables : "nil"}"
        val = evaluate(env)
        "#{self}: #{if val.respond_to? :to_css
            val.to_css
          else
#            p val
#            puts "#{val.class} #{val.first.class}"
            val.map {|i| i.to_css }.join(", ")
          end};"
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

      def evaluate env = nil
        if declaration
#          puts "evaluating DEC"
          value.evaluate #2
        else
#          puts "evaluating #{to_s} par: #{parent} env: #{env ? env.variables : "nil"}"
        begin
          var = (env || self.parent).nearest(to_s) #3
        rescue VariableNameError
          var = self.parent.nearest(to_s)
        end
          var.evaluate
        end
      end

      def to_ruby
        evaluate.to_ruby
      end

      def to_css env = nil
        val = evaluate env
        if val.respond_to? :to_css
          env ? val.to_css(env) : val.to_css
        else
          val.map {|i| env ? i.to_css(env) : i.to_css }.join ', '
        end
      end
    end

    class Expression < Array
      attr_accessor :parent, :delimiter

      def initialize ary, parent = nil, delimiter = ' '
        self.parent = parent
        self.delimiter = delimiter
#        puts "new expression #{ary} |#{delimiter}|"
        super(ary.is_a?(Array) ? ary : [ary].flatten)
      end

      def expressions; select {|i| i.kind_of? Expression } end
      def variables;   select {|i| i.kind_of? Variable   } end
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

      def delimiter= d
        @delimiter = d.strip + ' '
      end

      def flatten
        self
      end

      def terminal?
        expressions.empty? #&& variables.empty?
      end

      def to_css env = nil
#        puts "TOCSS, delim: |#{@delimiter}|"
        map do |i|
          i.parent = self.parent
          i.respond_to?(:to_css) ? i.to_css() : i.to_s
        end * @delimiter
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
      def evaluate env = nil
#        puts "expression #{self.inspect} env: #{env ? env.variables : "nil"}"
        if size > 2 or !terminal?
#          puts " SIZE > 2 or !terminal"

#          puts "--- sub evaluation ---"

          # Replace self with an evaluated sub-expression
          evaled = self.class.new(map {|e| e.respond_to?(:evaluate) ? e.evaluate(env) : e }, parent, delimiter) #5

#          puts "======================"
#          puts "evaled => #{evaled.inspect}"

          unit = evaled.literals.map do |node|
            node.unit
          end.compact.uniq.tap do |ary|
            raise MixedUnitsError, evaled * ' ' if ary.size > 1 && !evaled.operators.empty?
          end.join

          entity = evaled.literals.find {|e| e.unit == unit } || evaled.literals.first || evaled.entities.first
          result = evaled.operators.empty?? evaled : eval(evaled.to_ruby.join)

#          puts "entity is a #{entity.class}"
#          puts "delimiter is |#{@delimiter}|"

          case result
            when Entity     then result
            when Expression then result.one?? result.first : self.class.new(result, parent, delimiter)
            else entity.class.new(result, *(unit if entity.class == Node::Number))
          end
        elsif size == 1
          if first.is_a? Variable
            first.evaluate(env)
          elsif first.is_a? Function
            first.evaluate(env)
          else
            first
          end
        else
          self
        end
      end
    end
  end
end
