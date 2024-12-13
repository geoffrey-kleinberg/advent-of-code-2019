require 'set'

day = "01"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.strip }

def part1(input)
    fuel = 0
    for i in input
      fuel += (i.to_i / 3) - 2
    end
    return fuel
end

def part2(input)
    fuel = 0
    for i in input
      mass = i.to_i
      while mass > 0
        nextM = (mass.to_i / 3) - 2
        if nextM > 0
          fuel += nextM
        end
        mass = nextM
      end
    end
    return fuel
end

puts part1(data)
puts part2(data)