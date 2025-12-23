require 'set'
require_relative '../intcode.rb'

day = "05"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def part1(input)

    intcode = Intcode.new(input[0])

    intcode.inputs = [1]

    intcode.run

    if not intcode.outputs[0...-1].sum == 0
        raise "something went wrong"
    end
    return intcode.outputs[-1]
end

def part2(input)

    intcode = Intcode.new(input[0])

    intcode.inputs = [5]

    intcode.run

    return intcode.outputs[-1]
end

puts part1(data)
puts part2(data)