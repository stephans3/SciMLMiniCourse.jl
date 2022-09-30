#=
We assume the mathematical pendulum

ϕ'(t) = ω(t)
ω'(t) = -g/l * sin(ϕ(t))

1. Compute the solution with OrdinaryDiffEq
-> Initial values (ϕ₀, ω₀) = (π/4, 0)
-> Time span: t ∈ (0,5) seconds
-> Use parameter p = g/l with l=0.1

2. Plot your results

3. Vary the length from 0.1 to 1 meter

=#

# Compute solution
using OrdinaryDiffEq
function pendulum!(dx, x, p, t)
    dx[1] = x[2]               
    dx[2] = -p[1] * sin(x[1])
end

l = 0.1;  # length of pendulum
g = 9.81; # gravity constant 

x0    = [pi/4, 0.0]
tgrid = (0.,5.)
param = [g/l]

alg = Tsit5()
prob = ODEProblem(pendulum!, x0, tgrid)
sol  = solve(prob, alg, p=param)

# Plot results
using Plots
plot(sol, label=["ϕ" "ω"])


# Variable length of pendulum
l_pendulum = 0.1 : 0.1 : 1

for len in l_pendulum
    param = [g/len]     # Define new parameter
    sol_vary_len  = solve(prob, alg, p=param) # Solve ODE
    
    # Plot results
    title_pendulum = "Pendulum with length " * string(len)
    plt = plot(sol_vary_len, label=["ϕ" "ω"], title=title_pendulum)
    display(plt)
end