def string_to_number2(string)
  # with this version we will have different hash codes for the names "Sara" and "raSa"
  # Notice the usage of a prime number. We could have chosen any number we wanted, but prime numbers are preferable.
  # Multiplying by a prime number will reduce the likelihood of hash codes being evenly divisible by the bucket length,
  # which helps minimize the occurrence of collisions.
  hash_code = 0
  prime_number = 31

  string.each_char { |char| hash_code = prime_number * hash_code + char.ord }

  hash_code
end

def string_to_number(string)
  hash_code = 0
  string.each_char { |char| hash_code += char.ord }
  hash_code
end

def hash(name, surname)
  string_to_number(name) + string_to_number(surname)
end

p hash("John", "Smith")
p hash("Sandra", "Dee")

p string_to_number("Fred")
p string_to_number("Smith")
p string_to_number("John")
p string_to_number("Sandra")