def generate_moves(origin)
  adjacent = []
  # up
  adjacent << [origin[0] + 2, origin[1] - 1]
  adjacent << [origin[0] + 2, origin[1] + 1]
  # left
  adjacent << [origin[0] - 2, origin[1] - 1]
  adjacent << [origin[0] - 2, origin[1] + 1]
  # right
  adjacent << [origin[0] + 1, origin[1] - 2]
  adjacent << [origin[0] + 1, origin[1] + 2]
  # down
  adjacent << [origin[0] - 1, origin[1] - 2]
  adjacent << [origin[0] - 1, origin[1] + 2]

  filter_illegal_position(adjacent)
end

def filter_illegal_position(array)
  array.reject do |inner_array|
    inner_array.any? { |element| element.negative? || element > 7 }
  end
end

# 8 8 8 8 8 8 8 8
# 7 7 7 7 7 7 7 7
# 6 6 6 6 6 6 6 6
# 5 5 5 5 5 5 5 5
# 4 4 4 4 4 4 4 4
# 3 3 3 3 3 3 3 3
# 2 2 2 2 2 2 2 2
# 1 1 1 1 1 1 1 1
# a b c d e f g h

# 1 2 3 4 5 6 7 8
p generate_moves(0)
