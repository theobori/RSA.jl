using Test

include("../src/RSA.jl")

using .RSA

@testset "Secondary functions" begin

    @test RSA.exp!(2, 47) == 199807
    @test RSA.exp!(3, 51, 678) == 93

    @test RSA.inverse(2, 5) == 3
    @test RSA.inverse(17, 39) == 23
    @test_throws ErrorException RSA.inverse(2, 4)

    @test RSA.seive(1) == []
    @test RSA.seive(13) == [2, 3, 5, 7, 11, 13]

    @test RSA.phi!(10) == 4
    @test RSA.phi!(7) == 6
    @test RSA.phi!(33500000) == 13200000

    @test RSA.get_random_int(3) <= 7
    @test RSA.get_random_int(8) <= 255

    @test RSA.jacobi!(1001, 9907) == -1
    @test RSA.jacobi!(19, 45) == 1
    @test RSA.jacobi!(8,21) == -1
    @test RSA.jacobi!(3, 15) == 0
    @test_throws ErrorException RSA.jacobi!(13, 28)
    @test RSA.jacobi!(28, 13) == -1
end

@testset "Primality functions" begin

    @test RSA.miller_rabin(561) == false
    @test RSA.miller_rabin(29) == true
    @test RSA.miller_rabin(221) == false

    @test RSA.solovay_strassen(561) == false
    @test RSA.solovay_strassen(29) == true
    @test RSA.solovay_strassen(221) == false

    @test RSA.fermat_test(5) == true
    @test RSA.fermat_test(4) == false
    @test RSA.fermat_test(341) == false
end

@testset "Processing" begin

    a =""
    @test RSA.recover_string!(RSA.process_string!(a)) == a
    a ="123"
    @test RSA.recover_string!(RSA.process_string!(a)) == a
    a = "1234567890"
    @test RSA.recover_string!(RSA.process_string!(a)) == a
end

@testset "Encryption" begin
    B = RSASystem()
    a = "ABCDEFG"
    @test decrypt!(B, encrypt!(a, B.public_key)) == a
    a = "AB"
    @test decrypt!(B, encrypt!(a, B.public_key)) == a
    a = "ABABABABABABABABABABABABABABABAB123"
    @test decrypt!(B, encrypt!(a, B.public_key)) == a
end