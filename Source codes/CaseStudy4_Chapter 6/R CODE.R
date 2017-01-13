# SET WORKINg directory 
setwd('H://springer book//Case study//CaseStudy4')

#IMPORT DATA FILE 
Resolution<- read.csv("H:/springer book/Case study/CaseStudy4/Resolution time for Service request.csv", stringsAsFactors=FALSE)

#CHECK FORMAT 
str(Resolution)

# D = CREATE Y VARIABLE = CREATE RESOLUTON TIME 
# CONVERT Date.Opened AND Closed.Date INTO DATE TIME FORMAT 

Resolution$Open <- as.Date(Resolution$Date.Opened, "%m/%d/%Y %H:%M")

Resolution$closed <- as.Date(Resolution$Closed.Date, "%m/%d/%Y %H:%M")

str(Resolution$Open)
str(Resolution$closed)

Resolution$resolution.time=(Resolution$closed -Resolution$Open)
View(Resolution)

# CONVERT RESOLUTION TIME INTO NUMERIC
Resolution$resolution.time= as.numeric(Resolution$resolution.time)
str(Resolution$resolution.time)

# Box plot
boxplot(Resolution$resolution.time, horizontal=TRUE, main="RESOLUTION_TIME")

# DENSITY PLOT 
d<- density(Resolution$resolution.time)
plot(d)


# CHECK IF THERE ARE ANY VALUE LESS THAN 0 FOR RESOLUTION TIME 
attach(Resolution)
Resolution$resolution.time.cat[resolution.time<0]<-0
Resolution$resolution.time.cat[resolution.time>=0]<-1

mytable<- table(Resolution$resolution.time.cat)
mytable

# C & O - COLLECT AND ORGANISE THE DATA 

# CHECK FOR MISSING VALUES by replacing blanks with NA

#function to replace blanks with missing
blank2na <- function(x){ 
  z <- gsub("\\s+", "", x)  #make sure it's "" and not " " etc
  x[z==""] <- NA 
  return(x)
}

#apply that function
data.frame(sapply(Resolution,  blank2na))


#EXPLORE THE DATA TO UNDERSTAND NA AND OTHER SEGMENTS FOR DISCRETE VARIABLES
mytable<- table(Resolution$SR.Type)
mytable

mytable<- table(Resolution$Entitlement)
mytable

mytable<- table(Resolution$Billable)
mytable

# MISSING VALUES FOR CONTINUOUS DATA IN 10TH COLUMN- RESOLUTION TIME

Resolution[!complete.cases(resolution.time),10]


# OUTLIERS FOR CONTINUOUS VARIABLE -RESOLUTION TIME
install.packages("outliers")
library(outliers)

outs <- scores(Resolution$resolution.time, type="chisq", prob=0.997)
Resolution$resolution.time[outs]

# FREQUENCY TABLE OF AVG. RESOLUTION TIME BY IMPACT

library("plyr")

table1<- ddply(Resolution, c("Impact"), summarise,
               N    = length(resolution.time),
               mean = mean(resolution.time),
               median =median(resolution.time),
               sd   = sd(resolution.time)
               )
table1

# CREATE BOXPLOT TO CHECK DETAILS OF SEGMENTS UNDER IMPACT 

library(ggplot2)

bp1 <- ggplot(Resolution, aes(x=Impact, y=resolution.time)) + 
  geom_boxplot()
bp1


bp2<- ggplot(Resolution, aes(x=Impact, y=resolution.time)) + geom_boxplot() +
  stat_summary(fun.y=mean, geom="point", shape=5, size=4)

bp2

# FIND PERCENTILES
quantile(Resolution$resolution.time, c(.25, .50,  .75, .90, .99))

summary(Resolution$resolution.time)

# MAKE SUBSETS FOR VARIBLE IMPACT 
str(Resolution)

data2 <- subset(Resolution,Resolution$Impact=="Significant")
quantile(data2$resolution.time, c(.25, .50,  .75, .90, .99))
# REMOVE OUTLIER FOR SIGNIFICANT >99%
data2.1 <- subset(data2,data2$resolution.time <186.0)
quantile(data2.1$resolution.time, c(.25, .50,  .75, .90, .99))
boxplot(data2.1$resolution.time)



data1 <- subset(Resolution,Resolution$Impact=="Moderate")
quantile(data1$resolution.time, c(.25, .50,  .75, .90, .99))

# REMOVE OUTLIER FOR MODERATE >99% AND REWORK BECAUSE MMODERATE HAS A LONG TAIL IN THE BOXPLOT 
dim(data1)
data1.1 <- subset(data1,data1$resolution.time <=194.28)
quantile(data1.1$resolution.time, c(.25, .50,  .75, .90, .99))
boxplot(data1.1$resolution.time)

# REDO OUTLIER TREATMENT
data1.2 <- subset(data1.1,data1.1$resolution.time <=190.17)
quantile(data1.2$resolution.time, c(.25, .50,  .75, .90, .99))
boxplot(data1.2$resolution.time)

# REDO OUTLIER TREATMENT
data1.3 <- subset(data1.2,data1.2$resolution.time <=187.8)
quantile(data1.3$resolution.time, c(.25, .50,  .75, .90, .99))
boxplot(data1.3$resolution.time)
dim(data1.3)

# REDO OUTLIER TREATMENT
data1.4 <- subset(data1.3,data1.3$resolution.time <=185.82)
quantile(data1.4$resolution.time, c(.25, .50,  .75, .90, .99))
boxplot(data1.4$resolution.time)
dim(data1.4)

# REDO OUTLIER TREATMENT
data1.5 <- subset(data1.4,data1.4$resolution.time <=185.82)
quantile(data1.5$resolution.time, c(.25, .50,  .75, .90, .99))
boxplot(data1.5$resolution.time)
dim(data1.5)

summary(data1.5$resolution.time)

sd(data1.5$resolution.time)