require 'set'
require_relative '../intcode.rb'

day = "25"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def part1(input)
    intcode = Intcode.new(input[0])

    outIdx = 0

    # instruction set found via playing the game
    instructions = [
        'south',
        'east',
        'take mutex',
        'east',
        'take astronaut ice cream',
        'south',
        'take tambourine',
        'north',
        'west',
        'south',
        'south',
        'west',
        'south',
        'take easter egg',
        'west',
        'west'
    ]

    intcode.inputs = instructions.join("\n").split("").map { |i| i.ord } + [10]

    while true
      intcode.run
      puts intcode.outputs[outIdx..-1].map { |i| i.chr }.join
      break if intcode.halted
      outIdx = intcode.outputs.length

      myInp = gets

      intcode.inputs += myInp.split("").map { |i| i.ord }
    end

    return ""
end

def part2(input)
    return "free star!"
end

puts part1(data)
puts part2(data)