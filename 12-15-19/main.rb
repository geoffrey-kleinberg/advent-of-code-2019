require 'set'
require_relative '../intcode.rb'

day = "15"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def printCurrentState(allLocs, walls, emptySpaces, start, oxygenSystemLocation, location)
    minI, maxI = allLocs.minmax { |a, b| a[0] <=> b[0] }.map { |i| i[0] }
    minJ, maxJ = allLocs.minmax { |a, b| a[1] <=> b[1] }.map { |i| i[1] }

    puts "STARTING MAP"
    for i in minI..maxI
        for j in minJ..maxJ
            if start == [i, j]
                print "S"
            elsif oxygenSystemLocation == [i, j]
                print "O"
            elsif location == [i, j]
                print "D"
            elsif emptySpaces.include? [i, j]
                print "."
            elsif walls.include? [i, j]
                print "#"
            else
                print " "
            end
        end
        puts
    end
    puts "ENDING MAP"
end

def getDirections(location, goTo, walls, emptySpaces)

    queue = [location]
    seen = Set[location]
    instructions = {
        location => []
    }

    while queue.length > 0
        location = queue.delete_at(0)

        if location == goTo
            return instructions[location]
        end

        directions = [[-1, 0], [1, 0], [0, 1], [0, -1]]

        for d in directions
            nextLoc = [location[0] + d[0], location[1] + d[1]]
            if emptySpaces.include? nextLoc and not seen.include? nextLoc
                queue.append(nextLoc)
                seen.add(nextLoc)
                instructions[nextLoc] = instructions[location] + [directions.index(d) + 1]
            end
        end
    end
end

def part1(input)

    intcode = Intcode.new(input[0])

    emptySpaces = Set[[0, 0]]
    walls = Set[]
    allLocs = Set[[0, 0]]
    start = [0, 0]
    run = true
    oxygenSystemLocation = nil

    location = [0, 0]
    directions = [[-1, 0], [1, 0], [0, 1], [0, -1]]

    nextInps = [1, 2, 3, 4]

    tracked = Set[[0, 0]]

    tracking = [0, 0]

    queue = []

    iter = 0

    while run

        inp = nextInps.delete_at(0)
        dir = directions[inp - 1]
        nextLoc = [location[0] + dir[0], location[1] + dir[1]]

        intcode.inputs.append(inp)

        intcode.run

        if intcode.outputs.last == 0
            walls.add(nextLoc)
            allLocs.add(nextLoc)
        elsif intcode.outputs.last != 0
            location = nextLoc.clone
            allLocs.add(location)
            if intcode.outputs.last == 2
                oxygenSystemLocation = location
            end
            emptySpaces.add(location)

            if not tracked.include? location
                queue.unshift(location)
            end

            # do we go back
            potentialBack = nil
            if inp < 3
                potentialBack = 3 - inp
            else
                potentialBack = 7 - inp
            end
            if (not location == tracking) and nextInps.length <= 4
                nextInps.unshift(potentialBack)
            end
        end


        # puts iter
        # printCurrentState(allLocs, walls, emptySpaces, start, oxygenSystemLocation, location)
        # iter += 1

        if nextInps.length == 0

            tracking = queue.delete_at(0)
            
            nextInps = getDirections(location, tracking, walls, emptySpaces)
            break if not tracking
            tracked.add(tracking)
            possible = [1, 2, 3, 4]

            nextInps += possible

        end

    end

    return getDirections([0, 0], oxygenSystemLocation, walls, emptySpaces).length
end


def printO2Time(allLocs, walls, minutes, emptySpaces)
    minI, maxI = allLocs.minmax { |a, b| a[0] <=> b[0] }.map { |i| i[0] }
    minJ, maxJ = allLocs.minmax { |a, b| a[1] <=> b[1] }.map { |i| i[1] }

    puts "STARTING MAP"
    for i in minI..maxI
        for j in minJ..maxJ
            if minutes.keys.include? [i, j]
                print (minutes[[i, j]] % 10)
            elsif emptySpaces.include? [i, j]
                print "."
            elsif walls.include? [i, j]
                print "#"
            else
                print " "
            end
        end
        puts
    end
    puts "ENDING MAP"
end

def part2(input)
    intcode = Intcode.new(input[0])

    emptySpaces = Set[[0, 0]]
    walls = Set[]
    allLocs = Set[[0, 0]]
    start = [0, 0]
    run = true
    oxygenSystemLocation = nil

    location = [0, 0]
    directions = [[-1, 0], [1, 0], [0, 1], [0, -1]]

    nextInps = [1, 2, 3, 4]

    tracked = Set[[0, 0]]

    tracking = [0, 0]

    queue = []

    iter = 0

    while run

        inp = nextInps.delete_at(0)
        dir = directions[inp - 1]
        nextLoc = [location[0] + dir[0], location[1] + dir[1]]

        intcode.inputs.append(inp)

        intcode.run

        if intcode.outputs.last == 0
            walls.add(nextLoc)
            allLocs.add(nextLoc)
        elsif intcode.outputs.last != 0
            location = nextLoc.clone
            allLocs.add(location)
            if intcode.outputs.last == 2
                oxygenSystemLocation = location
            end
            emptySpaces.add(location)

            if not tracked.include? location
                queue.unshift(location)
            end

            # do we go back
            potentialBack = nil
            if inp < 3
                potentialBack = 3 - inp
            else
                potentialBack = 7 - inp
            end
            if (not location == tracking) and nextInps.length <= 4
                nextInps.unshift(potentialBack)
            end
        end

        if nextInps.length == 0

            tracking = queue.delete_at(0)
            
            nextInps = getDirections(location, tracking, walls, emptySpaces)
            break if not tracking
            tracked.add(tracking)
            possible = [1, 2, 3, 4]

            nextInps += possible

        end

    end

    oxygenated = Set[oxygenSystemLocation]
    queue = [oxygenSystemLocation]
    minutes = {
        oxygenSystemLocation => 0
    }

    while oxygenated.size < emptySpaces.size
        current = queue.delete_at(0)

        directions = [[-1, 0], [1, 0], [0, 1], [0, -1]]

        for d in directions
            nextLoc = [current[0] + d[0], current[1] + d[1]]
            if emptySpaces.include? nextLoc and not oxygenated.include? nextLoc
                queue.append(nextLoc)
                oxygenated.add(nextLoc)
                minutes[nextLoc] = minutes[current] + 1
            end
        end
    end

    return minutes.values.max
end

puts part1(data)
puts part2(data)