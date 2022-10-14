# Arrays and Loops

Julia is made for scientific computation. So, we have **Vectors** and **Matrices** which are both subtypes of arrays. We can create a simple 4-element `Vector` with

```julia
julia> v = [1,2,3,4]
4-element Vector{Int64}:
 1
 2
 3
 4
```

and see that all entries are saved as `Int64` which is a 64 bit integer. If we write one value as float then we yield a `Vector{Float64}` as

```julia
julia> v = [1,2.0,3,4]
4-element Vector{Float64}:
 1.0
 2.0
 3.0
 4.0
```
In Julia vectors are noted as **columns** and not as rows. If we do not use the comma between the entries than we yield a matrix with one row as
```julia
julia> v = [1 2 3 4]
1×4 Matrix{Int64}:
 1  2  3  4
```
In matrices each row is seperated with semicolons as

```julia
julia> M = [1 2 3 4; 5 6 7 8]
2×4 Matrix{Int64}:
 1  2  3  4
 2  3  4  5
```

## Zeros, ones and random values

If you want to create a vector or a matrix that contains only **zero entries** then you can use for vectors
```julia
julia> v = zeros(4)
4-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.0
```
and for matrices
```julia
julia> M = zeros(4,4)
4×4 Matrix{Float64}:
 0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0
```

If we want to define the datatype then we use `zeros(TYPE,ROWS,COLUMNS)` as
```julia
julia> M = zeros(Int,4,3)
4×3 Matrix{Int64}:
 0  0  0
 0  0  0
 0  0  0
 0  0  0
```

If we want to have a vector or matrix with only **one entries** then we use `ones(TYPE,ROWS,COLUMNS)` as
```julia
julia> M = ones(Int,4,3)
4×3 Matrix{Int64}:
 1  1  1
 1  1  1
 1  1  1
 1  1  1
```

We can create **random** values the same way as before with `rand(TYPE,ROWS,COLUMNS)` as 

```julia
julia> M = rand(3,4)
3×4 Matrix{Float64}:
 0.545932  0.272659  0.31695   0.707982
 0.246701  0.92546   0.878453  0.501426
 0.206801  0.659878  0.174388  0.0598787
```
and with datatype as
```julia
julia> M = rand(Bool, 3,4)
3×4 Matrix{Bool}:
 1  0  0  0
 0  0  0  1
 1  0  1  1
```

## For-loops

We can use **while** and **for** loops in Julia. While loops can be used as
```julia
n = 1;
while n<4
    n = n+1;
    println(n)
end
```

However, we will focus in this course only on for loops. There are several ways to define the iteration of the for loop. One way to rewrite the while loop above is 
```julia
for n=1:3
    n = n+1;
    println(n)
end
```
or using the `in` statement we can write
```julia
for n in 1:3
    n = n+1;
    println(n)
end
```

This `in` statement will be used later at several points. 

### Example: finding minimum and maximum
Firstly, we create a vector and fill it with some values.

```julia
# Vector
v = [1, 3, 5, 7, 9, 0, 2, 4, 6, 8]
N = length(v) # length of vector
```

The entries can be printed with a for-loop as
```julia
for i=1:N
    println("v[",i,"]= ", v[i])
end
```

or we can use the `enumerate` function that iterates over the whole vector and returns the index and the element as
```julia
for (idx,el) in enumerate(v)
    println("At index ", idx, " the element is ", el)
end
```

The maximum and minimum of the vector entries can be found with `maximum()` or `minimum()` as
```julia
println("Maximum of v is ", maximum(v)) 
println("Minimum of v is ", minimum(v)) 
```
 or manually with for-loops. Beside the maximum and minimum value we also want to find the indices of both values. Therefore, we declare 2 variable to store the values and 2 variables to store the indices.

```julia
    e_max, e_min = -Inf, Inf;   # Init min/max element
    idx_max, idx_min = -1, -1;  # Init indices
``` 

```julia
for (idx,e) in enumerate(v)
    # Save recent element and index if it is _larger_ than the already stored one
    if e > e_max
        e_max = e
        idx_max = idx
    end

    # Save recent element and index if it is _smaller_ than the already stored one
    if e < e_min
        e_min = e
        idx_min = idx
    end
end
``` 
