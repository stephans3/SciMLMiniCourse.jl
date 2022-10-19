# Finite differences in 2 dimensions

We can also compute the gradient of a 2-dimensional function like

$f(x,y) = \exp\left(- (x^2 + y^2) \right)$

Firstly, we define the function
```julia
f(x,y) = exp(-(x^2 + y^2))
```
and generate the 2-dimensional data of this function.

```julia
Nx, Ny = 61, 61;        # Number of grid points
xgrid  = range(-3,3,Nx) # Grid of x-values 
ygrid  = range(-3,3,Ny) # Grid of y-values 
M      = zeros(Nx,Ny)   # Data values

for (j,ely) in enumerate(ygrid), (i,elx) in enumerate(xgrid)
    M[i,j] = f(elx,ely)
end
```

We calculate the gradient analytically as 

```math
\nabla f(x,y) =
\begin{pmatrix}
\frac{d}{dx}f(x,y) \\
\frac{d}{dy}f(x,y)
\end{pmatrix} =
 -2
\begin{pmatrix}
x \\
y
\end{pmatrix}
\exp\left(- (x^2 + y^2) \right)
```

So, we see that the gradient is a 2-dimensional vector. The finite differences are computed as in the 1-dimensional case - but here with a matrix instead of a vector.

```julia
# x-direction
function finite_diff_2d_x(data2d,dx)    # 2-dimensional finite differences: x-direction
    Lx,Ly  = size(data2d)               # Size of original matrix
    diff2d = zeros(Lx-1,Ly);            # Matrix to store finite difference values
    for j in 1:Ly, i in 1:Lx-1
        diff2d[i,j] = (data2d[i+1,j]-data2d[i,j])/dx # Forward difference scheme
    end
    return diff2d
end

# y-direction
function finite_diff_2d_y(data2d,dy)    # 2-dimensional finite differences: y-direction
    Lx,Ly  = size(data2d)               # Size of original matrix
    diff2d = zeros(Lx,Ly-1);            # Matrix to store finite difference values
    for j in 1:Ly-1, i in 1:Lx
        diff2d[i,j] = (data2d[i,j+1]-data2d[i,j])/dy # Forward difference scheme
    end
    return diff2d
end
```

We only need to define the spatial sampling $\Delta x$ and $\Delta y$ and call the methods.
```julia
dx = xgrid[2] - xgrid[1]    # Spatial sampling: x-direction
dy = ygrid[2] - ygrid[1]    # Spatial sampling: y-direction
M_diffx = finite_diff_2d_x(M,dx) # Differentiation in x-direction
M_diffy = finite_diff_2d_y(M,dy) # ... in y-direction

```


## Second-order derivatives 

The second-order derivative of a two-dimensional function is found analytically as

$\Delta f(x,y) = \frac{d^2}{dx^2}f(x,y) + \frac{d^2}{dx^2}f(x,y)$

and so we yield for our example function $f(x,y) = \exp\left(- (x^2 + y^2) \right)$ the second-order derivative 

$\Delta f(x,y) = (-4 + 4x^2 +4y^2)~\exp\left(- (x^2 + y^2)\right).$

If we wish to compute second-order derivatives for any data we need to use numerical methods again. Second-order derivatives can be approximated with second-order **central finite differences** as

$\frac{d^2}{dx^2}f(x) \approx \frac{f(x- \Delta x) -2 f(x) + f(x+ \Delta x)}{\Delta x^2} = \frac{f(x_{n-1}) -2 f(x_{n}) + f(x_{n+1})}{\Delta x^2}.$

We implement the second-order differentiation with two for-loops to iterate over the rows (inner loop) and the colums (outer loop). 

```julia
function diffusion2d(data2d,dx,dy)
    Lx,Ly  = size(data2d)    # Size of original matrix
    diff2d = zeros(Lx,Ly);   # Matrix to store finite difference values
    for j in 2:Ly-1, i in 2:Lx-1
        ddx = (data2d[i-1,j] + data2d[i+1,j] - 2*data2d[i,j])/dx^2  # 2nd order finite differences
        ddy = (data2d[i,j-1] + data2d[i,j+1] - 2*data2d[i,j])/dy^2
        diff2d[i,j] = ddx + ddy 
    end
    return diff2d
end

M_diff2 = diffusion2d(M,dx,dy) # 2nd order differentiation
```

## Diffusion
When we iteratively calculate the second-order derivatives and add them to the original matrix then we yield a diffusion. We may not this mathematically as

$f^{[n+1]}(x,y) = f^{[n]}(x,y) + \eta ~ \frac{d^2}{dx^2}f^{[n]}(x,y) + \frac{d^2}{dx^2}f^{[n]}(x,y)$

where $\eta \in (0,1)$ is a factor that has to be chosen. If $\eta$ is very small than our diffusion is slow - if it is too large then the numerical algorithm becomes unstable. We can find a suitable $\eta$ with the condition

$1 - \eta \left(\frac{2}{\Delta x^2} + \frac{2}{\Delta y^2}\right) > 0$

which can be reformulated as

$\eta < \left(\frac{2}{\Delta x^2} + \frac{2}{\Delta y^2}\right)^{-1}.$

In Julia we find this with

```julia
η_max = 1/(2*(1/dx^2  + 1/dy^2))
```
We set our scaling factor as `η = 0.9*η_max` and run the diffusion for $200$ iterations.
```julia
M_blurr = copy(M)
for i=1:N_diff
    M_blurr = M_blurr + η*diffusion2d(M_blurr,dx,dy)
end
```

## Image processing
Finally, we apply the diffusion on our apple image.

```julia
using Images
# This image is taken from: https://openmoji.org/ 
# See: https://openmoji.org/library/emoji-1F34F/
img = load("images/1F34F_color.png");
Npx, Npy = size(img)

P = channelview(Gray.(img)) + zeros(Npx, Npy)
P_diff2d = diffusion2d(P,1,1)
heatmap(P, title="Original image")
heatmap(P_diff2d, title="Diffusion of image")

# Blurring
iter_blur = 1000;
P_new = copy(P)
for i=1:iter_blur
    P_new = P_new + 0.1 * diffusion2d(P_new,1,1)
end

blur_title = string("Blurring after n=", iter_blur, " iterations")
heatmap(P_new, title=blur_title)
```

