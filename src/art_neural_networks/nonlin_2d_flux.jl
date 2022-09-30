#=
    2-dimensional nonlinear function
    f(x,y) = 200*x*cos(2*x)*exp(-x^2)*sin(y*exp(-y^2)) / (1 + exp(-2*x))
=#

nonlin_fun(x) = 200*x[1]*cos(2*x[1])*exp(-x[1]^2)*sin(x[2]*exp(-x[2]^2)) / (1 + exp(-2*x[1]))
lb, ub = -2, 2; # lower / upper bounds of cartesian grid
N = 4000;       # Number of samples
x_train = rand(lb:1e-3:ub,2,N) # Training data
y_train = zeros(1,N)

for i in 1:N
    y_train[i] = nonlin_fun(x_train[:,i])
end

using Flux
using Flux: train!

N_n = 64; # Number of neurons in hidden layer

# ANN Model with 2 hidden layers
model = Chain(
  Dense(2 => N_n, σ),    # from input layer to 1. hidden layer
  Dense(N_n => N_n, σ),  # from 1. hidden layer to 2. hidden layer
  Dense(N_n => 1))       # from 2. hidden layer to output layer

params     = Flux.params(model)
loss(x, y) = Flux.Losses.mse(model(x), y);

model(x_train)
println("Loss of training data: ", loss(x_train, y_train))

opt = Descent()
data = [(x_train, y_train)]

train!(loss, params, data, opt) # 1 Training step
loss(x_train, y_train)
println("Loss of training data: ", loss(x_train, y_train))

N_epoch = 20000;
loss_res = zeros(N_epoch);

for epoch in 1:N_epoch
    train!(loss, params, data, opt)
    loss_res[epoch] = loss(x_train, y_train)
end

using Plots
plot(loss_res, yaxis=:log10, title="Loss value per iteration")

xgrid = LinRange(lb,ub,200)
ygrid = LinRange(lb,ub,200)
data2d_test = zeros(length(xgrid), length(ygrid)); # Saves values of ANN model
data2d_vali = zeros(length(xgrid), length(ygrid)); # Saves values of true model: nonlin_fun

for (i,x) in enumerate(xgrid), (j,y) in enumerate(ygrid)
  data2d_test[i,j] = model([x,y])[1]    # ANN model
  data2d_vali[i,j] = nonlin_fun([x,y])  # True model
end

using Plots
heatmap(xgrid, ygrid, data2d_test, title="ANN model")
heatmap(xgrid, ygrid, data2d_vali, title="True model")
heatmap(xgrid, ygrid, data2d_vali-data2d_test, title="Difference between true and ANN model")


