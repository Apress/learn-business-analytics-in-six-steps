setwd('H:/springer book/Case study/CaseStudy3')

#IMPORT DATA
mydata <- read.table("H:/springer book/Case study/CaseStudy3/Contacts register Aug 2015 and purchase order over 5000 April to June 2015.csv", header=TRUE, sep=',', stringsAsFactors = FALSE)

#DIMENSIONS OF DATA 
dim(mydata)

# VIEW DATA 
View(mydata)
head(mydata, n=10)

# VIEW CONTENTS 
str(mydata)
ls(mydata)

# DROP VARIABLES  13, 14,15, 16,17
newdata1 <- mydata[c( -13, -14,-15, -16,-17)]
head(newdata1, n=10)
ls(newdata1)

newdata1$Effective.Date<-NULL
newdata1$Description.of.goods.and.services<-NULL
newdata1$Extension.Period<-NULL
newdata1$NominatedContactPoint<-NULL
newdata1$Review.Date<-NULL
newdata1$SupplierName<-NULL
newdata1$Title.of.agreement<-NULL

dim(newdata1)

str(newdata1)

# CONVERT DATE VARIABLES INTO DATE FORMAT 
newdata1$Contract.Start.Date1<- as.Date(newdata1$Contract.Start.Date, "%m/%d/%Y")
newdata1$End.Date1<- as.Date(newdata1$End.Date,"%m/%d/%Y")
str(newdata1)

#DROP REDUNDANT VARIABLES
newdata1$Contract.Start.Date<-NULL
newdata1$End.Date<-NULL
str(newdata1)


# CREATE NEW VARIABLES 

newdata1$tat<- newdata1$End.Date1-newdata1$Contract.Start.Date1
newdata1$tat1<- as.numeric(newdata1$tat)
newdata1$perday<- newdata1$Contract.Value/newdata1$tat1
str(newdata1)

# C - NO ACTIVITY REQUIRED
# O - MISSING VALUES
# CHECK MISSING VALUES 

sapply(newdata1, function(x) sum(is.na(x)))

# DROP OBS WHERE END DATE IS MISSING ; KEEP OBS WHERE DATA IS COMPLETE 

newdata2<- newdata1[complete.cases(newdata1[,5:8]),]

# CHECK FREQUENCY TO UNDERSTAND SEGMENTS IN THE Service.responsible VARIABLE
# INSTALL PACKAGE 
install.packages('plyr')
library('plyr')

table1<- count(newdata2, 'Service.responsible')

table1

# To understand Average value of TAT across different segments of Service_responsible

barplot(with(newdata2, tapply(tat, Service.responsible, mean) ))

#CREATE PIE CHART TO UNDERSTAND CONTRIBUTION OF EACH SEGMENT OF Service_responsible IN THE DATA
library(MASS)   
serv.freq = table(newdata2$Service.responsible)
pie(serv.freq)

#DRAW A SCATTER PLOT TO SEE IF SOME CASES HAVE SIGNIFICANTLY HIGHER TAT OR HIGHER RATE PER DAY VALUES
plot(newdata2$tat)

#scatter plot1
newdata3 <- subset(newdata2,newdata2$Service.responsible=='Community')
plot(newdata3$tat)


#scatter plot2
newdata4 <- subset(newdata2,newdata2$Service.responsible=='Democratic Legal & Policy')
plot(newdata4$tat)

#scatter plot3
newdata5 <- subset(newdata2,newdata2$Service.responsible=='Environment')
plot(newdata5$tat)

#scatter plot4
newdata6 <- subset(newdata2,newdata2$Service.responsible=='Finance & Commercial')
plot(newdata6$tat)

#scatter plot5
newdata7 <- subset(newdata2,newdata2$Service.responsible=='Human Resources ICT/CSC & Shared Support Services')
plot(newdata7$tat)

#scatter plot6
newdata8 <- subset(newdata2,newdata2$Service.responsible=='Planning & Sustainability')
plot(newdata8$tat)