using Test

include("../src/RSA.jl")

@testset "Secondary functions" begin

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

    @test RSA.get_random_int(3) <= 7
    @test RSA.get_random_int(8) <= 255
end

@testset "Primality functions" begin

    @test RSA.miller_rabin(561) == false
    @test RSA.miller_rabin(29) == true
    @test RSA.miller_rabin(221) == false
end