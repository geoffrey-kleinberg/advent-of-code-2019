require 'set'

day = "24"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def getBiodiversityRating(grid)
  r = 0
  for sq in 0...(grid.length * grid[0].length)
    i = sq / grid[0].length
    j = sq % grid[0].length
    if grid[i][j] == "#"
      r += 2 ** sq
    end
  end
  return r
end

def countBugsAdjacent(grid, i, j)
  count = 0
  dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  for d in dirs
    check = [i + d[0], j + d[1]]
    if check[0] < 0 or check[0] >= grid.length or check[1] < 0 or check[1] >= grid[i].length
      next
    end
    if grid[check[0]][check[1]] == "#"
      count += 1
    end
  end
  return count
end

def getNextState(grid)
  nextGrid = grid.map { |i| i.clone }

  for i in 0...grid.length
    for j in 0...grid[i].length
      neighbors = countBugsAdjacent(grid, i, j)
      if grid[i][j] == "#" and neighbors != 1
        nextGrid[i][j] = "."
      elsif grid[i][j] == "." and [1, 2].include? neighbors
        nextGrid[i][j] = "#"
      else
        nextGrid[i][j] = grid[i][j]
      end
    end
  end

  return nextGrid


end

def part1(input)

    seenStates = Set[]
    grid = input.map { |i| i.split("") }

    while true
      if not seenStates.add? getBiodiversityRating(grid)
        return getBiodiversityRating(grid)
      end
      grid = getNextState(grid)
    end


    return -1
end

def printNicely(allLevels)
    allLevels.each do |i|
      puts "LEVEL"
      i.each do |i| puts i.join end
      puts
    end
end

def countBugsAdjacentRecursize(allLevels, level, row, col)
  if row == 2 and col == 2
    return 0
  end
  count = 0
  dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  for d in dirs
      check = [row + d[0], col + d[1]]
      if level != 0
          if check[0] == -1
              if allLevels[level - 1][1][2] == "#"
              count += 1
              end
              next
          end
          if check[0] == allLevels[level].length
              if allLevels[level - 1][3][2] == "#"
                  count += 1
              end
              next
          end
          if check[1] == -1
              if allLevels[level - 1][2][1] == "#"
                  count += 1
              end
              next
          end
          if check[1] == allLevels[level][check[0]].length
              if allLevels[level - 1][2][3] == "#"
                  count += 1
              end
              next
          end
      end
      if level != allLevels.length - 1
          if check[0] == 2 and row == 1 and check[1] == 2
              for c in 0...allLevels[level + 1][0].length
                  if allLevels[level + 1][0][c] == "#"
                      count += 1
                  end
              end
              next
          end
          if check[0] == 2 and row == 3 and check[1] == 2
              for c in 0...allLevels[level + 1][-1].length
                  if allLevels[level + 1][-1][c] == "#"
                      count += 1
                  end
              end
              next
          end
          if check[1] == 2 and col == 1 and check[0] == 2
              for r in 0...allLevels[level + 1].length
                  if allLevels[level + 1][r][0] == "#"
                      count += 1
                  end
              end
              next
          end
          if check[1] == 2 and col == 3 and check[0] == 2
              for r in 0...allLevels[level + 1].length
                  if allLevels[level + 1][r][-1] == "#"
                      count += 1
                  end
              end
              next
          end
      end
      if check[0] >= 0 and check[0] < allLevels[level].length and check[1] >= 0 and check[1] < allLevels[level][check[0]].length
        if allLevels[level][check[0]][check[1]] == "#"
            count += 1
        end
    end
  end
  return count
end

def part2(input)

    minutes = 200

    allLevels = []
    for idx in 0...(minutes * 2 + 1)
      if idx == minutes
        allLevels[idx] = input.map { |i| i.split("") }
      else
        allLevels[idx] = []
        for l in 0...5
            allLevels[idx][l] = ["."] * 5
        end
      end
    end

    for m in 0...minutes
      nextGrid = []
      for level in 0...allLevels.length
        nextGrid[level] = []
        for row in 0...allLevels[level].length
          nextGrid[level][row] = []
          for col in 0...allLevels[level][row].length
            neighbors = countBugsAdjacentRecursize(allLevels, level, row, col)
            if allLevels[level][row][col] == "#" and neighbors != 1
                nextGrid[level][row][col] = "."
            elsif allLevels[level][row][col] == "." and [1, 2].include? neighbors
                if level == 2 and row == 0 and col == 0
                  puts "here I am"
                end
                nextGrid[level][row][col] = "#"
            else
                nextGrid[level][row][col] = allLevels[level][row][col]
            end
          end
        end
      end
      allLevels = nextGrid
    end

    return allLevels.flatten.count("#")
end

# puts part1(data)
puts part2(data)