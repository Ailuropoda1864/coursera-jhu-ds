old.dir <- getwd()
setwd('~/code/r_coursera/3_Getting_and_Cleaning_Data')

# Q1
# download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv',
#               destfile = 'data/week3/Idaho_housing.csv')
# download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf',
#               destfile = 'data/week3/code_book.csv')

housing <- read.csv('data/week3/Idaho_housing.csv')
agricultureLogical <- housing$ACR==3 & housing$AGS==6
head(which(agricultureLogical), 3)


# Q2
# download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg',
#               destfile = 'data/week3/jeff.jpg')

library(jpeg)
pic <- readJPEG('data/week3/jeff.jpg', native=TRUE)
quantile(pic, probs = c(0.3, 0.8))
quantile(pic, probs = 0.3) - 638


# Q3
# download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv',
#               destfile = 'data/week3/GDP.csv')
# download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv',
#               destfile = 'data/week3/education.csv')

gdp <- read.csv('data/week3/GDP.csv', header=FALSE, skip=5, nrows=190, 
                col.names=c('id', 'rank', 'x1', 'country', 'US.dollars', 
                            'x2', 'x3', 'x4', 'x5', 'x6')
                )
library(dplyr)
gdp <- select(gdp, -starts_with('x'))
edu <- read.csv('data/week3/education.csv')

# number of matches
length(intersect(gdp$id, edu$CountryCode))
# the 13th country in the resulting dataframe
arrange(gdp, desc(rank))[13,]


# Q4
combined <- gdp %>%
    select(id, rank) %>%
    left_join(edu, by=c('id'='CountryCode'))

combined %>%
    group_by(Income.Group) %>%
    summarize(avg.ranking=mean(rank))


# Q5
combined %>%
    filter(rank <= 38, Income.Group=='Lower middle income') %>%
    nrow


setwd(old.dir)