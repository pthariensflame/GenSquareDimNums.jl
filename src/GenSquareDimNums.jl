module GenSquareDimNums

struct ImmutableBitSet256 <: AbstractSet{UInt8}
    raw_elems_low::UInt128
    raw_elems_high::UInt128
end

const UInt8_HALF_LIMIT::UInt8 = UInt8(128)

function ImmutableBitSet256(other)
    raw_elems_low::UInt128 = zero(UInt128)
    raw_elems_high::UInt128 = zero(UInt128)
    for ix in other
        ix8::UInt8 = ix
        if ix8 < UInt8_HALF_LIMIT
            raw_elems_low |= one(UInt128) << ix8
        else
            raw_elems_high |= one(UInt128) << (ix8 - UInt8_HALF_LIMIT)
        end
    end
    return ImmutableBitSet256(raw_elems_low, raw_elems_high)
end

ImmutableBitSet256(other::ImmutableBitSet256) = other

ImmutableBitSet256() = ImmutableBitSet256(zero(UInt128), zero(UInt128))

ImmutableBitSet256(other::ImmutableBitSet256, v::UInt8, vs::UInt8...) = union(other, ImmutableBitSet256(v, vs...))

ImmutableBitSet256(other::ImmutableBitSet256, v::Integer, vs::Integer...) = ImmutableBitSet256(other, convert(UInt8, v), convert.(UInt8, vs)...)

function ImmutableBitSet256(v::UInt8, vs::UInt8...)
    local raw_elems_low::UInt128
    local raw_elems_high::UInt128
    if v < UInt8_HALF_LIMIT
        raw_elems_low = one(UInt128) << v
        raw_elems_high = zero(UInt128)
    else
        raw_elems_low = zero(UInt128)
        raw_elems_high = one(UInt128) << (v - UInt8_HALF_LIMIT)
    end
    for ix8 in vs
        if ix8 < UInt8_HALF_LIMIT
            raw_elems_low |= one(UInt128) << ix8
        else
            raw_elems_high |= one(UInt128) << (ix8 - UInt8_HALF_LIMIT)
        end
    end
    return ImmutableBitSet256(raw_elems_low, raw_elems_high)
end

ImmutableBitSet256(v::Integer, vs::Integer...) = ImmutableBitSet256(convert(UInt8, v), convert.(UInt8, vs)...)

Base.convert(::Type{ImmutableBitSet256}, other::AbstractSet{UInt8}) = ImmutableBitSet256(other)

Base.isempty(s::ImmutableBitSet256) = iszero(s.raw_elems_low) && iszero(s.raw_elems_high)

Base.eltype(::ImmutableBitSet256) = UInt8

function Base.iterate(initial::ImmutableBitSet256, current=initial)::Union{Tuple{UInt8, ImmutableBitSet256}, Nothing}
    local result::UInt8
    local next::UInt128
    if !iszero(current.raw_elems_low)
        result = trailing_zeros(current.raw_elems_low)
        next = current.raw_elems_low & ~(one(UInt128) << result)
        return (result, ImmutableBitSet256(next, current.raw_elems_high))
    elseif !iszero(current.raw_elems_high)
        result = trailing_zeros(current.raw_elems_high)
        next = current.raw_elems_high & ~(one(UInt128) << result)
        return (result + UInt8_HALF_LIMIT, ImmutableBitSet256(zero(UInt128), next))
    else
        return nothing
    end
end

Base.isdone(current::ImmutableBitSet256) = isempty(current)

Base.length(s::ImmutableBitSet256) = count_ones(s.raw_elems_low) + count_ones(s.raw_elems_high)

function Base.in(v, s::ImmutableBitSet256)
    ismissing(v) && return missing
    v8::UInt8 = v
    if v8 < UInt8_HALF_LIMIT
        return !iszero(s.raw_elems_low & (one(UInt128) << v8))
    else
        return !iszero(s.raw_elems_high & (one(UInt128) << (v8 - UInt8_HALF_LIMIT)))
    end
