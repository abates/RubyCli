
require 'leaf_node'

class InnerNode
  attr_reader :node_name, :children

  def initialize node_name
    @node_name = node_name
    @children = {}
    @auto_complete_tree = {}
  end

  def add_path value, *path
    root = path.shift
    raise "Cannot add an empty path" if (root.nil?)
    if (path.length == 0)
      raise "Node already exists at this path!" if (@children[root])
      #puts "Creating new leaf node for #{root}"
      #add_child(LeafNode.new(root, value))
      return @children[root]
    end
    #puts "Adding inner node for #{root}"
    add_child(InnerNode.new(root)) if (@children[root].nil?)
    return @children[root].add_path(value, *path)
  end

  def lookup prefix, node=nil
    node = auto_complete(prefix) if (node.nil?)
    c = []
    node.each do |k,v|
      p = prefix + k
      if (v.length == 0)
        #puts "Adding #{p}"
        c.push(@children[p])
      else
        c.push(*lookup(p, v))
      end
    end
    c
  end

  def to_s
    "#{node_name}"
  end

  private
    def add_child child
      @children[child.node_name] = child
      build(child.node_name)
    end

    def auto_complete(str)
      node = @auto_complete_tree
      str.each_char { |ch|
        cur = ch
        node = node[cur]
        if node == nil
          return {}
        end
      }
      return node
    end

    def build(str)
      node = @auto_complete_tree
      str.each_char { |ch|
        cur = ch
        prev_node = node
        node = node[cur]
        if node == nil
          prev_node[cur] = Hash.new()
          node = prev_node[cur]
        end
      }
    end
end
