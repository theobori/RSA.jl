using Test

include("../src/RSA.jl")

using .RSA

@testset "Secondary functions" begin

    @test RSA.exp!(big(2), big(47)) == big(199807)
    @test RSA.exp!(big(3), big(51), big(678)) == big(93)

    @test RSA.inverse(big(2), big(5)) == big(3)
    @test RSA.inverse(big(17), big(39)) == big(23)
    @test_throws ErrorException RSA.inverse(big(2), big(4))

    @test RSA.seive(big(1)) == []
    @test RSA.seive(big(13)) == [big(2), big(3), big(5), big(7), big(11), big(13)]

    @test RSA.phi!(big(10)) == big(4)
    @test RSA.phi!(big(7)) == big(6)
    @test RSA.phi!(big(33500000)) == big(13200000)

    @test RSA.get_random_int(big(3)) <= big(7)
    @test RSA.get_random_int(big(8)) <= big(255)

    @test RSA.jacobi!(big(1001), big(9907)) == -big(1)
    @test RSA.jacobi!(big(19), big(45)) == big(1)
    @test RSA.jacobi!(big(8),big(21)) == -big(1)
    @test RSA.jacobi!(big(3), big(15)) == big(0)
    @test_throws ErrorException RSA.jacobi!(big(13), big(28))
    @test RSA.jacobi!(big(28), big(13)) == -big(1)
end

@testset "Primality functions" begin

    @test RSA.miller_rabin(big(561)) == false
    @test RSA.miller_rabin(big(29)) == true
    @test RSA.miller_rabin(big(221)) == false

    @test RSA.solovay_strassen(big(561)) == false
    @test RSA.solovay_strassen(big(29)) == true
    @test RSA.solovay_strassen(big(221)) == false

    @test RSA.fermat_test(big(5)) == true
    @test RSA.fermat_test(big(4)) == false
    @test RSA.fermat_test(big(341)) == false
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