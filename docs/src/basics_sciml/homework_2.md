# Homework: Machine Learning

## 2-dimensional function approximation

Read in the **Flux** documentation about building models:
- [Overview](https://fluxml.ai/Flux.jl/stable/models/overview/)
- [Basics](https://fluxml.ai/Flux.jl/stable/models/basics/) 

We assume the true model

```math
    f(x,y) = 200~x~\frac{\cos(2x)~\exp(-x^2)}{1 + \exp(-2x)}~\sin(y~\exp(-y^2)) \\
```
**Tasks**
1. Create random training values for $(x,y) \in [-2,2] \times [-2,2]$
2. Build an artificial neural network model (with **Flux**) with at least 1 hidden layer
3. Train the ANN model and plot the loss values per iteration. Use at least 5000 iterations.
4. Plot the graph of the ANN model and the true model.

## Function approximation with Lux.jl

Read in the **Lux** documentation:
- [Julia & Lux for the Uninitiated](http://lux.csail.mit.edu/stable/examples/generated/beginner/Basics/main/)
- [Fitting a Polynomial using MLP](http://lux.csail.mit.edu/stable/examples/generated/beginner/PolynomialFitting/main/)

**Task**

Implement with **Lux.jl** the 1-dimensional function approximation example with

```math
y = \sum_{n} [W_{1,n}^{L} ~ f_{n}^{L-1}(W^{L-1} x^{L-2} + b^{L-1})] + b_{1,1}^{L}.
```