end

Base.unique(s::ImmutableBitSet256) = s

Base.allunique(s::ImmutableBitSet256) = true

function Base.filter(f, initial::ImmutableBitSet256)
    raw_elems_low::UInt128 = zero(UInt128)
    raw_elems_high::UInt128 = zero(UInt128)
    for ix8 in zero(UInt8):typemax(UInt8)
        bit::UInt128 = (ix8 ∈ s) && f(ix8)
        if v8 < UInt8_HALF_LIMIT
            return s.raw_elems_low |= bit << ix8
        else
            return s.raw_elems_high |= bit << (ix8 - UInt8_HALF_LIMIT)
        end
    end
    return ImmutableBitSet256(raw_elems_low, raw_elems_high)
end

function Base.union(initial::ImmutableBitSet256, iters...)
    raw_elems_low::UInt128 = initial.raw_elems_low
    raw_elems_high::UInt128 = initial.raw_elems_high
    for itr in iters
        s256 = ImmutableBitSet256(itr)
        raw_elems_low |= s256.raw_elems_low
        raw_elems_high |= s256.raw_elems_high
    end
    return ImmutableBitSet256(raw_elems_low, raw_elems_high)
end

function Base.intersect(initial::ImmutableBitSet256, iters...)
    raw_elems_low::UInt128 = initial.raw_elems_low
    raw_elems_high::UInt128 = initial.raw_elems_high
    for itr in iters
        s256 = ImmutableBitSet256(itr)
        raw_elems_low &= s256.raw_elems_low
        raw_elems_high &= s256.raw_elems_high
    end
    return ImmutableBitSet256(raw_elems_low, raw_elems_high)
end

function Base.setdiff(initial::ImmutableBitSet256, iters...)
    raw_elems_low::UInt128 = initial.raw_elems_low
    raw_elems_high::UInt128 = initial.raw_elems_high
    for itr in iters
        s256 = ImmutableBitSet256(itr)
        raw_elems_low &= ~(s256.raw_elems_low)
        raw_elems_high &= ~(s256.raw_elems_high)
    end
    return ImmutableBitSet256(raw_elems_low, raw_elems_high)
end

function Base.symdiff(initial::ImmutableBitSet256, iters...)
    raw_elems_low::UInt128 = initial.raw_elems_low
    raw_elems_high::UInt128 = initial.raw_elems_high
    for itr in iters
        s256 = ImmutableBitSet256(itr)
        raw_elems_low ⊻= s256.raw_elems_low
        raw_elems_high ⊻= s256.raw_elems_high
    end
    return ImmutableBitSet256(raw_elems_low, raw_elems_high)
end

@inline _half_issubset(this::UInt128, other::UInt128) = iszero(this & ~other)

Base.issubset(this::ImmutableBitSet256, other::ImmutableBitSet256) = _half_issubset(this.raw_elems_low, other.raw_elems_low) && _half_issubset(this.raw_elems_high, other.raw_elems_high)

Base.issetequal(this::ImmutableBitSet256, other::ImmutableBitSet256) = (this.raw_elems_low == other.raw_elems_low) && (this.raw_elems_high == other.raw_elems_high)

@inline _half_isdisjoint(this::UInt128, other::UInt128) = iszero(this & other)

Base.isdisjoint(this::ImmutableBitSet256, other::ImmutableBitSet256) = _half_isdisjoint(this.raw_elems_low, other.raw_elems_low) && _half_isdisjoint(this.raw_elems_high, other.raw_elems_high)

Base.bitstring(this::ImmutableBitSet256) = bitstring(this.raw_elems_high) * bitstring(this.raw_elems_low)

struct GenSquareDimNum{Scalar <: Real, NegOneAxes, ZeroAxes, PosOneAxes} <: Number
    value_map::Base.ImmutableDict{ImmutableBitSet256, Scalar}
end

export ImmutableBitSet256, GenSquareDimSum

end
