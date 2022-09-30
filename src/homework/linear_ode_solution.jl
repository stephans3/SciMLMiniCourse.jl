#=
We assume the ordinary differential equation

dx1/dt =  -x1 + 2*x2 + 3*x3
dx2/dt = 4*x1 - 5*x2 + 6*x3
dx3/dt = 7*x1 + 8*x2 - 9*x3

Tasks
1. Determine the stability
-> compute the Eigenvalues

2.  Find the analytical solution for initial values x0=[1,1,1] 
-> x(t)=x0*exp(At)

3. Discretize the system with Euler method and simulate it for 5 seconds
-> use sampling time Ts=0.1 seconds

4. Plot the analytical solution and the solution of the Euler method

5. Compute the solution with OrdinaryDiffEq.jl (or DifferentialEquations.jl)
=#

# Stability
using LinearAlgebra
A = [-1 2 3; 4 -5 6; 7 8 -9]
ev = eigvals(A)

# Find the analytical and numerical solution 
x0 = ones(3) # x0=[1,1,1]
sol_anal(t) =  exp(A*t)*x0

Ts = 0.1 # Sampling time for Euler method
Tf = 5.0 # Final simulation time

tgrid = 0 : Ts : Tf;
ode_sol_analytical = zeros(3, length(tgrid)) # Store anaylical solution
ode_sol_euler = zeros(3, length(tgrid)+1)    # Store numerical solution
ode_sol_euler[:,1] = x0 # Initial values for Euler mehtod

for (i,t) in enumerate(tgrid)
    ode_sol_analytical[:,i] = sol_anal(t) # Analytical solution
    ode_sol_euler[:,i+1] = ode_sol_euler[:,i] + Ts*A*ode_sol_euler[:,i] # Euler method
end

using Plots
plot(tgrid, ode_sol_analytical', labels=["x1" "x2" "x3"], legend=:topleft, yaxis=:log10)
plot!(tgrid, ode_sol_euler[:,1:end-1]', labels=["y1" "y2" "y3"] )


# Solution with OrdinaryDiffEq
using OrdinaryDiffEq
function linear_ode!(dx, x, p, t)
   dx[1] =  -x[1] + 2*x[2] + 3*x[3]
   dx[2] = 4*x[1] - 5*x[2] + 6*x[3]
   dx[3] = 7*x[1] + 8*x[2] - 9*x[3]
end

alg = Tsit5()       # Solution algorithm
tspan = (0., Tf)    # Time span
prob = ODEProblem(linear_ode!, x0, tspan) 
sol = solve(prob, alg, saveat=Ts)

plot(sol, labels=["x1" "x2" "x3"], legend=:topleft, yaxis=:log10) # Plot the solution

# Numerical Error 
err = ode_sol_analytical- sol[:,:] 
plot(tgrid, err')

