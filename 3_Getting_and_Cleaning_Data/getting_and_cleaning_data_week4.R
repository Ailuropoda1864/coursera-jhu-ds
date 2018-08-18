old.dir <- getwd()
setwd('~/code/r_coursera/3_Getting_and_Cleaning_Data/data/week4')


# Q1
# download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv',
#               destfile = 'Idaho_housing.csv')

housing <- read.csv('Idaho_housing.csv')
split <- strsplit(names(housing), 'wgtp')
print(split[123])


# Q2
# download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv',
#               destfile = 'GDP.csv')

gdp <- read.csv('GDP.csv', header=FALSE, skip=5, nrows=190, 
                col.names=c('id', 'rank', 'x1', 'country', 'US.dollars', 
                            'x2', 'x3', 'x4', 'x5', 'x6')
                )

library(dplyr)
gdp <- select(gdp, -starts_with('x'))

gdp %>%
    mutate(US.dollars=as.numeric(gsub(',', '', US.dollars))) %>%
    summarize(mean(US.dollars)) %>%
    print


# Q3
matches <-grep('^United', gdp$country)
print(length(matches))


# Q4
# download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv',
#               destfile = 'education.csv')

edu <- read.csv('education.csv')

combined <- gdp %>%
    select(id, rank) %>%
    left_join(edu, by=c('id'='CountryCode'))

june <- grep('Fiscal year end: June', combined$Special.Notes)
print(length(june))


# Q5
library(quantmod)
library(lubridate)
amzn = getSymbols("AMZN", auto.assign=FALSE)
sampleTimes = index(amzn)

print(sum(year(sampleTimes) == 2012))
print(sum(year(sampleTimes) == 2012 & wday(sampleTimes) == 2))


setwd(old.dir)