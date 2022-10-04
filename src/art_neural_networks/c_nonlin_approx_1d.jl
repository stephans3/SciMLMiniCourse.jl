#=
  This script covers the approximation of a polynomial using a artificial neural network with Flux.

  f(x) = 3 - 0.5x - 1.5x^2 + 0.5x^3
=#

nonlin_fun(x) = 3 - 0.5x - 1.5x^2 + 0.5x^3
N = 50; # Number of samples
x_train, x_test = rand(-2:1e-3:4,1,N), rand(-4:0.1:6,1,N)
y_train, y_test = nonlin_fun.(x_train), nonlin_fun.(x_test)

using Flux
Nn = 64 # Number of neurons per layer

# ANN Model with 2 hidden layers
model = Chain(
  Dense(1 => Nn, σ),   # from input layer to 1. hidden layer
  Dense(Nn => Nn, σ),  # from 1. hidden layer to 2. hidden layer
  Dense(Nn => 1))      # from 2. hidden layer to output layer

params     = Flux.params(model)             # Model parameters
loss(x, y) = Flux.Losses.mse(model(x), y);  # Loss function: mean-squared-error

model(x_train)
println("Loss of training data: ", loss(x_train, y_train))
println("Loss of test data: ", loss(x_test, y_test))

opt = Descent() # Optimization method
data = [(x_train, y_train)]

using Flux: train!
train!(loss, params, data, opt) # 1 Training step
println("Loss of training data: ", loss(x_train, y_train))

N_epoch = 20000;            # Number of training iterations
loss_res = zeros(N_epoch);  # Array to save loss values

for epoch in 1:N_epoch
    train!(loss, params, data, opt)         # Train iteratively the ANN model
    loss_res[epoch] = loss(x_train, y_train)
end

using Plots
plot(loss_res, yaxis=:log10, title="Loss value per iteration")

scatter(x_train', model(x_train)', title="Training data")
scatter(x_test', model(x_test)', title="Test data")
