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
        "Homework: Day 1" => "homework_1.md",
        "Artificial Neural Networks" => "art_neural_networks.md",
        "Neural Differential Equaions" => "neural_ode.md",
        "Homework: Day 2" => "homework_2.md",
        "Projects" => "projects.md",
    ],
)

#=
deploydocs(;
    repo="github.com/stephans3/SciMLMiniCourse.jl",
    devbranch="main",
)=#
