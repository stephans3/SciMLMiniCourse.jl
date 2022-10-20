function diffusion2d(data2d)
    Lx,Ly  = size(data2d)    # Size of original matrix
    diff2d = zeros(Lx,Ly);   # Matrix to store finite difference values
    for j in 2:Ly-1, i in 2:Lx-1
        ddx = (data2d[i-1,j] + data2d[i+1,j] - 2*data2d[i,j])  # 2nd order finite differences
        ddy = (data2d[i,j-1] + data2d[i,j+1] - 2*data2d[i,j])
        diff2d[i,j] = ddx + ddy 
    end
    return diff2d
end

using Images
img = load("images/zielona.jpg");

# A = channelview(img)
# Ar = A[1,:,:]; # red channel
# Ag = A[2,:,:]; # green channel
# Ab = A[3,:,:]; # blue channel

A = channelview(img)[1,:,:] # only red channelview
Npx, Npy = size(img)

P_orig = channelview(Gray.(img)) + zeros(Npx, Npy)
P_diff2d = diffusion2d(P_orig)
using Plots
heatmap(P_orig, title="Original image")
heatmap(P_diff2d, title="Diffusion of image")

# Blurring
iter_blur = 10;
P_new = copy(P_orig)
for i=1:iter_blur
    P_new = P_new + 0.1 * diffusion2d(P_new)
end

blur_title = string("Blurring after n=", iter_blur, " iterations")
heatmap(P_new, title=blur_title)

