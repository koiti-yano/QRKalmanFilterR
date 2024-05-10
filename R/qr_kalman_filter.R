#' @title qr_kalman_filter
#' @author Koichi (Koiti) Yano
#' @docType package
#' @title QR Kalman Filter
#' @description Square root Kalman Filter using only QR decompositions.
#' @details This package provides a square root Kalman filter implementation
#' that uses only QR decompositions. This is a numerically stable way to
#' implement the Kalman filter.
#' @export

qr_r <- function(AA, BB) {

  # QR decomposition of matrix A where only the upper triangular R is returned
  return(qr.R(qr(rbind(AA,BB))))

}

qr_kalman_filter <- function(yy, uu = 0, xx, Sig, FF, EE = 0, HH,
                             Gm_v, Gm_w, GG=GG, ee=ee, II=II) {

  #browser()
  # Compute the prediction
  qr_kp <- qr_kf_prediction(xx, Sig, uu, FF, EE, Gm_v)
  xx <- qr_kp$xx; Sig_p <- qr_kp$Sig_p

  # Compute the innovation
  qr_ki <- qr_kf_innovation(yy, xx, Sig, HH, Gm_w)
  ee <- qr_ki$ee; GG <- qr_ki$GG

  # Compute the update
  qr_ku <- qr_kf_update(xx, Sig, HH, ee, GG, II)
  xx <- qr_ku$xx; Sig <- qr_ku$Sig

  return(list(xx=xx, Sig=Sig))
}

#' qr_kalman_prediction
qr_kf_prediction <- function(xx, Sig, uu, FF, EE, Gm_v) {

  #browser()
  # predict one step
  xx <- FF %*% xx + EE %*% uu
  Sig <- qr_r(Sig %*% t(FF), Gm_v)

  return(list(xx=xx, Sig=Sig))
}

#' qr_kalman_innovation
qr_kf_innovation <- function(yy, xx, Sig, HH, Gm_w, ee, GG) {

  #browser()
  # innovation
  ee <- yy - HH %*% xx
  GG <- qr_r((Sig %*% t(HH)), Gm_w)

  return(list(ee=ee, GG=GG))
}

#' qr_kalman_update
qr_kf_update <- function(xx, Sig, HH, ee, GG, II) {

  #browser()
  # update
  KK <- t(bs(GG) %*% (fs(t(GG))%*%HH) %*% t(Sig) %*% Sig)
  xx <- xx + KK %*% ee
  Sig <- qr_r(Sig%*%t(II-KK%*%HH), Gm_w %*% t(KK))

  return(list(xx=xx, Sig=Sig))
}
