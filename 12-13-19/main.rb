require 'set'
require_relative '../intcode.rb'

day = "13"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def part1(input)
    intcode = Intcode.new(input[0])

    scene = []

    intcode.run

    for i in 0...(intcode.outputs.length / 3)
        left = intcode.outputs[3 * i]
        down = intcode.outputs[3 * i + 1]
        id = intcode.outputs[3 * i + 2]

        if not scene[down]
            scene[down] = []
        end

        scene[down][left] = id
    end

    return scene.map { |i| i.count(2) }.sum
end

def updateScene(outs, scene)
    for i in 0...(outs.length / 3)
        left = outs[3 * i]
        if left == -1
            # puts "SCORE #{outs[3 * i + 2]}"
            next
        end
        down = outs[3 * i + 1]
        id = outs[3 * i + 2]

        if not scene[down]
            scene[down] = []
        end

        scene[down][left] = id
    end
    return scene
end

def findBallIntersectX(intcode, scene)

    intcode.inputs.append(0)

    intcode.run

    scene = updateScene(intcode.outputs, scene)

    ballY = scene.index { |i| i.include? 4 }

    while ballY < scene.length - 3 and not intcode.halted
        intcode.outputs = []

        intcode.inputs.append(0)

        intcode.run

        scene = updateScene(intcode.outputs, scene)

        ballY = scene.index { |i| i.include? 4 }

    end

    return scene[ballY].index(4)
end

def part2(input)
    intcode = Intcode.new(input[0])

    intcode.program[0] = 2

    intcode.run

    scene = updateScene(intcode.outputs, [])

    # velocity = [1, 1]

    iters = 0
    ballIntersectX = findBallIntersectX(intcode.clone, scene.map { |i| i.clone })
    findNext = false
    myX = scene[-2].index(3)
    if myX < ballIntersectX
        instruction = 1
    elsif myX > ballIntersectX
        instruction = -1
    else
        instruction = 0
    end
    ballY = scene.index { |i| i.include? 4 }
    myX = scene[-2].index(3)


    while not intcode.halted
        intcode.outputs = []

        intcode.inputs.append(instruction)
        intcode.run
        scene = updateScene(intcode.outputs, scene)
        findNext = (ballY == scene.length - 3)
        if findNext
            ballIntersectX = findBallIntersectX(intcode.clone, scene.map { |i| i.clone })
            findNext = false
        end
        ballY = scene.index { |i| i.include? 4 }
        myX = scene[-2].index(3)

        if myX < ballIntersectX
            instruction = 1
        elsif myX > ballIntersectX
            instruction = -1
        else
            instruction = 0
        end
        iters += 1
    end

    return intcode.outputs.last
end

puts part1(data)
puts part2(data)
