function mass_spring(dx, x, p, t)
    u = sin(t)   # external force / input signal
    
    dx[1] = x[2]                # dx1/dt = x2
    dx[2] = -p[1] * x[1] + u    # dx2/dt = -p * x2 + u
end

param = [2.0]       # Parameter p = k/m with k=spring constant, m=mass
x0    = [0.0, 0.0]  # Initial values
tspan = (0.,30.)    # Time span 

using DifferentialEquations
alg   = Tsit5()             # Runge-Kutta integration method
prob  = ODEProblem(mass_spring, x0, tspan)
sol   = solve(prob, alg, p=param)    # Numerical integration with parameter


using Plots
plot(sol, label=["x1" "x2"])

# Set new parameter
p_new   = [5.0] # New parameter
sol_new = solve(prob, alg, p=p_new)    # Numerical integration with parameter
plot(sol_new, label=["x1" "x2"], title="Solution with new parameter")