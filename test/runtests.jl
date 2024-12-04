using AdventOfCode2024
using Test

@testset "day_1_2022" begin
    input = "../input_test/day_1_2022.txt";
    test_answer_part_1 = 24000
    test_answer_part_2 = 45000
    @test main_day_1_2022(input, 1) == test_answer_part_1
    @test main_day_1_2022(input, 2) == test_answer_part_2
end

@testset "day_1" begin
    input = "../input_test/day_1.txt";
    test_answer_part_1 = 11
    test_answer_part_2 = 31
    @test main_day_1(input, 1) == test_answer_part_1
    @test main_day_1(input, 2) == test_answer_part_2
end

@testset "day_2" begin
    input = "../input_test/day_2.txt";
    test_answer_part_1 = 2
    test_answer_part_2 = 4
    @test main_day_2(input, 1) == test_answer_part_1
    @test main_day_2(input, 2) == test_answer_part_2
end

@testset "day_3" begin
    input_1 = "../input_test/day_3_part_1.txt";
    input_2 = "../input_test/day_3_part_2.txt";
    test_answer_part_1 = 161
    test_answer_part_2 = 48
    @test main_day_3(input_1, 1) == test_answer_part_1
    @test main_day_3(input_2, 2) == test_answer_part_2
end

@testset "day_4" begin
    input = "../input_test/day_4.txt";
    test_answer_part_1 = 18
    test_answer_part_2 = 9
    @test main_day_4(input, 1) == test_answer_part_1
    @test main_day_4(input, 2) == test_answer_part_2
end
