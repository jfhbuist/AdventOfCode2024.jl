# day_1.jl

function main_day_1(input, part)

    # text = read(input, String)
    lines = readlines(input)
    # split_lines = Vector(undef,6)

    # split_lines = [split(line, "   ") for line in lines]
    split_lines = [[parse(Int, x) for x in split(line, "   ")] for line in lines]
    left = [line[1] for line in split_lines]
    right = [line[2] for line in split_lines]
    sort!(left)
    sort!(right)
    sorted_lines = [[left[idx], right[idx]] for idx in 1:length(left)]
    distances = [abs(line[1] - line[2]) for line in sorted_lines]
    total_distance = sum(distances)

    scores = [id*count(x -> x == id, right) for id in left]
    similarity_score = sum(scores)

    if part == 0
        return (total_distance, similarity_score)
    elseif part == 1
        return total_distance
    elseif part == 2
        return similarity_score
    end
end

# include("src/day_1.jl"); input = "input_test/day_1.txt"; part = 0; main_day_1(input, part)
# include("src/day_1.jl"); input = "input_full/day_1.txt"; part = 0; main_day_1(input, part)
