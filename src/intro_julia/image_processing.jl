using Images
img = load("images/zielona.jpg");

# A = channelview(img)
# Ar = A[1,:,:]; # red channel
# Ag = A[2,:,:]; # green channel
# Ab = A[3,:,:]; # blue channel

A = channelview(img)[1,:,:]

N,M = size(A)

using SparseArrays
diff_2_rows = spdiagm(-1 => ones(N-1), 0 => -2*ones(N), 1 => ones(N-1))
diff_2_rows[1,2] = -2
diff_2_rows[end,end-1] = -2

α = 0.4;
A2d_rows = copy(A);

for i in 1:100;
    A2d_rows = A2d_rows + α*diff_2_rows*A2d_rows
end


using Plots
heatmap(A)
heatmap(A2d_rows)




using Plots
heatmap(Ar[end:-1:1,:])
heatmap(Ag[end:-1:1,:])

N,M = size(Ar)

using SparseArrays
diff_l1_rows = spdiagm(-1 => ones(N-1), 0 => -1*ones(N))
diff_l1_cols = spdiagm(-1 => ones(M-1), 0 => -1*ones(M))

dAr_l_rows = diff_l1_rows*Ar
dAr_l_cols = Ar*diff_l1_cols

heatmap(dAr_l_rows[end:-1:1,:])
heatmap(dAr_l_cols[end:-1:1,:])

diff_2_rows = spdiagm(-1 => ones(N-1), 0 => -1*ones(N), 1 => ones(N-1))
diff_2_cols = spdiagm(-1 => ones(M-1), 0 => -1*ones(M), 1 => ones(M-1))

ddAr_rows = diff_2_rows*Ar
ddAr_cols = Ar*diff_2_cols

heatmap(ddAr_rows[end:-1:1,:])
heatmap(ddAr_cols[end:-1:1,:])

Ar_rows = copy(Ar);
heatmap(Ar_rows)
α = 1e-5;

for i in 1:1000;
    Ar_rows = Ar_rows + α*diff_2_rows*Ar_rows
end

heatmap(Ar_rows)
