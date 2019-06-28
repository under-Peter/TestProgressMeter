using Test

@testset "AllTests" begin
    include("tests1.jl")
    @testset "Test2" begin
        @test 5 + 3 == 8
        sleep(1)
    end
    @testset "Test3" begin
        @test 10^3 ≈ 1/(10^(-3))
        sleep(1)
    end
    @testset "Test4" begin
        @test_broken 1 == 0
    end
    @testset "Test5" begin
        sleep(1)
        @test 1 == 1
        @test 1 == 1
        sleep(1)
        @test 1 == 1
        @test 1 == 1
        sleep(1)
        @test 1 == 1
    end
    @testset "Test6" begin
        sleep(1)
        @test 1 == 1
        @test 1 == 1
        sleep(1)
        @test 1 == 1
    end
    include("tests2/tests.jl")
end