# Pre-workshop setup instructions

- Download and install the latest version of R: https://cran.r-project.org/
- Download and install the latest version of RStudio Desktop (Free License): https://www.rstudio.com/products/rstudio/download3/
- Once both are installed, open RStudio and run the following lines of code in the Console

```{r}
install.packages("tidyverse")
```

and then

```{r}
library(tidyverse)
```

- The datasets we will be using for the workshop can be downloaded with this line of code

```{r}
download.file('https://www.dropbox.com/s/zhmn02ti0ggxdj7/rladies_ggplot2_datasets.rda?dl=1',
              'rladies_ggplot2_datasets.rda')
```

- The slides and materials for this workshop can be found here: https://github.com/rladies/meetup-presentations_rtp/tree/master/2019-03-06-ggplot2

- If you have not used R and RStudio before, please see the first section of the presentation from a previous meetup for an introduction: http://rpubs.com/minebocek/rladies-dplyr-tidyr

- Please bring a fully charged laptop to the workshop
