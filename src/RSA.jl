#!/usr/bin/env julia

module RSA

"""
Returns x^n mod p
"""
function exp(x::T, n::T, p::T = 1000007) where T <: Integer
    ans = 1
    x = x % p

    while n > 0
        if ((n & 1) != 0)
            ans = (ans * x) % p
        end
        x = (x * x) % p
        n = n >> 1
    end
    ans
end

"""
Modular multiplicative inverse

a: integer whose inverse is to be found
n: modular base
"""
function inverse(a::T, n::T) where T <: Integer
    g, x, _ = gcdx(a, n)

    if (g != 1)
        error("The inverse doesn't exist")
    end
    (x % n + n) % n
end

"""
Seive of Eratosthenes

Returns primes less than n
"""
function seive(n::T) where T <: Integer
    seive_list = ones(Bool, n)

    for i in 2:trunc(T, sqrt(n))
        if seive_list[i] == true
           for j in (i*i):i:n
                seive_list[j] = false
           end
        end 
   end
    filter(x -> seive_list[x] == true, 2:n)
end

"""
Euler totient function of n
phi(n) = number of positive integers co-prime with n.

n: Int
"""
function phi(n::Integer)
    result = n
    p = 2

    while p * p <= n
        if (n % p == 0)
            while n % p == 0
                n /= p
            end
            result -= result / p
        end
        p += 1
    end
    if (n > 1)
        result -= result / n
    end
    Int(result)
end

"""Miller Rabin primality test
Return False if n is composite, True(probably prime) otherwise.

n: integer to be tested for primality
k: number of iterations to run the test
"""
function miller_rabin(n::T, k::T = 10) where T <: Integer
    if (n == 2)
        return (true)
    end
    if (n == 1 || n % 2 == 0)
        return (false)
    end 
    s = 0
    d = n - 1
    while d % 2 == 0
        s += 1
        d /= 2
    end
    @assert 2^s*d == n - 1
end

end # module
