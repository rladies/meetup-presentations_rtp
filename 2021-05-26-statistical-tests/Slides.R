#' ---
#' title: "Common Statistical Tests in R"
#' subtitle: "t-tests, linear regression, and ANOVA"
#' author:
#'    - Stephanie Zimmer, RTI International
#' date: "2021-05-26"
#' output:
#'   xaringan::moon_reader:
#'     css: xaringan-themer.css
#'     nature:
#'       slideNumberFormat: "%current%"
#'       highlightStyle: github
#'       highlightLines: true
#'       ratio: 16:9
#'       countIncrementalSlides: true
#' ---
#' 
## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message = FALSE, tidy = TRUE)

#' 
#' 
## ----xaringan-themer, include=FALSE, warning=FALSE----------------------------
library(xaringanthemer)
style_duo_accent(
  primary_color = "#1E4F96",
  secondary_color = "#00A3E0",
  inverse_header_color = "#FFFFFF"
)

#' 
## .small .remark-code { /*Change made here*/

##   font-size: 80% !important;

## }

## .smaller .remark-code { /*Change made here*/

##   font-size: 70% !important;

## }

#' 
#' ## Topics
#' 
#' - formula notation
#' - linear regression
#' - ANOVA
#' - t-tests
#'   - one-sample t-tests
#'   - two-sample t-tests
#'   - paired t-test
#' ???
#' Everything is a linear model at the end of the day. Helper function for t.test but will also show how to do as the more generic `lm` function
#' 
#' ---
#' 
#' ## Formula notation
#' 
#' To do any modeling, need to understand how to specify formulas in R
#' 
#' Most basic formula:
#' 
## ----bassyn, eval=FALSE-------------------------------------------------------
## Y ~ X
## Y ~ X+Z

#' 
#' - left side of formula is response/dependent variable
#' - right side of formula is predictor/independent variable(s)
#' 
#' If these are linear models, this is written mathematically as:
#' 
#' $$Y_i=\beta_0+\beta X_i+\epsilon_i$$
#' 
#' $$Y_i =\beta_0+\beta_1 X_{i}+\beta_2 Z_{i}$$
#' .footnote[Sources: https://faculty.chicagobooth.edu/richard.hahn/teaching/formulanotation.pdf, ]
#' 
#' ---
#' ## Formula notation - no intercept
#' 
#' $$Y_i=\beta_1X_i+\epsilon_i$$
#' 
## ----synnoint, eval=FALSE-----------------------------------------------------
## Y~X-1
## Y~X+0

#' 
#' ---
#' ## Formula notation - interactions
#' 
#' $$Y_i=\beta_0+\beta_1X_i+\beta_2Z_i+\beta_3X_iZ_i+\epsilon_i$$
#' 
## ----synint, eval=FALSE-------------------------------------------------------
## Y~X+Z+X:Z #X:Z makes interaction between X and Z
## Y~X*Z #X*Z includes the variables and the interaction between them

#' 
#' ---
#' ## Formula notation - most common uses
#' 
#' Symbol | Example | Meaning
#' -|-|-
#' +|`+X`|include this variable
#' -|`-X`|delete this variable
#' :|`X:Z`|include the interaction between these variables
#' * |`X*Z`|include these variables and the interactions between them
#' ^n |`(X+Z+Y)^3`|include these variables and all interactions up to n way
#' I |`I(X-Z)`| as-as: include a new variable which is the difference of these variables
#' 
#' ---
#' ## Formula notation - knowledge check
#' 
#' I want to model the following:
#'    
#' $$mpg_i=\beta_0+\beta_1cyl_{i}+\beta_2disp_{i}+\beta_3hp_{i}+\beta_4cyl_{i}disp_{i}+\beta_5cyl_{i}hp_{i}+\beta_6disp_{i}hp_{i}+\epsilon_i$$
#'       
#' How can you write this formula? Select all that apply:
#' 
#' 1. `mpg~cyl:disp:hp`
#' 2. `mpg~(cyl+disp+hp)^2`
#' 3. `mpg~cyl+disp+hp+cyl:disp+cyl:hp+disp:hp`
#' 4. `mpg~cyl*disp*hp`
#' 5. `mpg~cyl*disp+cyl*hp+disp*hp`
#' 
#' ---
#' ## Formula notation - knowledge check (solution)
#' 
#' I want to model the following:
#'    
#' $$mpg_i=\beta_0+\beta_1cyl_{i}+\beta_2disp_{i}+\beta_3hp_{i}+\beta_4cyl_{i}disp_{i}+\beta_5cyl_{i}hp_{i}+\beta_6disp_{i}hp_{i}+\epsilon_i$$
#'       
#' How can you write this formula? Select all that apply:
#' 
#' 1. `mpg~cyl:disp:hp` - no, this only has the interactions
#' 2. `mpg~(cyl+disp+hp)^2` - yes
#' 3. `mpg~cyl+disp+hp+cyl:disp+cyl:hp+disp:hp` - yes
#' 4. `mpg~cyl*disp*hp` - no, this also has the 3-way interaction
#' 5. `mpg~cyl*disp+cyl*hp+disp*hp` - yes
#' 
#' There may be other ways as well!!!
#' 
#' ---
#' ## Data for exercises
#' 
#' - Using `palmerpenguins` data for examples
#' 
#' - Data were collected and made available by Dr. Kristen Gorman and the Palmer Station, Antarctica LTER, a member of the Long Term Ecological Research Network.
#' 
#' - Access data through `palmerpenguins` package https://github.com/allisonhorst/palmerpenguins/
#' 
## ----pengin-------------------------------------------------------------------
library(palmerpenguins)
library(tidyverse)
glimpse(penguins)

