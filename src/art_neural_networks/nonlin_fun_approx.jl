#=
    This script covers the approximation of a polynomial using a artificial neural network with Flux.

   f(x) = 3 - 0.5x - 1.5x^2 + 0.5x^3
=#

nonlin_fun(x) = 3 - 0.5x - 1.5x^2 + 0.5x^3
N = 100; # Number of samples
x_train = rand(-2:1e-3:4,1,N)
y_train = nonlin_fun.(x_train)

using Plots
scatter(x_train, y_train, legend=false)
Nn = 32; # Number of neurons in hidden layer

W1 = rand(Nn, 1)
b1 = rand(Nn)

W2 = rand(Nn, Nn)
b2 = rand(Nn)

W3 = rand(1, Nn)
b3 = rand(1)

layer1(x) = W1 * x .+ b1
layer2(x) = W2 * x .+ b2
layer3(x) = W3 * x .+ b3

using Flux
using Flux: train!

model(x)   = layer3( σ( 
                layer2( σ(
                    layer1(x))))) # ANN model
params     = Flux.params(W1, b1, W2, b2, W3, b3) # Model parameters
loss(x, y) = Flux.Losses.mse(model(x), y);     # Loss function 

model(x_train)
display(loss(x_train, y_train))

opt = Descent()
data = [(x_train, y_train)]

train!(loss, params, data, opt)
loss(x_train, y_train)
#display(params)

N_epoch = 20000;
loss_res = zeros(N_epoch);

for epoch in 1:N_epoch
    train!(loss, params, data, opt)
    loss_res[epoch] = loss(x_train, y_train)
end

scatter(loss_res, yaxis=:log10)

using Plots
plot(loss_res, yaxis=:log10, title="Loss value per iteration")

scatter(x_train', model(x_train)', title="Training data")
scatter(x_test', model(x_test)', title="Test data")
