old.dir <- getwd()
setwd('~/code/r_coursera/3_Getting_and_Cleaning_Data')


# Q1: How many properties are worth $1,000,000 or more?
# download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv',
#               destfile = 'data/week1/Idaho_housing.csv')
# download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf',
#               destfile = 'data/week1/code_book.pdf')

housing <- read.csv('data/week1/Idaho_housing.csv')
head(housing)
names(housing)
head(housing$VAL)
sum(housing$VAL==24, na.rm = TRUE)


# Q3
# download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx',
#               destfile = 'data/week1/NGAP.xlsx')

library(xlsx)
dat <- read.xlsx('data/week1/NGAP.xlsx', sheetIndex = 1, 
                 rowIndex = 18:23, colIndex = 7:15)
sum(dat$Zip*dat$Ext, na.rm=T)


# Q4
library(XML)
res <- xmlTreeParse('http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml',
                    useInternalNodes = TRUE)
rootNode <- xmlRoot(res)
zipcodes <- xpathSApply(rootNode, '//zipcode', xmlValue)
sum(zipcodes=='21231')


# Q5
# download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv',
#               destfile = 'data/week1/Idaho_housing2.csv')

library(data.table)
DT <- fread('data/week1/Idaho_housing2.csv')
DT[, mean(pwgtp15), by=SEX]


setwd(old.dir)