#=
    Function approximation with Lux.jl
    f(x) = 3 - 0.5x - 1.5x^2 + 0.5x^3
=#
import Lux
import Optimisers, Plots, Random, Statistics, Zygote
using NNlib

nonlin_fun(x) = 3 - 0.5x - 1.5x^2 + 0.5x^3
N = 50;                       # Number of samples
rng = Random.default_rng()    # Random number generator
x_train = rand(rng,-2:1e-3:4,1,N)
y_train = nonlin_fun.(x_train)

using Plots
scatter(x_train, y_train, legend=false)

Nn = 64 # Number of neurons per hidden layer
model = Lux.Chain(
    Lux.Dense(1 => Nn, σ),
    Lux.Dense(Nn => Nn, σ),
    Lux.Dense(Nn => 1))

ps, st = Lux.setup(rng, model)
model(x_train, ps, st)

import Optimisers, Statistics
opt = Optimisers.Descent()

function loss_function(model, ps, st, data)
    y_pred, st = Lux.apply(model, data[1], ps, st)
    mse_loss = Statistics.mean(abs2, y_pred .- data[2])
    return mse_loss, st, ()
end


tstate = Lux.Training.TrainState(rng, model, opt; transform_variables=Lux.gpu)
vjp_rule = Lux.Training.ZygoteVJP()

function main(tstate :: Lux.Training.TrainState, 
                vjp  :: Lux.Training.AbstractVJP, 
                data :: Tuple,
                epochs::Int)
    data = data .|> Lux.gpu
    for epoch in 1:epochs
        grads, loss, stats, tstate = Lux.Training.compute_gradients(vjp, loss_function,
                                                                    data, tstate)
        #@info epoch=epoch loss=loss
        tstate = Lux.Training.apply_gradients(tstate, grads)
    end
    return tstate
end

N_epoch = 20000; # Number of epochs
tstate = main(tstate, vjp_rule, (x_train, y_train), N_epoch)
y_pred = Lux.cpu(Lux.apply(tstate.model, Lux.gpu(x_train), tstate.parameters, tstate.states)[1])

scatter(x_train', y_train', title="Original training data")
scatter(x_train', y_pred', title="Predicted data")
