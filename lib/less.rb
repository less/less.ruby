require 'cgi'
require 'treetop'
require 'mutter'
require 'delegate'

LESS_ROOT = File.expand_path(File.dirname(__FILE__))
LESS_PARSER = File.join(LESS_ROOT, 'less', 'engine', 'parser.rb')
LESS_GRAMMAR = File.join(LESS_ROOT, 'less', 'engine', 'grammar')

$LESS_LOAD_PATH = []

$:.unshift File.dirname(__FILE__)

require 'less/ext'
require 'less/command'
require 'less/engine'

module Less
  MixedUnitsError   = Class.new(RuntimeError)
  PathError         = Class.new(RuntimeError)
  VariableNameError = Class.new(NameError)
  MixinNameError    = Class.new(NameError)
  SyntaxError       = Class.new(RuntimeError)
  ImportError       = Class.new(RuntimeError)
  CompileError      = Class.new(RuntimeError)

  $verbose = false

  def self.version
    File.read( File.join( File.dirname(__FILE__), '..', 'VERSION') ).strip
  end

  def self.parse less
    Engine.new(less).to_css
  end
end
