using DifferentialEquations, Flux, Plots
tspan = (0.0f0,8.0f0)
Nn = 64;
ann = Flux.Chain(Flux.Dense(1,Nn,tanh), Flux.Dense(Nn,Nn,tanh), Flux.Dense(Nn,1))
pinit, re = Flux.destructure(ann)

function rlc_ode!(dx, x, p, t)    
    u = re(p)([t])[1]

    a1 = 1/(L*C)
    a2 = R/L

    dx[1] = x[2]
    dx[2]  = -a1 * x[1] - a2 * x[2] + a1 * u  
end

x0 = [0.0, 0.0];
Tf = 30;
tspan = (0, Tf);

R = 1;
L = 2; 
C = 3;

prob = ODEProblem(rlc_ode!, x0, tspan)
alg = Tsit5()
Ts = 1.; # Save at time steps
sol = solve(prob, alg, p=pinit, saveat=Ts)
plot(sol, label=["x₁" "x₂"], legend=:right)


ref(t)= 5*(1- exp(-0.2t))
ref_traj = ref.(sol.t)
function loss(p)
    sol_pred = solve(prob, alg, p=p, saveat=Ts)

    if sol_pred.retcode == :Success
        yout =  sol_pred[1,:]
        l = sum(abs2, ref_traj - yout)
    else
        l = Inf
    end

    return l
end

#LOSS  = []     # Loss accumulator
#PARS  = []     # parameters accumulator

function callback1(p, l)
    display(l)

    #append!(LOSS, l)
    #append!(PARS, [p])

    # Tell sciml_train to not halt the optimization. If return true, then
    # optimization stops.

    if l < 60 #100 # 0.1
        return true
    end


    return false
end

function callback2(p, l)
    display(l)

    #append!(LOSS, l)
    #append!(PARS, [p])

    # Tell sciml_train to not halt the optimization. If return true, then
    # optimization stops.

    if l < 0.1 # 50 # 0.1
        return true
    end


    return false
end


loss(pinit)

using Optimization, OptimizationFlux, OptimizationOptimJL, SciMLSensitivity
adtype = Optimization.AutoZygote()
optf   = Optimization.OptimizationFunction((x,p)->loss(x), adtype)

optprob = Optimization.OptimizationProblem(optf, pinit)
ml_sol = Optimization.solve(optprob, ADAM(0.5), callback = callback1,maxiters=100)

optprob2 = Optimization.OptimizationProblem(optf, ml_sol.u)
ml_sol2 = Optimization.solve(optprob2, BFGS(), callback = callback2, maxiters=100, allow_f_increases = false)

sol_prev = solve(prob, alg, p=pinit)
sol_opti = solve(prob, alg, p=ml_sol2)

p1 = plot(sol_prev, label=["x₁" "x₂"], legend=:right)

plot(sol_opti, label=["x₁" "x₂"], legend=:right)
p2 = scatter!(sol.t, ref_traj, label="ref")

p1_path = "images/opt_control_ann_initial.pdf"
p2_path = "images/opt_control_ann_trained.pdf"

savefig(p1, p1_path)
savefig(p2, p2_path)

