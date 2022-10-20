function rlc_ode!(dx, x, p, t)    
    u = 1

    dx[1] = x[2]
    dx[2]  = -p[1] * x[1] - p[2] * x[2] + p[1] * u  
end

using OrdinaryDiffEq

x0 = [0.0, 0.0]; # Initial ode values
Tf = 30;         # Simulation time
tspan = (0, Tf);

R = 1; # Resistance
L = 2; # Inductance
C = 3; # Capacitance

pars = [1/(L*C), R/L];

prob = ODEProblem(rlc_ode!, x0, tspan)
alg = Tsit5()
Ts = 1; # Save at time steps
sol = solve(prob, alg, p=pars, saveat=Ts)

using Plots
plot(sol, label=["x₁" "x₂"], legend=:right)


function loss(p)
    sol_grey = solve(prob, alg, p=p, saveat=Ts)
    l = sum(abs2, sol - sol_grey)

    return l
end

LOSS  = []     # Loss accumulator
PARS  = []     # parameters accumulator

callback = function (p, l)
    display(l)

    append!(LOSS, l)
    append!(PARS, [p])

    # Tell sciml_train to not halt the optimization. If return true, then
    # optimization stops.

    #=
    if l < 1e3 # 0.1
        return true
    end
    =#

    return false
end


pinit = [0.6,0.1] 
loss(pinit)

using Optimization, OptimizationPolyalgorithms
adtype = Optimization.AutoZygote()
optf = Optimization.OptimizationFunction((x,p)->loss(x), adtype)
optprob = Optimization.OptimizationProblem(optf, pinit)

ml_sol = Optimization.solve(optprob, PolyOpt(),
                                callback = callback,
                                maxiters = 100)

loss(ml_sol)


scatter(sol, label=["x₁ original" "x₂ original"])
sol_init = solve(prob, alg, p=pinit)
plot!(sol_init, label=["x₁ init" "x₂ init"], legend=:right)

sol_ml = solve(prob, alg, p=ml_sol)
p = plot!(sol_ml, label=["x₁ found" "x₂ found"], legend=:right)

p_path = "images/rlc_grey_box.pdf"
savefig(p, p_path)