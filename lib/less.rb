require 'cgi'
require 'mutter'
require 'delegate'
require 'johnson'

LESS_ROOT = File.expand_path(File.dirname(__FILE__))

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
  ParseError        = Class.new(RuntimeError)
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
