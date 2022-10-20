# Artificial Neural Networks

... are a set of machine learning tools which are ["inspired by biological neural networks", see Wikipedia](https://en.wikipedia.org/wiki/Artificial_neural_network).  They can be visualized as (directed) graphs where the nodes or vertices are neurons and the edges are connections between the neurons.

In this course we will focus on (simple) feed-forward networks with
- one input layer consisting of $N$ input neurons
- a certain number of hidden layers, and
- one ouput layer consisting of $M$ output neurons.

The $j$-th neuron of a hidden layer or output layer $l$ has three components:
- a connection from the $k$-th neuron of the previous layer $l-1$ with weight $w_{j,k}^{l}$,
- a bias $b_{j}^{l}$ and
- an [activation function $f^{l}(\cdot)$](https://en.wikipedia.org/wiki/Activation_function) like $tanh$ or sigmoid function.

The state of this neuron is computed as 

$x_{j}^{l} = f^{l}(w_{j,k}^{l} ~ x_{k}^{l-1} + b_{j}^{l}).$

The weights and the bias are usually expressed in matrix and vector notation as 

$W^{l} = \begin{pmatrix}
w_{1,1} & w_{1,2} & \cdots & w_{1,k} & \cdots & w_{1,K} \\
\vdots  & \vdots  & ~      & ~       &        & \vdots  \\
w_{j,1} & w_{j,2} & \cdots & w_{j,k} & \cdots & w_{j,K} \\
\vdots  & \vdots  & ~      &         &        & \vdots  \\
w_{J,1} & w_{J,2} & \cdots & w_{J,k} & \cdots & w_{J,K}
\end{pmatrix} \qquad b^{l} = \begin{pmatrix}
b_{1,1} \\
\vdots  \\
b_{j,1} \\
\vdots  \\
b_{J,1} 
\end{pmatrix}$

Weights and bias are parameters which are adjusted during the training of the neural network to minimize the difference between the recent output data $y$ and the target output $y_{target}$. 


**Procedure**
1. Multiply the input data $x^{0}$ with the weights between the input layer and first hidden layer as $W^{1} x^{0} + b^{1}$
2. Calculate output of the first hidden layer $x^{1} = f^{1}(W^{1} x^{0} +  + b^{1})$
3. Repeat step 1 and 2 for all hidden layers and the output layers

Therefore the output data after the last layer $L$ is found as 

$y = f^{L}( W^{L} f^{L-1}( W^{L-1} f^{L-2}( \cdots f^{1}(W^{1} x^{0} + b^{1} ) + b^{L-2} ) + b^{L-1} ) + b^{L} ).$

The computed output data $y$ is compared with the target output $y_{target}$, and the difference is evaluated with a loss function or cost function. For example we use the [quadratic loss function](https://en.wikipedia.org/wiki/Loss_function#Quadratic_loss_function)

$J(y_{target,i},y) = \sum_{i=1} (y_{target,i} - y_{i})^2$

The weights are adjusted and the loss function is minimized using backpropagation and optimization methods like (stochastic) [gradient descent](https://en.wikipedia.org/wiki/Gradient_descent). 

## Linear regression in 1D

The first example is taken from the [Flux documentation](https://fluxml.ai/Flux.jl/stable/models/overview/). Here, we try to approximate the function

$f(x) = 4~x + 2$

with an artificial neural network with 1 input and 1 output neuron. The artificial neural network model can be noted as

$y = W^{1} x^{0} + b^{1}$

where $W^{1}$ and $b^{1}$ are the parameters that shall be learned and $x^{0}$ is the input data.

## Linear regression in 2D

In the second example we try to approximate the two-dimensinal function

$f(x,y) = 3~x - 5~y + 2$

with the artificial neural network

$y = (W_{1,1}^{1}, W_{1,2}^{1}) \begin{pmatrix}
x_{1}^{0}\\
x_{2}^{0}
\end{pmatrix} + b^{1}.$

Here we have 2 input neurons and 1 output neuron. Next, we see how to build an ANN model step-by-step.


#### Generate data

Firstly, we define the true model and create random input values for training and test. Here, we define the interval for training data as $[-3,4]$ and for test data as $[2,9]$. The lower and upper bounds of the intervals are chosen arbitrarily. 

```julia
actual(x) = 3x[1] - 5x[2] + 2  # Model that shall be approximated
N_samples = 10
x_train, x_test = rand(-3:0.1:4, 2, N_samples), rand(2:0.1:9, 2, N_samples) # Input data
```

Next, we need to generate the output data which is used later to compute the loss. 

```julia
y_train, y_test = zeros(1,N_samples), zeros(1,N_samples) # Output data
for i in 1:N_samples
    y_train[i] = actual(x_train[:,i])
    y_test[i] = actual(x_test[:,i])
end
```


#### ANN model and loss function

In the second step, we create the artificial neural network model. As discussed above, we have 2 input neurons and 1 output neuron. We have in total 3 parameters: $W_{1,1}^{1}, W_{1,2}^{1}$ and $b_{1}^{1}$. We do not need an activation function because our reference model is linear.

```julia
using Flux
predict = Dense(2 => 1) # ANN with 2 input neuron and 1 output neuron
parameters = Flux.params(predict) # Parameters of ANN
```

Further, we use a [mean squared error](https://en.wikipedia.org/wiki/Mean_squared_error) as

$J(y_{t},y) = \sum (y_{t,i} - y_{i})^2.$

```julia
loss(x, y) = Flux.Losses.mse(predict(x), y); # Loss function: mean squared error
```


#### Train model 

In the last step, we choose [gradient descent](https://en.wikipedia.org/wiki/Gradient_descent) as the optimization method, define the input and output training data and run 1 training iteration.

```julia
using Flux: train!
opt = Descent() # Gradient descent optimizer
data = [(x_train, y_train)]
train!(loss, parameters, data, opt)
```

The training step has to be repeated iteratively to minimize the loss.

## Nonlinear function approximation

The approximation of linear functions is very simple because we only do not need a hidden layer - input and output layer are enough. In case of nonlinear functions we need hidden layers and activation functions. In this example we assume the nonlinear function

$f(x) = 3 - 0.5~x - 1.5 ~ x^2 + 0.5 ~ x^3.$

In this example, we use  an artificial neural network with one hidden layer. The ANN structure is:

- Input layer with 1 neuron
- 2 hidden layers with $N$ neurons
- Output layer with 1 neuron

The ANN model is modelled with `Chain()` with $N$ in the hidden layer:

```julia
Nn = 64 # 16 # Number of neurons per layer
model = Chain(
  Dense(1 => Nn, σ),
  Dense(Nn => Nn, σ),
  Dense(Nn => 1))
```

In the output layer $L$ we sum up all results of the previous layer $L-1$ like

```math
y = \sum_{n} [W_{1,n}^{L} ~ f_{n}^{L-1}(W^{L-1} x^{L-2} + b^{L-1})] + b_{1,1}^{L}. 
```

Learning the weights and bias is typical function approximation or interpolation.
And the more neurons we have in the hidden layer the more exact is our interpolation. However, this approach only works fine here for interpolation and not for extrapolation. 

## Flux vs. Lux 

Flux is one Julia's standard machine learning libraries. Beside Flux there exist several other libraries like:
- [MLJ](https://alan-turing-institute.github.io/MLJ.jl/dev/)
- [Knet](https://denizyuret.github.io/Knet.jl/latest/)
- [Lux](http://lux.csail.mit.edu/stable/)
- [SimpleChains](https://github.com/PumasAI/SimpleChains.jl)

In this course we will use **Flux** and **Lux**. Lux is a young project that was created to build a better foundation for Scientific Machine Learning methods than Flux. This means, the interoperability with **DifferentialEquations** framework shall be better than with Flux.

#### Further reading

The Knet documentation contains a rather comprehensive introduction to artificial neural networks and their training methods.
It can be found here: [Backpropagation and SGD](https://denizyuret.github.io/Knet.jl/latest/backprop/)

If you want to play more with Flux, you may take a look on the [Flux model zoo](https://github.com/FluxML/model-zoo).