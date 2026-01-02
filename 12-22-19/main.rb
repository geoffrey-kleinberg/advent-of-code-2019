require 'set'

day = "22"
file_name = "12-#{day}-19/sampleIn.txt"
file_name = "12-#{day}-19/input.txt"

data = File.read(file_name).split("\n").map { |i| i.rstrip }

def part1(input)
    instructions = input.map { |i| i.split(" ") }

    numCards = 10007
    position = 2019

    for inst in instructions
        if inst[0] == "deal" and inst[1] == "into"
          position = numCards - position - 1
        elsif inst[0] == "cut"
          toCut = inst[1].to_i
          position = (position - toCut) % numCards
        elsif inst[0] == "deal" and inst[1] == "with"
          inc = inst.last.to_i
          position = (position * inc) % numCards
        end
    end

    return position
end

def getBezoutCoefficients(a, b)
    a, b = [a, b].minmax

    s0 = 1
    t0 = 0

    s1 = 0
    t1 = 1

    while a != 0
      q = b / a
      r = b % a

      s = s0 - q * s1
      t = t0 - q * t1

      s0, s1 = s1, s
      t0, t1 = t1, t
      a, b = r, a
    end

    return t0, s0
  
end

def getLinearCoeffs(instructions, numCards)
    m = 1
    b = 0

    for inst in instructions
        if inst[0] == "deal" and inst[1] == "into"
          m *= -1
          b = numCards - b - 1
        elsif inst[0] == "cut"
          toCut = inst[1].to_i
          b -= toCut
        elsif inst[0] == "deal" and inst[1] == "with"
          inc = inst.last.to_i
          m *= inc
          b *= inc
        end
        b = b % numCards
        m = m % numCards
    end
    return m, b
end

def exp(x, n, mod)
  xm = x % mod
  if n == 0
    return 1
  elsif n % 2 == 0
    return exp(xm * xm, n / 2, mod) % mod
  elsif n % 2 == 1
    return xm * exp(xm * xm, (n - 1) / 2, mod) % mod
  end
end

def part2(input)
    instructions = input.map { |i| i.split(" ") }

    numCards = 119315717514047 # this is a prime number
    iters = 101741582076661 # this is a prime number
    position = 2020

    # shuffling is a linear transformation of the form
    # f(x) = m * x + const
    m, const = getLinearCoeffs(instructions, numCards)

    # shuffling 100 trillion times is a linear transformation
    # of the form f(x) = (m ** iters) * x + const * (m ** iters - 1) / (m - 1)
    # or f(x) = bigM * x + bigB
    
    # we want to find bigM (mod numCards) and bigB (mod numCards)

    # bigM can be computed directly with exponentiation by squaring
    bigM = exp(m, iters, numCards)

    # Now, we want bigB \equiv const * (m ** iters - 1) / (m - 1) (mod numCards)
    # So, bigB * (m - 1) \equiv const * (m ** iters - 1) (mod numCards)
    # The result of the following algorithm is t0 such that:
    #   t0 * (m - 1) \equiv 1 (mod numCards)
    a, b = [m - 1, numCards].minmax

    t0 = 0
    t1 = 1
    while a != 0
      q = b / a
      r = b % a
      t = t0 - q * t1
      t0, t1 = t1, t
      a, b = r, a
    end

    # Thus, t0 * const * (m ** iters - 1) * (m - 1) \equiv const * (m ** iters - 1) (mod numCards)
    # So bigB \equiv t0 * const * (bigM - 1) (mod numCards)
    bigB = (t0 * const * (bigM - 1)) % numCards
    

    # Now, we want to find x such that
    # bigM * x + bigB \equiv posititon (mod numCards)
    # Again, the result of the following algorithm is t0 such that:
    #   t0 * bigM \equiv 1 (mod numCards)
    a, b = [bigM, numCards].minmax
    t0 = 0
    t1 = 1
    while a != 0
      q = b / a
      r = b % a
      t = t0 - q * t1
      t0, t1 = t1, t
      a, b = r, a
    end

    # Thus, t0 * bigM * (posititon - bigB) \equiv position - bigB (mod numCards)
    # so our answer is t0 * (position - bigB)
    return (t0 * (position - bigB)) % numCards

end

# puts part1(data)
puts part2(data)