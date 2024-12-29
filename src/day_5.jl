# day_5.jl
using DataFrames

function main_day_5(input, part)

    text = read(input, String)
    pages = unique(split(split(text,"\n\n")[1],['|','\n']))
    rules = split(split(text,"\n\n")[1],"\n")
    left_rules = [split(rule,'|')[1] for rule in rules]
    right_rules = [split(rule,'|')[2] for rule in rules]
    manuals = [split(m,",") for m in filter(s->!isempty(s),split(split(text,"\n\n")[2],"\n"))]

    smaller_than = Vector{Vector{String}}()
    larger_than = Vector{Vector{String}}()
    for page in pages
        push!(smaller_than, right_rules[findall(x -> x == page, left_rules)])
        push!(larger_than, left_rules[findall(x -> x == page, right_rules)])
    end
    # page_data=[[pages[i], smaller_than[i], larger_than[i]] for i in eachindex(pages)]

    tests = Vector{Bool}()
    for manual in manuals
        test = true
        for idx in eachindex(manual)
            page = manual[idx]
            page_smaller_than = smaller_than[findall(x -> x==page,pages)[1]]
            page_larger_than = larger_than[findall(x -> x==page,pages)[1]]
            if any([m in page_smaller_than for m in manual[1:(idx-1)]]) || any([m in page_larger_than for m in manual[(idx+1):end]])
                test = false
                break
            end
        end
        push!(tests, test)
    end

    if part == 1
        middle_indices = [Int(ceil(length(m)/2)) for m in manuals]
        middle_values = [parse(Int,manuals[i][middle_indices[i]]) for i in eachindex(manuals)]
        total = sum(tests.*middle_values)
        return total
    elseif part == 2
        bad_manuals = manuals[.!tests]
        for manual in bad_manuals
            manual_length = length(manual)
            sorted = false
            while !sorted
                sorted = true
                for idx_left in 1:(length(manual)-1)
                    page_left = manual[idx_left]
                    page_smaller_than = smaller_than[findall(x -> x==page_left,pages)[1]]
                    page_larger_than = larger_than[findall(x -> x==page_left,pages)[1]]
                    for idx_right in (idx_left+1):(length(manual))
                        page_right = manual[idx_right]
                        if page_right in page_larger_than 
                            # then we need to swap
                            permute!(manual, [collect(1:idx_left-1); collect((idx_left+1):(idx_right)); idx_left; collect((idx_right+1):manual_length)])
                            # if we needed to make a swap, then apparently we are not sorted yet, so we need another top level iteration
                            sorted = false 
                            break
                        end 
                    end
                end
            end
        end
        middle_indices = [Int(ceil(length(m)/2)) for m in bad_manuals]
        middle_values = [parse(Int,bad_manuals[i][middle_indices[i]]) for i in eachindex(bad_manuals)]
        total = sum(middle_values)
        return total
    end
end

input = "input_test/day_5.txt"; part = 1; main_day_5(input, part)
