using AdventOfCode2024
using Test

@testset "day_1_2022" begin
    input = "input_test/day_1_2022.txt";
    test_answer_part_1 = 24000
    test_answer_part_2 = 45000
    @test main_day_1_2022(input, 1) == test_answer_part_1
    @test main_day_1_2022(input, 2) == test_answer_part_2
end
