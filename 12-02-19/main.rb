require 'set'
require_relative '../intcode.rb'

day = "02"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.strip }

def part1(input)
    intcode = Intcode.new(input[0])

    intcode.program[1] = 12
    intcode.program[2] = 2

    intcode.run

    return intcode.program[0]
end

def part2(input)
    for noun in 0..99
        for verb in 0..99
            intcode = Intcode.new(input[0])

            intcode.program[1] = noun
            intcode.program[2] = verb

            intcode.run

            if intcode.program[0] == 19690720
                return 100 * noun + verb
            end
        end
    end

    return -1
end

puts part1(data)
puts part2(data)