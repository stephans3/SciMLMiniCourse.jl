```@meta
CurrentModule = SciMLMiniCourse
```

# Mini Course on Scientific Machine Learning (SciML)

This mini course is based on [Julia programming language](https://julialang.org/) and covers the following topics
1. Quick introduction / repetition of differential equations
    - See: [DifferentialEquations.jl](https://diffeq.sciml.ai/stable/)
2. Artificial Neural Networks 
    - [Flux.jl](https://fluxml.ai/) for *standard* Machine Learning 
    - [Lux.jl](http://lux.csail.mit.edu/dev/) as ML backend for SciML
3. Neural Ordinary Differential Equations 
    - [DiffEqFlux.jl](https://diffeqflux.sciml.ai/dev/) for Neural ODEs
    - [SciMLSensitivity.jl](https://sensitivity.sciml.ai/stable/) for Parameter Estimation and Sensitivity Analysis
    - [Optimization.jl](http://optimization.sciml.ai/stable/) Meta-Package for Optimization tools
4. Sensitivity Analysis
    - [ForwardDiff.jl](https://github.com/JuliaDiff/ForwardDiff.jl/) for Forward Differentiation
    - [Zygote.jl](https://fluxml.ai/Zygote.jl/dev/) for Automatic Differentiation


## What is SciML?
In Scientific Machine Learning we use ideas and tools from machine learning like artificial neural network, optimizers or automatic differentiation and apply them on problems from natural sciences and engineering. In other words as noted on [webpage scientific-ml.com](https://www.scientific-ml.com/): "...the development and mathematical theory of machine learning techniques for applications in computational science and engineering".

In natural sciences and engineering we describe our ideas and models with formulas, for instance differential equations. We run experiments to gain data which we compare with our theoretical model. The more data we have the more precisly we can specify our model.

**Falling body example**

We assume we let an object fall down from $x=10$ meter, we measure the time until it hits the ground and we want to find the local gravity constant $g$. This model is described by formula 
$x(t) = \frac{g}{2} ~ t^2$ or equally $g = \frac{2}{t^2} ~ x$.

Our time measurements and found gravity constants are

| Experiment | Time [s] |  Gravity constant [$\frac{m}{s^2}$] |
| ---------- | -------- | -------- |
| 1 | 1.51 |  8.77 |
| 2 | 1.40 | 10.20 |
| 3 | 1.39 | 10.35 |
| 4 | 1.47 |  9.26 |
| 5 | 1.44 |  9.65 |

The mean gravity constant is $\overline{g} = \frac{\sum g_{i}}{5} \approx 9.65 ~ \frac{m}{s^2}$. 

In case of such small and easy models the proposed manual computation may work well. However, in case of complex models like *bio-chemical reactions*, *energy distribution networks* or *quantum mechanics* with hundreds or thousands of formulas and parameters the computation is unknown variables or parameters is much more expensive. So, we need powerful computational tools to handle such problems. 


## Learn about Julia
If you are new to Julia then I recommend to learn about it:
- Wikibooks: [Introducing Julia](https://en.wikibooks.org/wiki/Introducing_Julia)
- Blog: [The Julia Programming Language: an Effective Tutorial](https://www.matecdev.com/posts/julia-tutorial-science-engineering.html)
- Youtube: [Learn Julia with Us](https://www.youtube.com/playlist?list=PLP8iPy9hna6TbWJ-Uo-qkKRVFpHuCyivG)
- [Many more resources can be found here](https://julialang.org/learning/)

## Requirements
- Computer with Windows/Linux/MacOS/FreeBSD
- (Latest) Julia installation, see: [Download Julia](https://julialang.org/downloads/)
- Text editor like Notepad++, Gedit, Visual Studio Code, (Atom)

Not required but can be also used:
- Jupyter Notebooks, see [IJulia.jl](https://github.com/JuliaLang/IJulia.jl)

## Further ressources about SciML
- [Parallel Computing and Scientific Machine Learning (SciML): Methods and Applications](https://book.sciml.ai/)
- [Introduction to Computational Thinking](https://computationalthinking.mit.edu/Spring21/)
- List of tutorials: [SciMLTutorials.jl: Tutorials for Scientific Machine Learning and Differential Equations](https://tutorials.sciml.ai/stable/)


Documentation for [SciMLMiniCourse](https://github.com/stephans3/SciMLMiniCourse.jl).

```@index
```

```@autodocs
Modules = [SciMLMiniCourse]
```
