require 'set'

day = "10"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

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

def howManyCanSee(centerI, centerJ, input)
    total = 0
    for i in 0...input.length
        for j in 0...input[i].length
            if input[i][j] == "#"
                di = i - centerI
                dj = j - centerJ
                next if di == 0 and dj == 0
                steps = gcd(di.abs, dj.abs)
                vec = [di / steps, dj / steps]
                canSee = true
                for s in 1...steps
                    if input[centerI + vec[0] * s][centerJ + vec[1] * s] == "#"
                        canSee = false
                    end
                end
                total += 1 if canSee
            end
        end
    end
    return total
end

def part1(input)
    input = input.map { |i| i.split("") }
    best = -1
    for i in 0...input.length
        for j in 0...input[i].length
            if input[i][j] == "#"
                canSee = howManyCanSee(i, j, input)
                best = [best, canSee].max
            end
        end
    end
    return best
end

def part2(input)
    input = input.map { |i| i.split("") }
    best = -1
    bestLoc = nil
    for i in 0...input.length
        for j in 0...input[i].length
            if input[i][j] == "#"
                canSee = howManyCanSee(i, j, input)
                if canSee > best
                    best = canSee
                    bestLoc = [i, j]
                end
            end
        end
    end

    polars = []
    bestI = bestLoc[0]
    bestJ = bestLoc[1]
    for i in 0...input.length
        for j in 0...input[i].length
            next if i == bestI and j == bestJ
            if input[i][j] == "#"
                di = bestI - i
                dj = j - bestJ
                rsquared = di * di + dj * dj
                if dj == 0
                    if di > 0
                        theta = Math::PI / 2
                    else
                        theta = - Math::PI / 2
                    end
                else
                    theta = Math.atan(di.to_f / dj)
                end
                if dj < 0
                    theta += Math::PI
                end
                theta = theta % (2 * Math::PI)
                polars.append([rsquared, theta])
            end
        end
    end

    vaporized = 0
    lastVaporized = nil
    lastTheta = Math::PI / 2 + (10 ** -7)
    while vaporized < 200
        bestTheta = polars.select { |i| i[1] < lastTheta }.max { |a, b| a[1] <=> b[1] }
        if not bestTheta
            bestTheta = polars.max { |a, b| a[1] <=> b[1] }
        end
        bestTheta = bestTheta[1]
        closestR = polars.select { |i| i[1] == bestTheta }.min { |a, b| a[0] <=> b[0] }[0]

        polars.delete([closestR, bestTheta])
        lastTheta = bestTheta
        lastVaporized = [closestR, bestTheta]
        xy = [bestI - Math.sqrt(closestR) * Math.sin(bestTheta), Math.sqrt(closestR) * Math.cos(bestTheta) + bestJ]
        vaporized += 1
    end
    rsquared = lastVaporized[0]
    theta = lastVaporized[1]
    xy = [bestI - Math.sqrt(rsquared) * Math.sin(theta), Math.sqrt(rsquared) * Math.cos(theta) + bestJ]
    return (xy[1] * 100 + xy[0]).to_i
end

# puts part1(data)
puts part2(data)