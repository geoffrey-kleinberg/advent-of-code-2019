require 'set'

day = "06"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def part1(input)
    connections = input.map { |i| i.split(")") }
    orbits = {}
    for con in connections
        if not orbits[con[0]]
            orbits[con[0]] = []
        end
        orbits[con[0]].append(con[1])
    end

    dists = {}

    queue = ["COM"]
    dists["COM"] = 0
    while queue.length > 0
        current = queue[0]
        queue.delete_at(0)
        next if not orbits[current]
        for c in orbits[current]
            queue.append(c)
            dists[c] = dists[current] + 1
        end
    end
    return dists.values.sum
end

def part2(input)

    connections = input.map { |i| i.split(")") }
    orbits = {}
    for con in connections
        if not orbits[con[0]]
            orbits[con[0]] = []
        end
        orbits[con[0]].append(con[1])
        if not orbits[con[1]]
            orbits[con[1]] = []
        end
        orbits[con[1]].append(con[0])
    end

    dists = {}

    queue = ["YOU"]
    visited = Set["YOU"]
    dists["YOU"] = 0
    while queue.length > 0
        current = queue[0]
        queue.delete_at(0)
        for c in orbits[current]
            next if not visited.add? c
            if c == "SAN"
                return dists[current] - 1
            end
            queue.append(c)
            dists[c] = dists[current] + 1
        end
    end
end

# puts part1(data)
puts part2(data)