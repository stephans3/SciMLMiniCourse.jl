#=
Finite differences in 2 dimensions
=#

f(x,y) = exp(-(x^2 + y^2))

Nx, Ny = 61, 61;        # Number of grid points
xgrid  = range(-3,3,Nx) # Grid of x-values 
ygrid  = range(-3,3,Ny) # Grid of y-values 
M      = zeros(Nx,Ny)   # Data values

for (j,ely) in enumerate(ygrid), (i,elx) in enumerate(xgrid)
    M[i,j] = f(elx,ely)
end

using Plots
p1 = heatmap(ygrid, xgrid, M, title="2-dimensional distribution")
p1_path = "images/2dim_distribution.png"
savefig(p1, p1_path)

function finite_diff_2d_x(data2d,dx)    # 2-dimensional forward finite differences
    Lx,Ly  = size(data2d)    # Size of original matrix
    diff2d = zeros(Lx-1,Ly);   # Matrix to store finite difference values
    for j in 1:Ly, i in 1:Lx-1
        diff2d[i,j] = (data2d[i+1,j]-data2d[i,j])/dx # Forward difference scheme
    end
    return diff2d
end

function finite_diff_2d_y(data2d,dy)    # 2-dimensional forward finite differences
    Lx,Ly  = size(data2d)    # Size of original matrix
    diff2d = zeros(Lx,Ly-1);   # Matrix to store finite difference values
    for j in 1:Ly-1, i in 1:Lx
        diff2d[i,j] = (data2d[i,j+1]-data2d[i,j])/dy # Forward difference scheme
    end
    return diff2d
end

dx = xgrid[2] - xgrid[1]    # Spatial sampling: x-direction
dy = ygrid[2] - ygrid[1]    # Spatial sampling: y-direction
M_diffx = finite_diff_2d_x(M,dx) # Differentiation in x-direction
M_diffy = finite_diff_2d_y(M,dy) # ... in y-direction

p2 = heatmap(ygrid,xgrid[1:end-1], M_diffx, title="Differentiation in x-direction")
p3 = heatmap(ygrid[1:end-1],xgrid, M_diffy, title="Differentiation in y-direction")

p2_path = "images/2dim_diff_x.png";
p3_path = "images/2dim_diff_y.png";

savefig(p2, p2_path)
savefig(p3, p3_path)

# 2nd order derivative / diffusion

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

M_diff2 = diffusion2d(M,dx,dy)
p4 = heatmap(ygrid,xgrid, M_diff2, title="Second order differentiation")

p4_path = "images/2dim_2nd_diff.png";
savefig(p4, p4_path)

# Diffusion
η_max = 1/(2*(1/dx^2  + 1/dy^2)) # Maximum scaling factor
η = 0.9*η_max;
N_diff = 200;
M_blurr = copy(M)
for i=1:N_diff
    M_blurr = M_blurr + η*diffusion2d(M_blurr,dx,dy)
end

title_text = string("Diffusion after ", N_diff , " steps")
p5 = heatmap(ygrid,xgrid, M_blurr, title=title_text)
p5_path = "images/2dim_diffusion.png";
savefig(p5, p5_path)

using Images
# This image is taken from: https://openmoji.org/ 
# See: https://openmoji.org/library/emoji-1F34F/
img = load("images/1F34F_color.png");
Npx, Npy = size(img)

P = channelview(Gray.(img)) + zeros(Npx, Npy)
P_diff2d = diffusion2d(P,1,1)
heatmap(P)
heatmap(P_diff2d)

# Blurring
M = 1000;
P_new = copy(P)
for i=1:M
    P_new = P_new + 0.1 * diffusion2d(P_new,1,1)
end

heatmap(P_new)

