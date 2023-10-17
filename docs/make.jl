using GenSquareDimNums
using Documenter

DocMeta.setdocmeta!(GenSquareDimNums, :DocTestSetup, :(using GenSquareDimNums); recursive=true)

makedocs(;
    modules=[GenSquareDimNums],
    authors="Laine Taffin Altman <alexanderaltman@me.com> and contributors",
    repo="https://github.com/Laine Taffin Altman/GenSquareDimNums.jl/blob/{commit}{path}#{line}",
    sitename="GenSquareDimNums.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Laine Taffin Altman.github.io/GenSquareDimNums.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Laine Taffin Altman/GenSquareDimNums.jl",
    devbranch="main",
)
