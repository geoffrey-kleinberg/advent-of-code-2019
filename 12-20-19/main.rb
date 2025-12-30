require 'set'

day = "20"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def part1(input)

    # the hard part here is gonna be input parsing
    
    openSquares = Set[]
    squareToPortalMap = {}
    portalToSquareMap = {}

    capital = /^[A-Z]$/

    for i in 0...input.length
      for j in 0...input[i].length
        thisSquare = input[i][j]
        if capital.match(thisSquare)
          square = nil
          portalName = nil
          
          above = nil
          below = nil
          right = nil
          left = nil
          if i != 0
            above = input[i - 1][j]
          end
          if i != input.length - 1
            below = input[i + 1][j]
          end
          if j != 0
            left = input[i][j - 1]
          end
          if j != input[i].length - 1
            right = input[i][j + 1]
          end

          if capital.match(above) and below == "."
            portalName = above + thisSquare
            square = [i + 1, j]
          end
          if capital.match(below) and above == "."
            portalName = thisSquare + below
            square = [i - 1, j]
          end
          if capital.match(left) and right == "."
            portalName = left + thisSquare
            square = [i, j + 1]
          end
          if capital.match(right) and left == "."
            portalName = thisSquare + right
            square = [i, j - 1]
          end

          next if not square

          squareToPortalMap[square] = portalName
          if not portalToSquareMap[portalName]
            portalToSquareMap[portalName] = []
          end
          portalToSquareMap[portalName].append(square)

        elsif thisSquare == "."
          openSquares.add([i, j])
        elsif thisSquare == "#" or thisSquare == " "
        end
      end
    end
    
    startLoc = portalToSquareMap["AA"][0]
    goal = portalToSquareMap["ZZ"][0]

    queue = [startLoc]
    visited = Set[startLoc]
    dists = {
        startLoc => 0
    }

    while queue.length > 0
      current = queue.delete_at(0)

      if current == goal
        return dists[goal]
      end

      possibleNext = []

      directions = [[1, 0], [0, 1], [-1, 0], [0, -1]]
      for d in directions
        candidiate = [current[0] + d[0], current[1] + d[1]]

        if openSquares.include? candidiate
          possibleNext.append(candidiate)
        end
      end

      portalAt = squareToPortalMap[current]

      if portalAt and portalAt != "AA"
        locs = portalToSquareMap[portalAt]
        possibleNext.append(locs.select { |i| i != current }[0])
      end

      for p in possibleNext
        next if not visited.add? p
        dists[p] = dists[current] + 1
        queue.append(p)
      end

    end

    return -1
end

def part2(input)
    openSquares = Set[]
    squareToInnerPortalMap = {}
    squareToOuterPortalMap = {}
    portalToInnerSquareMap = {}
    portalToOuterSquareMap = {}

    capital = /^[A-Z]$/

    for i in 0...input.length
      for j in 0...input[i].length
        thisSquare = input[i][j]
        if capital.match(thisSquare)
          square = nil
          portalName = nil
          
          above = nil
          below = nil
          right = nil
          left = nil
          if i != 0
            above = input[i - 1][j]
          end
          if i != input.length - 1
            below = input[i + 1][j]
          end
          if j != 0
            left = input[i][j - 1]
          end
          if j != input[i].length - 1
            right = input[i][j + 1]
          end

          if capital.match(above) and below == "."
            portalName = above + thisSquare
            square = [i + 1, j]
          end
          if capital.match(below) and above == "."
            portalName = thisSquare + below
            square = [i - 1, j]
          end
          if capital.match(left) and right == "."
            portalName = left + thisSquare
            square = [i, j + 1]
          end
          if capital.match(right) and left == "."
            portalName = thisSquare + right
            square = [i, j - 1]
          end

          next if not square

          if i < 2 or i > input.length - 3 or j < 2 or j > input[i].length - 3
            squareToOuterPortalMap[square] = portalName
            portalToOuterSquareMap[portalName] = square
          else
            squareToInnerPortalMap[square] = portalName
            portalToInnerSquareMap[portalName] = square
          end

        elsif thisSquare == "."
          openSquares.add([i, j])
        elsif thisSquare == "#" or thisSquare == " "
        end
      end
    end

    
    startLoc = [portalToOuterSquareMap["AA"], 0]
    goal = [portalToOuterSquareMap["ZZ"], 0]

    queue = [startLoc]
    visited = Set[startLoc]
    dists = {
        startLoc => 0
    }

    while queue.length > 0
      currentState = queue.delete_at(0)
      current = currentState[0]
      level = currentState[1]

      if currentState == goal
        return dists[goal]
      end

      possibleNext = []

      directions = [[1, 0], [0, 1], [-1, 0], [0, -1]]
      for d in directions
        candidiate = [current[0] + d[0], current[1] + d[1]]

        if openSquares.include? candidiate
          possibleNext.append([candidiate, level])
        end
      end

      portalIn = squareToInnerPortalMap[current]
      portalOut = squareToOuterPortalMap[current]

      if portalIn
        possibleNext.append([portalToOuterSquareMap[portalIn], level + 1])
      end
      if portalOut and level != 0 and portalOut != "AA" and portalOut != "ZZ"
        possibleNext.append([portalToInnerSquareMap[portalOut], level - 1])
      end

      for p in possibleNext
        next if not visited.add? p
        dists[p] = dists[currentState] + 1
        queue.append(p)
      end

    end

    return -1
end

# puts part1(data)
puts part2(data)