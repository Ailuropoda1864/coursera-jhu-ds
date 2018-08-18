old.dir <- getwd()
setwd('~/code/r_coursera/3_Getting_and_Cleaning_Data')


# Q1
library(jsonlite)
jsonData <- fromJSON('https://api.github.com/users/jtleek/repos')
names(jsonData)

index <- which(jsonData$name == 'datasharing')
jsonData$created_at[index]


# Q2
# url.string <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
# download.file(url.string, destfile = 'data/week2/acs.csv')
acs <- read.csv('data/week2/acs.csv')

sql.query <-
'SELECT pwgtp1 FROM acs
WHERE AGEP < 50;'

library(sqldf)
# also make sure that RMySQL library is detached 
sqldf(sql.query)


# Q3
sqldf("select distinct AGEP from acs")


# Q4
con <- url('http://biostat.jhsph.edu/~jleek/contact.html', 'r')
html <- readLines(con)
close(con)

lapply(html[c(10, 20, 30, 100)], nchar)


# Q5
# download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for',
#               destfile = 'data/week2/sst.txt')
header <- c(' Week          ', 
            'SST ', 'SSTA', 
            '     SST ', 'SSTA',
            '     SST ', 'SSTA', 
            '     SST ', 'SSTA')
widths <- sapply(header, nchar)
df <- read.fwf('data/week2/sst.txt', widths=widths, skip=4)
sum(df[4])


setwd(old.dir)