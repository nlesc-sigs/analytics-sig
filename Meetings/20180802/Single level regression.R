rm(list=ls())
graphics.off()
# Specify working directory
wd= "D:/OneDrive - Netherlands eScience Center/talks/StatsSIG 2 August 2018/"
# Example and data from Gelman and Hill:
# 'Data Analysis Using Regression and Multilevel/Hierarchical Models'
# Cambridge University Press 2017
# Data vailable from: http://www.stat.columbia.edu/~gelman/arm/examples/
#======================================================
# Chapter 3: Linear regression
#======================================================
# Load data
library(foreign)
filename = paste0(wd,"kidiq.dta")
kidiq = read.dta(filename, convert.dates = TRUE, convert.factors = TRUE,
                 missing.type = FALSE,
                 convert.underscore = FALSE, warn.missing.labels = TRUE)
mom_hs_categories = c("mother completed high school",
                      "mother did not complete high school")

# Fit models:

# With one predictor (mom_hs)
lm_1pred = lm(kid_score ~ mom_hs, data = kidiq)

# With two predictors (mom_hs and mom_iq)
lm_2pred = lm(kid_score ~ mom_hs + mom_iq, data = kidiq)

# With two predictors with interaction term, the interaction
# term shows the difference in the slope between the two groups.
lm_2pred_interaction = lm(kid_score ~ mom_hs + mom_iq + mom_hs:mom_iq, data = kidiq)



#======================================================
# Scatterplots of data with regression lines on top:
jpeg(filename = paste0(wd,paste0("Linear_plot.jpeg")),
     width = 11,height= 6, units = "in",res=600)
# x11()
par(mfrow=c(1,3))
CL = 1.5
CA = 1.1
plot(kid_score ~ mom_hs, data = kidiq,type="p",pch=20,bty="l",
     xlab = "mother completed high school",
     ylab="kid test score",
     main = "1 predictor",cex.lab=CL,cex.axis=CA)
abline(coef(lm_1pred),col="blue",lwd=3)
# x11()
plot(kidiq$kid_score ~ kidiq$mom_iq,type="p",pch=20,bty="l",
     xlab = "mother iq",
     ylab="kid test score",
     main = "2 predictors",cex.lab=CL,cex.axis=CA)
curve(cbind(1,1,x) %*% coef(lm_2pred), col = 1, add = T, lwd=3)
curve(cbind(1,0,x) %*% coef(lm_2pred), col = 2, add = T, lwd=3)
legend("bottomright",col = c(1,2),lty=c(1,1),cex=0.8,
       legend = mom_hs_categories)
# x11()
plot(kidiq$mom_iq, kidiq$kid_score, type="p",pch=20,bty="l",
     xlab = "mother iq",
     ylab="kid test score",
     main = "2 predictors with with interaction",cex.lab=CL,cex.axis=CA)
curve(cbind(1,1,x, 1*x) %*% coef(lm_2pred_interaction), col = 1, add = T, lwd=3)
curve(cbind(1,0,x, 0*x) %*% coef(lm_2pred_interaction), col = 2, add = T, lwd=3)
legend("bottomright", col = c(1,2),lty=c(1,1),cex=0.8,
       legend = mom_hs_categories)
dev.off()