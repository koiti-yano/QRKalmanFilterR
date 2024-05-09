#' @title qr_kalman_filter_recursion
#'
#' @description
#' qr_kalman_filter_recursion is the main function to implement
#' the square root Kalman Filter using only QR decompositions.
#'
#' @details
#' The state space model is given by
#' \deqn{x(t) = F x(t-1) + E u(t) + v(t)}
#' \deqn{y(t) = H x(t) + w(t)}
#' where \eqn{x(t)} is the state vector (\eqn{k \times 1}),
#' \eqn{y(t)} is the observation vector (\eqn{l \times 1}),
#' \eqn{u(t)} is the exogenous vector (\eqn{n \times 1}),
#' \eqn{v(t)} is the state noise (\eqn{k \times 1}),
#' and \eqn{w(t)} is the observation noise (\eqn{l \times 1}).
#' The square root Kalman Filter is used to estimate the state vector
#' \eqn{x(t)} given the observations \eqn{y(t)}.
#'
#' The QR Kalman filter (square root Kalman Filter using only QR
#' decompositions) is implemented using the following recursion:
#' Prediction step:
#'  \deqn{x(t|t-1) = F x(t-1|t-1) + E u(t)}
#'  \deqn{\Sigma(t|t-1) = gr_r(\Sigma(t-1|t-1) F^t, \Gamma_v)}
#'  Innovation step:
#'  \deqn{e(t) = y(t) - H x(t|t-1)}
#'  \deqn{G(t) = gr_r(\Sigma (t|t-1) H^t, \Gamma_w)}
#'  Update step:
#'  \deqn{K(t) = {[G(t)^{-1} (G(t)^{-t}  H^t) { \Sigma (t|t-1)}^t \Sigma(t|t-1)]}^{-t}}
#'  \deqn{x(t|t) = x(t|t-1) + K(t) e(t)}
#'  \deqn{\Sigma(t|t) = gr_r(\Sigma(t|t-1) {(I - K(t) H)}^t, \Gamma_w {K(t)}^t)}
#'  where \eqn{x(t|t)} is the estimated state vector at time t given the
#'  observations up to time t, \eqn{G(t)} is the square root of
#'  the estimated state covariance matrix at time t given
#' the observations up to time t,
#'  \eqn{K(t)} is the Kalman gain at time t,
#'
#' @param y The observation vector (\eqn{l \times 1})
#' @param u The exogenous vector (\eqn{n \times 1})
#' @param x0 The initial state vector (\eqn{k \times 1})
#' @param Sig0 The square root of the initial state covariance matrix (\eqn{k \times k})
#' @param F The state transition matrix (\eqn{k \times k})
#' @param E The control matrix (\eqn{k \times n})
#' @param H The observation matrix (\eqn{l \times k})
#' @param Gm_v The square root of the state noise covariance matrix (\eqn{k \times k})
#' @param Gm_w The square root of the observation noise covariance matrix (\eqn{l \times l})
#' @return A list with the following components:
#' \item{x(t)}{The estimated state vector (\eqn{k \times 1})}
#' \item{Sig(t)}{The square root of the estimated state covariance matrix (\eqn{k \times k})}
#'
#' @export

qr_kalman_filter_recursion <- function(y, u = 0, x0, Sig0, F, E, H,
                                       Gm_v, Gm_w) {
  source("../R/qr_kalman_filter.R") # Need to improve this line
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
