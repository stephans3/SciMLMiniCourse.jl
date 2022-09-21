# Differential Equations

Differential Equations are mathematical structures which can be used to model physical, biological, chemical, economical/financial and social models. 



#### [Ordinary Differential Equations (ODE)](https://en.wikipedia.org/wiki/Ordinary_differential_equation)
*Van der Pol oscillator*

$\ddot{y}(t) - \mu (1 - y(t)^2) \dot{y}(t) + y(t) = 0$

#### [Differential-Algebraic Equation (DAE)](https://en.wikipedia.org/wiki/Differential-algebraic_system_of_equations)
$\begin{matrix}
\dot{x}(t) = & -2x(t) + 3y(t) \\
\dot{y}(t) = & -3x(t) \\
0 = & x(t) + y(t)
\end{matrix}$

Applications e.g. in Robotics (multibody dynamics) and Electrical Engineering (circuit modeling).

#### [Stochastic Differential Equation (SDE)](https://en.wikipedia.org/wiki/Stochastic_differential_equation)
*Langevin equation*

$m \frac{d v(t)}{dt} = - \lambda v(t) + \eta(t)$
with noise term $\eta(t)$

Applications e.g. in biology. 

#### [Partial Differential Equation (PDE)](https://en.wikipedia.org/wiki/Partial_differential_equation)
*Heat Equation* 

$\frac{\partial y(t,x)}{\partial t} = \alpha \frac{\partial^2 y(t,x)}{\partial x^2}$

Applications in continuum mechanics (Navier-Stokes equations), electromagnetism (Maxwell–Heaviside equations), etc. 

