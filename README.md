# QRKalmanFilterR 

## The square root Kalman Filter using only QR decompositions <img align="right" src="/tools/hex_QRKalman.png" width="120">

I devise an R implimentation of the Square root Kalman Filter using only QR decompositions by Tracy (2022). Please be advised that all codes and documents are provisional as the project is currently in progress. Any comments are welcome in discussion.

## Installation
```R
# install.packages("devtools")
devtools::install_github("koiti-yano/QRKalmanFilterR", upgrade="never")
```

## Examples

See "run_kf_qr_1.R" and "run_kf_qr_2.R" in "tools/".

## Documents

See PDFs in "tools/".

## References
Anderson, Brian D. O., Moore, John B, (1979), Optimal Filtering, Dover Books.

Kitagawa, Genshiro, (2010), Introduction to Time Series Modeling, Chapman & Hall.

Tracy, Kevin, (2022), "A Square-Root Kalman Filter Using Only QR Decompositions," https://arxiv.org/abs/2208.06452

Tracy, Kevin, (2022), QRKalmanFilter, 
https://github.com/kevin-tracy/QRKalmanFilter
