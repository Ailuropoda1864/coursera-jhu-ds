old.dir <- getwd()
setwd('/home/fay/code/r_coursera/2_R_Programming/data/week4')


# 1. Plot the 30-day mortality rates for heart attack
outcome <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
head(outcome)

ncol(outcome)
nrow(outcome)
names(outcome)

outcome[, 11] <- as.numeric(outcome[, 11])
hist(outcome[, 11])


# 2. Finding the best hospital in a state
best <- function(state, outcome) {
    # read outcome data
    outcome.df <- read.csv("outcome-of-care-measures.csv",
                           colClasses = "character")
    
    # check that state is valid
    if(!state %in% outcome.df$State) {
        stop('invalid state')
    }
    
    # check that outcome is valid
    if(!outcome %in% c("heart attack", "heart failure", "pneumonia")) {
        stop('invalid outcome')
    }
    
    # map outcome input to column name
    outcome.name <- if(outcome == "heart attack") {
        'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack'
    } else if(outcome == "heart failure") {
        'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure'
    } else {
        'Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia'
    }

    outcome.df[, outcome.name] <- as.numeric(outcome.df[, outcome.name])
    state.hospitals <- outcome.df[outcome.df$State==state, 
                                  c(outcome.name, 'Hospital.Name')]
    best.indices <- which(state.hospitals[1] == min(state.hospitals[1], na.rm = TRUE))
    min(state.hospitals[best.indices, 'Hospital.Name'])
}


# test cases
best("TX", "heart attack")  # "CYPRESS FAIRBANKS MEDICAL CENTER"
best("TX", "heart failure")  # "FORT DUNCAN MEDICAL CENTER"
best("MD", "heart attack")  # "JOHNS HOPKINS HOSPITAL, THE"
best("MD", "pneumonia")  # "GREATER BALTIMORE MEDICAL CENTER"
best("BB", "heart attack")  # Error in best("BB", "heart attack") : invalid state
best("NY", "hert attack")  # Error in best("NY", "hert attack") : invalid outcome


# 3. Ranking hospitals by outcome in a state
rankhospital <- function(state, outcome, num = 'best') {
    # read outcome data
    outcome.df <- read.csv("outcome-of-care-measures.csv",
                           colClasses = "character")
    
    # check that state is valid
    if(!state %in% outcome.df$State) {
        stop('invalid state')
    }
    
    # check that outcome is valid
    if(!outcome %in% c("heart attack", "heart failure", "pneumonia")) {
        stop('invalid outcome')
    }
    
    # map outcome input to column name
    outcome.name <- if(outcome == "heart attack") {
        'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack'
    } else if(outcome == "heart failure") {
        'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure'
    } else {
        'Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia'
    }
    
    
    outcome.df[, outcome.name] <- as.numeric(outcome.df[, outcome.name])
    state.hospitals <- outcome.df[outcome.df$State==state & 
                                      !is.na(outcome.df[[outcome.name]]),
                                  c(outcome.name, 'Hospital.Name')]
    ranks <- order(state.hospitals[1], state.hospitals[2])
    
    num <- if(num=='best') 1 else if(num=='worst') nrow(state.hospitals) else num
    state.hospitals[ranks[num], 2]
}


# test cases
rankhospital("TX", "heart failure", 4)  # "DETAR HOSPITAL NAVARRO"
rankhospital("MD", "heart attack", "worst")  # "HARFORD MEMORIAL HOSPITAL"
rankhospital("MN", "heart attack", 5000)  # NA


# 4. Ranking hospitals in all states
rankall <- function(outcome, num = 'best') {
    # read outcome data
    outcome.df <- read.csv("outcome-of-care-measures.csv",
                           colClasses = "character")

    # check that outcome is valid
    if(!outcome %in% c("heart attack", "heart failure", "pneumonia")) {
        stop('invalid outcome')
    }
    
    # map outcome input to column name
    outcome.name <- if(outcome == "heart attack") {
        'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack'
    } else if(outcome == "heart failure") {
        'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure'
    } else {
        'Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia'
    }
    
    outcome.df[, outcome.name] <- as.numeric(outcome.df[, outcome.name])
    outcome.df$State <- as.factor(outcome.df$State)
    
    by.state <- split(outcome.df[c(outcome.name, 'Hospital.Name')],
                      outcome.df$State)
    
    rank.helper <- function(hospitals, num) {
        hospitals <- hospitals[!is.na(hospitals[1]),]
        ranks <- order(hospitals[1], hospitals[2])
        num <- if(num=='best') 1 else if(num=='worst') nrow(hospitals) else num
        hospitals[ranks[num], 2]
    }
    
    vec <- sapply(by.state, rank.helper, num=num)
    data.frame(hospital=vec, state=names(vec))
}


# test cases
head(rankall("heart attack", 20), 10)
tail(rankall("pneumonia", "worst"), 3)
tail(rankall("heart failure"), 10)


# quiz
# Q1
best("SC", "heart attack")

# Q2
best("NY", "pneumonia")

# Q3
best("AK", "pneumonia")

# Q4
rankhospital("NC", "heart attack", "worst")

# Q5
rankhospital("WA", "heart attack", 7)

# Q6
rankhospital("TX", "pneumonia", 10)

# Q7
rankhospital("NY", "heart attack", 7)

# Q8
r <- rankall("heart attack", 4)
as.character(subset(r, state == "HI")$hospital)

# Q9
r <- rankall("pneumonia", "worst")
as.character(subset(r, state == "NJ")$hospital)

# Q10
r <- rankall("heart failure", 10)
as.character(subset(r, state == "NV")$hospital)


setwd(old.dir)