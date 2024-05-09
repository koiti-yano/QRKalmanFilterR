#' qm: quick matrix
#' @author Rasmus Bååth
#' @examples
#' # example code
#' qm(1, 2 | 3, 4)
#' qm(1, 2, 3 | 4, 5, 6 | 7, 8, 9)
#' qm(1 | 2 | 3)
#'
#' @export
#'
qm <- function(...) {
  # Get the arguments as a list
  arg <- eval(substitute(alist(...)))
  # Initialize l as a list of vecors, each vector in l corresponds to one row
  # of the matrix.
  l <- list(c())
  # rhl_l is a list where we will push the rhs of expressions like 1 | 2 | 3 ,
  # which parses as (1 | 2) | 3 , while we deal with the left hand side (1 |
  # 2)
  rhl_l <- list()
  while (length(arg) > 0) {
    a <- arg[[1]]
    arg <- tail(arg, -1)
    if (length(a) > 1 && a[[1]] == "|") {
      # Push the left hand side of the ... | ... expression back on the arguments
      # list and push the rhs onto rhl_l
      arg <- c(a[[2]], arg)
      rhl_l <- c(a[[3]], rhl_l)
    } else {
      # Just a normal element, that we'll evaluate and append to the last
      # vector/row in l.
      l[[length(l)]] <- c(l[[length(l)]], eval(a))
      # If there are rhs elements left in rhs_l we'll append them as new
      # vectors/rows on l and then we empty rhs_l.
      for (i in seq_along(rhl_l)) {
        l[[length(l) + 1]] <- eval(rhl_l[[i]])
      }
      rhl_l <- list()
    }
  }
  do.call(rbind, l)
}
