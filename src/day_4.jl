# day_4.jl

function day_4_part_1(grid)

    horizontal_strings = [string(grid[i,:]...) for i in 1:size(grid,2)]
    vertical_strings = [string(grid[:,i]...) for i in 1:size(grid,1)]
    center_diagonal_string_1 = string([grid[i,i] for i in 1:size(grid,1)]...)
    center_diagonal_string_2 = string([grid[i,1+size(grid,2)-i] for i in 1:(size(grid,1))]...)
    west_south_diagonal_strings = [string([grid[i+j,i] for i in 1:(size(grid,1)-j)]...) for j in 1:size(grid,1)]
    north_east_diagonal_strings = [string([grid[i,i+j] for i in 1:(size(grid,1)-j)]...) for j in 1:size(grid,2)]
    north_west_diagonal_strings = [string([grid[i,1+size(grid,2)-i-j] for i in 1:((size(grid,1))-j)]...) for j in 1:size(grid,2)]
    # north_west_diagonal_strings = [string([grid[1+size(grid,1)-i-j,i] for i in 1:((size(grid,1))-j)]...) for j in 1:size(grid,1)]
    east_south_diagonal_strings = [string([grid[i+j,1+size(grid,2)-i] for i in 1:((size(grid,1))-j)]...) for j in 1:size(grid,1)]
    collected_strings = filter(s->!isempty(s), vcat(horizontal_strings, vertical_strings, center_diagonal_string_1, center_diagonal_string_2, west_south_diagonal_strings, north_east_diagonal_strings, north_west_diagonal_strings, east_south_diagonal_strings))

    # re = r"(XMAS)|(SAMX)"
    re = r"(?=(XMAS)|(SAMX))"
    total = 0
    for s in collected_strings
        matches = [x.offset for x in eachmatch(re,s)]
        total += length(matches)
    end

    return total

end

function day_4_part_2(grid)

    total = 0
    for i in 2:(size(grid,1)-1)
        for j in 2:(size(grid,2)-1)
            if grid[i,j] == "A" 
                if grid[i-1,j-1] == "M" && grid[i-1,j+1] == "S" && grid[i+1,j+1] == "S" && grid[i+1,j-1] == "M"
                    total += 1
                elseif grid[i-1,j-1] == "M" && grid[i-1,j+1] == "M" && grid[i+1,j+1] == "S" && grid[i+1,j-1] == "S"
                    total += 1
                elseif grid[i-1,j-1] == "S" && grid[i-1,j+1] == "M" && grid[i+1,j+1] == "M" && grid[i+1,j-1] == "S"
                    total += 1
                elseif grid[i-1,j-1] == "S" && grid[i-1,j+1] == "S" && grid[i+1,j+1] == "M" && grid[i+1,j-1] == "M"
                    total += 1
                end
            end
        end
    end

    return total

end

function main_day_4(input, part)

    lines = readlines(input)
    split_lines = [split(line,"") for line in lines]
    # grid = mapreduce(permutedims, vcat, split_lines)
    grid =  permutedims(hcat(split_lines...))

    if part == 1
        return day_4_part_1(grid)
    elseif part == 2
        return day_4_part_2(grid)
    end
end

# include("src/day_4.jl"); input = "input_test/day_4.txt"; part = 1; main_day_4(input, part)
# include("src/day_4.jl"); input = "input_full/day_4.txt"; part = 1; main_day_4(input, part)

# include("src/day_4.jl"); input = "input_test/day_4.txt"; part = 2; main_day_4(input, part)
# include("src/day_4.jl"); input = "input_full/day_4.txt"; part = 2; main_day_4(input, part)
