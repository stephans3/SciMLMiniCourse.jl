# Numerical integration

y(x)= -x^2 + 4  # Original function

N = 21; # Number of entries
xgrid = range(-2,2,N)       # Grid of x-values
v = [y(i) for i in xgrid]   # Data samples

using Plots
scatter(xgrid,v) # Plot data samples

Δx = xgrid[2]-xgrid[1]  # Spatial sampling
v_int = sum(v)*Δx       # Approximation of integral

println("The approximated integral value is ", v_int)

# Own sum function
function mysum(vec)
    s = 0;  # Store results
    for (idx,el) in enumerate(vec)
        s = s + el # Sum up all elements
    end
    return s # return result
end

v_int2 = mysum(v)*Δx 
println("The approximated integral value with mysum function is ", v_int2)


# Finite differences

function forward_fd(vals,dx)    # Forward finite differences
    L = length(vals)    # Length of original vector
    v_d = zeros(L-1);   # Vector to store finite difference values
    for i in 1:L-1
        v_d[i] = (vals[i+1]-vals[i])/dx # Forward difference scheme
    end
    return v_d
end

function backward_fd(vals,dx)   # Backward finite differences
    L = length(vals)
    v_d = zeros(L-1);
    for i in 2:L
        v_d[i-1] = (vals[i]-vals[i-1])/dx # Backward difference scheme
    end
    return v_d
end

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

v_d1 = forward_fd(v,Δx)
scatter(xgrid[1:N-1], v_d1, label="forward")

v_d2 = backward_fd(v,Δx)
scatter!(xgrid[2:N], v_d2, label="backward")

v_d3 = central_fd(v,Δx)
scatter!(xgrid[2:N-1], v_d3, label="central")