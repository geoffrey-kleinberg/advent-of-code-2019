require 'set'

day = "12"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def readLine(line)
    positions = line.split(", ").map { |i| i.split("=")[1] }
    positions[-1] = positions.last.chop
    return positions.map { |i| i.to_i }
end

def part1(input)
    positions = input.map { |i| readLine(i) }
    velocities = [
        [0,0,0],
        [0,0,0],
        [0,0,0],
        [0,0,0]
    ]
    for iter in 0...1000
        for m1 in 0...positions.length
            for m2 in (m1 + 1)...positions.length
                for dim in 0...3
                    if positions[m1][dim] > positions[m2][dim]
                        velocities[m1][dim] -= 1
                        velocities[m2][dim] += 1
                    elsif positions[m2][dim] > positions[m1][dim]
                        velocities[m1][dim] += 1
                        velocities[m2][dim] -= 1
                    end
                end
            end
        end

        for m in 0...positions.length
            for dim in 0...3
                positions[m][dim] += velocities[m][dim]
            end
        end
    end

    return (0...positions.length).map { |i| positions[i].map { |i| i.abs}.sum * velocities[i].map { |i| i.abs}.sum }.sum
end

def gcd(a, b)
    if a == 0
        return b
    end
    if b == 0
        return a
    end
    if a > b
        return gcd(a % b, b)
    else
        return gcd(a, b % a)
    end
end

def part2(input)
    positions = input.map { |i| readLine(i) }
    velocities = [
        [0,0,0],
        [0,0,0],
        [0,0,0],
        [0,0,0]
    ]

    repeats = []
    starts = []
    for dim in 0...3
        seen = Set[]
        times = {}
        iters = 0
        searching = true

        while searching
            currentState = positions.map { |i| i[dim] } + velocities.map { |i| i[dim] }
            if not seen.add? currentState
                starts.append(times[currentState])
                repeats.append(iters - times[currentState])
                searching = false
                break
            end
            times[currentState] = iters

            for m1 in 0...positions.length
                for m2 in (m1 + 1)...positions.length
                    if positions[m1][dim] > positions[m2][dim]
                        velocities[m1][dim] -= 1
                        velocities[m2][dim] += 1
                    elsif positions[m2][dim] > positions[m1][dim]
                        velocities[m1][dim] += 1
                        velocities[m2][dim] -= 1
                    end
                end
            end
            for m in 0...positions.length
                positions[m][dim] += velocities[m][dim]
            end

            iters += 1
        end
    end

    rep1 = repeats[0] * repeats[1] / gcd(repeats[0], repeats[1])
    return rep1 * repeats[2] / gcd(rep1, repeats[2])
end

# puts part1(data)
puts part2(data)