
require 'leaf_node'
require 'inner_node'

class Tree
  def initialize root_node_name = 'root'
    @root_node = InnerNode.new(root_node_name)
  end

  def find path
    if (path.instance_of?(String))
      path = path.split(/\s+/)
    elsif (! path.instance_of(Array))
      raise "Can only find the path of a String or an Array of Strings"
    end
    current_node = @root_node
    path.each do |part|
      if (current_node.children[part])
        nodes = [current_node.children[part]]
      else
        nodes = current_node.lookup(part)
      end

      if (nodes.length == 0)
        return []
      elsif (nodes.length == 1)
        return nodes if (nodes[0].instance_of?(LeafNode))
        current_node = nodes[0]
      else
        return nodes
      end
    end
    return [current_node]
  end

  def add_path value, path
    @root_node.add_path(value, path)
  end

end

