$:.unshift File.dirname(__FILE__)

require 'cgi'
require 'treetop'

require 'less/command'
require 'less/engine'
require 'less/engine/element'
require 'less/tree'
require 'less/engine/builder'

Treetop.load 'lib/less/less'

module Less
  MixedUnitsError = Class.new(Exception)
  PathError = Class.new(Exception)
  CompoundOperationError = Class.new(Exception)

  def self.version
    File.read( File.join( File.dirname(__FILE__), '..', 'VERSION') ).strip
  end
  
  def self.parse less
    Engine.new(less).to_css
  end
end

class Hash
  # Convert a hash into a Tree
  def to_tree
    Less::Tree.new self
  end
end
