module GenSquareDimNumsHyperDualNumbersExt
using GenSquareDimNums, HyperDualNumbers

GSDNum{S}(d::Hyper{<:Real}) where {S<:Real} =
    GSDNum{S}(axial_sets() => realpart(d), axial_sets(zsq = :ϵ) => dualpart(d))
GSDNum(d::Hyper{S}) where {S<:Real} = GSDNum{S}(d)

GSDNum{S}(d::Hyper{<:Complex}) where {S<:Real} = GSDNum{S}(
    axial_sets() => real(value(d)),
    axial_sets(zsq = :ϵ1) => real(epsilon1(d)),
    axial_sets(zsq = :ϵ2) => real(epsilon2(d)),
    axial_sets(zsq = (:ϵ1, :ϵ2)) => real(epsilon12(d)),
    axial_sets(nsq = :i) => imag(value(d)),
    axial_sets(nsq = :i, zsq = :ϵ1) => imag(epsilon1(d)),
    axial_sets(nsq = :i, zsq = :ϵ2) => imag(epsilon2(d)),
    axial_sets(nsq = :i, zsq = (:ϵ1, :ϵ2)) => imag(epsilon12(d)),
)
GSDNum(d::Hyper{Complex{S}}) where {S<:Real} = GSDNum{S}(d)

Base.convert(T::Type{<:GSDNum}, v::Hyper) = T(v)

Base.promote_rule(::Type{GSDNum{S1}}, ::Type{Hyper{S2}}) where {S1<:Real,S2<:Real} =
    GSDNum{promote_type(S1, S2)}

Base.promote_rule(
    ::Type{GSDNum{S1}},
    ::Type{Hyper{Complex{S2}}},
) where {S1<:Real,S2<:Real} = GSDNum{promote_type(S1, S2)}

HyperDualNumbers.value(gsdnum::GSDNum) = get(gsdnum, axial_sets())

HyperDualNumbers.epsilon1(gsdnum::GSDNum) = get(gsdnum, axial_sets(zsq = :ϵ1))

HyperDualNumbers.epsilon2(gsdnum::GSDNum) = get(gsdnum, axial_sets(zsq = :ϵ2))

HyperDualNumbers.epsilon12(gsdnum::GSDNum) = get(gsdnum, axial_sets(zsq = (:ϵ1, :ϵ2)))

end
