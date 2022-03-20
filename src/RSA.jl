module RSA

using Random

include("utils.jl")
include("primality.jl")
include("process.jl")

struct CipherText
    data::Any
    is_str::Bool
end

"""
RSA Crypto RSASystem
"""
struct RSASystem
    bit_size::BigInt
    primality_test::Function
    p::BigInt
    q::BigInt
    n::BigInt
    phi::BigInt
    public_key::Tuple{BigInt, BigInt}
    private_key::Tuple{BigInt, BigInt}
end

function RSASystem(bit_size::BigInt = big(256), primality_test::Function = miller_rabin)
    p = generate_large_prime(bit_size, primality_test)
    q = generate_large_prime(bit_size, primality_test)
    
    while p == q
        q = generate_large_prime(bit_size, primality_test)
    end
    n = p * q
    phi = (p - 1) * (q - 1)
    public_key, private_key = generate_keys(n, phi)
    RSASystem(bit_size, primality_test, p, q, n, phi, public_key, private_key)
end

"""
Generates public and private keys
"""
function generate_keys(n::BigInt, phi::BigInt) 
    e = rand(2:phi-1)
    
    while gcd(e, phi) != 1
        e = rand(2:phi-1)
    end
    
    d = inverse(e, phi)
    public_key = (e, n)
    private_key = (d, n)
    public_key, private_key
end

include("encrypt.jl")

export encrypt!, decrypt!, RSASystem

end # module
