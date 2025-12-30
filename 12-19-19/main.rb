require 'set'
require_relative '../intcode.rb'

day = "19"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def part1(input)
    intcode = Intcode.new(input[0])

    total = 0

    for x in 0...50
      for y in 0...50
        intcode = Intcode.new(input[0])
        intcode.inputs = [x, y]
        intcode.run
        total += intcode.outputs.last
      end
    end
    return total
end

def getBoundary(input, a, b)
  if (a - b).abs <= Float::EPSILON
    return a
  end

  intcode = Intcode.new(input)
  intcode.inputs = [1, a]
  intcode.run
  valAtA = intcode.outputs.last

  # intcode = Intcode.new(input)
  # intcode.inputs = [b, 1]
  # intcode.run
  # valAtB = intcode.outputs.last

  intcode = Intcode.new(input)
  intcode.inputs = [1, (a + b) / 2.0]
  intcode.run
  valBetween = intcode.outputs.last

  if valBetween == valAtA
    return getBoundary(input, (a + b) / 2.0, b)
  else
    return getBoundary(input, a, (a + b) / 2.0)
  end
end

def part2(input)

    lowerBound = getBoundary(input[0], 1.3, 1.4)
    upperBound = getBoundary(input[0], 1.5, 1.6)
    upperBound = upperBound.floor(13)
    lowerBound = lowerBound.ceil(13)

    # these are pretty good bounds
    # for i in 1...8582
    #   intcode = Intcode.new(input[0])
    #   intcode.inputs = [i, (lowerBound - 10 ** -13) * i]
    #   intcode.run
    #   a = intcode.outputs.last
    #   if a == 1
    #     puts i
    #     raise "nah"
    #   end

    #   intcode = Intcode.new(input[0])
    #   intcode.inputs = [i, lowerBound * i]
    #   intcode.run
    #   a = intcode.outputs.last
    #   if a == 0
    #     puts i
    #     raise "nah"
    #   end

    #   intcode = Intcode.new(input[0])
    #   intcode.inputs = [i, (upperBound + 10 ** -13) * i]
    #   intcode.run
    #   a = intcode.outputs.last
    #   if a == 1
    #     puts i
    #     raise "nah"
    #   end

    #   intcode = Intcode.new(input[0])
    #   intcode.inputs = [i, upperBound * i]
    #   intcode.run
    #   a = intcode.outputs.last
    #   if a == 0
    #     puts i
    #     raise "nah"
    #   end
    # end
    
    # (x, y) is good iff lowerBound <= y / x <= upperBound
    # we want the point x, y with minimum (x + y) such that (x + 99, y) is good and (x, y + 99) is good
    # off by one errors are my favorite
    total = 0
    while true
      for x in 0...total
        y = (total - x).to_f
        if ((y / (x + 99)) <= upperBound) and (lowerBound <= (y / (x + 99))) and (lowerBound <= ((y + 99) / x)) and (((y + 99) / x) <= upperBound)
          return 10000 * x + y.to_i
        end
      end
      total += 1
    end
    
    return 0
end

# puts part1(data)
puts part2(data)