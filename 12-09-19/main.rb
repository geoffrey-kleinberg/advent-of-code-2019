require 'set'
require_relative '../intcode.rb'

day = "09"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def part1(input)
    intcode = Intcode.new(input[0])

    intcode.inputs = [1]
    intcode.run

    return intcode.outputs
end

def part2(input)
    intcode = Intcode.new(input[0])

    intcode.inputs = [2]
    intcode.run

    return intcode.outputs
end

puts part1(data)
puts part2(data)