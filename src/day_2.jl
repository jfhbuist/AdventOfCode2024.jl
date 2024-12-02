# day_2.jl

function check_safety(report)
    diffs = diff(report)
    if (all(i -> i > 0, diffs) || all(i -> i < 0, diffs)) && all(1 .<= abs.(diffs) .<= 3)
        safety = true
    else
        safety = false
    end
    return safety
end

function main_day_2(input, part)

    lines = readlines(input)
    report_list = [[parse(Int, x) for x in split(line, " ")] for line in lines]
    safety_list = zeros(Int64, length(report_list))
  
    for (idx1, report) in enumerate(report_list)
        if check_safety(report)
            safety_list[idx1] = 1
        elseif part == 2
            for idx2 in 1:length(report)
                dampened_report = [report[1:(idx2-1)]; report[(idx2+1):length(report)]]
                if check_safety(dampened_report)
                    safety_list[idx1] = 1
                    break
                end
            end
        end
    end   
    safe_count = sum(safety_list)

    return safe_count
end

# include("src/day_2.jl"); input = "input_test/day_2.txt"; part = 1; main_day_2(input, part)
