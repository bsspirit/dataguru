## > library(raster)
## > waldo=brick(system.file("DepartmentStoreW.grd",
##                 + package="raster"))
## > waldo
## class       : RasterBrick
## dimensions  : 768, 1024, 786432, 3 (nrow,ncol,ncell,nlayer)
## resolution  : 1, 1  (x, y)
## extent      : 0, 1024, 0, 768  (xmin, xmax, ymin, ymax)
## coord. ref. : NA
## values      : C:\R\win-library\raster\DepartmentStoreW.grd
## min values  : 0 0 0
## max values  : 255 255 255

## library(raster)
## #waldo=brick(system.file("external/DepartmentStoreW.grd", package="raster"))
## 
## waldo=brick(system.file("external/rlogo.grd", package="raster"))
## print(waldo)
## 
## plot(waldo,useRaster=FALSE)
## 
## # white component
## white = min(waldo[[1]] , waldo[[2]] , waldo[[3]])>220
## focalswhite = focal(white, w=3, fun=mean)
## plot(focalswhite,useRaster=FALSE)
## 
## # red component
## red = (waldo[[1]]>150)&(max(  waldo[[2]] , waldo[[3]])<90)
## focalsred = focal(red, w=3, fun=mean)
## plot(focalsred,useRaster=FALSE)
## 
## 
## # striped component
## striped = red; n=length(values(striped)); h=5
## values(striped)=0
## values(striped)[(h+1):(n-h)]=(values(red)[1:(n-2*h)]==
##             TRUE)&(values(red)[(2*h+1):n]==TRUE)
## focalsstriped = focal(striped, w=3, fun=mean)
## plot(focalsstriped,useRaster=FALSE)

library(raster)
waldo = stack("DepartmentStore.jpg")

r = waldo[[1]] - waldo[[2]] - waldo[[3]]
r[is.na(r)] = 0
r_mask = Which(r > 0)
r_masked = r * r_mask

focalsd = focal(r_masked, w=3, fun=sd)
plot(focalsd)
