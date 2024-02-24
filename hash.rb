# https://www.theodinproject.com/lessons/ruby-hashmap
# Use the following snippet whenever you access a bucket through an index. We want to raise an error
# if we try to access an out of bound index:
# raise IndexError if index.negative? || index >= @buckets.length

require_relative './lib/LinkedList'

class HashMap
  def initialize
    @capacity = 16
    @load_factor_max = 0.75
    @load_factor_min = 0.2
    @buckets = []
    @capacity.times do
      @buckets.push(LinkedList.new)
    end
  end

  def redistribute_buckets
    puts "\nredistributing buckets"
    @backup.each do | bucket |
      index = 0
      while bucket.at(index)
        key = bucket.at(index).key unless bucket.at(index).key.nil?
        value = bucket.at(index).value unless bucket.at(index).value.nil?
        # puts "key: #{key} | value: #{value}" if key.to_s.length > 0
        set_without_hashing(key, value) if key.to_s.length.positive?
        index += 1
      end
    end
  end

  def decrease_capacity
    # create backup
    @backup = @buckets
    # decrease capacity
    @capacity /= 2
    puts "\n@capacity now is: #{@capacity}"
    # recreate buckets with new capacity
    @buckets = []
    @capacity.times do
      @buckets.push(LinkedList.new)
    end
    # redistribute from backup to new buckets and empty backup
    redistribute_buckets
    @backup = []
  end

  def increase_capacity
    # create backup
    @backup = @buckets
    # increase capacity
    @capacity *= 2
    puts "\n@capacity now is: #{@capacity}"
    # recreate buckets with new capacity
    @buckets = []
    @capacity.times do
      @buckets.push(LinkedList.new)
    end
    # redistribute from backup to new buckets and empty backup
    redistribute_buckets
    @backup = []
  end

  def load
    load = 0
    @buckets.each { |bucket | load += bucket.size }
    load
  end

  def reload?
    puts "\nmax capacity: #{@capacity * @load_factor_max}"
    puts "current load: #{load}"
    puts "min capacity: #{@capacity * @load_factor_min}"
    increase_capacity if load >= (@capacity * @load_factor_max)
    decrease_capacity if load <= (@capacity * @load_factor_min) && @capacity > 31
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = (prime_number * hash_code) + char.ord }

    hash_code
  end

  def to_s
    index = 0
    @buckets.each do |bucket |
      puts "----------------------------------- Listing Bucket Number #{index} -----------------------------------"
      bucket.print if bucket
      index += 1
    end
  end

  def set_without_hashing(key, value)
    hash_key = key
    # divide the hash / @capacity (the amount of buckets) to get a number between 0 and @capacity.
    # ex if we have 16 buckets we get a number between 0 and 15 so we divide the registers between the 16 buckets.
    b_index = hash_key % @capacity
    # check if the key is already stored
    if @buckets[b_index].contains_key?(hash_key)
      begin
        # get index to overwrite
        overwrite_index = @buckets[b_index].find_key(hash_key)
        # overwrite
        @buckets[b_index].overwrite(hash_key, value, overwrite_index)
      rescue
        puts "ERROR, data not inserted"
      end
    else
      # add
      @buckets[b_index].append(hash_key, value)
    end
  end

  def set(key, value)
    hash_key = hash(key)
    # divide the hash / @capacity (the amount of buckets) to get a number between 0 and @capacity.
    # ex if we have 16 buckets we get a number between 0 and 15 so we divide the registers between the 16 buckets.
    b_index = hash_key % @capacity
    # check if the key is already stored
    if @buckets[b_index].contains_key?(hash_key)
      begin
        # get index to overwrite
        overwrite_index = @buckets[b_index].find_key(hash_key)
        # overwrite
        @buckets[b_index].overwrite(hash_key, value, overwrite_index)
      rescue
        puts "ERROR, data not inserted"
      end
    else
      # add
      @buckets[b_index].append(hash_key, value)
    end
    # check capacity
    reload?
  end

  def get(key)
    # takes one argument as a key and returns the value that is assigned to this key. If key is not found, return nil.
    hash_key = hash(key)
    b_index = hash_key % @capacity
    return unless @buckets[b_index].contains_key?(hash_key)

    index = @buckets[b_index].find_key(hash_key)
    @buckets[b_index].at(index).value
  end

  def has(key)
    # #has(key) takes a key as an argument and returns true or false based on whether or not the key is in the hash map.
    hash_key = hash(key)
    b_index = hash_key % @capacity
    @buckets[b_index].contains_key?(hash_key) ? true : false
  end

  def remove(key)
    # #remove(key) takes a key as an argument. If the given key is in the hash map, it should remove the entry with
    # that key and return the deleted entry’s value. If the key isn’t in the hash map, it should return nil.
    hash_key = hash(key)
    b_index = hash_key % @capacity
    # p @buckets[b_index].contains_key?(hash_key)
    return unless @buckets[b_index].contains_key?(hash_key)

    index = @buckets[b_index].find_key(hash_key)
    @buckets[b_index].remove_at(index)
  end

  def length
    # #length returns the number of stored keys in the hash map.
    total = 0
    @buckets.each { | bucket | total += bucket.size }
    total
  end

  def clear
    # #clear removes all entries in the hash map.
    initialize
  end

  def keys
    # #keys returns an array containing all the keys inside the hash map.
    keys = []
    @buckets.each do | bucket |
      index = 0
      while bucket.at(index)
        key = bucket.at(index).key unless bucket.at(index).key.nil?
        # puts "key: #{key} | value: #{value}" if key.to_s.length > 0
        keys.push(key) if key.to_s.length.positive?
        index += 1
      end
    end
    keys
  end

  def values
    # #values returns an array containing all the values.
    values = []
    @buckets.each do | bucket |
      index = 0
      while bucket.at(index)
        value = bucket.at(index).value unless bucket.at(index).value.nil?
        # puts "key: #{key} | value: #{value}" if key.to_s.length > 0
        values.push(value) if value.to_s.length.positive?
        index += 1
      end
    end
    values
  end

  def entries
    # #entries returns an array that contains each key, value pair.
    # Example: [[first_key, first_value], [second_key, second_value]]
    entries = []
    @buckets.each do | bucket |
      index = 0
      while bucket.at(index)
        key = nil
        key = bucket.at(index).key unless bucket.at(index).key.nil?
        value = bucket.at(index).value unless bucket.at(index).value.nil?
        if key.to_s.length.positive?
          entry = [nil, nil]
          entry[0] = key
          entry[1] = value
        end
        entries.push(entry) unless entry.nil?
        index += 1
      end
    end
    entries
  end
end

hmap = HashMap.new

hmap.set("Carlos", "000")
hmap.set("Carlos", "001") # this key is duplicated !
hmap.set("Carla", "002")
hmap.set("Carlitos", "003")
hmap.set("Carli", "004")
hmap.set("Aga", "005")
hmap.set("Ada", "006")
hmap.set("Ana", "007")
hmap.set("Aneta", "008")
hmap.set("Anete", "009")
hmap.set("Mike", "010")
hmap.set("Mikael", "011")
hmap.set("Mika", "012")
hmap.set("Miak", "013")

hmap.to_s

p hmap.length

puts "\n\n=========================================================================\n\n"

hmap.remove("Carli")
hmap.remove("Aga")
hmap.remove("Ada")
hmap.remove("Mike")
hmap.remove("Anete")

hmap.to_s

p hmap.length

# hmap.clear

hmap.to_s

# keys = hmap.keys
# keys.each { |element| p element }

# values = hmap.values
# values.each { |element| p element }

entries = hmap.entries
entries.each { |element| p element }
