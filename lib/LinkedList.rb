# You will need two classes:
#   LinkedList class, which will represent the full list.
#   Node class, containing a #value method and a link to the #next_node, set both as nil by default.
#
# Build the following methods in your linked list class:
#
#   #append(value) adds a new node containing value to the end of the list
#   #prepend(value) adds a new node containing value to the start of the list
#   #size returns the total number of nodes in the list
#   #head returns the first node in the list
#   #tail returns the last node in the list
#   #at(index) returns the node at the given index
#   #pop removes the last element from the list
#   #contains?(value) returns true if the passed in value is in the list and otherwise returns false.
#   #find(value) returns the index of the node containing value, or nil if not found.
#   #to_s represent your LinkedList objects as strings, so you can print them out and preview them in the console. The format should be: ( value ) -> ( value ) -> ( value ) -> nil

class LinkedList
  # represent linked list
  def initialize()
    @first_node = Node.new
  end

  def append(key, value)
    # adds a new node containing key and value to the end of the list
    if @first_node.key.nil?
      @first_node.edit_key(key)
      @first_node.edit_value(value)
    else
      new_node = Node.new(key, value)
      last_node = tail
      last_node.edit_next(new_node)
    end
  end

  def prepend(key, value)
    # adds a new node containing key and value to the start of the list
    if @first_node.key.nil?
      @first_node.edit_key(key)
      @first_node.edit_value(value)
    else
      new_node = Node.new(key, value)
      new_node.edit_next(@first_node)
      @first_node = new_node
    end
  end

  def size
    count = 0
    count += 1 unless @first_node.key.nil?
    unless @first_node.next_node.nil?
      next_node = @first_node.next_node
      count += 1
      until next_node.next_node.nil?
        count += 1
        next_node = next_node.next_node
      end
    end
    count
  end

  def head
    @first_node
  end

  def tail
    if @first_node.next_node.nil?
      @first_node
    else
      last_node = @first_node.next_node
      until last_node.next_node.nil?
        last_node = last_node.next_node
      end
      last_node
    end
  end

  def at(index)
    # #at(index) returns the node at the given index
    if index.zero?
      @first_node
    elsif index < itself.size
      count = 1
      next_node = @first_node.next_node
      while count != index
        next_node = next_node.next_node
        count += 1
      end
      next_node
    end
  end

  def pop
    # removes the last element from the list
    tail.edit_key(nil)
    tail.edit_value(nil)
    new_last_node = at(itself.size-2)
    new_last_node.edit_next(nil)
  end

  def contains_key?(key)
    # #contains?(key) returns true if the passed in key is in the list and otherwise returns false.
    if @first_node.key == key
      @first_node
    elsif @first_node.next_node
      next_node = @first_node.next_node
      return true if next_node.key == key
      until next_node.next_node.nil?
        next_node = next_node.next_node
        return true if next_node.key == key
      end
      false
    end
  end

  def contains_value?(value)
    # #contains?(value) returns true if the passed in value is in the list and otherwise returns false.
    if @first_node.value == value
      @first_node
    else
      next_node = @first_node.next_node
      return true if next_node.value == value
      until next_node.next_node.nil?
        next_node = next_node.next_node
        return true if next_node.value == value
      end
      false
    end
  end

  def find_key(key)
    # #find(value) returns the index of the node containing key, or nil if not found.
    count = 0
    if @first_node.key == key
      return count
    else
      next_node = @first_node.next_node
      count += 1
      return count if next_node.key == key
      until next_node.next_node.nil?
        next_node = next_node.next_node
        count += 1
        return count if next_node.key == key
      end
    end
    "Key Not Found"
  end

  def find_value(value)
    # #find(value) returns the index of the node containing value, or nil if not found.
    count = 0
    if @first_node.value == value
      return count
    else
      next_node = @first_node.next_node
      count += 1
      return count if next_node.value == value
      until next_node.next_node.nil?
        next_node = next_node.next_node
        count += 1
        return count if next_node.value == value
      end
    end
    "Value Not Found"
  end

  def overwrite(key, value, index)
    # #insert_at(value, index) that inserts a new node with the provided value at the given index
    overwrite_node = at(index)
    p overwrite_node
    overwrite_node.edit_key(key)
    overwrite_node.edit_value(value)
  end

  def insert_at(key, value, index)
    # #insert_at(value, index) that inserts a new node with the provided value at the given index
    if index.zero?
      prepend(key, value)
    elsif index > itself.size-1
      append(key, value)
    else
      if @first_node.key.nil?
        @first_node.edit_key(key)
        @first_node.edit_value(value)
      else
        # get previous, new and next nodes
        before_node = at(index-1)
        after_node = at(index)
        new_node = Node.new(key, value)
        # point previous node to the new one
        before_node.edit_next(new_node)
        # point new node to the next node
        new_node.edit_next(after_node)
      end
    end
  end

  def remove_first_node
    if size > 1
      # if more than one node
      @first_node = at(1)
    else
      # if only one node
      @first_node = Node.new
    end
  end

  def remove_at(index)
    # #remove_at(index) that removes the node at the given index
    begin
      if index.zero?
        remove_first_node
      elsif index == itself.size-1
        pop
      else
        # get previous and next nodes
        before_node = at(index-1)
        after_node = at(index+1)
        # point previous to next skipping the middle node
        before_node.edit_next(after_node)
      end
    rescue StandardError
      "Node Not Found"
    end
  end

  def to_s(node)
    puts "\t[ Address: #{node} | Key: #{node.key} | Value: #{node.value} | Next Node: #{node.next_node} ]"
  end

  def print
    puts "\t[ Listing #{itself.size} nodes ]"
    to_s(@first_node) if @first_node.key
    unless @first_node.next_node.nil?
      # to_s(@first_node)
      next_node = @first_node.next_node
      if next_node
        until next_node.next_node.nil?
          to_s(next_node)
          next_node = next_node.next_node
        end
        to_s(next_node)
      end
    end
    puts "\n"
  end
end

class Node
  def initialize(key=nil, value=nil, next_node=nil)
    @key = key
    @value = value
    @next_node = next_node
  end

  def key
    @key unless @key.nil?
  end

  def value
    @value unless @value.nil?
  end

  def next_node
    @next_node
  end

  def edit_key(key)
    @key = key
  end

  def edit_value(value)
    @value = value
  end

  def edit_next(next_node)
    @next_node = next_node
  end
end

# l1 = LinkedList.new()
#
# l1.prepend("Carlo", "Alcahuete")
# l1.append("Carlo", "Alcahuete222")
# l1.insert_at("Carla", "Mozuela", 1)
# l1.print
# l1.remove_at(0)
# l1.print


#
# l2 = LinkedList.new()
#
# l2.prepend("Carlo", "Alcahuete")
#
# l2.print
#
# puts "\n///////////////////////// DEBUGGING ////////////////////////////////////"
# l2.remove_at(0)
#
# puts "\n///////////////////////// DEBUGGING ////////////////////////////////////"
# l2.print