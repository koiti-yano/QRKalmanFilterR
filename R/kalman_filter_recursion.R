#' @title kalman_filter_recursion
#'
#' @description
#' kalman_filter_recursion is the main function to implement
#' the Kalman filter.
#'
#' @details The Kalman filter is a recursive algorithm for estimating
#' the state of a linear dynamic system from a series of observed
#' measurements.
#'
#' The state space model is given by
#' \deqn{x(t) = F x(t-1) + E u(t) + v(t)}
#' \deqn{y(t) = H x(t) + w(t)}
#' where \eqn{x(t)} is the state vector (\eqn{k \times 1}),
#' \eqn{y(t)} is the observation vector (\eqn{l \times 1}),
#' \eqn{u(t)} is the exogenous vector (\eqn{n \times 1}),
#' \eqn{v(t)} is the state noise (\eqn{k \times 1}),
#' and \eqn{w(t)} is the observation noise (\eqn{l \times 1}).
#' The Kalman filter is used to estimate the state vector
#' \eqn{x(t)} given the observations \eqn{y(t)}.
#'
#' The Kalman filter is implemented using the following recursion:
#' Prediction step:
#'  \deqn{x(t|t-1) = F x(t-1|t-1) + E u(t)}
#'  \deqn{P(t|t-1) = F P(t-1|t-1) F^t + V}
#'  Innovation step:
#'  \deqn{e(t) = y(t) - H x(t|t-1)}
#'  \deqn{s(t) = H P(t|t-1) H^t + W}
#'  Update step:
#'  \deqn{K(t) = P(t|t-1) H^t s(t)^{-1}}
#'  \deqn{x(t|t) = x(t|t-1) + K(t) e(t)}
#'  \deqn{P(t|t) = (I - K(t) H) P(t|t-1)}
#'  where \eqn{x(t|t)} is the estimated state vector at,
#'  \eqn{P(t)} is the estimated state covariance matrix,
#'  and \eqn{K(t)} is the Kalman gain at time t.
#'
#'  See Kitagawa, (2010), Introduction to Time Series Modeling, Chapman & Hall
#' for more details.
#'
#' @param y The observation vector (\eqn{l \times 1})
#' @param u The exogenous vector (\eqn{n \times 1})
#' @param x0 The initial state vector (\eqn{k \times 1})
#' @param P0 The initial state covariance matrix (\eqn{k \times k})
#' @param F The state transition matrix (\eqn{k \times k})
#' @param E The control matrix (\eqn{k \times n})
#' @param H The observation matrix (\eqn{l \times k})
#' @param V The state noise covariance matrix (\eqn{k \times k})
#' @param W The observation noise covariance matrix (\eqn{l \times l})
#' @return A list with the following components:
#' \item{xt}{The estimated state vector (\eqn{k \times 1})}
#' \item{Pt}{The estimated state covariance matrix (\eqn{k \times k})}
#' @export

kalman_filter_recursion <- function(y, u, x0, P0, F, E, H,
                                    V, W) {
  source("../R/kalman_filter.R") # Need to improve this line
  yy<-y # variable traceability
  uu <- u # variable traceability
  FF <- F # variable traceability
  EE <- E # variable traceability
  HH <- H # variable traceability
  VV <- V # variable traceability
  WW <- W # variable traceability

  #browser()
  TT <- dim(yy)[2]
  xx_stored <- array(0, c(dim(FF)[1], TT+1))
  PP_stored <- array(0, c(dim(FF)[1], dim(FF)[2], TT+1))
  xx_stored[,1] <- x0
  PP_stored[,,1] <- P0
  xx <- x0
  PP <- P0
  ee <- array(0, c(dim(HH)[1], 1))
  ss <- array(0, c(dim(HH)[1], dim(HH)[1]))
  KK <- array(0, c(dim(FF)[1], dim(HH)[1]))

  for (ii in 1:(TT)){
#    print(ii)
    # Iterate kalman_filter
    kf <- kalman_filter(yy=yy[,ii,drop=F], uu=uu[,ii, drop=F], xx=xx,
                         PP=PP, ss=ss, ee=ee,
                         FF=FF, EE=EE, HH=HH, VV=VV, WW=WW, KK)
    xx_stored[,ii+1] <- kf$xx; PP_stored[,,ii+1] <- kf$PP
  }

  return(list(xx_stored=xx_stored, PP_stored=PP_stored))
}
