# day_1_2022.jl

function sort_calories(current_cal, elf_idx, max_cal, max_idx)
    for (pos, cal) in enumerate(max_cal)
        if current_cal > cal
            # shift entries right and insert removed value at current position
            # println([max_cal,max_idx,pos])
            insert!(max_cal, pos, pop!(max_cal))
            insert!(max_idx, pos, pop!(max_idx))
            # replace inserted value with new current cal value
            max_cal[pos] = current_cal
            max_idx[pos] = elf_idx
            break
        end
    end
    return max_cal, max_idx
end

function main_day_1_2022(input, part)
    current_cal = 0
    elf_idx = 1
    max_cal = [0, 0, 0]  # first is highest
    max_idx = [0, 0, 0]  # first is highest
    open(input, "r") do f
        for line in eachline(f)
            # println(line)
            if isempty(line)
                # println(line)
                max_cal, max_idx = sort_calories(current_cal, elf_idx, max_cal, max_idx)
                current_cal = 0
                elf_idx += 1
            else
                # println(line)
                item_cal = parse(Int,strip(line))
                current_cal += item_cal     
            end
            # println(current_cal)
        end
    end
    if current_cal != 0
        max_cal, max_idx = sort_calories(current_cal, elf_idx, max_cal, max_idx)
        current_cal = 0
        elf_idx += 1
    end

    if part == 0
        return max_cal[1], sum(max_cal)
    elseif part == 1
        return max_cal[1]
    elseif part == 2
        return sum(max_cal)
    end
end

# if isinteractive()
#     input = "input_test/day_1.txt"
#     part = 0
#     println(main(input, part))
# end

# if abspath(PROGRAM_FILE) == @__FILE__
#     input = "input_test/day_1.txt"
#     part = 0
#     println(main(input, part))
# end

# include("src/day_1_2022.jl"); input = "input_test/day_1_2022.txt"; part = 0; println(main_day_1_2022(input, part))

# input = "input_test/day_1_2022.txt"; part = 0; println(main_day_1_2022(input, part))
