class Intcode

    attr_accessor :program, :pointer, :halted, :inputs, :inputLoc, :outputs, :waiting, :relativeBase, :debug

    def initialize(program)
        @program = program.split(",").map { |i| i.to_i }
        @pointer = 0
        @halted = false
        @waiting = false
        @inputs = []
        @inputLoc = 0
        @outputs = []
        @relativeBase = 0
        @debug = false
    end

    def clone
      i = Intcode.new("")
      i.program = @program.clone
      i.pointer = @pointer
      i.halted = @halted
      i.waiting = @waiting
      i.inputs = @inputs.clone
      i.inputLoc = @inputLoc
      i.outputs = @outputs.clone
      i.relativeBase = @relativeBase

      return i
    end

    def run
        @waiting = false
        while not @halted and not @waiting
            instruction = @program[@pointer]
            opcode = instruction % 100
            parameterMode = instruction / 100
            if opcode == 1
                self.executeOpcode1(parameterMode)
            elsif opcode == 2
                self.executeOpcode2(parameterMode)
            elsif opcode == 3
                self.executeOpcode3(parameterMode)
            elsif opcode == 4
                self.executeOpcode4(parameterMode)
            elsif opcode == 5
                self.executeOpcode5(parameterMode)
            elsif opcode == 6
                self.executeOpcode6(parameterMode)
            elsif opcode == 7
                self.executeOpcode7(parameterMode)
            elsif opcode == 8
                self.executeOpcode8(parameterMode)
            elsif opcode == 9
                self.executeOpcode9(parameterMode)
            elsif opcode == 99
                @halted = true
            else
                raise "Unknown opcode #{opcode} encountered"
            end
        end
    end

    def getPointers(parameterMode, count)
        modes = parameterMode.to_s.rjust(count, "0")

        ptrs = []
        for idx in 0...count
            i = idx + 1
            if modes.slice(count - i) == "0"
                ptrs[idx] = readPtr(@pointer + i)
            elsif modes.slice(count - i) == "1"
                ptrs[idx] = @pointer + idx + 1
            elsif modes.slice(count - i) == "2"
                ptrs[idx] = readPtr(@pointer + i) + @relativeBase
            else
                raise 'unknown parameter mode'
            end
        end

        return ptrs
    end

    def executeOpcode1(parameterMode)
        ptrs = getPointers(parameterMode, 3)

        if @debug
          puts "Adding #{readPtr(ptrs[0])} [#{ptrs[0]}] and #{readPtr(ptrs[1])} [#{ptrs[1]}], storing in [#{ptrs[2]}]"
        end

        @program[ptrs[2]] = readPtr(ptrs[0]) + readPtr(ptrs[1])

        @pointer += 4
    end

    def executeOpcode2(parameterMode)
        ptrs = getPointers(parameterMode, 3)

        if @debug
          puts "Multiplying #{readPtr(ptrs[0])} [#{ptrs[0]}] and #{readPtr(ptrs[1])} [#{ptrs[1]}], storing in [#{ptrs[2]}]"
        end

        @program[ptrs[2]] = readPtr(ptrs[0]) * readPtr(ptrs[1])

        @pointer += 4
    end

    def executeOpcode3(parameterMode)
        ptrs = getPointers(parameterMode, 1)

        if inputLoc >= @inputs.length
            @waiting = true
            return
        end
        if @debug
          puts "Reading input #{@inputs[@inputLoc]}, storing in [#{ptrs[0]}]"
        end
        @program[ptrs[0]] = @inputs[@inputLoc]
        @inputLoc += 1

        @pointer += 2
    end

    def executeOpcode4(parameterMode)
        ptrs = getPointers(parameterMode, 1)
        if @debug
          puts "Outputting #{readPtr(ptrs[0])} [#{ptrs[0]}]"
        end
        outputs.append(readPtr(ptrs[0]))

        @pointer += 2
    end

    def executeOpcode5(parameterMode)
        ptrs = getPointers(parameterMode, 2)

        if @debug
          puts "Jumping to [#{ptrs[1]}] if #{readPtr(ptrs[0])} [#{ptrs[0]}] is not 0"
        end

        if readPtr(ptrs[0]) != 0
            @pointer = readPtr(ptrs[1])
        else
            @pointer += 3
        end
    end

    def executeOpcode6(parameterMode)
        ptrs = getPointers(parameterMode, 2)

        if @debug
          puts "Jumping to [#{ptrs[1]}] if #{readPtr(ptrs[0])} [#{ptrs[0]}] is 0"
        end

        if readPtr(ptrs[0]) == 0
            @pointer = readPtr(ptrs[1])
        else
            @pointer += 3
        end
    end

    def executeOpcode7(parameterMode)
        ptrs = getPointers(parameterMode, 3)

        if @debug
          puts "Setting [#{ptrs[2]}] to #{readPtr(ptrs[0])} [#{ptrs[0]}] < #{readPtr(ptrs[1])} [#{ptrs[1]}]"
        end

        if readPtr(ptrs[0]) < readPtr(ptrs[1])
            @program[ptrs[2]] = 1
        else
            @program[ptrs[2]] = 0
        end
        @pointer += 4
    end

    def executeOpcode8(parameterMode)
        ptrs = getPointers(parameterMode, 3)

        if @debug
          puts "Setting [#{ptrs[2]}] to #{readPtr(ptrs[0])} [#{ptrs[0]}] == #{readPtr(ptrs[1])} [#{ptrs[1]}]"
        end

        if readPtr(ptrs[0]) == readPtr(ptrs[1])
            @program[ptrs[2]] = 1
        else
            @program[ptrs[2]] = 0
        end
        @pointer += 4
    end

    def executeOpcode9(parameterMode)
        ptrs = getPointers(parameterMode, 1)

        @relativeBase += readPtr(ptrs[0])

        if @debug
          puts "Increasing relative base by #{readPtr(ptrs[0])} [#{ptrs[0]}] to #{@relativeBase}"
        end

        @pointer += 2
    end

    def readPtr(ptr)
        @program[ptr] || 0
    end
end