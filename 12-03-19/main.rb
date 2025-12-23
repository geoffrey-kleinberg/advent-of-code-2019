require 'set'

day = "03"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def get_wire_locations(line)
    locations = Set[]
    moves = line.split(",")
    currentLocation = [0, 0]
    for m in moves
        direction = m.slice(0)
        amount = m.slice(1, m.length).to_i
        if direction == "U"
            for dY in 1..amount
                locations.add([currentLocation[0], currentLocation[1] + dY])
            end
            currentLocation = [currentLocation[0], currentLocation[1] + amount]
        elsif direction == "D"
            for dY in 1..amount
                locations.add([currentLocation[0], currentLocation[1] - dY])
            end
            currentLocation = [currentLocation[0], currentLocation[1] - amount]
        elsif direction == "L"
            for dX in 1..amount
                locations.add([currentLocation[0] - dX, currentLocation[1]])
            end
            currentLocation = [currentLocation[0] - dX, currentLocation[1]]
        elsif direction == "R"
            for dX in 1..amount
                locations.add([currentLocation[0] + dX, currentLocation[1]])
            end
            currentLocation = [currentLocation[0] + dX, currentLocation[1]]
        end
    end

    return locations
end

def part1(input)

    wire1 = get_wire_locations(input[0])

    wire2 = get_wire_locations(input[1])

    intersections = wire1 & wire2
    
    return intersections.min { |a, b| (a[0].abs + a[1].abs) <=> (b[0].abs + b[1].abs) }.map { |i| i.abs }.sum

end

def get_wire_locations_and_times(line)
    locations = Set[]
    times = {}
    moves = line.split(",")
    currentLocation = [0, 0]
    time = 0
    for m in moves
        direction = m.slice(0)
        amount = m.slice(1, m.length).to_i
        if direction == "U"
            for dY in 1..amount
                toAdd = [currentLocation[0], currentLocation[1] + dY]
                locations.add(toAdd)
                if not times[toAdd]
                    times[toAdd] = time + dY
                end
            end
            currentLocation = [currentLocation[0], currentLocation[1] + amount]
            time += amount
        elsif direction == "D"
            for dY in 1..amount
                toAdd = [currentLocation[0], currentLocation[1] - dY]
                locations.add(toAdd)
                if not times[toAdd]
                    times[toAdd] = time + dY
                end
            end
            currentLocation = [currentLocation[0], currentLocation[1] - amount]
            time += amount
        elsif direction == "L"
            for dX in 1..amount
                toAdd = [currentLocation[0] - dX, currentLocation[1]]
                locations.add(toAdd)
                if not times[toAdd]
                    times[toAdd] = time + dX
                end
            end
            currentLocation = [currentLocation[0] - dX, currentLocation[1]]
            time += amount
        elsif direction == "R"
            for dX in 1..amount
                toAdd = [currentLocation[0] + dX, currentLocation[1]]
                locations.add(toAdd)
                if not times[toAdd]
                    times[toAdd] = time + dX
                end
            end
            currentLocation = [currentLocation[0] + dX, currentLocation[1]]
            time += amount
        end
    end

    return locations, times
end

def part2(input)
    wire1, times1 = get_wire_locations_and_times(input[0])

    wire2, times2 = get_wire_locations_and_times(input[1])

    intersections = wire1 & wire2
    
    best = intersections.min { |a, b| (times1[a] + times2[a]) <=> (times1[b] + times2[b]) }
    return times1[best] + times2[best]
end

# puts part1(data)
puts part2(data)