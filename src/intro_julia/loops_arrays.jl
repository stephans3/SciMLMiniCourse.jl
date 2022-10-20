#=

=#


# Vectors 
v = [1, 3, 5, 7, 9, 0, 2, 4, 6, 8]
N = length(v) # length

for i=1:N
    println("v[",i,"]= ", v[i])
end

for (idx,el) in enumerate(v)
    println("At index ", idx, " the element is ", el)
end


# find maximum / minimum entry + index
println("Maximum of v is ", maximum(v)) 
println("Minimum of v is ", minimum(v)) 

e_max, e_min = -Inf, Inf;   # Init min/max element
idx_max, idx_min = -1, -1;  # Init indices


for (idx,e) in enumerate(v)
    if e > e_max
        e_max = e
        idx_max = idx
    end

    if e < e_min
        e_min = e
        idx_min = idx
    end

end

println("Maximum of v is ", e_max, " at index ", idx_max) 
println("Minimum of v is ", e_min, " at index ", idx_min) 

# Example with image
using Images
# This image is taken from: https://openmoji.org/ 
# See: https://openmoji.org/library/emoji-1F34F/
img_orig = load("images/1F34F_color.png")
Npx, Npy = size(img_orig)

noise_rgb  = rand(RGB,Npx, Npy)  # Noise as random matrix
noise_gray = rand(Gray,Npx, Npy) # Noise as random matrix
img_noisy  = img_orig+noise_rgb  # Image with RGB noise

# Matrices with gray scale values
P_orig = channelview(Gray.(img_orig)) + zeros(Npx, Npy)
P_noisy = channelview(Gray.(img_noisy))  + zeros(Npx, Npy)

using Plots
heatmap(P_orig, title="Heatmap of original image")
heatmap(P_noisy, title="Heatmap of image with noise")

# Modify the image
P_mod = 0.5*P_noisy + P_noisy[end:-1:1,:]
heatmap(P_mod, title="Modified noisy image")

# Convolution of image
function convolution_img(M)
    Nx,Ny = size(M)

    Mnew = similar(M)

    for j in 2:Ny-1, i in 2:Nx-1
        Mnew[i,j] = 5*M[i,j] - (M[i-1,j] + M[i+1,j] + M[i,j-1] + M[i,j+1])
    end

    for i in 2:Nx-1
        Mnew[i,1] = 5*M[i,1] - (M[i-1,1] + M[i+1,1] + M[i,2] + Mnew[i,1])
        Mnew[i,end] = 5*M[i,end] - (M[i-1,1] + M[i+1,1] + M[i,end-1] +  Mnew[i,end])
    end

    for j in 2:Ny-1
        Mnew[1,j] = 5*M[1,j] - (M[2,j] + M[1,j-1] + M[1,j+1] + Mnew[1,j])
        Mnew[end,j] = 5*M[end,j] - (M[end-1,j] + M[end,j-1] + M[end,j+1] + Mnew[end,j])
    end

    Mnew[1,1] = 5*M[1,1] - (M[2,1] + M[1,2] + 2*M[1,1])
    Mnew[1,end] = 5*M[1,end] - (M[2,end] + M[1,end-1] + 2*M[1,end])
    Mnew[end,1] = 5*M[end,1] - (M[end-1,1] + M[end,2]+ 2*M[end,1])
    Mnew[end,end] = 5*M[end,end] - (M[end-1,end] + M[end,end-1] +  + 2*M[end,end])

    return Mnew
end

P_conv = convolution_img(P_orig) # 1. Convolution
P_conv = convolution_img(P_conv) # 2. Convolution
heatmap(P_conv, title="Convolution of image")

heatmap(tanh.(P_conv))