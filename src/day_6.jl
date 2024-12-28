# day_6.jl

function move_guard(grid, log_grid)
    dimensions = size(grid)
    orig_pos = findall(x->(x=="^" || x==">" || x=="v" || x=="<"),grid)[1]   
    orig_direction = grid[orig_pos]
    orig_mark = log_grid[orig_pos]

    direction = deepcopy(orig_direction)
    valid_direction = false
    while !valid_direction 
        trial_pos = get_trial_position(orig_pos, direction)
        if !(((trial_pos[1] < 1) || (trial_pos[1] > dimensions[1])) || ((trial_pos[2] < 1) || (trial_pos[2] > dimensions[2]))) && grid[trial_pos] == "#"
            direction = get_trial_direction(direction)
        else
            valid_direction = true
        end
    end

    new_pos = get_trial_position(orig_pos, direction)
    grid[orig_pos] = "X"
    if ((new_pos[1] < 1) || (new_pos[1] > dimensions[1])) || ((new_pos[2] < 1) || (new_pos[2] > dimensions[2]))  
        out_of_bounds  = true
    elseif grid[new_pos] == "." || grid[new_pos] in ["X", "|", "-", "+"]
        out_of_bounds = false
        grid[new_pos] = direction
    end

    new_mark = get_mark(orig_mark, direction, orig_direction)
    log_grid[orig_pos] = new_mark
    if orig_mark in ["|", "-", "+"] && new_mark == "+"
        circuit_found = true
    else
        circuit_found = false
    end

    return grid, log_grid, out_of_bounds, circuit_found
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

function get_mark(orig_mark, direction, orig_direction)
    if orig_mark in ["^", ">", "v", "<"] 
        mark = orig_mark
    else
        if direction == orig_direction
            if orig_mark == "."
                if direction == "^"
                    mark = "|"
                elseif direction == ">" 
                    mark = "-"
                elseif direction == "v"
                    mark = "|"
                elseif direction == "<"
                    mark = "-"
                end
            elseif orig_mark == "|"
                if direction == "^"
                    mark = "|"
                elseif direction == ">" 
                    mark = "+"
                elseif direction == "v"
                    mark = "|"
                elseif direction == "<"
                    mark = "+"
                end
            elseif orig_mark == "-"
                if direction == "^"
                    mark = "+"
                elseif direction == ">" 
                    mark = "-"
                elseif direction == "v"
                    mark = "+"
                elseif direction == "<"
                    mark = "-"
                end
            elseif orig_mark == "+"
                mark = "+"
            end
        elseif direction in ["^", "v"] && orig_direction in [">", "<"]  
            mark = "+"
        elseif direction in [">", "<"] && orig_direction in ["^", "v"]
            mark = "+"
        end
    end
    return mark
end

function print_grid(grid)
    for row in 1:size(grid)[1]
        println(join(grid[row,:]))
    end
end

function main_day_6(input, part)

    lines = readlines(input)
    split_lines = [split(line,"") for line in lines]
    grid =  permutedims(hcat(split_lines...))
    log_grid = deepcopy(grid)
    circuit_count = 0
    
    out_of_bounds = false
    while !out_of_bounds 
        grid, log_grid, out_of_bounds, circuit_found = move_guard(grid, log_grid)
        if circuit_found
            circuit_count += 1
        end
    end
    # visited_position_count = length(findall(x->x == "X", grid))
    visited_position_count = length(findall(x->x in ["|", "-", "+", "^", ">", "v", "<"], log_grid))

    # print_grid(log_grid)
    if part == 1
        return visited_position_count
    elseif part == 2
        return circuit_count
    end
end

input = "input_test/day_6.txt"; part = 1; main_day_6(input, part)
