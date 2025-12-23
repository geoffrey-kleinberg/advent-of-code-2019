require 'set'
require_relative '../intcode.rb'

day = "11"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def part1(input)
    intcode = Intcode.new(input[0])

    whitePanels = Set[]
    paintedOnce = Set[]

    location = [0, 0]
    facing = "u"

    while not intcode.halted

        if whitePanels.include? location
            intcode.inputs.append(1)
        else
            intcode.inputs.append(0)
        end

        intcode.run

        out = intcode.outputs.last(2)

        # paint
        if out[0] == 1
            whitePanels.add(location.clone)
        else
            whitePanels.delete(location.clone)
        end
        paintedOnce.add(location.clone)

        # turn
        if out[1] == 0
            # turn left
            if facing == "u"
                facing = "l"
            elsif facing == "l"
                facing = "d"
            elsif facing == "d"
                facing = "r"
            else
                facing = "u"
            end
        else
            # turn right
            if facing == "u"
                facing = "r"
            elsif facing == "r"
                facing = "d"
            elsif facing == "d"
                facing = "l"
            else
                facing = "u"
            end
        end

        # move
        if facing == "u"
            location[0] -= 1
        elsif facing == "l"
            location[1] -= 1
        elsif facing == "d"
            location[0] += 1
        else
            location[1] += 1
        end

    end
    return paintedOnce.size
end

def part2(input)
    intcode = Intcode.new(input[0])

    whitePanels = Set[[0, 0]]

    location = [0, 0]
    facing = "u"

    while not intcode.halted

        if whitePanels.include? location
            intcode.inputs.append(1)
        else
            intcode.inputs.append(0)
        end

        intcode.run

        out = intcode.outputs.last(2)

        # paint
        if out[0] == 1
            whitePanels.add(location.clone)
        else
            whitePanels.delete(location.clone)
        end

        # turn
        if out[1] == 0
            # turn left
            if facing == "u"
                facing = "l"
            elsif facing == "l"
                facing = "d"
            elsif facing == "d"
                facing = "r"
            else
                facing = "u"
            end
        else
            # turn right
            if facing == "u"
                facing = "r"
            elsif facing == "r"
                facing = "d"
            elsif facing == "d"
                facing = "l"
            else
                facing = "u"
            end
        end

        # move
        if facing == "u"
            location[0] += 1
        elsif facing == "l"
            location[1] -= 1
        elsif facing == "d"
            location[0] -= 1
        else
            location[1] += 1
        end

    end
    
    minI, maxI = whitePanels.minmax { |a, b| a[0] <=> b[0] }[0]
    minJ, maxJ = whitePanels.minmax { |a, b| a[1] <=> b[1] }[1]

    for i in minI..maxI
        for j in minJ..maxJ
            trueI = minI - i + maxI
            if whitePanels.include? [trueI, j]
                print "#"
            else
                print "."
            end
        end
        puts
    end
    return nil
end

puts part1(data)
puts part2(data)