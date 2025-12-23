require 'set'

day = "08"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def part1(input)
    nums = input[0].split("").map { |i| i.to_i }
    width = 25
    height = 6
    depth = nums.length / (width * height)
    image = []
    for i in 0...nums.length
        x = i % width
        y = (i / width) % height
        z = (i / (width * height))

        if not image[z]
            image[z] = []
        end
        if not image[z][y]
            image[z][y] = []
        end
        image[z][y][x] = nums[i]
    end
    layer = image.min { |a, b| a.map { |j| j.count(0) }.sum <=> b.map { |j| j.count(0) }.sum }
    ones = layer.map { |j| j.count(1) }.sum
    twos = layer.map { |j| j.count(2) }.sum
    return ones * twos
end

def part2(input)
    nums = input[0].split("").map { |i| i.to_i }

    width = 25
    height = 6
    depth = nums.length / (width * height)
    image = []
    for i in 0...nums.length
        x = i % width
        y = (i / width) % height
        z = (i / (width * height))

        if not image[y]
            image[y] = []
        end
        if not image[y][x]
            image[y][x] = []
        end
        image[y][x][z] = nums[i]
    end
    firstPixels = image.map { |i| i.map { |j| j.index { |k| k != 2 } } }
    
    visible = []
    for idx in 0...6
        visible[idx] = []
        for jdx in 0...25
            visible[idx][jdx] = image[idx][jdx][firstPixels[idx][jdx]]
        end
    end
    visible.each do |i|
        print i.map { |i| (i == 1) ? "#" : "." }.join
        puts
    end
    return -1
end

# puts part1(data)
puts part2(data)