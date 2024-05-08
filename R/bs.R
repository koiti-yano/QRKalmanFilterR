#' bs: the inverse of a upper triangular matrix with backsolve 
#' @title Backward substitution with backsolve
#' @importFrom base backsolve diag
#' @export
#' @param Up an upper triangular matrix
#' @example 
#' Up <- matrix(c(2, 0, 0, 3, 4, 0, 3, 2, 5), nrow = 3, ncol = 3)
#' bs(Up) # 
#' solve(Up)
bs <- function(Up){
  # Use backsolve function to solve the system of equations
  return(backsolve(Up, x = diag(ncol(Up))))
}
