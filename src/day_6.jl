# day_6.jl

function move_guard(grid)
    out_of_bounds = false
    dimensions = size(grid)
    guard_pos = findall(x->(x=="^" || x==">" || x=="v" || x=="<"),grid)[1]
    direction = grid[guard_pos]

    moved = false
    while !moved 
        trial_pos = get_trial_position(guard_pos, direction)
        if ((trial_pos[1] < 1) || (trial_pos[1] > dimensions[1])) || ((trial_pos[2] < 1) || (trial_pos[2] > dimensions[2]))  
            # we are out of bounds
            # grid[guard_pos] = get_mark(grid[guard_pos], direction)
            grid[guard_pos] = "X"
            out_of_bounds  = true
            break
        elseif grid[trial_pos] == "#"
            direction = get_trial_direction(direction)
        elseif grid[trial_pos] == "." || grid[trial_pos] in ["X", "|", "-", "+"]
            # grid[guard_pos] = get_mark(grid[guard_pos], direction)
            grid[guard_pos] = "X"
            guard_pos = trial_pos
            grid[guard_pos] = direction
            moved = true
        end
    end
    return grid, out_of_bounds 
end

function get_trial_position(guard_pos, direction)
    if direction == "^"
        trial_pos = CartesianIndex(guard_pos[1]-1, guard_pos[2])
    elseif direction == ">"
        trial_pos = CartesianIndex(guard_pos[1], guard_pos[2]+1)
    elseif direction == "v"
        trial_pos = CartesianIndex(guard_pos[1]+1, guard_pos[2])
    elseif direction == "<"
        trial_pos = CartesianIndex(guard_pos[1], guard_pos[2]-1)
    end
    return trial_pos
end

function get_trial_direction(direction)
    if direction == "^"
        direction = ">"
    elseif direction == ">"
        direction = "v"
    elseif direction == "v"
        direction = "<"
    elseif direction == "<"
        direction = "^"
    end
    return direction
end

function get_mark(orig_mark, direction)
    if direction == "^"
        mark = "|"
    elseif direction == ">" 
        mark = "-"
    elseif direction == "v"
        mark = "|"
    elseif direction == "<"
        mark = "-"
    end
    return mark
end

function main_day_6(input, part)

    lines = readlines(input)
    split_lines = [split(line,"") for line in lines]
    grid =  permutedims(hcat(split_lines...))
    
    out_of_bounds = false
    while !out_of_bounds 
        grid, out_of_bounds = move_guard(grid)
    end
    visited_position_count = length(findall(x->x in ["X", "|", "-", "+"], grid))

    if part == 1
        return visited_position_count
        # return grid
    elseif part == 2
        return 0
    end
end

input = "input_test/day_6.txt"; part = 1; main_day_6(input, part)
