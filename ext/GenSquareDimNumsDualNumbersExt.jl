module GenSquareDimNumsDualNumbersExt
using GenSquareDimNums, DualNumbers

GSDNum{S}(d::Dual{<:Real}) where {S<:Real} =
    GSDNum{S}(axial_sets() => realpart(d), axial_sets(zsq = :ϵ) => dualpart(d))
GSDNum(d::Dual{S}) where {S<:Real} = GSDNum{S}(d)

GSDNum{S}(d::Dual{<:Complex}) where {S<:Real} = GSDNum{S}(
    axial_sets() => real(realpart(d)),
    axial_sets(zsq = :ϵ1) => real(dualpart(d)),
    axial_sets(nsq = :i) => imag(realpart(d)),
    axial_sets(nsq = :i, zsq = :ϵ1) => imag(dualpart(d)),
)
GSDNum(d::Dual{Complex{S}}) where {S<:Real} = GSDNum{S}(d)

Base.convert(T::Type{<:GSDNum}, v::Dual) = T(v)

Base.promote_rule(::Type{GSDNum{S1}}, ::Type{Dual{S2}}) where {S1<:Real,S2<:Real} =
    GSDNum{promote_type(S1, S2)}

Base.promote_rule(::Type{GSDNum{S1}}, ::Type{Dual{Complex{S2}}}) where {S1<:Real,S2<:Real} =
    GSDNum{promote_type(S1, S2)}

DualNumbers.realpart(gsdnum::GSDNum) = get(gsdnum, axial_sets())

DualNumbers.dualpart(gsdnum::GSDNum) = get(gsdnum, axial_sets(zsq = :ϵ))

end
