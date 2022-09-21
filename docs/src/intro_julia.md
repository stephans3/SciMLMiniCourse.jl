# Quick introduction to Julia

When you installed the Julia environment on your PC, please open the Julia executive. The REPL will show you something like
```julia
julia>
```

Here you can try typical commands like
```julia
julia> 1+1
2

julia> println("Hello World")
Hello World

julia> foo(x) = x
julia> foo(3)
3
```

If you want to develop scripts or packages then it you may use a text editor.
You can write some code like
```julia
a = 3;
b = 5;
c = a + b

function myfun(x,y)
    return x+y
end
```
Save your code, here "my_demo_file.jl". Now you can open and run your script in the REPL.

```julia
julia> include("path/to_my_file/my_demo_file.jl")
```

Now, the variables `a`, `b` and `c` and the function `myfun` are in your environment.
```julia
julia> a
3

julia> b
5

julia> c
8

julia> myfun(4,5)
9
```

## Visual Studio Code

High level editors like VS Code simplify the usage of Julia. VS Code supports [Julia with its extension](https://www.julia-vscode.org/). See also its [documentation](https://www.julia-vscode.org/docs/stable/) for the installation guide. 

## Installing Packages

Julia has an own [Package Manager called Pkg](https://docs.julialang.org/en/v1/stdlib/Pkg/). You can reach it in the REPL if you press `]` and you can leave it with backspace. If you want to install a package, e.g. the standard plotting library  `Plots` then open the REPL and...

```julia
julia> ]

pkg>

pkg> add Plots
```

