#!/usr/bin/env julia

module RSA

using Random

"""
Returns x^n mod p
"""
function exp(x::T, n::T, p::T = 1000007) where {T <: Number}
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

a: Number whose inverse is to be found
n: modular base
"""
function inverse(a::T, n::T) where {T <: Number}
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
function seive(n::T) where {T <: Number}
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

phi(n) = number of positive Numbers co-prime with n.
n: Int
"""
function phi(n::Number)
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

"""
Returns a random Number of size bit_size bits
"""
function get_random_int(bit_size::T) where {T <: Number}
    bit_vector = bitrand(bit_size)
    sum([(2 ^ (i - 1)) * bit for (i, bit) in enumerate(reverse(bit_vector))])
end  

"""
Returns the Jacobi symbol
If b is prime, it returns the Legendre Symbol
"""
function jacobi(a::T, b::T) where {T <: Number}
    if (b <= 0)
        error("b must be >= 1")
    end
    if (b & 1 == 0)
        error("b must be odd")
    end

    ans = 1
    if (a < 0)
        a = -a
        if (b % 4 == 3)
            ans = -ans
        end
    end

    while a != 0
        while a % 2 == 0
            a /= 2
            if ((b % 8) in [3, 5])
                ans = -ans
            end
        end
        a, b = b, a
        if a % 4 == 3 && b % 4 == 3
            ans = -ans
        end
        a = a % b
    end

    if (b == 1)
        return (ans)
    end
    0
end

"""
Estimate if the number is prime
"""
function check_composite(a::T, d::T, n::T, s::T) where {T <: Number}
    x = exp(a, d, n)

    if (x == 1 || x == (n - 1))
        return (false)
    end

    for _ in 1:s
        x = (x * x) % n
        if (x == (n - 1))
            return (false)
        end
    end
    true
end

"""Miller Rabin primality test
Return False if n is composite, True(probably prime) otherwise.

n: Number to be tested for primality
k: number of iterations to run the test
"""
function miller_rabin(n::T, k::T = 10) where {T <: Number}
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

    @assert 2 ^ s * d == n - 1

    for _ in 1:k
        a = rand(2:n - 1)
        d = floor(Int, d)
        if (check_composite(a, d, n, s))
            return (false)
        end
    end
    true
end

"""
Solovay Strassen Primality Test
Returns False is n is composite, True(probably prime) otherwise

n: Number to be tested for primality
k: number of iterations to run the test
"""
function solovay_strassen(n::T, k::T = 10) where {T <: Number}
    if (n == 2)
        return (true)
    end
    if (n == 1 || n & 1 == 0)
        return (false)
    end

    for _ in 1:k
        a = rand(2:n-1)
        x = (jacobi(a, n) + n) % n
        if (x == 0 || exp(a, floor(Int, (n - 1) / 2), n) != x)
            return (false)
        end
    end
    true
end

"""
Fermat's Primality test
Returns True(probably prime) if n is prime, Flase if n is composite

n: Number to be tested for primality
k: number of iterations of the Fermat's Primality Test
"""
function fermat_test(n::T, k::T = 10) where {T <: Number}
    if (n == 2)
        return (true)
    end
    if (n & 1 == 0)
        return (false)
    end

    for _ in 1:k
        a = rand(2:n-1)
        if (exp(a, n - 1, n) != 1)
            return (false)
        end
    end
    true
end

"""
Generates a large a prime number by incremental search
"""
function generate_large_prime(bit_size::T, primality_test::Function = fermat_test) where {T <: Number}
    p = get_random_int(bit_size)

    if (p & 1 != 1)
        p += 1
    end
    while primality_test(p) == false
        p += 2
    end
    p
end

end # module
