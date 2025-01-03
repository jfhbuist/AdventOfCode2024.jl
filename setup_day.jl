# setup_day.jl

using Printf
using HTTP

function setup_day(day)

    if !isa(day, Number) || !isinteger(day)
        println("ERROR: Entered day is not an integer.")
        return
    end

    script_path = @sprintf("src/day_%d.jl",day)
    online_input_path = @sprintf("https://adventofcode.com/2024/day/%d/input",day)
    local_input_path = @sprintf("input_full/day_%d.txt",day)

    # Exit with error if preqrequisites are not met
    if isfile(script_path)
        println("ERROR: Script for this day already exists.")
        return
    elseif !isfile(".session_cookie")
        println("ERROR: .session_cookie file does not exist.")
        return
    elseif isfile(local_input_path)
        println("ERROR: Input file for this day already exists.")
        return
    end

    # To get session cookie, go to input file in browser, and do the following:
    # right-click/inspect/network/refresh/input/cookies/session
    # Put this string in a file called ".session_cookie", in the top directory
    # We now read the cookie
    cookie_string = open(".session_cookie", "r") do f
        read(f, String)    
    end
    cookies_dict = Dict("session" => cookie_string)

    req = HTTP.get(online_input_path, cookies=cookies_dict)

    # Check if request has succeeded, otherwise exit
    if req.status != 200
        println("ERROR: Input could not be downloaded.")
        return
    end
    # Now all checks have succeeded, so continue

    # Create and write input file
    open(local_input_path, "w") do f
        write(f,(String(req.body))) 
    end

    # Create julia solution script
    open(script_path, "w") do f
        write(f, @sprintf("# day_%d.jl\n\n",day)) 
        write(f, @sprintf("function main_day_%d(input, part)\n\n",day)) 
        write(f, "    text = read(input, String)\n")
        write(f, "    lines = readlines(input)\n\n")
        write(f, "    if part == 1\n")
        write(f, "        return 0\n")
        write(f, "    elseif part == 2\n")
        write(f, "        return 0\n")
        write(f, "    end\n")
        write(f, "end\n\n") 
        write(f, @sprintf("input = \"input_test/day_%d.txt\"; part = 1; main_day_%d(input, part)\n",day,day)) 
    end

    println("Succes!")
    return

end

# include("setup_day.jl"); setup_day(x)
