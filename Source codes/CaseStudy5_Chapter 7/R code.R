startupcost <- read.csv("H:/springer book/Case study/CaseStudy5/startupcost.csv", stringsAsFactors=FALSE)
View(startupcost)

str(startupcost)

startup2 <- startupcost

recon1 <- rowSums(!is.na(startup2[-(1:5)]))

# similar variance 

var.test(startup2$X1,startup2$X2)


# Normal distribution 

d <- density(na.omit(startup2$X1))
plot(d)

library("pastecs")


stat.desc(na.omit(startup2$X1))

boxplot(startup2$X1)

# t test 
t.test(startup2$X1 , startup2$X2 ,var.equal = TRUE)
t.test(startup2$X1 , startup2$X2 ,var.equal = FALSE)

# ANOVA
str(startup2)
data1<- aov(X1 ~ X2+X3+X4, data=startup2)
summary(data1)
 
# Normal distribution of residuals 
data1$residuals    
shapiro.test(data1$residuals)

# Equal Variance 
bartlett.test(list(startup2$X1,startup2$X2,startup2$X3,startup2$X4))

summary(startup2)

# Chi Sq test

library(MASS) 

chisq.test(startup2$X1,startup2$X2,startup2$X3,startup2$X4)
