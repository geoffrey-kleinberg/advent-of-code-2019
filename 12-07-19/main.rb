require 'set'
require_relative '../intcode.rb'

day = "07"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def part1(input)

    best = -1

    for perm in (0...5).to_a.permutation(5)
        lastOut = 0
        for programNum in 0...5

            amplifier = Intcode.new(input[0])
            amplifier.inputs = [perm[programNum], lastOut]

            amplifier.run
            
            lastOut = amplifier.outputs[-1]

        end

        best = [best, lastOut].max
    end
    return best
end

def part2(input)

    best = -1

    for perm in (5...10).to_a.permutation(5)
        amplifiers = []
        for programNum in 0...5

            amplifiers[programNum] = Intcode.new(input[0])
            amplifiers[programNum].inputs = [perm[programNum]]
        end

        lastOut = 0
        running = true
        while running
            for programNum in 0...5
                amplifiers[programNum].inputs.append(lastOut)

                amplifiers[programNum].run

                lastOut = amplifiers[programNum].outputs.last
            end
            if amplifiers[4].halted
                running = false
            end
        end
        best = [best, lastOut].max
    end

    return best
end

puts part1(data)
puts part2(data)