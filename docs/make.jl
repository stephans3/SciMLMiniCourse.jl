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
        "Introduction to Julia programming" => Any[
        "intro_programming/intro_julia.md",
        "intro_programming/arrays_loops.md",
        "intro_programming/num_integration_diff.md",
        "intro_programming/finite_diff_2d.md"
        ],
        "Basics of Scientific Machine Learning" => [
        "basics_sciml/diff_eq.md",
        "basics_sciml/homework_1.md",
        "basics_sciml/art_neural_networks.md",
        "basics_sciml/neural_ode.md",
        "basics_sciml/homework_2.md"],
        "Projects" => "projects.md",
    ],
)

#=
deploydocs(;
    repo="github.com/stephans3/SciMLMiniCourse.jl.git",
    # repo="github.com/stephans3/SciMLMiniCourse.jl",
    # devbranch="main",
)=#


