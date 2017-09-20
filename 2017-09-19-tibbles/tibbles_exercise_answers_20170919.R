# ---- 4.4 exercise answers ----

# let's work through this together
# http://r4ds.had.co.nz/tibbles.html#exercises-18

# load library
library(tidyverse)

# 1. how to tell if an object is a tibble
class(mtcars)
mtcars_tib=as_tibble(mtcars)
class(mtcars_tib)

# 2. compare/contrast operations on data frames and tibbles.
# what is different? why might the default data frame behaviors cause you frames cause you frustration?
df=data.frame(abc=1,xyz="a")
tib=as_tibble(df)
df$x # this doesn't really exist but it works
tib$x # this doesn't work
tib$xyz # only this works

df[,"xyz"]
tib[["xyz"]]
class(df[,"abc"])
class(tib[["abc"]]) # need [[ or pull() from dplyr

df[,c("abc","xyz")]
tib[c("abc","xyz")] # don't need ","

# 3. if you have a variable stored in an object var="mpg" how can you extract the reference variable from the tibble
var="mpg"
test_df=mtcars %>% .$mpg
test_df2=mtcars %>% .[[var]] # can use var in subset

test_tib=mtcars_tib %>% .$mpg
test_tib2=mtcars_tib %>% .[[var]] # also works for tibbles
# helpful for using this in a loop
# see tidyeval for quoted variables in select()

# 4. (part 1) extract variable called 1.
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

annoying$`1`

# 4. (part 2) plot scatterplot of 1 vs 2
plot(annoying$`1`~annoying$`2`)

# 4. (part 3) create a new column called 3 which is 2 divided by 1
annoying_new=annoying %>% mutate(`3`=`2`/`1`)
annoying_new
# could also use $ opperator annoying$`3`=annoying$`2`/annoying$`1`

# 4. (part 4) rename columns one, two, three
annoying_new2=annoying_new %>% transmute(one=`1`,
                                        two=`2`,
                                        three=`3`)
annoying_new2
# there is also a rename() function

# 5. what does tibble::enframe() do? when might you use it?
tibble::enframe()
# "Converts named atomic vectors or lists to two-column data frames."
# use it to add these data to a tibble or data frame or when using gather and spread

# 6. what option controls how many additional column names are printed at the footer of a tibble?
annoying_new2
m=2
n=10 # doesn't seem to be work (?)
options(tibble.print_max=n,tibble.print_min=m) # if more than m rows print n rows
annoying_new2
#options(dplyr.print_min=Inf) # to show all rows



