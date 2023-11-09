const AxialSet = Set{Symbol}
const AnyAxialSet = AbstractSet{Symbol}
const AxialSets = @NamedTuple{nsq::AxialSet, zsq::AxialSet, osq::AxialSet}
const AnyAxialSets = (
    @NamedTuple{
        nsq::NSq,
        zsq::ZSq,
        osq::OSq,
    } where {NSq<:AnyAxialSet,ZSq<:AnyAxialSet,OSq<:AnyAxialSet}
)
const CoeffsMap{Scalar} = Dict{AxialSets,Scalar}
const AnyCoeffsMap = Dict{<:AnyAxialSets,<:Real}

function axial_sets(
    other::AnyAxialSets;
    nsq = nothing,
    zsq = nothing,
    osq = nothing,
)::AxialSets
    local nsq_a::Vector{Symbol}
    if isnothing(nsq)
        nsq_a = Symbol[]
    elseif nsq isa Symbol
        nsq_a = [nsq]
    else
        nsq_a = [nsq...]
    end
    append!(nsq_a, other.nsq)

    local zsq_a::Vector{Symbol}
    if isnothing(zsq)
        zsq_a = Symbol[]
    elseif zsq isa Symbol
        zsq_a = [zsq]
    else
        zsq_a = [zsq...]
    end
    append!(zsq_a, other.zsq)

    local osq_a::Vector{Symbol}
    if isnothing(osq)
        osq_a = Symbol[]
    elseif osq isa Symbol
        osq_a = [osq]
    else
        osq_a = [osq...]
    end
    append!(osq_a, other.osq)

    return (; nsq = Set(nsq_a), zsq = Set(zsq_a), osq = Set(osq_a))
end

struct GSDNum{Scalar<:Real} <: Number
    coeffs_map::CoeffsMap{Scalar}
    GSDNum{Scalar}(coeffs_map::CoeffsMap{Scalar}) where {Scalar<:Real} =
        new{Scalar}(filter!(p -> !iszero(p.second), deepcopy(coeffs_map)))
end

GSDNum{Scalar}(coeffs_map::AnyCoeffsMap) where {Scalar<:Real} =
    GSDNum{Scalar}(convert(CoeffsMap{Scalar}, coeffs_map))
GSDNum(coeffs_map::AnyCoeffsMap) = GSDNum{valtype(coeffs_map)}(coeffs_map)

GSDNum{Scalar}(monomials::Pair{<:AnyAxialSets,<:Real}...) where {Scalar<:Real} =
    GSDNum{Scalar}(CoeffsMap{Scalar}(convert.(Pair{AxialSets,Scalar}, monomials)))
GSDNum(
    monomial::Pair{<:AnyAxialSets,S},
    monomials::Pair{<:AnyAxialSets,S}...,
) where {S<:Real} = GSDNum{S}(monomial, monomials...)
GSDNum() = GSDNum{Bool}()

Base.get(gsdnum::GSDNum{Scalar}, ix::AnyAxialSets) where {Scalar<:Real} =
    convert(Scalar, get(gsdnum.coeffs_map, ix) do
        zero(Scalar)
    end)

Base.broadcastable(gsdnum::GSDNum) = Ref(gsdnum)
