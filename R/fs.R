#' fs: the inverse of a lower triangular matrix with forwardsolve
#' @title forward substitution with forwardsolve
#' @export
#' @param Lw a lower triangular matrix

fs <- function(Lw){
  # Use forwardsolve function to calculate the inverse of a lower triangular matrix
  return(forwardsolve(Lw, x = diag(ncol(Lw))))
}
