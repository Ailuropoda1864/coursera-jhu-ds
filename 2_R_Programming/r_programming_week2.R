DIR <- '/home/fay/code/r_coursera/2_R_Programming/data/week2/specdata'


# Part 1

#' Calculate the mean of a pollutant (sulfate or nitrate) across a specified 
#' list of monitors.
#'
#' @param directory A character vector of length 1 indicating the location of 
#' the CSV files.
#' @param pollutant A character vector of length 1 indicating the name of the 
#' pollutant for which the mean will be calculated; either 'sulfate' or 
#' 'nitrate'.
#' @param id An integer cector indicating the monitor ID numbers to be used.
#'
#' @return The mean of the pollutant across all monitors list in \code{id} 
#' (ignoring NA values).
#' @export
#'
#' @examples
#' pollutantmean(DIR, "sulfate", 1:10)
pollutantmean <- function(directory, pollutant, id = 1:332) {
    files <- file.path(directory, sprintf('%03d.csv', id))
    x <- vector(mode = 'numeric')  # initiate empty numeric vector
    for(i in seq_along(files)) {
        df <- read.csv(files[i])
        x <- c(x, df[[pollutant]])  # subset as vector (not data.frame)
    }
    mean(x, na.rm = TRUE)
}


# Part 2
#' Read a directory full of files and reports the number of completely observed 
#' cases in each data file.
#'
#' @param directory A character vector of length 1 indicating the location of 
#' the CSV files.
#' @param id An integer cector indicating the monitor ID numbers to be used.
#'
#' @return A data frame where the first column is the name of the file ('id') 
#' and the second column is the number of complete cases ('nobs').
#' @export
#'
#' @examples
#' complete(DIR, c(2, 4, 8, 10, 12))
complete <- function(directory, id = 1:322)  {
    result <- data.frame()  # initiate empty dataframe
    
    files <- file.path(directory, sprintf('%03d.csv', id))
    for(i in seq_along(files)) {
        df <- read.csv(files[i])
        nobs <- sum(complete.cases(df))
        result <- rbind(result, data.frame(id=id[i], nobs=nobs))
    }
    result
}


# Part 3
corr <- function(directory, threshold = 0) {
    result <- vector(mode = 'numeric')  # initiate empty numeric vector
    files <- file.path(directory, dir(directory))
    for(i in seq_along(files)) {
        df <- read.csv(files[i]) 
        if(sum(complete.cases(df)) > threshold) {
            result <- c(result, cor(x = df$sulfate, 
                                    y = df$nitrate, 
                                    use = "pairwise.complete.obs"))
        }
    }
    result
}


# quiz
# Q1
pollutantmean(DIR, "sulfate", 1:10)

# Q2
pollutantmean(DIR, "nitrate", 70:72)

# Q3
pollutantmean(DIR, "sulfate", 34)

# Q4
pollutantmean(DIR, "nitrate")

# Q5
cc <- complete(DIR, c(6, 10, 20, 34, 100, 200, 310))
print(cc$nobs)

# Q6
cc <- complete(DIR, 54)
print(cc$nobs)

# Q7
set.seed(42)
cc <- complete(DIR, 332:1)
use <- sample(332, 10)
print(cc[use, "nobs"])

# Q8
cr <- corr(DIR)                
cr <- sort(cr)                
set.seed(868)                
out <- round(cr[sample(length(cr), 5)], 4)
print(out)

# Q9
cr <- corr(DIR, 129)                
cr <- sort(cr)                
n <- length(cr)                
set.seed(197)                
out <- c(n, round(cr[sample(n, 5)], 4))
print(out)

# Q10
cr <- corr(DIR, 2000)                
n <- length(cr)                
cr <- corr(DIR, 1000)                
cr <- sort(cr)
print(c(n, round(cr, 4)))
