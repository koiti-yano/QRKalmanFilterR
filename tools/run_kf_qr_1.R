# Compare the Kalman filter and QR Kalman filter on simulated data

# https://stackoverflow.com/questions/13672720/r-command-for-setting-working-directory-to-source-file-location-in-rstudio
#setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# This script runs the QR/plain-vanilla Kalman filter on the simulated data.
# The Kalman filter is implemented in kalman_filter_recursion.R
# The QR Kalman filter is implemented in qr_kalman_filter_recursion.R

# Generate simulated data

TT <- 100
dt <- 0.1
n <- 6
m <- 6
nu <- 3
FF <- diag(n) + rbind(cbind(matrix(0, nrow = 3, ncol = 3), dt * diag(3)), matrix(0, nrow = 3, ncol = 6))
EE <- rbind(0.5 * dt^2 * diag(3), dt * diag(3))
HH <- diag(n)

VV <- 0.1 * diag(n)
WW <- 0.1 * diag(n)

x0 <- array(0, c(6,1))
P0 <- diag(n)
uu <- array(0, c(nu, TT))
xx <- array(0, c(n, TT))
yy <- array(0, c(n, TT))
xx[,1] <- x0

Sig0 <- chol(P0)
Gm_v <- chol(VV)
Gm_w <- chol(WW)

for (ii in 2:TT){
  # System equation
  xx[,ii] <- FF %*% xx[,ii-1, drop=F] + EE %*% uu[,ii-1, drop=F] +
    VV %*% matrix(rnorm(n),c(n,1))
  # Observation equation
  yy[,ii] <- HH %*% xx[,ii, drop=F] + WW %*% matrix(rnorm(n),c(n,1))
}

# Run the Kalman filter on the simulated data
source("../R/kalman_filter_recursion.R")
kfr <- kalman_filter_recursion(y=yy, u=uu, x0=x0, P0=P0,
                               F=FF, E=EE, H=HH,
                               V=VV, W=WW)

# Run the QR Kalman filter on the simulated data
source("../R/qr_kalman_filter_recursion.R")
qrkfr <- qr_kalman_filter_recursion(y=yy, u=uu, x0=x0, Sig0=Sig0,
                                  F=FF, E=EE, H=HH,
                                  Gm_v=Gm_v, Gm_w=Gm_w)
if(1){
  # Plot the results
  par(mfrow=c(1,2))
  plot(xx[1,], type="l", xlab="Time", ylab="State 1", col="black")
  lines(kfr$xx_stored[1,], type="l", col="red",lwd=1.5)
  lines(qrkfr$xx_stored[1,], type="l", col="blue",lwd=1.5)

  plot(xx[2,], type="l", ylab="State 2", col="black")
  lines(kfr$xx_stored[2,], type="l", col="red",lwd=1.5)
  lines(qrkfr$xx_stored[2,], type="l", col="blue",lwd=1.5)
}
