## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)

## ---- echo=TRUE----------------------------------------------------------
library(ZillowR)
library(XML)
library(tidyverse)

## ---- echo=TRUE----------------------------------------------------------
source("C:/Users/sazimmer/Documents/Voter/Programs/ZillowAPIKey.R")
# This 1-line R program contains the function pulling in my API key 
# I'm concealing this as it is a private key
# The program is simply:
# set_zillow_web_service_id('XXXXXXXXXX')
# where XXXXXXXXXX is my Zillow API key


## ---- echo=TRUE, message=FALSE, results='asis'---------------------------
NCPolAdd <- read_csv("../Data/PoliticianAddresses.csv") %>%
  arrange(Org)
library(knitr)
kable(NCPolAdd[1:5,1:6])

## ---- echo=TRUE, results='asis'------------------------------------------
kable(NCPolAdd[1:5,c(1,7:11)])
GovernorInfo <- NCPolAdd %>% filter(toupper(Org)=="GOVERNOR")

## ---- echo=TRUE----------------------------------------------------------
GDSROutput <- GetDeepSearchResults(address=GovernorInfo$StreetAddress, 
                     citystatezip = as.character(GovernorInfo$ZIP))
typeof(GDSROutput$request)
typeof(GDSROutput$message)
typeof(GDSROutput$response)


## ---- echo=TRUE----------------------------------------------------------
GDSROutput$request
GDSROutput$message

## ---- echo=TRUE----------------------------------------------------------
#Convert this to a list where we should
GovernorHomeList <- xmlToList(GDSROutput$response[["results"]][[1]])
names(GovernorHomeList)
GovernorHomeList$finishedSqFt

