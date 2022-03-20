"""
Estimate if the number is prime
"""
function check_composite(a::BigInt, d::BigInt, n::BigInt, s::BigInt) 
    x = exp!(a, d, n)

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

check_composite(a::T, d::T, n::T, s::T) where {T <: Integer} =
check_composite(big(a), big(d), big(n), big(s))

"""Miller Rabin primality test
Return False if n is composite, True(probably prime) otherwise.

n: Number to be tested for primality
k: number of iterations to run the test
"""
function miller_rabin(n::BigInt, k::BigInt = big(10)) 
    if (n == 2)
        return (true)
    end
    if (n == 1 || n % 2 == 0)
        return (false)
    end 

    s::BigInt = 0
    d = n - 1

    while d % 2 == 0
        s += 1
        d /= 2
    end

    @assert floor(BigInt, 2 ^ s * d) == n - 1

    for _ in 1:k
        a = rand(2:n - 1)
        d = floor(BigInt, d)
        if (check_composite(a, d, n, s))
            return (false)
        end
    end
    true
end

miller_rabin(n::T, k::T = 10) where {T <: Integer} = 
miller_rabin(big(n), big(k))

"""
Solovay Strassen Primality Test
Returns False is n is composite, True(probably prime) otherwise

n: Number to be tested for primality
k: number of iterations to run the test
"""
function solovay_strassen(n::BigInt, k::BigInt = big(10)) 
    if (n == 2)
        return (true)
    end
    if (n == 1 || n & 1 == 0)
        return (false)
    end

    for _ in 1:k
        a = rand(2:n-1)
        x = (jacobi!(a, n) + n) % n
        if (x == 0 || exp!(a, floor(BigInt, (n - 1) / 2), n) != x)
            return (false)
        end
    end
    true
end

solovay_strassen(n::T, k::T = 10) where {T <: Integer} = 
solovay_strassen(big(n), big(k))

"""
Fermat's Primality test
Returns True(probably prime) if n is prime, Flase if n is composite

n: Number to be tested for primality
k: number of iterations of the Fermat's Primality Test
"""
function fermat_test(n::BigInt, k::BigInt = big(10)) 
    if (n == 2)
        return (true)
    end
    if (n & 1 == 0)
        return (false)
    end

    for _ in 1:k
        a = rand(2:n-1)
        if (exp!(a, n - 1, n) != 1)
            return (false)
        end
    end
    true
end

fermat_test(n::T, k::T = 10) where {T <: Integer} = 
fermat_test(big(n), big(k))
