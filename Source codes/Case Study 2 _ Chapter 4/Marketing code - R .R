# Prepare the Directory / space where you will work 
setwd("H:/springer book/Case study/CaseStudy2")
getwd()

# Import the data 


market1 <- read.table("E:/springer book/Case study/CaseStudy2/MarketingData.csv", header=TRUE, sep=",", stringsAsFactors = FALSE)

# Understand the dimensions of the dataset - Obs and Vars 
dim(market1)

# type of data in the data frame 

str(market1)

# 5 number Summary of Recurring Revenue 

summary(market1$Monthly.Reccuring.Revenue.in.INR)

#  Standard Deviation of Recurring Revenue 

sd(market1$Monthly.Reccuring.Revenue.in.INR)

library("psych")
describe(market1$Monthly.Reccuring.Revenue.in.INR, na.rm = TRUE, interp=FALSE,skew = TRUE, ranges = TRUE,trim=.1,type=3,check=TRUE)

# Create Frequency Tables 

attach(market1)

table(market1$CustomerType)

table(market1$TypeOfCalling)

table(market1$TypeOfCalling,market1$CustomerType)

table(market1$TypeOfCalling)

table(market1$TypeOfCalling,market1$CustomerType)

table1<- table(market1$TypeOfCalling,market1$CustomerType)

margin.table(table1,1)

margin.table(table1,2)

prop.table(table1) # cell percentages

prop.table(table1, 1) # row percentages

prop.table(table1,2) # column percentages

table(market1$Vertical)


# sort table to make sense 

table2<-table(market1$Vertical)

table4<-as.data.frame(table2) # convert to data frame

View(table4)
table5<- table4[order(-table4$Freq),] 

sum(table4$Freq)

table4$cfp<- table4$Freq/586
table4

table5<- table4[order(-table4$cfp),] 
View(table5)
table5

market1$newvar[market1$Vertical=="Media & Entertainment"]<-1
View(market1)

market1$newvar[market1$Vertical=="Retail"]<-2
market1$newvar[market1$Vertical=="High Technology"]<-3
market1$newvar[market1$Vertical=="Gaming"]<-4

market1[is.na(market1)]<-0 
table(market1$newvar)

library("ggplot2")

library("ggplot2")
qplot(newvar,Monthly.Reccuring.Revenue.in.INR, data = market1)

market1$TypeOfCalling <- as.factor(market1$TypeOfCalling)
qplot(newvar,Monthly.Reccuring.Revenue.in.INR, data = market1, color=TypeOfCalling)


market1$MRR.thou<-market1$Monthly.Reccuring.Revenue.in.INR/1000
qplot(newvar,MRR.thou, data = market1, color=TypeOfCalling)


# List of variables 
names(market1)

# Remove variables where Monthly Recurring Revenue is 0 
market2<- market1[which( market1$Monthly.Reccuring.Revenue.in.INR>0),]
dim(market2)

# Plots to explore sum of newvar (MRR in thousands) over the other variables 
ggplot(market2, aes(x=CustomerType, y=MRR.thou)) + geom_bar(stat="identity")

table1<- table(market2$CustomerType)
prop.table(table1) 

ggplot(market2, aes(x=Quarter, y=MRR.thou)) + geom_bar(stat="identity")
table1<- table(market2$CustomerType, market2$Quarter)
table1

prop.table(table1,2) 


# check average MRR across Customer Type 

ggplot(market2, aes(x=factor(CustomerType), y=MRR.thou)) + stat_summary(fun.y="mean", geom="bar")





















