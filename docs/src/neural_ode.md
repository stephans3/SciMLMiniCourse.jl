# Neural Ordinary Differential Equations

Neural Ordinary Differential Equations (Neural ODE) are either:
- artificial neural networks that are modelled as ordinary differential equations (used in machine learning) or
- ordinary differential equations that contain neural networks (used in computational sciences and engineering).

The idea of neural ordinary differential equations was firstly introduced (as we use it today) by Chen, Rubanova, Bettencourt and Duvenaud in 2018. The arxiv preprint can be found here: [Neural Ordinary Differential Equations](https://arxiv.org/abs/1806.07366).

The basic idea was to speed-up the computation of deep learning approaches like residual neural networks, recurrent neural networks or normalizing flows. All of these appraches can be described by 

```math
x(n+1) = x(n) + f(x(n), p(n))
```

where $n$ denotes the layer, $x$ the states, $p$ the parameters and $f()$ the activation function. This recursive algorithm $x(n+1)=...$ also describes the [forward Euler method](https://en.wikipedia.org/wiki/Euler_method) which is used to solve ordinary differential equations. So, the idea is to formulate the *original* ordinary differential equation

$\frac{dx(t)}{dt} = f(x(t), p,t)$

and solve it with a high-order numerical integration method like Runge-Kutta methods. 


#### Literature
- [Neural Ordinary Differential Equations](https://arxiv.org/abs/1806.07366)
- [Universal Differential Equations](https://arxiv.org/abs/2001.04385)
- [On Neural Differential Equations](https://arxiv.org/abs/2202.02435)