require 'set'
require_relative '../intcode.rb'

day = "21"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def part1(input)

    intcode = Intcode.new(input[0])

    intcode.run

    springscript = [
        "NOT A J",
        "NOT C T",
        "AND T J",
        "NOT A T",
        "OR T J",
        "NOT C T",
        "AND D T",
        "OR T J",
        "WALK\n"
    ]

    intcode.inputs = springscript.join("\n").split("").map { |i| i.ord }

    intcode.run

    begin
        intcode.outputs.each { |i| print i.chr }
    rescue
        return intcode.outputs.last
    else
        return -1
    end

end

def part2(input)
    intcode = Intcode.new(input[0])

    intcode.run

    springscript = [
        "NOT A J",
        "NOT C T",
        "AND D T",
        "AND H T",
        "OR T J",
        "NOT B T",
        "AND D T",
        "AND H T",
        "OR T J",
        "RUN"
    ]

    intcode.inputs = springscript.join("\n").split("").map { |i| i.ord } + [10]

    intcode.run

    begin 
        intcode.outputs.each { |i| print i.chr }
    rescue
        return intcode.outputs.last
    else
        return -1
    end
end

# puts part1(data)
puts part2(data)