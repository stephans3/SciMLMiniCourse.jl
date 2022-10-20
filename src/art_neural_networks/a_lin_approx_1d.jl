#=
This code is taken from the Flux documentation:

https://fluxml.ai/Flux.jl/stable/models/overview/
=#

using Flux
actual(x) = 4x + 2  # Model that shall be approximated
x_train, x_test = hcat(0:5...), hcat(6:10...)       # Input data
y_train, y_test = actual.(x_train), actual.(x_test) # Output data

predict = Dense(1 => 1) # ANN with 1 input neuron and 1 output neuron
predict(x_train)
parameters = Flux.params(predict) # Parameters of ANN

loss(x, y) = Flux.Losses.mse(predict(x), y); # Loss function: mean squared error
loss(x_train, y_train)

using Flux: train!
opt = Descent() # Gradient descent optimizer
data = [(x_train, y_train)]

train!(loss, parameters, data, opt) # 1 training step
loss(x_train, y_train)
display(parameters)

N_epoch = 200;
loss_res = zeros(N_epoch); # Array to save all loss values

for epoch in 1:N_epoch
    train!(loss, parameters, data, opt)      # Apply training
    loss_res[epoch] = loss(x_train, y_train) # Save loss values
end

using Plots
scatter(loss_res)    # Plot loss values
loss(x_test, y_test)