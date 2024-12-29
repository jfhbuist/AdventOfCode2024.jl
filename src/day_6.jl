# day_6.jl

function move_guard(grid, log_grid)
    dimensions = size(grid)
    orig_pos = findall(x->(x=="^" || x==">" || x=="v" || x=="<"),grid)[1]   
    orig_direction = grid[orig_pos]
    orig_mark = log_grid[orig_pos]

    direction = deepcopy(orig_direction)
    trial_pos = deepcopy(orig_pos)
    valid_direction = false
    while !valid_direction 
        trial_pos = get_trial_position(orig_pos, direction)
        if !(((trial_pos[1] < 1) || (trial_pos[1] > dimensions[1])) || ((trial_pos[2] < 1) || (trial_pos[2] > dimensions[2]))) && grid[trial_pos] in ["#", "O"]
            direction = get_trial_direction(direction)
        else
            valid_direction = true
        end
    end

    new_pos = trial_pos
    grid[orig_pos] = "X"
    out_of_bounds = false
    if ((new_pos[1] < 1) || (new_pos[1] > dimensions[1])) || ((new_pos[2] < 1) || (new_pos[2] > dimensions[2]))  
        out_of_bounds  = true
    elseif !(grid[new_pos] in ["#", "O"])
        grid[new_pos] = direction
    else
        throw("failed to move")
    end

    if direction in orig_mark
        circuit_found = true
    else
        circuit_found = false
    end
    push!(log_grid[orig_pos], orig_direction)
    push!(log_grid[orig_pos], direction)
    unique!(log_grid[orig_pos])

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

function place_obstacle(grid, log_grid)
    dimensions = size(grid)
    orig_pos = findall(x->(x=="^" || x==">" || x=="v" || x=="<"),grid)[1]   
    direction = grid[orig_pos]

    new_pos = get_trial_position(orig_pos, direction)
    placed_obstacle = false
    if ((new_pos[1] < 1) || (new_pos[1] > dimensions[1])) || ((new_pos[2] < 1) || (new_pos[2] > dimensions[2]))  
        # do nothing
    elseif grid[new_pos] == "." || grid[new_pos] == "X" # may need to remove the second condition
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
                    elseif any(x-> x == "O", mark_list) 
                        # this is only needed if it is allowed to place obstacles during movement of the guard
                        # if this is not allowed, then remove "|| grid[new_pos] == "X"" in place_obstacle()
                        elm = "O"
                    end
                end
                # println(elm_list)
            end
            row_string = string(row_string, elm)
        end
        println(row_string)
    end
end

function show_all_obstacles(grid, obstacle_list)
    for ob in obstacle_list
        grid[ob] = "O"
    end
    return grid
end


function main_day_6(input, part)

    lines = readlines(input)
    split_lines = [split(line,"") for line in lines]
    grid = permutedims(hcat(split_lines...))
    init_pos = findall(x->(x=="^" || x==">" || x=="v" || x=="<"),grid)[1]  
    init_direction = grid[init_pos]
    tried_pos = Vector{CartesianIndex{2}}([init_pos])
    log_grid = [Vector{String}([x]) for x in grid]

    log_grid_list = Vector{Matrix}()
    obstacle_list = Vector{CartesianIndex{2}}()
    
    out_of_bounds = false
    while !out_of_bounds 
        circuit_found = false
        test_out_of_bounds = false
        test_grid = deepcopy(grid)
        test_log_grid = deepcopy(log_grid)
        test_grid, test_log_grid, placed_obstacle = place_obstacle(test_grid, test_log_grid)
        if placed_obstacle
            obstacle_pos = findall(x->x=="O", test_grid)[1]  
            if !(obstacle_pos in tried_pos) 
                while !test_out_of_bounds
                    test_grid, test_log_grid, test_out_of_bounds, circuit_found = move_guard(test_grid, test_log_grid)
                    if !test_out_of_bounds && circuit_found
                        push!(log_grid_list, test_log_grid)
                        push!(obstacle_list, obstacle_pos)
                        break
                    end
                end
            push!(tried_pos, obstacle_pos)
            end
        end
        grid, log_grid, out_of_bounds = move_guard(grid, log_grid)
    end

    visited_position_count = length(findall(x->x == "X", grid))
    circuit_count = length(obstacle_list)

    if part == 0
        return log_grid_list, obstacle_list, visited_position_count, circuit_count
    elseif part == 1
        return visited_position_count
    elseif part == 2
        return circuit_count
    end
end

# input = "input_test/day_6.txt"; part = 2; main_day_6(input, part)
input = "input_full/day_6.txt"; part = 0; log_grid_list, obstacle_list, visited_position_count, circuit_count = main_day_6(input, part)

# input = "input_test/day_6.txt"; part = 0; log_grid_list, obstacle_list, visited_position_count, circuit_count = main_day_6(input, part)
lines = readlines(input)
split_lines = [split(line,"") for line in lines]
grid = permutedims(hcat(split_lines...))
init_pos = findall(x->(x=="^" || x==">" || x=="v" || x=="<"),grid)[1]  
init_direction = grid[init_pos]
# for grid in log_grid_list
#     print_log_grid(grid, init_pos, init_direction)
#     println()
# end
println(visited_position_count, " ", circuit_count)

print_grid(show_all_obstacles(grid, obstacle_list))
