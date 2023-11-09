Base.real(gsdnum::GSDNum) = get(gsdnum, axial_sets())

Base.imag(gsdnum::GSDNum) = get(gsdnum, axial_sets(nsq = :i))

Base.zero(::Type{GSDNum{S}}) where {S<:Real} = GSDNum{S}()
Base.zero(::Type{GSDNum}) = zero(GSDNum{Bool})

Base.one(::Type{GSDNum{S}}) where {S<:Real} = GSDNum{S}(axial_sets() => one(S))
Base.one(::Type{GSDNum}) = one(GSDNum{Bool})

Base.oneunit(::Type{GSDNum{S}}) where {S<:Real} = GSDNum{S}(axial_sets() => oneunit(S))
Base.oneunit(::Type{GSDNum}) = oneunit(GSDNum{Bool})

Base.:-(gsdnum::GSDNum{S}) where {S<:Real} =
    GSDNum{S}(map(p -> p.first => -(p.second), gsdnum.coeff_map)...)

Base.conj(gsdnum::GSDNum{S}) where {S<:Real} = GSDNum{S}(
    get(gsdnum, axial_sets()),
    (
        map(gsdnum.coeff_map) do p
            p.first =>
                (isempty(p.first.nsq) && isempty(p.first.osq) ? p.second : -(p.second))
        end
    )...,
)
