# How to use backsolve and forwardsolve functions in R
# https://stackoverflow.com/questions/25662643/what-is-the-way-to-invert-a-triangular-matrix-in-r
# 
# Example 1
# Create a matrix
Up <- matrix(c(2, 0, 0, 3, 4, 0, 3, 2, 5), nrow = 3, ncol = 3)
Up
# Create a vector
#b <- matrix(c(1, 2, 3, 2,1,2,2,3,1), nrow = 3, ncol = 3)
# Use backsolve function to solve the system of equations
backsolve(Up, x = diag(ncol(Up)))
solve(Up)
bs <- function(Up){
  # Use backsolve function to solve the system of equations
  return(backsolve(Up, x = diag(ncol(Up))))
}
bs(Up)

# Example 2
# Create a matrix
Lw <- matrix(c(3, 2, 1, 0, 4, 1, 0, 0, 2), nrow = 3, ncol = 3)
Lw
# Use forwardsolve function to solve the system of equations
forwardsolve(Lw, x = diag(ncol(Lw)))
solve(Lw)
fs <- function(Lw){
  # Use forwardsolve function to solve the system of equations
  return(forwardsolve(Lw, x = diag(ncol(Lw))))
}
fs(Lw)