#' 
#' 
#' 
#' ---
#' ## Linear regression - simple linear regression
#' 
#' Model penguin body mass as function of flipper length
## ----slr1---------------------------------------------------------------------
o <- lm(body_mass_g~flipper_length_mm, data=penguins)
o

#' 
#' ---
#' ## Linear regression - simple linear regression
#' 
#' 
## ----slr2---------------------------------------------------------------------
summary(o)

#' 
#' ---
#' ## Linear regression - multiple linear regression
#' 
#' Model penguin body mass as function of flipper length and bill length
#' 
## ----mlr1---------------------------------------------------------------------
lm(body_mass_g~flipper_length_mm+bill_length_mm, data=penguins) %>%
  summary()

#' 
#' ---
#' ## Linear regression - multiple linear regression
#' 
#' How would I model penguin mody mass as a function of flipper length and bill length and also include an interaction?
#' 
## ----mlrq, eval=FALSE---------------------------------------------------------
## lm(body_mass_g~######,
##      data=penguins)

#' 
#' --
#' 
## ----mlrqs--------------------------------------------------------------------
lm(body_mass_g~flipper_length_mm*bill_length_mm,
     data=penguins) %>%
  summary()

#' 
#' ???
#' Also `flipper_length_mm+bill_length_mm+flipper_length_mm:bill_length_mm`
#' 
#' --- 
#' ## ANOVA - one-way
#' 
#' Does average penguin mass vary by species?
#' 
## ----anovabp------------------------------------------------------------------
penguins %>%
  ggplot(aes(x=species, y=body_mass_g)) +
  geom_boxplot()

#' 
#' ---
#' ## ANOVA - one-way using lm
#' 
#' Does average penguin mass vary by species?
#' 
## ----anovalm------------------------------------------------------------------
lm(body_mass_g~species, data=penguins) %>% summary()

#' 
#' ---
#' ## ANOVA - one-way using aov
#' 
#' Does average penguin mass vary by species?
#' 
## ----anovaaov-----------------------------------------------------------------
aov(body_mass_g~species, data=penguins)
coefficients(aov(body_mass_g~species, data=penguins))

#' 
#' ---
#' ## ANOVA - two-way 
#' Does average penguin mass vary by species and sex?
#' 
## ----anova2bp-----------------------------------------------------------------
penguins %>%
  filter(!is.na(sex)) %>%
  ggplot(aes(x=species, y=body_mass_g)) +
  geom_boxplot()+
  facet_wrap(~sex)


#' 
#' ---
#' ## ANOVA - two-way 
#' Does average penguin mass vary by species and sex?
#' 
## ----anova2lm-----------------------------------------------------------------
lm(body_mass_g~species*sex, data=penguins) %>% summary()

#' 
#' ---
#' ## t-test: one-sample with lm
#' 
#' On average, are penguin body masses significantly different from half a kg (5000 g)?
#' 
## ----tt1----------------------------------------------------------------------
lm(I(body_mass_g-5000)~1, data=penguins) %>% summary()

