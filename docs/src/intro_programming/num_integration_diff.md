# Numerical integration and differentiation
We use vectors and matrices very often to store data or to describe natural or technical processes like diffusion as part of chemical processes or switching of states in Petri nets.   

Many of these processes are based on mathematical tools like differentiation and integration. If we assume the function

```math
y(x) = -x^2 + 4
```
with x values in the interval $[-2, 2]$ then we can directly calculate the integral as

```math
\int_{-2}^{2} y(x) dx = \int_{-2}^{2} -x^2 + 4 dx = \left[-\frac{1}{3}~x^3 + 4~x \right]_{-2}^{2} = \frac{32}{3} \approx 10.67.
```

Now, we want to calculate this using numerical routines. Firstly, we define the original function
```julia
y(x)= -x^2 + 4  # Original function
```
and define the vector of data samples with

```julia
N = 21;                     # Number of samples
xgrid = range(-2,2,N)       # Grid of x-values
v = [y(i) for i in xgrid]   # Data samples
```

Next, we approximate the integral as a sum 
```math
\int_{-2}^{2} y(x) dx \approx \sum_{n=1}^{N} y(x_{n}) ~ \Delta x
```
where $\Delta x$ is the spatial sampling $\Delta x = x_{n+1}-x{n}$. We implement this using the `sum()` function as

```julia
Δx = xgrid[2]-xgrid[1]  # Spatial sampling
v_int = sum(v)*Δx       # Approximation of integral
```
We yield for the approximated integral value almost $10.64$. We can also replace the `sum()` function with our own function.

```julia
function mysum(vec)
    s = 0;  # Store results
    for (idx,el) in enumerate(vec)
        s = s + el # Sum up all elements
    end
    return s # return result
end
```

## Exercises
Calculate the integral of [normal distribution](https://en.wikipedia.org/wiki/Normal_distribution)
```math
f(x) = \frac{1}{\sigma \sqrt{2\pi}}~\exp\left(-\frac{x^2}{2\sigma^2}\right) 
```
with $\sigma=2$ in the interval $[-6,6]$.

Calculate the integral of [Rayleigh distribution](https://en.wikipedia.org/wiki/Rayleigh_distribution)
```math
f(x) = \frac{x}{\sigma^2}~\exp\left(-\frac{x^2}{2\sigma^2}\right) 
```
with $\sigma=2$ in the interval $[-0,6]$.

## Finite differences

The first-order derivative $\frac{d}{dx} f(x)$ can be approximated by the **forward** finite difference

```math
\frac{d}{dx} f(x) \approx \frac{f(x + \Delta x) - f(x)}{\Delta x} = \frac{f(x_{n+1}) - f(x_{n})}{\Delta x},
```
the **backward** finite difference
```math
\frac{d}{dx} f(x) \approx \frac{f(x) - f(x-\Delta x)}{\Delta x} = \frac{f(x_{n}) - f(x_{n-1})}{\Delta x},
```
or the **central** finite difference
```math
\frac{d}{dx} f(x) \approx 
\frac{f(x+\frac{\Delta x}{2}) - f(x-\frac{\Delta x}{2})}{\Delta x}  = \frac{f^{+}(x_{n}) - f^{-}(x_{n})}{\Delta x}
```
where 

$f^{+}(x_{n}) \approx \frac{1}{2}(f(x_{n})+ f(x_{n+1}))$ 

and 

$f^{-}(x_{n}) \approx \frac{1}{2}(f(x_{n-1})+ f(x_{n})).$

We are interested in computing the first-order derivate of 

```math
y(x) = -x^2 + 4
```

which is found analytically as

```math
\frac{d}{dx} y(x) = -2~x.
```

The finite difference schemes are implemented as functions that use a for-loop to iterate over all data elements. The main difference is the difference scheme. In case of the forward differences we use
```julia
v_d[i] = (vals[i+1]-vals[i])/dx
```
and in case of the backward differences we note
```julia
v_d[i-1] = (vals[i]-vals[i-1])/dx
```

For the central differences we firstly have to compute $f^{+}(x_{n})$ and $f^{-}(x_{n})$ and calculate their differences.

```julia
dv1 = (vals[i] + vals[i-1])/2   # First central point: f^{+}
dv2 = (vals[i] + vals[i+1])/2   # Second central point: f^{-}
v_d[i-1] = (dv2-dv1)/dx         # Finite difference between first and second central point
```

#### Forward finite differences

```julia
function forward_fd(vals,dx)    # Forward finite differences
    L = length(vals)    # Length of original vector
    v_d = zeros(L-1);   # Vector to store finite difference values
    for i in 1:L-1
        v_d[i] = (vals[i+1]-vals[i])/dx # Forward difference scheme
    end
    return v_d
end
```

#### Backward finite differences

```julia
function backward_fd(vals,dx)   # Backward finite differences
    L = length(vals)
    v_d = zeros(L-1);
    for i in 2:L
        v_d[i-1] = (vals[i]-vals[i-1])/dx # Backward difference scheme
    end
    return v_d
end
```

#### Central finite differences

```julia
function central_fd(vals,dx)    # Central finite differences
    L = length(vals)
    v_d = zeros(L-2);
    for i in 2:L-1
        dv1 = (vals[i] + vals[i-1])/2   # First central point
        dv2 = (vals[i] + vals[i+1])/2   # Second central point
        v_d[i-1] = (dv2-dv1)/dx         # Finite difference between first and second central point
    end
    return v_d
end
```

