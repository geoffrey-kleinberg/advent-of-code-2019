require 'set'

day = "14"
file_name = "12-#{day}-19/sampleIn.txt"
# file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def getDownstream(element, downstream, reactions)
    if element == "ORE"
        return Set[]
    end
    if downstream[element]
        return downstream[element]
    end

    thisDownstream = Set[]

    for e in reactions[element].keys
        toAdd = getDownstream(e, downstream, reactions)
        thisDownstream.add(e)
        thisDownstream = thisDownstream + toAdd
    end

    downstream[element] = thisDownstream
    return thisDownstream

end

def part1(input)

    reactions = {}
    makes = {}
    for line in input
        ingredients, product = line.split(" => ")
        ingredients = ingredients.split(", ").map { |i| i.split(" ") }
        quantity, product = product.split(" ")

        reactions[product] = {}
        for i in ingredients
            reactions[product][i[1]] = i[0].to_i
        end
        makes[product] = quantity.to_i

    end

    downstream = {
        "ORE" => Set[]
    }
    getDownstream("FUEL", downstream, reactions)

    needed = {
        "FUEL" => 1
    }
    while needed.keys != ["ORE"]
        nextProcess = nil
        for n in needed.keys
            good = true
            for j in needed.keys
                if downstream[j].include? n
                    good = false
                    break
                end
            end
            if good
                nextProcess = n
                break
            end
        end
        totalReactions = (needed[nextProcess].to_f / makes[nextProcess]).ceil
        needed.delete(nextProcess)
        for ing in reactions[nextProcess].keys
            if not needed[ing]
                needed[ing] = 0
            end
            needed[ing] += totalReactions * reactions[nextProcess][ing]
        end
    end
    return needed["ORE"]
end

def getNeeded(reactions, downstream, inventory, makes)
    needed = {
        "FUEL" => inventory["FUEL"] + 1
    }
    while needed.keys != ["ORE"]
        nextProcess = nil
        for n in needed.keys
            good = true
            for j in needed.keys
                if downstream[j].include? n
                    good = false
                    break
                end
            end
            if good
                nextProcess = n
                break
            end
        end
        totalReactions = ((needed[nextProcess].to_f - inventory[nextProcess]) / makes[nextProcess]).ceil
        for ing in reactions[nextProcess].keys
            if not needed[ing]
                needed[ing] = 0
            end
            needed[ing] += totalReactions * reactions[nextProcess][ing]
        end
        inventory[nextProcess] += (totalReactions * makes[nextProcess])
        if nextProcess != "FUEL"
            inventory[nextProcess] -= needed[nextProcess]
        end
        needed.delete(nextProcess)
    end
    return needed["ORE"]
end

def part2(input)

    reactions = {}
    makes = {}
    for line in input
        ingredients, product = line.split(" => ")
        ingredients = ingredients.split(", ").map { |i| i.split(" ") }
        quantity, product = product.split(" ")

        reactions[product] = {}
        for i in ingredients
            reactions[product][i[1]] = i[0].to_i
        end
        makes[product] = quantity.to_i

    end

    downstream = {
        "ORE" => Set[]
    }
    getDownstream("FUEL", downstream, reactions)

    inventory = {
        "ORE" => 1000000000000
    }

    # I should probably optimize this, but oh well

    for r in reactions.keys
        inventory[r] = 0
    end

    while inventory["ORE"] >= 0
        used = getNeeded(reactions, downstream, inventory, makes)
        inventory["ORE"] -= used

    end
    
    return inventory["FUEL"] - 1
end

# puts part1(data)
puts part2(data)