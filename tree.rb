
class Tree
  def initialize root_node_name = ''
    @root_node = Node.new(root_node_name)
  end

  def auto_complete path, return_children=false
    path = path.split(/\s+/)
    if (path.length > 0 && return_children)
      path.push(nil)
    end
    return @root_node.auto_complete(path)
  end

  def add_path value, path
    @root_node.add_path(value, path)
  end
end

class Node
  attr_reader :node_name, :node_value, :children

  def initialize node_name, node_value = nil
    @node_name = node_name
    @node_name.freeze
    @node_value = node_value
    @children = {}
    @auto_complete_tree = {}
  end

  def add_path value, path=""
    path = path.split(/\s+/) unless (path.instance_of?(Array))
    root = path.shift
    raise "Cannot add an empty path" if (root.nil?)
    if (path.length > 0)
      add_child(Node.new(root)) if (@children[root].nil?)
      @children[root].add_path(value, path)
    else
      raise "Existing node #{root} as child of #{node_name}" if (@children[root])
      add_child(Node.new(root))
    end
  end

  # The input to auto complete has several possible input
  # scenarios:
  #   1) a path with all parts completed
  #   2) a path with all but the last part completed (final auto complete)
  #   3) a path with some parts completed (intermediate auto complete)
  #   4) a path with no parts completed (auto complete)
  #
  # Auto complete has 3 possible outcomes:
  #   1) A single command is found
  #   2) An ambiguous set of commands is found
  #   3) No command is found
  #
  # The return value for these 3 scenarios is (in order)
  #   1) Array with single node representing the matching command
  #   2) Array with all the nodes matching the ambiguous lookup
  #   3) nil
  def auto_complete prefix
    top = prefix.shift
    top ||= ""
    top = match_prefix(top)

    if (top.nil?)
      return nil
    elsif (top.length == 1)
      if (prefix.length == 0)
        if (@children[top[0]].nil?)
          return [self]
        else
          return [@children[top[0]]]
        end
      else
        return @children[top[0]].auto_complete(prefix)
      end
    elsif (prefix.length == 0)
      nodes = []
      top.each do |command|
        raise "Failed to find child node for command #{command}" if (@children[command].nil?)
        nodes.push(@children[command])
      end

      return nodes
    end
    return nil
  end

  def to_s
    node_value.nil? ? "#{node_name}" : "#{node_name}: #{node_value}"
  end

  private
    def add_child node
      @children[node.node_name] = node
      add_auto_complete(node.node_name)
    end

    def match_prefix prefix=nil, root=nil, commands = []
      #puts "Matching #{prefix.inspect} #{root.inspect} #{commands.inspect}"
      if (! prefix.nil? && root.nil?)
        root = @auto_complete_tree
        prefix.each_char do |ch|
          return [] unless (root = root[ch])
        end
      end

      if (root.length > 0)
	root.each do |k,v|
	  match_prefix(prefix + k, v, commands)
	end
      else
	commands.push(prefix)
      end
      return commands
    end

    def add_auto_complete(str) 
      node = @auto_complete_tree
      str.each_char do |ch|
	node[ch] ||= Hash.new
	node = node[ch]
      end
    end
end
