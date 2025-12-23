require 'set'

day = "04"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def getNextValid(num)
    num += 1
    digits = num.to_s.split("").map { |i| i.to_i }

    foundDouble = false
    foundDecrease = false
    for i in 1...digits.length
        if digits[i] < digits[i - 1]
            foundDecrease = true
        end
        if foundDecrease
            digits[i] = digits[i - 1]
        end
        if digits[i] == digits[i - 1]
            foundDouble = true
        end
    end

    if not foundDouble
        digits[-2] = digits[-1]
    end

    return digits.inject(0) { |sum, i| i + (sum * 10) }

end

def part1(input)
    range = input[0].split("-").map { |i| i.to_i }
    valid = 0
    num = getNextValid(range[0] - 1)
    while num <= range[1]
        valid += 1
        num = getNextValid(num)
        puts num
    end
    return valid
end

def isValid2(num)
    digits = num.to_s.split("").map { |i| i.to_i }

    groups = [1]
    foundDecrease = false
    for i in 1...digits.length
        if digits[i] < digits[i - 1]
            foundDecrease = true
        end
        if (digits[i] == digits[i - 1])
            groups[-1] += 1
        else
            groups.append(1)
        end
    end

    return ((not foundDecrease) and groups.include? 2)

end

def part2(input)
    range = input[0].split("-").map { |i| i.to_i }

    puts isValid2(112233)
    puts isValid2(123444)
    puts isValid2(111234)
    valid = 0
    for i in range[0]..range[1]
        if isValid2(i)
            valid += 1
        end
    end
    return valid
end

# puts part1(data)
puts part2(data) # 832 too high