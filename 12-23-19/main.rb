require 'set'
require_relative '../intcode.rb'

day = "23"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def part1(input)
    computers = []
    for i in 0...50
      computers[i] = Intcode.new(input[0])
      computers[i].inputs = [i]
    end

    idxs = [0] * 50
    inputs = {

    }

    while true
        # update inputs
        for c in 0...50
          if inputs[c]
            computers[c].inputs += inputs[c]
            inputs.delete(c)
          else
            computers[c].inputs += [-1]
          end
        end
        # run each
        for c in computers
          c.run
        end
        # read outputs
        for c in 0...50
          thisOut = computers[c].outputs[idxs[c]..-1]
          for t in 0...(thisOut.length / 3)
            if thisOut[t * 3] == 255
              return thisOut[t * 3 + 2]
            end
            if not inputs[thisOut[t * 3]]
              inputs[thisOut[t * 3]] = []
            end
            inputs[thisOut[t * 3]] += [thisOut[t * 3 + 1], thisOut[t * 3 + 2]]
          end
          idxs[c] = computers[c].outputs.length
        end
    end
    return -1
end

def part2(input)
    computers = []
    for i in 0...50
      computers[i] = Intcode.new(input[0])
      computers[i].inputs = [i]
    end

    nat = nil
    last0 = nil

    idxs = [0] * 50
    inputs = {}

    while true
        # update inputs
        for c in 0...50
          if inputs[c]
            computers[c].inputs += inputs[c]
            inputs.delete(c)
          else
            computers[c].inputs += [-1]
          end
        end
        # run each
        for c in computers
          c.run
        end
        # read outputs
        for c in 0...50
          thisOut = computers[c].outputs[idxs[c]..-1]
          for t in 0...(thisOut.length / 3)
            if thisOut[t * 3] == 255
              nat = [thisOut[t * 3 + 1], thisOut[t * 3 + 2]]
              next
            end
            if not inputs[thisOut[t * 3]]
              inputs[thisOut[t * 3]] = []
            end
            inputs[thisOut[t * 3]] += [thisOut[t * 3 + 1], thisOut[t * 3 + 2]]
          end
          idxs[c] = computers[c].outputs.length
        end

        # check if idle
        if inputs.keys.size == 0
          inputs[0] = nat
          if last0 and last0 == nat[1]
            return last0
          end
          last0 = nat[1]
        end
    end
end

puts part1(data)
puts part2(data)