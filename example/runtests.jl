using Test

@testset "AllTests" begin
    include("tests1.jl")
    @testset "Test2" begin
        @test true
        sleep(0.5)
    end
    @testset "Test3" begin
        @test true
        sleep(0.5)
    end
    @testset "Test4" begin
        @test_broken false
    end
    @testset "Test5" begin
        @test true
        sleep(0.5)
        @test true
        sleep(0.5)
    end
    @testset "Test6" begin
        @test true
        sleep(0.5)
        @test true
        sleep(0.5)
        @test true
    end
    # include("tests2/tests.jl")
end
