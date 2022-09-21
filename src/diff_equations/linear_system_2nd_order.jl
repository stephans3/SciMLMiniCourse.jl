A = [-2 1; 3 -4]; # System matrix

using LinearAlgebra
evals = eigvals(A) # Eigenvalues

x0 = [3,5];

# True solution
x_true(t) = exp(A*t)*x0

# Euler metod
Tf = 10.0;  # Final simulation time
ΔT = 0.25;  # Sampling time
N  = round(Int, Tf/ΔT + 1); # Number of sampling points
x_euler = zeros(2, N)       # Solution of Euler method
x_euler[:,1] = x0           # Set initial value

for i in range(1,N-1)
    x_euler[:,i+1] = x_euler[:,i] + ΔT * (A*x_euler[:,i]) # Euler method: x(n+1)=x(n)+ΔT*A*x(n)
end

using Plots
tg = 0.0 : ΔT : Tf  # Time grid 
plot(tg, x_euler', label=["x1" "x2"], title="Euler method")               # Plot numerical solution
scatter!(tg, hcat(x_true.(tg)...)', label=["x1 true" "x2 true"]) 

# Numerical error
err1 = hcat(x_true.(tg)...) - x_euler
scatter(tg, err1', title="Numerical error")


# Runge-Kutta method
using DifferentialEquations
linear_ode(x,p,t) = A * x   # Right-hand side of ODE x'(t)=A x(t)
tspan = (0.,Tf)             # Time span 
alg   = Tsit5()             # Runge-Kutta integration method
prob  = ODEProblem(linear_ode, x0, tspan)
sol   = solve(prob, alg, saveat=ΔT)    # Solution of numerical integration

using Plots
plot(sol, label=["x1" "x2"], title="Runge-Kutta method")               # Plot numerical solution
scatter!(sol.t, hcat(x_true.(sol.t)...)', label=["x1 true" "x2 true"])   # Plot analytical solution

# Numerical error
err2 = hcat(x_true.(tg)...) - sol[:,:]
scatter(tg, err2', title="Numerical error")