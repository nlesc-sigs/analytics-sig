rm(list=ls())
graphics.off()
# Specify working directory
wd= "D:/OneDrive - Netherlands eScience Center/talks/StatsSIG 2 August 2018/"
# Example and data from Gelman and Hill:
# 'Data Analysis Using Regression and Multilevel/Hierarchical Models'
# Cambridge University Press 2017
# Data vailable from: http://www.stat.columbia.edu/~gelman/arm/examples/
#======================================================
#======================================================
# Chapter 13: Multi-level modelling
#======================================================
#======================================================
library(lme4)
library(arm)
# read in and clean the data
ssrs2filename = paste0(wd,"srrs2.dat")
ctyfilename =  paste0(wd,"cty.dat")
srrs2 = read.table(ssrs2filename, header=T, sep=",")
mn = srrs2$state=="MN"
radon = srrs2$activity[mn]
log.radon = log (ifelse (radon==0, .1, radon))
floor = srrs2$floor[mn] # 0 for basement, 1 for first floor
n = length(radon)
log.radon = log.radon
x = floor
# get county index variable
county.name = as.vector(srrs2$county[mn])
uniq = unique(county.name)
J = length(uniq)
county = rep (NA, J)
for (i in 1:J){
  county[county.name==uniq[i]] = i
}
# get the county-level predictor
srrs2.fips = srrs2$stfips*1000 + srrs2$cntyfips
cty = read.table (ctyfilename, header=T, sep=",")
usa.fips = 1000*cty[,"stfips"] + cty[,"ctfips"]
usa.rows = match (unique(srrs2.fips[mn]), usa.fips)
uranium = cty[usa.rows,"Uppm"]
u = log (uranium)
uranium = u[county]

#===================================================
# Key variables:
# log.radon: log.radon a naturally occuring gas causing lung cancer
# floor: floor on which measurment is taken
# u: soil uranium which differs by state
# uranium: same as u but provided at a house level
# Aim: identify areas where radon levels are higher, while taking into account all information

library(nlme)
radonstudy = data.frame(log.radon=log.radon,floor=floor,county=county,uranium=uranium)
display8 = c (36, 1, 35, 21, 14, 71, 61, 70)
radonstudy = radonstudy[which(radonstudy$county %in% display8),]


#===================================================
# Based on lme from the nlme package
ctrl = lmeControl(opt="optim")

# varying-intercept
fit1 = nlme::lme(fixed = log.radon ~ floor, random = ~1|county,data=radonstudy,control=ctrl,na.action = na.omit)

# varying-intercept, varying-slope with no group-level predictors
fit2 = nlme::lme(fixed = log.radon ~ floor, random = ~1 + floor|county,data=radonstudy,control=ctrl,na.action = na.omit)

# varying-intercept, varying-slope with group-level predictors
fit3 = nlme::lme(fixed = log.radon ~ floor + uranium, random = ~1 + floor|county,data=radonstudy,control=ctrl,na.action = na.omit)

coef(fit2)[1,] # 0.8927377 -0.3806795
fixed.effects(fit2) #1.3634618  -0.5616935
random.effects(fit2)[1,] #-0.4707241 0.181014

#===================================================
# Based on lmre from the lme4 package

# varying-intercept
M1 = lme4::lmer (log.radon ~ floor + (1 | county), data = radonstudy)

# varying-intercept, varying-slope with no group-level predictors
M2 = lme4::lmer (log.radon ~ floor + (1 + floor | county), data = radonstudy)

# varying-intercept, varying-slope with group-level predictors
M3 = lme4::lmer (log.radon ~ floor + uranium + (floor | county), data = radonstudy)

coef(M2)$county[1,] # 0.8955543 -0.3926359
fixef(M2)   # 1.3651034  -0.5686104
ranef(M2)$county[1,] #-0.4695491 0.1759745




#===================================================
# Create plots
radonstudy$floor.jitter = radonstudy$floor + runif(length(radonstudy$floor),-.05,.05)
log.radon.range = range(log.radon[!is.na(radonstudy$county)]) * c(1,1.5)
lm.pooled = lm (log.radon ~ floor, data = radonstudy)
b.hat.unpooled.varying = array (NA, c(length(display8),2))
for (j in 1:length(display8)){
  lm.unpooled.varying = lm (log.radon ~ floor, subset=c(county==display8[j]))
  b.hat.unpooled.varying[j,] = coef(lm.unpooled.varying)
}

for (zz in 1:3) {
  # Create a plot from the different models
  jpeg(filename = paste0(wd,paste0("ML_plot",zz,".jpeg")),
       width = 11,height= 6, units = "in",res=600)
  par (mfrow=c(2,4), mar=c(4,4,3,1), oma=c(1,1,2,1))
  for (j in 1:length(display8)){
    county_j = which(radonstudy$count == display8[j])
    plot (radonstudy$floor.jitter[county_j], radonstudy$log.radon[county_j], 
          xlim=c(-.05,1.05), ylim=log.radon.range,
          xlab="floor", ylab="log radon level", cex.lab=1.6, cex.axis=1.5,cex=1.2,
          pch=20, mgp=c(2,.7,0), xaxt="n", yaxt="n", cex.main=1.3, main=uniq[j])
    axis (1, c(0,1), mgp=c(2,.7,0), cex.axis=1.5)
    axis (2, seq(-1,3,2), mgp=c(2,.7,0), cex.axis=1.5)
    if (zz >= 1) {
      # linear model fitted on all the data not taking into account the county
      curve (coef(lm.pooled)[1] + coef(lm.pooled)[2]*x, lwd=1, lty=2, col="darkgrey", add=TRUE)
    }
    if (zz == 2) {
      # linear models fitted per county
      curve (b.hat.unpooled.varying[j,1] + b.hat.unpooled.varying[j,2]*x, lwd=1, col="blue", add=TRUE)
    }
    if (zz == 3) {
      # multi-level model with varying-intercept
      M1predict=predict(M1,radonstudy[county_j,])
      lines(radonstudy$floor[county_j],M1predict,type="l",lwd=1,col="red")
      # multi-level model with varying-intercept and slope
      M2predict=predict(M2,radonstudy[county_j,])
      lines(radonstudy$floor[county_j],M2predict,type="l",lwd=1,col="green")
      # multi-level model with varying-intercept and slope, and group-level predictors
      M3predict=predict(M3,radonstudy[county_j,])
      lines(radonstudy$floor[county_j],M3predict,type="l",lwd=1,col="black")
    }
    par(xpd=FALSE) # this is usually the default
    legend("topright",legend=c("1 model 4 all","1 model | county","varying intercept",
                               "varying intercept and slope",
                               "varying intercept, slope, uraniam"),
           col=c("darkgrey","blue","red","green","black"),lwd=rep(1,5),cex=0.9,bty="n")
    par(xpd=T) # this is usually the default
  }
  dev.off()
}
