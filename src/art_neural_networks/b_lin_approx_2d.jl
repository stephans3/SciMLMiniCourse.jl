#=
Flux example: approximation of 2-dimensional function
f(x,y) = 3x - 5y + 2
=#


using Flux
actual(x) = 3x[1] - 5x[2] + 2  # Model that shall be approximated
N_samples = 10
x_train, x_test = rand(-3:0.1:4, 2, N_samples), rand(2:0.1:9, 2, N_samples) # Input data
y_train, y_test = zeros(1,N_samples), zeros(1,N_samples)                    # Output data

for i in 1:N_samples
    y_train[i] = actual(x_train[:,i])
    y_test[i] = actual(x_test[:,i])
end

predict = Dense(2 => 1) # ANN with 2 input neuron and 1 output neuron
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

N_epoch = 100;
loss_res = zeros(N_epoch); # Array to save all loss values

for epoch in 1:N_epoch
    train!(loss, parameters, data, opt)      # Apply training
    loss_res[epoch] = loss(x_train, y_train) # Save loss values
end

using Plots
scatter(loss_res, title="Loss per iteration", yaxis="Loss")   # Plot loss values
display(parameters)
loss(x_test, y_test)