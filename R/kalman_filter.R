#' @title kalman_filter
#' @author Koichi (Koiti) Yano
#' @export
#'
#'
#'
kalman_filter <- function(yy, uu = 0, xx, PP, ss, ee,
                          FF, EE = 0, HH, VV, WW, KK) {

  #browser()
  # Compute the prediction
  kp <- kalman_prediction(xx, PP, uu, FF, EE, VV)
  xx <- kp$xx; PP <- kp$PP

  # Compute the innovation
  ki <- kalman_innovation(yy, xx, PP, HH, WW)
  ee <- ki$ee; ss <- ki$ss

  # Compute the update
  ku <- kalman_update(xx, PP, HH, ee, ss, KK)
  xx <- ku$xx; PP <- ku$PP

  return(list(xx = xx, PP = PP))
  }


#' kalman_prediction
kalman_prediction <- function(xx, PP, uu, FF, EE, VV) {

    # Compute the prediction
    xx = FF %*% xx + EE %*% uu
    PP = FF %*% PP %*% t(FF) + VV

    return(list(xx = xx, PP = PP))
  }

#' kalman_innovation
kalman_innovation <- function(yy, xx, PP, HH, WW) {

  #browser()
  # Compute the innovation
  ee = yy - HH %*% xx
  ss = HH %*% PP %*% t(HH) + WW

  return(list(ee = ee, ss = ss))
}

#' kalman_update
kalman_update <- function(xx, PP, HH, ee, ss, KK){

  # Compute the update
  KK = PP %*% t(HH) %*% solve(ss)
  xx = xx + KK %*% ee
  PP = PP - KK %*% HH %*% PP

  return(list(xx = xx, PP = PP))
}

#**************************************************
# end
#**************************************************
