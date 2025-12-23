require 'set'

day = "16"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def part1(input)
    # naive implementation
    signals = input[0].split("").map { |i| i.to_i }
    iters = 0
    while iters < 100
        nextSignals = [0] * signals.length
        for i in 0...signals.length
            for j in 0...signals.length
                nextSignals[i] += signals[j] * Math.sin(((j + 1) / (i + 1)) * Math::PI / 2).to_i
            end
        end
        signals = nextSignals.map { |i| i.abs % 10}
        iters += 1
    end
    return signals.first(8).map { |i| i.to_s }.join
end

def factorial(n, memo)
    if n == 0
        return 1
    end
    if memo[n]
        return memo[n]
    end

    memo[n] = n * factorial(n - 1, memo)
    return memo[n]
end

def computeNDTriangularNumber(n, dim, memo, tMemo)
    if tMemo[[n, dim]]
        return tMemo[[n, dim]]
    end

    numerator = ((dim + 1)..(n + dim - 1)).inject(1) { |prod, i| prod * i }

    tMemo[[n, dim]] = numerator / factorial(n - 1, memo)
    return tMemo[[n, dim]]
end

def part2(input)
    signals = input[0].split("").map { |i| i.to_i } * 10000
    offset = signals.first(7).map { |i| i.to_s }.join.to_i
    allICareAbout = signals[offset..-1]
    memo = {}
    tmemo = {}
    answer = [0] * 8
    iters = 100
    for idx in 0...8
        for k in idx...allICareAbout.length
            answer[idx] += allICareAbout[k] * computeNDTriangularNumber(iters, k - idx, memo, tmemo)
            puts "#{k} / #{allICareAbout.length}" if k % 1000 == 0
        end
    end
    return answer.inject(0) { |sum, i| 10 * sum + (i % 10) }
end

# puts part1(data)
puts part2(data)