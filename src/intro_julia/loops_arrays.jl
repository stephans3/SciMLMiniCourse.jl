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
img = load("images/1F34F_color.png");
Npx, Npy = size(img)

img_noise = img+rand(Gray,Npx, Npy)
P_orig = channelview(Gray.(img)) + zeros(Npx, Npy)
P_noise = channelview(Gray.(img_noise))  + zeros(Npx, Npy)

maximum(P_orig)
minimum(P_orig)

maximum(P_noise)
minimum(P_noise)