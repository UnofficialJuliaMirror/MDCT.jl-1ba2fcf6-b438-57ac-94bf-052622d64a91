using MDCT, Compat, LinearAlgebra
using Compat.Test

# O(N^2) implementations straight from the definitions

function slow_mdct(x::AbstractVector{T}) where {T<:Number}
    n = length(x)
    m = div(n,2)
    y = Array{T}(undef, m)
    for j = 1:m
        y[j] = sum(x .* cos.(2*pi/n * (j-0.5) * ((1:n) .- 0.5 .+ n/4)))
    end
    return y
end

function slow_imdct(y::AbstractVector{T}) where {T<:Number}
    m = length(y)
    n = m*2
    x = Array{T}(undef, n)
    for k = 1:n
        x[k] = 2/n * sum(y .* cos.(2*pi/n * ((1:m).-0.5) * (k - 0.5 + n/4)))
    end
    return x
end

N=100
X = rand(N)
Y = mdct(X)
Z = imdct(Y)
Ys = slow_mdct(X)
Zs = slow_imdct(Y)
@test norm(Y-Ys) < 1e-13 * norm(Y)
@test norm(Z-Zs) < 1e-13 * norm(Z)
