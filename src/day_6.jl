# day_6.jl

function move_guard(grid, log_grid)
    dimensions = size(grid)
    orig_pos = findall(x->(x=="^" || x==">" || x=="v" || x=="<"),grid)[1]   
    orig_direction = grid[orig_pos]
    orig_mark = log_grid[orig_pos]

    direction = deepcopy(orig_direction)
    valid_direction = false
    turned = false
    while !valid_direction 
        trial_pos = get_trial_position(orig_pos, direction)
        if !(((trial_pos[1] < 1) || (trial_pos[1] > dimensions[1])) || ((trial_pos[2] < 1) || (trial_pos[2] > dimensions[2]))) && grid[trial_pos] in ["#", "O"]
            direction = get_trial_direction(direction)
            turned = true
        else
            valid_direction = true
        end
    end

    new_pos = get_trial_position(orig_pos, direction)
    grid[orig_pos] = "X"
    out_of_bounds = false
    if ((new_pos[1] < 1) || (new_pos[1] > dimensions[1])) || ((new_pos[2] < 1) || (new_pos[2] > dimensions[2]))  
        out_of_bounds  = true
    elseif grid[new_pos] == "." || grid[new_pos] in ["X", "|", "-", "+"]
        grid[new_pos] = direction
    end

    # println(orig_mark)
    if direction in orig_mark
        circuit_found = true
        # println(orig_mark, direction)
    else
        circuit_found = false
    end
    push!(log_grid[orig_pos], orig_direction)
    push!(log_grid[orig_pos], direction)
    unique!(log_grid[orig_pos])

    return grid, log_grid, out_of_bounds, circuit_found, turned
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

function place_obstacle(grid, log_grid)
    dimensions = size(grid)
    orig_pos = findall(x->(x=="^" || x==">" || x=="v" || x=="<"),grid)[1]   
    direction = grid[orig_pos]

    new_pos = get_trial_position(orig_pos, direction)
    placed_obstacle = false
    if ((new_pos[1] < 1) || (new_pos[1] > dimensions[1])) || ((new_pos[2] < 1) || (new_pos[2] > dimensions[2]))  
        # do nothing
    elseif grid[new_pos] == "." || grid[new_pos] == "X"
        grid[new_pos] = "O"
        push!(log_grid[new_pos], "O")
        placed_obstacle = true
    end 

    return grid, log_grid, placed_obstacle
end

function print_grid(grid)
    for row in 1:size(grid)[1]
        println(join(grid[row,:]))
    end
end

function print_log_grid(log_grid, init_pos, init_direction)
    direction_to_mark = Dict("." => ".", "#" => "#", "O" => "O", "^" => "|", "v" => "|", ">" => "-", "<" => "-")
    for row in 1:size(log_grid)[1]
        row_string = ""
        for col in 1:size(log_grid)[2]
            if CartesianIndex(row, col) == init_pos
                elm = init_direction
            else
                elm_list = log_grid[row, col]
                mark_list = unique([direction_to_mark[x] for x in elm_list])
                if length(mark_list) == 1
                    elm = mark_list[1]
                else
                    filter!(x -> x != ".", mark_list)
                    if length(mark_list) == 1
                        elm = mark_list[1]
                    elseif any(x-> x == "|", mark_list) && any(x-> x == "-", mark_list)
                        elm = "+"
                    end
                end
            end
            row_string = string(row_string, elm)
        end
        println(row_string)
    end
end

function main_day_6(input, part)

    lines = readlines(input)
    split_lines = [split(line,"") for line in lines]
    grid =  permutedims(hcat(split_lines...))
    init_pos = findall(x->(x=="^" || x==">" || x=="v" || x=="<"),grid)[1]  
    init_direction = grid[init_pos]
    tried_pos = Vector{CartesianIndex{2}}([init_pos])
    log_grid = [Vector{String}([x]) for x in grid]
    circuit_count = 0
    
    out_of_bounds = false
    while !out_of_bounds 
        circuit_found = false
        test_out_of_bounds = false
        test_grid = deepcopy(grid)
        test_log_grid = deepcopy(log_grid)
        test_grid, test_log_grid, placed_obstacle = place_obstacle(test_grid, test_log_grid)
        # print_grid(test_grid)
        # println(placed_obstacle)
        if placed_obstacle
            obstacle_pos = findall(x->x=="O", test_grid)[1]  
            if !(obstacle_pos in tried_pos) 
                while !test_out_of_bounds
                    test_grid, test_log_grid, test_out_of_bounds, circuit_found = move_guard(test_grid, test_log_grid)
                    if !test_out_of_bounds && circuit_found
                        circuit_count += 1
                        print_log_grid(test_log_grid, init_pos, init_direction)
                        println(circuit_count)
                        break
                    end
                end
            push!(tried_pos, obstacle_pos)
            end
        end
        grid, log_grid, out_of_bounds = move_guard(grid, log_grid)
    end
    visited_position_count = length(findall(x->x == "X", grid))

    # print_grid(grid)

    println(visited_position_count)
    println(circuit_count)
    if part == 1
        return visited_position_count
    elseif part == 2
        return circuit_count
    end
end

input = "input_test/day_6.txt"; part = 2; main_day_6(input, part)
