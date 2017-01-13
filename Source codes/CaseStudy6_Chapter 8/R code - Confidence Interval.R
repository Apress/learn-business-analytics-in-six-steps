# D- understand the correlation between Balance of Payments of Goods and Services 
# Understadn if Balance of Payments for Exports and Imports can be said to belong to the same population 

# Import data 
BOP <- read.csv("F:/springer book/Case study/CaseStudy6/BOP.csv", stringsAsFactors=FALSE)

# Check Format 
str(BOP)
# Conclusion :- all are integers 

# C and O - check for missing values and outliers 
# Check Descriptive statistics 
install.packages("pastecs")

library(pastecs)

stat.desc(BOP)

# Conclusion :- No null or na values 
# Draw boxplot 

boxplot(BOP)

# There are outliers in most of the variables 
# Remove outliers for  total_BOP,  Goods_BOP, Services_BOP

# Remove outliers using The boxplot.stats function; is a ancillary 
#function that produces statistics for drawing boxplots. It returns among 
#other information a vector stats with five elements: the extreme of the 
#lower whisker, the lower 'hinge', the median, the upper 'hinge' and the 
#extreme of the upper whisker, the extreme of the whiskers are the adjacent 
#values (last non-missing value, i.e. every value beyond is an outlier.

#Outliers are then all values outside the interval id1$stats[1] < and id1$stats[5]


id1 <- boxplot.stats(BOP$total_BOP)

id2 <- boxplot.stats(BOP$total_BOP, coef=2)

id1$stats

id1$stats[1]

id1$stats[5]

# Conclusion - Outliers for BOP$total_BOP is Below -761716 and above 12404
summary(BOP$total_BOP)

# Conclusion - no outliers for total_BOP


id1 <- boxplot.stats(BOP$Goods_BOP)
id2 <- boxplot.stats(BOP$Goods_BOP, coef=2)
id1$stats
id1$stats[1]
id1$stats[5]
summary(BOP$Goods_BOP)
# Conclusion - There are values below the lower limit of -837289 which should be dropped 

id1 <- boxplot.stats(BOP$Services_BOP)
id2 <- boxplot.stats(BOP$Services_BOP, coef=2)
id1$stats
id1$stats[1]
id1$stats[5]
summary(BOP$Services_BOP)
# Conclusion - there are values above 154020 which should be dropped 

# subset to remove outliers from 2 variables 
NEWBOP<- subset(BOP, Goods_BOP>-837289)
NEWBOP<-subset(NEWBOP, Services_BOP<154020)
dim(NEWBOP)

# A- Analyse the data by running correlation between Services and Good BOP 

cor(NEWBOP$Goods_BOP, NEWBOP$Services_BOP)
cor.test(NEWBOP$Goods_BOP, NEWBOP$Services_BOP)$p.value


# Conclusion - The correlation coefficient is -.79 and the p value is <=.05. 
# Thus we can conclude that the correlation is real and should be accepted

# you can aslo use 
#install.packages("Hmisc")
#library(Hmisc)
# rcorr(NEWBOP, type="pearson")





