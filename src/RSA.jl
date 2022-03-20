module RSA

using Random

include("utils.jl")
include("primality.jl")

"""
RSA Crypto System
"""
struct System{T <: Integer}
    bit_size::T
    primality_test::Function
    p::T
    q::T
    n::T
    phi::T
    public_key::T
    private_key::T
end

function System(bit_size::Integer = 128, primality_test::Function = miller_rabin)
    p = generate_large_prime(bit_size, primality_test)
    q = generate_large_prime(bit_size, primality_test)

    while p == q
        q = generate_large_prime(bit_size, primality_test)
    end
    n = p * q
    phi = (p - 1) * (q - 1)
    public_key, private_key = generate_keys()
    System(bit_size, primality_tes, p, q, n, phi, public_key, private_key)
end

"""
Generates public and private keys
"""
function generate_keys(n::T, phi::T) where {T <: Integer}
    e = rand(2:phi-1)

    while gcd(e, phi) != 1
        e = rand(2:phi-1)
    end

    d = inverse(e, phi)
    public_key = (e, n)
    private_key = (d, n)
    public_key, private_key
end

"""
Converts String to Integer
"""
function process_string!(message::String)
    acc::BigInt = 0
    padding = 0
    len = length(message)

    if (len % 4 != 0)
        padding = (4 - (len % 4))
        message = repeat("\x00", padding) * message
    end

    for i in 1:4:len
        message_part = Vector{UInt8}(message[i:i + 3])
        message_part = reinterpret(UInt32, message_part)[1]
        acc = (acc << 32) + message_part
    end
    acc
end

"""
Convert Integer to String
"""
function recover_string!(number::Integer)
    s = ""
    i = 1
    len = 0

    while number > 0
        s = String(to_bytes(UInt32(number & 0xffffffff))) * s
        number = number >> 32
    end
    if (s == "")
        return (s)
    end
    while UInt8(s[i]) == 0
        i += 1
    end
    s[i:length(s)]
end

end # module
