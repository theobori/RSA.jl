using Test

include("../src/RSA.jl")

@testset "Secondary function" begin

    @test RSA.exp(2, 47) == 199807
    @test RSA.exp(3, 51, 678) == 93

    @test RSA.inverse(2, 5) == 3
    @test RSA.inverse(17, 39) == 23
    @test_throws ErrorException RSA.inverse(2, 4)

    @test RSA.seive(1) == []
    @test RSA.seive(13) == [2, 3, 5, 7, 11, 13]

    @test RSA.phi(10) == 4
    @test RSA.phi(7) == 6
    @test RSA.phi(33500000) == 13200000
end