# IMPORT DATA 
Sales <- read.csv("F:/springer book/Case study/CaseStudy7/Sales.csv", stringsAsFactors=FALSE)

str(Sales)
dim(Sales)

# C and O 
# Merge the Returns data and the Manager name
# import the 2 datasets 



Manager <- read.csv("F:/springer book/Case study/CaseStudy7/Sales_manager.csv", stringsAsFactors=FALSE)
str(Manager)

Returns <- read.csv("F:/springer book/Case study/CaseStudy7/Sales_returns.csv", stringsAsFactors=FALSE)
str(Returns)

# Sort data 
attach(Returns)
Returns1 <- Returns[order(Order.ID),] 

attach(Sales)
Sales1 <- Sales[order(Order.ID),] 


total <- merge(Sales1,Returns1,by="Order.ID",all = TRUE)

dim(total)

str(total)

# Visualise - Sales vs Returns (Status = Returned / NA)
total[["Status"]][is.na(total[["Status"]])] <- "NotReturned"

library(MASS)

# frequency of returns 
mytable<- xtabs(~Status, data = total)
mytable
pie(mytable)

slices<- c(7527, 872)
lbls<- c("NotReturned", "Returned")
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, pct)
lbls <- paste(lbls,"%",sep="")
pie(slices,labels = lbls, col=rainbow(length(lbls)),
    main="Returned vs Not Returned- freq")


# value of returns thru cross tab 


total$Salesnum <- total$Sales
mytable2 <- aggregate(Salesnum ~ Status, total, sum)
mytable2

slices<- c(13260747, 1654854)
lbls<- c("NotReturned", "Returned")
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, pct)
lbls <- paste(lbls,"%",sep="")
pie(slices,labels = lbls, col=rainbow(length(lbls)),
    main="Returned vs Not Returned- value")


# Correlation 
# Create numerical value for Status 

total$statusnum[total$Status=="Returned"] <- 1

total$statusnum[total$Status=="NotReturned"] <- 0

cor(total$Salesnum,total$statusnum )

cor.test(total$Salesnum,total$statusnum )$p.value
