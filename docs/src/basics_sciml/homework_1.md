# Homework: Differential Equations

Read the DifferentialEquations.jl documentation about [Ordinary Differential Equations](https://diffeq.sciml.ai/stable/tutorials/ode_example/) and solve the following exercises.


## Linear ODE
We assume the ordinary differential equation

```math
\dot{x}_{1}(t) =  -x_1 + 2 ~ x_2 + 3 ~ x_3 \\
\dot{x}_{2}(t) = 4~x_1 - 5~x_2 + 6~x_3 \\
\dot{x}_{3}(t) = 7~x_1 + 8~x_2 - 9~x_3
```

**Tasks**
1. Is this ODE stable? Compute the Eigenvalues.
2. Find the analytical solution for initial values $x(0)=(1,1,1)^{\top}$.
3. Discretize the system with Euler method and simulate it for $T_f=5$ seconds.
4. Plot the analytical solution and the solution of the Euler method. You may use the option ` yaxis=:log10` in `plot()` for a better readability.
5. Compute the solution with DifferentialEquations.jl or OrdinaryDiffEq.jl (which is a sub-library of DifferentialEquations.jl).

## Mathematical Pendulum
We assume the mathematical pendulum

```math
\dot{\phi}(t) = \omega(t) \\
\dot{\omega}(t) = -\frac{g}{l} ~ \sin(\phi(t))
```
with angle $\phi$, angle velocity $\omega$, gravitational acceleration $g=9.81$ and lenght $l>0$. 

**Tasks**
1. Compute the solution with DifferentialEquations.jl or OrdinaryDiffEq.jl
    - Assume the initial values $(\phi_0,\omega_0)=(π/4,0)^{\top}$ and simulation time $T_{f}=5$ seconds.
    - Use parameter $p=\frac{g}{l}$ with $l=0.1$.
2. Plot your results.
3. Vary the length from $l=0.1$ to $l=1$ meter.