#' 
#' ---
#' ## t-test: one-sample with t.test (A)
#' 
#' On average, are penguin body masses significantly different from half a kg (5000 g)?
#' 
## ----tt2a---------------------------------------------------------------------
t.test(I(body_mass_g-5000)~1, data=penguins)


#' 
#' ---
#' ## t-test: one-sample with t.test (B)
#' 
#' On average, are penguin body masses significantly different from half a kg (5000 g)?
#' 
## ----tt2b---------------------------------------------------------------------
t.test(penguins$body_mass_g-5000)


#' 
#' ---
#' ## t-test: two-sample with lm
#' Is penguin weight significantly different between males and females?
#' 
## ----ttlm---------------------------------------------------------------------
lm(body_mass_g ~ sex, data=penguins) %>% summary()

#' 
#' ---
#' ## t-test: two-sample with t.test
#' Is penguin weight significantly different between males and females?
#' 
## ----tttt---------------------------------------------------------------------
t.test(body_mass_g ~ sex, data=penguins, var.equal=TRUE) 

#' 
#' ---
#' ## paired t-test: introduce data
#' Is the cost of books on Amazon cheaper than the bookstore?
#' 
#' 
## -----------------------------------------------------------------------------
library(openintro)
glimpse(textbooks)

textbooks %>%
  ggplot(aes(x=ucla_new, y=amaz_new)) + 
  geom_point() + 
  geom_abline(slope=1, intercept=0)

#' 
#' ---
#' ## paired t-test: lm
#' Is the cost of books on Amazon different than the bookstore?
#' 
#' 
## ----pttlm--------------------------------------------------------------------
lm(ucla_new-amaz_new~1, data=textbooks) %>%
  summary()

#' 
#' ---
#' ## paired t-test: t.test
#' Is the cost of books on Amazon different than the bookstore?
#' 
#' 
## ----ptttt--------------------------------------------------------------------
t.test(textbooks$ucla_new, textbooks$amaz_new, paired=TRUE)

#' 
#' 
#' 
#' 
#' 
#' ---
#' ## Linear models - good resource
#' 
#' Great resource: https://lindeloev.github.io/tests-as-linear/ 
#' 
#' ---
#' ## Sources
#' 
#' - Horst AM, Hill AP, Gorman KB (2020). palmerpenguins: Palmer Archipelago (Antarctica) penguin data. R package version 0.1.0. https://allisonhorst.github.io/palmerpenguins/ 
#' 
#' - https://faculty.chicagobooth.edu/richard.hahn/teaching/formulanotation.pdf 
#' 
#' - https://stat.ethz.ch/R-manual/R-devel/library/stats/html/formula.html
#' 
#' - https://lindeloev.github.io/tests-as-linear/
#' 
#' - Mine &Ccedil;etinkaya-Rundel, David Diez, Andrew Bray, Albert Y. Kim, Ben Baumer, Chester Ismay, Nick Paterno and Christopher Barr (2021). openintro: Data Sets and Supplemental Functions from 'OpenIntro' Textbooks and Labs. R package version 2.1.0. https://CRAN.R-project.org/package=openintro
#' 
#' - Diez, David M., Christopher D. Barr, and Mine &Ccedil;etinkaya-Rundel. OpenIntro statistics, Fourth Edition. OpenIntro, 2019.
#' 
#' ---
#' ## ANCOVA 
#' After controlling for flipper length, is body mass the same for all species?
#' 
## ----ancovaplot---------------------------------------------------------------
penguins %>%
  ggplot(aes(x=flipper_length_mm, y=body_mass_g, colour=species, group=species)) +
  geom_point()

#' 
#' ---
#' ## ANCOVA
#' After controlling for flipper length, is body mass the same for all species?
#' 
## ----ancovalm-----------------------------------------------------------------
ancout <- lm(body_mass_g~flipper_length_mm+species, data=penguins) 
summary(ancout)

#' 
#' ---
#' ## Plot ANCOVA
#' After controlling for flipper length, is body mass the same for all species?
#' 
## ----ancovap2-----------------------------------------------------------------
peng2 <- penguins %>%
  filter(!is.na(flipper_length_mm), !is.na(body_mass_g), !is.na(species)) %>%
  mutate(yhat=predict(ancout))
peng2 %>%
  ggplot(aes(x=flipper_length_mm, y=body_mass_g, colour=species, group=species)) +
  geom_point() +
  geom_line(aes(y = yhat), size = 1)

#' 
