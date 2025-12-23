require 'set'
require_relative '../intcode.rb'

day = "17"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def part1(input)
    intcode = Intcode.new(input[0])
    intcode.run

    lines = intcode.outputs.map { |c| c.chr }.join.split("\n").map { |i| i.split("") }

    total = 0
    for y in 1...(lines.length - 1)
        for x in 1...(lines[y].length - 1)
            next if not lines[y][x] == "#"
            neighbors = [[y + 1, x], [y - 1, x], [y, x + 1], [y, x - 1]]
            intersection = true
            for n in neighbors
                if not lines[n[0]][n[1]] == "#"
                    intersection = false
                end
            end
            if intersection
                total += y * x
            end
        end
    end
    

    return total
end

def part2(input)
    intcode = Intcode.new(input[0])

    # these came to me in a dream
    main = "B,A,B,C,A,C,A,C,B,A\n"
    a = "R,8,L,6,L,4,L,10,R,8\n"
    b = "L,6,L,4,R,8\n"
    c = "L,4,R,4,L,4,R,8\n"
    feed = "n\n"

    intcode.inputs = (main + a + b + c + feed).split("").map { |i| i.ord }

    intcode.program[0] = 2
    intcode.run

    return intcode.outputs.last
end

# puts part1(data)
puts part2(data)