using SciMLMiniCourse
using Documenter

DocMeta.setdocmeta!(SciMLMiniCourse, :DocTestSetup, :(using SciMLMiniCourse); recursive=true)

makedocs(;
    modules=[SciMLMiniCourse],
    authors="Stephan Scholz",
    repo="https://github.com/stephans3/SciMLMiniCourse.jl/blob/{commit}{path}#{line}",
    sitename="SciMLMiniCourse.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://stephans3.github.io/SciMLMiniCourse.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Quick Julia introduction" => "intro_julia.md",
        "Differential Equations" => "diff_eq.md",
    ],
)

#=
deploydocs(;
    repo="github.com/stephans3/SciMLMiniCourse.jl",
    devbranch="main",
)=#
