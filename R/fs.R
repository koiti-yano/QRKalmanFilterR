#' fs: the inverse of a lower triangular matrix with forwardsolve
#' @title forward substitution with forwardsolve
#' @importFrom base forwardsolve diag
#' @export
#' @param Lw a lower triangular matrix
#' @examples
#' Lw <- matrix(c(3, 2, 1, 0, 4, 1, 0, 0, 2), nrow = 3, ncol = 3)
#' fs(lw) #
#' solve(Lw)

fs <- function(Lw){
  # Use forwardsolve function to calculate the inverse of a lower triangular matrix
  return(forwardsolve(Lw, x = diag(ncol(Lw))))
}
