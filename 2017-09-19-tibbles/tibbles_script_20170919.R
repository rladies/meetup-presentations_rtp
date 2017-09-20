# all about tibbles script
# last updated: 20170919


# ---- 1. meet up schedule & objectives ----

# introductions

# set up
# all up-to-date materials can be found on github: 
# https://github.com/sheilasaia/rtp_20170919_tibbles/

# by the end of this workshop, you will be able to:
# 1. *describe* different data structures in R
# 2. *explain* some differences between data frames and tibbles

# discussion: (list on the white board)
# what data structures are used in R?

# discussion (list on white board)
# what do you know about data frames?
# what do you know about tibbles?

# go through script below

# discussion/activity:
# beginner R users - ????
# advanced R users - look for some functions that do/don't allow tibbles (and share them)

# any last questions/issues/things you discovered and want to share?


# ---- 2. set up ----

# install packages (if you haven't already. only need to do this once!)
install.packages("tidyverse")
install.packages("microbenchmark")

# load library
library(tidyverse)
# the tibble package is inside the tidyverse package
# library(tibble) # just the tibble package
library(microbenchmark)

vignette("tibble") # for more info on tibbles
# note: this tutorial was adapted from this vignette!

# help: https://blog.rstudio.com/2016/03/24/tibble-1-0-0/
# more help: http://tibble.tidyverse.org/


# ---- 3. basic data structures in R ----

# vectors
my_vector=c(1,"b",3)
my_vector # all changed to character

# lists
my_list=list(1,"b",3)
my_list # each is kept as is
class(my_list[[1]]) # numeric
class(my_list[[2]]) # character

# matrices
my_matrix=matrix(c(my_vector,my_vector),nrow=2,ncol=3,byrow=TRUE)
my_matrix
class(my_matrix)

# arrays
is.array(my_vector)
is.array(my_list) 
is.array(my_matrix) # true

# data frames
my_dataframe=data.frame(letters=c("a","b","c"),
                        numbers=c(1,2,3))
my_dataframe
class(my_dataframe$letters) # factor
class(my_dataframe$numbers) # numeric




# for more info on data structures see: http://adv-r.had.co.nz/Data-structures.html

# extras (if there's time)
# lists are recursive - their components can be lists themselves
is.recursive(my_list)
is.recursive(my_vector)

# vectors are atomic - their components cannot be 
is.atomic(my_list)
is.atomic(my_vector)

# lists are vectors but vectors are not lists
is.vector(my_list)
is.list(my_vector)

# note how dataframe deals with nested nature of list
my_dataframe2=data.frame(x=my_list,y=my_vector)
my_dataframe2 # my_list is repeated for 3 rows

# to avoid forced formatting...
my_dataframe3=data.frame(x=c(my_list[[1]],my_list[[2]],my_list[[3]]),
                         x2=my_vector)
my_dataframe3
class(my_dataframe3$x[1]) # but loose numeric definition to entries (all are factors)


# ---- 4. all about tibbles (as compared to data frames) ----

# ---- 4.1 tibbles are lazy ----

# tibbls will not adjust the names of variables
names(data.frame(`some crazy name`=1)) # do you notice the .'s where the spaces were?

names(tibble(`some crazy name`=1))

# tibbles will not change an input type
my_df=data.frame(x=letters)
class(my_df$x) # factor

my_tib=tibble(x=letters)
class(my_tib$x) # character

# tibbles will not allow you to assign row names
row.names(my_df)
row.names(my_tib) # does have row names
row.names(my_tib)=letters # get an error when you try to assign names

# tibbles will only shows some of output in console window
my_df

my_tib

# tibbles will allow column entries to be lists
my_df2=data.frame(x=1:3,y=list(1:5,1:10,1:20))
my_df2

my_tib2=tibble(x=1:3,y=list(1:5,1:10,1:20))
my_tib2
# good for survey or sequencing data where cell can change lengths within a given column

# tibbles will do things in sequence 
my_db3=data.frame(x=1:5,y=x^2)
my_db3

my_tib3=tibble(x=1:5,y=x^2)
my_tib3

# tibbles are more computationally efficient (leaves more time to be lazy)
my_list=replicate(26,sample(100),simplify=FALSE)
# 26 nested lists with 100 randome samples in each
my_list
names(my_list)=letters
microbenchmark::microbenchmark(as_tibble(my_list),
                               as.data.frame(my_list))

# tibbles stay as tibbles if you take subset


# ---- 4.2 tibbles are surly ----

# tibbles are strict about subsetting (always returning a tibble)
my_df4=data.frame(x=1:3,y=3:1)
class(my_df4[,1:2])
class(my_df4[,1])

my_tib4=tibble(x=1:3,y=3:1)
class(my_tib4[,1:2])
class(my_tib4[,1])

class(my_tib4[[2]])
class(my_tib4$x)
# use [[ or $ to extrat a single column

# tibbles are more strict with $ (more frugal? hehe)
my_df5=data.frame(abc=1)
my_df5$a

my_tib5=tibble(abc=1)
my_tib5$a


# ---- 4.3 other things to watch out for ----

# some functions written pre-tidyverse revolution don't allow tibbles as inputs
my_new_tib5=as.data.frame(my_tib5)
class(my_tib5)
class(my_new_tib5)

# do you know of any others?



# ---- 4.4 exercise ----

# let's work through this together
# http://r4ds.had.co.nz/tibbles.html#exercises-18

# see answers in tibbles_excercise_answers_20170919.R


# ---- 4.5 extra credit ----

# do you know of some functions that don't work with tibbles?


