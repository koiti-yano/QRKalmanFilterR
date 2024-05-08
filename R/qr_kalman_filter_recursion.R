#' qr kalman_filter_recursion.R
#' Square root Kalman Filter using only QR decompositions.
#'
#' The state space model is given by
#' x(t) = F x(t-1) + E u(t) + v(t)
#' y(t) = H x(t) + w(t)
#' where x(t) is the state vector (\eqn{k \times 1}),
#' y(t) is the observation vector (\eqn{l \times 1}),
#' u(t) is the exogenous vector (\eqn{n \times 1}),
#' v(t) is the state noise (\eqn{k \times 1}),
#' and w(t) is the observation noise (\eqn{l \times 1}).
#' The Kalman filter is used to estimate the state vector
#' x(t) given the observations y(t).
#'
#' @param y The observation vector (\eqn{l \times 1})
#' @param u The exogenous vector (\eqn{n \times 1})
#' @param x0 The initial state vector (\eqn{k \times 1})
#' @param Sig0 The initial state covariance matrix (\eqn{k \times k})
#' @param F The state transition matrix (\eqn{k \times k})
#' @param E The control matrix (\eqn{k \times n})
#' @param H The observation matrix (\eqn{l \times k})
#' @param Gm_v The state noise covariance matrix (\eqn{k \times k})
#' @param Gm_w The observation noise covariance matrix (\eqn{l \times l})
#' @return A list with the following components:
#' \item{xt}{The estimated state vector (\eqn{k \times 1})}
#' \item{Pt}{The estimated state covariance matrix (\eqn{k \times k})}
#'
#' @examples
#' # Kalman filter example
#' FF <- matrix(c(1, 1, 0, 1), 2, 2)
#' EE <- matrix(c(0, 1), 2, 1)
#' HH <- matrix(c(1, 0), 1, 2)
#' QQ <- matrix(c(0.1, 0, 0, 0.1), 2, 2)
#' RR <- matrix(0.1, 1, 1)
#' x0 <- matrix(c(0, 0), 2, 1)
#' V0 <- matrix(c(1, 0, 0, 1), 2, 2)
#' u <- matrix(0, 1, 1)
#' y <- matrix(c(1, 2), 2, 1)
#' kalman_filter(y, u, FF, EE, HH, QQ, RR, x0, P0)

qr_kalman_filter_recursion <- function(y, u = 0, x0, Sig0, F, E, H,
                                       Gm_v, Gm_w) {
  source("qr_kalman_filter.R")
  yy <- y # variable traceability
  uu <- u # variable traceability
  FF <- F # variable traceability
  EE <- E # variable traceability
  HH <- H # variable traceability

  #browser()
  TT <- dim(yy)[2]
  xx_stored <- array(0, c(dim(FF)[1], TT+1))
  Sig_stored <- array(0, c(dim(FF)[1], dim(FF)[2], TT+1))
  xx_stored[,1] <- x0
  Sig_stored[,,1] <- Sig0
  xx <- x0
  Sig <- Sig0
  GG <- array(0, c(dim(HH)[1], dim(HH)[1]))
  ee <- array(0, c(dim(HH)[1], 1))
  II <- diag(dim(FF)[1])

  for (ii in 1:(TT)){
#    print(ii)
    kf <- qr_kalman_filter(yy=yy[,ii, drop=F], uu=uu[,ii, drop=F], xx=xx,
                         Sig=Sig, FF=FF, EE=EE, HH=HH,
                         Gm_v=Gm_v, Gm_w=Gm_w, GG=GG, ee=ee, II=II)
    xx_stored[,ii+1] <- kf$xx; Sig_stored[,,ii+1] <- kf$Sig
  }

  return(list(xx_stored=xx_stored, Sig_stored=Sig_stored))
}
