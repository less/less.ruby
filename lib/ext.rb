module Treetop
  module Runtime
    class CompiledParser
      def failure_message
        return nil unless (tf = terminal_failures) && tf.size > 0
        "on line #{failure_line}: expected " + (
          tf.size == 1 ? 
            tf[0].expected_string : 
            "one of #{Less::YELLOW[tf.map {|f| f.expected_string }.uniq * ' ']}"
        ) +
        " got #{Less::YELLOW[input[failure_index].chr]}" +
        " after:\n\n#{input[index...failure_index]}\n"
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
  
  def log(s = '')  puts "* #{s}" if $verbose end
  def log!(s = '') puts "* #{s}" end
  def error(s) $stderr.puts s end
  def error!(s) raise Exception, s end
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

class Class
  def to_sym
    self.to_s.to_sym
  end
end

unless :symbol.respond_to?(:to_proc)
  class Symbol
    def to_proc
      proc {|obj, *args| obj.send(self, *args) }
    end
  end
end
