require 'set'

day = "18"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def getPossibleNext(i, j, cavern, keysCollected)
    steps = [[0, 1], [0, -1], [1, 0], [-1, 0]]
    possible = []

    for s in steps
      potential = [i + s[0], j + s[1]]
      wouldBe = cavern[potential[0]][potential[1]]
      if wouldBe == "." or wouldBe.match?(/^[a-z]+$/) or keysCollected.include? wouldBe.downcase
        possible.append(potential)
      end
    end

    return possible
end

def manhattan(a, b)
    return (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

def aStar(start, target, cavern, keysCollected)
    dist = manhattan(start, target)

    dists = {
        start => 0
    }
    alongTheWay = {
        start => ""
    }
    finalized = Set[]
    queue = {
        dist => [[start, ""]]
    }
    bestPossible = dist

    while queue.keys.size > 0
      if queue[bestPossible].length == 0
        queue.delete(bestPossible)
        bestPossible = queue.keys.min
        if queue.keys.size == 0
          return Float::INFINITY
        end
      end

      current, pickedUp = queue[bestPossible].delete_at(0)
      if current == target
        return dists[current], alongTheWay[current]
      end
      next if not finalized.add? (current)

      for n in getPossibleNext(current[0], current[1], cavern, keysCollected)
        next if finalized.include? n
        if dists[n] and dists[current] >= dists[n]
          next
        end
        dists[n] = dists[current] + 1
        bestFromHere = dists[n] + manhattan(n, target)
        pickedAnything = pickedUp
        if cavern[n[0]][n[1]].match(/^[a-z]+/)
          pickedAnything += cavern[n[0]][n[1]]
        end
        alongTheWay[n] = pickedAnything
        if not queue[bestFromHere]
          queue[bestFromHere] = []
        end
        queue[bestFromHere].append([n, pickedAnything])
      end

    end

    return Float::INFINITY
end

def getFastest(startLoc, cavern, keysToCollect, keysCollected, keyLocs, memo)
  if keysCollected.length == keysToCollect.length
    return 0
  end
  if memo[[startLoc, keysCollected]]
    return memo[[startLoc, keysCollected]]
  end

  best = Float::INFINITY

  for k in keysToCollect.split("")
    next if keysCollected.include? k
    toKey, pickedUp = aStar(startLoc, keyLocs[k], cavern, keysCollected)

    next if toKey >= best

    newCollected = (keysCollected + pickedUp).split("").uniq.sort.join

    remaining = getFastest(keyLocs[k], cavern, keysToCollect, newCollected, keyLocs, memo)

    if toKey + remaining <= best
      best = toKey + remaining
    end
  end

  memo[[startLoc, keysCollected]] = best
  return best
end

def part1(input)

    cavern = input.map { |i| i.split("") }
    keyLocs = {}
    startLoc = []

    for i in 0...cavern.length
      for j in 0...cavern[i].length
        if cavern[i][j] == "@"
          startLoc = [i, j]
          cavern[i][j] = "."
        end
        if cavern[i][j].match?(/^[a-z]+$/)
          keyLocs[cavern[i][j]] = [i, j]
        end
      end
    end

    keysToCollect = keyLocs.keys.sort.join

    puts keysToCollect
    return getFastest(startLoc, cavern, keysToCollect, "", keyLocs, {})
    
end

def getFastest2(startLocs, cavern, keysToCollect, keysCollected, keyLocs, memo, center)
  if keysCollected.length == keysToCollect.length
    return 0
  end
  if memo[[startLocs, keysCollected]]
    return memo[[startLocs, keysCollected]]
  end

  best = Float::INFINITY

  for s in 0...startLocs.length
    for k in keysToCollect.split("")
      if (startLocs[s][0] <=> center[0]) != (keyLocs[k][0] <=> center[0])
        next
      end
      if (startLocs[s][1] <=> center[1]) != (keyLocs[k][1] <=> center[1])
        next
      end
      next if keysCollected.include? k
      toKey, pickedUp = aStar(startLocs[s], keyLocs[k], cavern, keysCollected)

      next if toKey >= best

      newCollected = (keysCollected + pickedUp).split("").uniq.sort.join
      newStart = startLocs.clone
      newStart[s] = keyLocs[k]


      remaining = getFastest2(newStart, cavern, keysToCollect, newCollected, keyLocs, memo, center)

      if toKey + remaining <= best
        best = toKey + remaining
      end
    end
  end

  memo[[startLocs, keysCollected]] = best
  return best
end

def part2(input)

    cavern = input.map { |i| i.split("") }

    keysCollected = Set[]
    keyLocs = {}
    startLocs = []

    for i in 0...cavern.length
      for j in 0...cavern[i].length
        if cavern[i][j] == "@"
          startLocs = [[i - 1, j - 1], [i - 1, j + 1], [i + 1, j - 1], [i + 1, j + 1]]
          center = [i, j]
          cavern[i][j] = "#"
          cavern[i][j - 1] = "#"
          cavern[i][j + 1] = "#"
          cavern[i + 1][j] = "#"
          cavern[i - 1][j] = "#"
        end
        if cavern[i][j].match?(/^[a-z]+$/)
          keyLocs[cavern[i][j]] = [i, j]
        end
      end
    end

    keysToCollect = keyLocs.keys.sort.join

    puts keysToCollect
    return getFastest2(startLocs, cavern, keysToCollect, "", keyLocs, {}, center)
end

# puts part1(data)
puts part2(data)