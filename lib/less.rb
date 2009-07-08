$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'cgi'
require 'treetop'
require 'forwardable'
require 'delegate'

require 'less/command'
require 'less/engine'

module Less
  PARSER = 'lib/less/engine/parser.rb'
  GRAMMAR = 'lib/less/engine/less.tt'
  
  MixedUnitsError   = Class.new(Exception)
  PathError         = Class.new(Exception)
  VariableNameError = Class.new(NameError)
  MixinNameError    = Class.new(NameError)
  SyntaxError       = Class.new(RuntimeError)
  
  $verbose = false

  def self.version
    File.read( File.join( File.dirname(__FILE__), '..', 'VERSION') ).strip
  end
  
  def self.parse less
    Engine.new(less).to_css
  end
end

module Treetop
  module Runtime
    class CompiledParser
      def failure_message
        return nil unless (tf = terminal_failures) && tf.size > 0
        "on line #{failure_line}: expected " + (
          tf.size == 1 ? 
            tf[0].expected_string : 
            "one of #{tf.map {|f| f.expected_string }.uniq * ' '}"
        ) +
        " got `#{input[failure_index]}`" +
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
  def error!(s) raise CradleError, s end
end

class Class
  def to_sym
    self.to_s.to_sym
  end
end

class Symbol
  def to_proc
    proc {|obj, *args| obj.send(self, *args) }
  end
end