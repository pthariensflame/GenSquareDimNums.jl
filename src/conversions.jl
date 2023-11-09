Base.promote_rule(::Type{GSDNum{S1}}, ::Type{GSDNum{S2}}) where {S1<:Real,S2<:Real} =
    GSDNum{promote_type(S1, S2)}

GSDNum{Scalar}(real_part::Real) where {Scalar<:Real} =
    GSDNum{Scalar}(axial_sets() => real_part)
GSDNum(real_part::S) where {S<:Real} = GSDNum{S}(real_part)

Base.convert(T::Type{<:GSDNum}, v::Union{Real,Complex}) = T(v)

Base.promote_rule(::Type{GSDNum{S1}}, ::Type{S2}) where {S1<:Real,S2<:Real} =
    GSDNum{promote_type(S1, S2)}

GSDNum{Scalar}(z::Complex) where {Scalar<:Real} =
    GSDNum{S}(axial_sets() => real(z), axial_sets(nsq = :i) => imag(z))
GSDNum(z::Complex{S}) where {S<:Real} = GSDNum{S}(z)

Base.convert(::Type{GSDNum{S}}, other::GSDNum) where {S<:Real} = GSDNum{S}(other.coeffs_map)

Base.promote_rule(::Type{GSDNum{S1}}, ::Type{Complex{S2}}) where {S1<:Real,S2<:Real} =
    GSDNum{promote_type(S1, S2)}
