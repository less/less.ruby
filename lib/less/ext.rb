module Treetop
  module Runtime
    class CompiledParser
      def failure_message color
        o = color ? Mutter.new.clear : lambda {|i, *args| i }
        return nil unless (tf = terminal_failures) && tf.size > 0
        msg = "on line #{failure_line}: expected " + (
          tf.size == 1 ?
            o[tf[0].expected_string, :yellow] :
            "one of #{o[tf.map {|f| f.expected_string }.uniq * ' ', :yellow]}"
        )
        f = input[failure_index]
        got = case f
          when "\n" then o['\n',  :cyan]
          when nil  then o["EOF", :cyan]
          when ' '  then o["white-space", :cyan]
          else           o[f.chr, :yellow]
        end
        msg += " got #{got} after:\n\n#{input[index...failure_index]}\n"
      end
    end
  end
end

class Object
  def verbose
    $verbose = true
    yield
  ensure
    $verbose = false
  end
  
  def tap
    yield self
    self
  end
end

class Array
  def dissolve
    ary = flatten.compact
    case ary.size
      when 0 then []
      when 1 then first
      else ary
    end
  end
  
  def one?
    size == 1
  end
end

unless :symbol.respond_to?(:to_proc)
  class Symbol
    def to_proc
      Proc.new {|*args| args.shift.__send__(self, *args) }
    end
  end
end
