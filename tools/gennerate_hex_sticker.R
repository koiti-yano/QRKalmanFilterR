# create hexagon sticker for QRKalman


# install.packages("hexSticker")

par(mfrow=c(1,1))
plot(xx[1,], type="l", xlab="",xaxt="n", ylab="State", col="black")


library(hexSticker)
s <- sticker(~plot(xx[1,],type="l",xlab="",xaxt="n",ylab="State", col="black"),
             package="QRKalman", p_size=20, s_x=1.0, s_y=0.8, s_width=1.2, s_height=1.0,
             filename="tools/hex_QRKalman.png")
