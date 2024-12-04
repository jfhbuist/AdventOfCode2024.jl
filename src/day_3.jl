# day_3.jl

function day_3_part_1(text)

    re = r"mul\(\d{1,3},\d{1,3}\)"
    matches = [x.match for x in eachmatch(re,text)]
    
    arguments = [[parse(Int64,s) for s in split(strip(m[4:end],['(',')']),",")] for m in matches]

    evaluations = [a[1]*a[2] for a in arguments]

    total = sum(evaluations)

    return total

end

function day_3_part_2(text)

    re = r"(mul\(\d{1,3},\d{1,3}\))|((do\(\))|(don't\(\)))"
    matches = [x.match for x in eachmatch(re,text)]

    split_matches = [split(m,"(") for m in matches]
    parsed_matches = [[sm[1],[tryparse(Int,a) for a in split(strip(sm[2],')'),",")]] for sm in split_matches]

    total = 0
    enabled = true
    for pm in parsed_matches
        if enabled
            if pm[1] == "mul"
                total += pm[2][1]*pm[2][2]
            elseif pm[1] == "don't"
                enabled = false
            end
        else
            if pm[1] == "do"
                enabled = true
            end
        end
    end

    # commands = [strip(split(m,"(")[1],['(',')']) for m in matches]
    # arguments = [strip(split(m,"(")[2],['(',')']) for m in matches]
    # parsed_arguments = [[tryparse(Int,s) for s in split(a,",")] for a in arguments]

    return total

end

function main_day_3(input, part)

    # lines = readlines(input)
    text = read(input, String)

    if part == 1
        total = day_3_part_1(text)
        return total
    elseif part == 2
        total = day_3_part_2(text)
        return total
    end
end

# include("src/day_3.jl"); input = "input_test/day_3_part_1.txt"; part = 1; main_day_3(input, part)
# include("src/day_3.jl"); input = "input_full/day_3.txt"; part = 1; main_day_3(input, part)

# include("src/day_3.jl"); input = "input_test/day_3_part_2.txt"; part = 2; main_day_3(input, part)
# include("src/day_3.jl"); input = "input_full/day_3.txt"; part = 2; main_day_3(input, part)
