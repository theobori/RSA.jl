# RSA.jl

[![Build Status](https://app.travis-ci.com/theobori/RSA.jl.svg?branch=main)](https://app.travis-ci.com/theobori/RSA.jl)

Pseudo-portage of [RSA](https://github.com/kaushiksk/rsa-from-scratch/tree/73d6495d86ec571f4c9d79bf249a08827f67b5d6/py3)


# API

##### Main structure
```julia
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
```

##### Encrypt
```julia
encrypt!(message::String, key::Tuple{BigInt, BigInt})
encrypt!(message::Any, key::Tuple{BigInt, BigInt})
```

##### Decrypt
```julia
decrypt!(system::RSASystem, ciphertext::CipherText)
```

# Example

```julia
Alice = RSASystem()
John = RSASystem()

msg_from_alice = encrypt!("hello john", John.public_key)
msg_from_john = encrypt!("hello alice", Alice.public_key)


decrypt!(Alice, msg_from_john)
> "hello alice"

decrypt!(John, msg_from_alice)
> "hello john"
```