#### Mixtures and other types
- [Stochastic PDE](https://en.wikipedia.org/wiki/Stochastic_partial_differential_equation)
- [Partial-Differential-Algebraic Equations](https://en.wikipedia.org/wiki/Partial_differential_algebraic_equation) 
- [Integro-differential equations](https://en.wikipedia.org/wiki/Integro-differential_equation)
- [Delay differential equations](https://en.wikipedia.org/wiki/Delay_differential_equation)


## About ODEs

In this course we will focus on ODEs. Nevertheless, the existing SciML methods can also be used for other types of differential equations. As a first step in the study of an ODE we distinguish between linear and nonlinear equations. Many easy concepts from linear algebra exist to investigate [linear ODEs](https://en.wikipedia.org/wiki/Linear_differential_equation). These concepts can not (or only up to some limit) be applied on nonlinear ODE and so we have to use methods from systems theory ([Lyapunov stability](https://en.wikipedia.org/wiki/Lyapunov_stability)) or differential geometry like Lie derivatives, differential flatness, etc.

If we study a linear ODE $\dot{x}(t) = A ~ x(t)$ we can determine the behaviour of its $x(t)$ for $t \rightarrow \infty$ via its stability (in the sense of Lyapunov). If (and only iff) all Eigenvalues of system matrix $A$ smaller than zero (negative) then we call call the ODE stable and we know that all states approaching zero at $t \rightarrow \infty$

#### Example: Linear ODE

The ordinary differential equation

$\begin{pmatrix}
\dot{x}_{1}(t) \\
\dot{x}_{2}(t)
\end{pmatrix} =
\begin{pmatrix}
-2 & ~1 \\
~3 & -4 
\end{pmatrix}
\begin{pmatrix}
x_{1}(t) \\
x_{2}(t)
\end{pmatrix}$

has the Eigenvalues $\lambda \in \{-1, -5\}$. So the ODE is stable and all states reach for arbitrary initial values $x_{0}$ the origin $(0,0)$.

In Julia we can prove this with method `eigvals()` from the standard library [LinearAlgebra.jl](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/).

```julia
A = [-2 1; 3 -4];

using LinearAlgebra
evals = eigvals(A)
```

The true solution of this ODE is
$x(t)=\exp(A~t) ~ x_{0}$ 

#### Euler method

The differential equation $\dot{x}(t)=A~x(t)$ can also be solved numerically. The forward Euler method is one of the easiest numerical integration methods. It is briefly described by

$\dot{x}(t) \approx \frac{x(n+1) - x(n)}{\Delta T} = A ~ x(n)$

and can be rearranged as

$x(n+1) = x(n) + \Delta T ~ A~x(n) = (I + \Delta T ~ A) ~ x(n)$

with identity matrix $I$. The sampling time $\Delta T>0$ has to be chosen such that all Eigenvalues of matrix $A_{d} = I + \Delta T ~ A$ are inside the unit circle. So, we guarantee a [stable numerical integration; see also: A-Stability](https://en.wikipedia.org/wiki/Stiff_equation#A-stability).

```julia
Tf = 10.0;  # Final simulation time
ΔT = 0.25;  # Sampling time
N  = round(Int, Tf/ΔT + 1); # Number of sampling points
x = zeros(2, N)       # Solution of Euler method
x[:,1] = x0           # Set initial value

for i in range(1,N-1)
    x[:,i+1] = x[:,i] + ΔT * A*x[:,i] # Euler method: x(n+1)=x(n)+ΔT*A*x(n)
end
```

#### Runge-Kutta methods via DifferentialEquations.jl

The Euler method has a very weak performance and is rather used for tests. In contrast, n-th order [Runge-Kutta methods](https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta_methods) provide much more better integration tools. A lot of integration methods is already implemented in [DifferentialEquations.jl](https://diffeq.sciml.ai/stable/). A list of all integration methods [can be found in section "ODE Solvers"](https://diffeq.sciml.ai/stable/solvers/ode_solve/). 

**I recommend to read the [tutorial about Ordinary Differential Equations](https://diffeq.sciml.ai/stable/tutorials/ode_example/).**

```julia
using DifferentialEquations
linear_ode(x,p,t) = A * x   # Right-hand side of ODE x'(t)=A x(t)
tspan = (0.,Tf)             # Time span 
alg   = Tsit5()             # Runge-Kutta integration method
prob  = ODEProblem(linear_ode, x0, tspan)
sol   = solve(prob, alg, saveat=ΔT)    # Solution of numerical integration
```

## Parameters

One main questions of this course is how to compute system parameters. We know for many processes the system dynamics which is described by parameters. However, quite often we do not know the certain parameters. In case of a spring mass system we derive the ODE as

$m \ddot{x}(t) + k x(t) = u(t)$

or equivalent 

$\ddot{x}(t) = -\frac{k}{m} x(t) + u(t) = -p ~ x(t) + u(t)$

with mass $m>0$ and spring constant $k>0$ as parameters and $u(t)$ as external force (or input signal). Both parameters are united as $p=\frac{k}{m}$. We assume the input $u(t)=sin(t)$ and develop the right-hand side of this ODE.

```julia
function mass_spring(dx, x, p, t)
    u = sin(t)   # external force / input signal
    
    dx[1] = x[2]                # dx1/dt = x2
    dx[2] = -p[1] * x[1] + u    # dx2/dt = -p * x2 + u
end
```

The time span, initial values $x_0 = (0,0)^{\top}$ and the parameter $p=\frac{k}{m}=2$ have to be defined.

```julia
param = [2.0]       # Parameter p = k/m with k=spring constant, m=mass
x0    = [0.0, 0.0]  # Initial values
tspan = (0.,30.)    # Time span 
```

The parameter can be handed over to the solver in `ODEProblem(...,p=param)` or in `solve(,p=param)`. I recommend to use `solve(,p=param)` because in the Machine Learning part we will build the ODEProblem once and use `solve` repeatedly.

```julia
using DifferentialEquations
alg   = Tsit5()             # Runge-Kutta integration method
prob  = ODEProblem(mass_spring, x0, tspan)
sol   = solve(prob, alg, p=param)    # Numerical integration with parameter
```

See also: (Defining Parametrized Functions)[https://diffeq.sciml.ai/stable/tutorials/ode_example/#Defining-Parameterized-Functions] in the DifferentialEquations docs.