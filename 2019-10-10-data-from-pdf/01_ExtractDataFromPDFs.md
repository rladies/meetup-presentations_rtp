---
title: "Extracting Data from PDFs"
author: "Stephanie Zimmer"
date: "10/7/2019"
output: 
  html_document:
    keep_md: true
---



# Intro and Source

This example is based on a real world work example of mine. We do surveys of prisoners and received a list of prisoners in a scanned PDF. For this example, I've generated a PDF similar to the real one using synthetic data. We first work with the machine readable PDF and then the scanned one.

# First we load the packages


```r
library(pdftools)
library(tabulizer)
library(tidyverse)
```

```
## -- Attaching packages -------------------------------------- tidyverse 1.2.1 --
```

```
## v ggplot2 3.2.1     v purrr   0.3.2
## v tibble  2.1.3     v dplyr   0.8.3
## v tidyr   1.0.0     v stringr 1.4.0
## v readr   1.3.1     v forcats 0.4.0
```

```
## -- Conflicts ----------------------------------------- tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

# Demonstrating pdftools package


```r
# Get metadata about the PDF
PDFInfo <- pdftools::pdf_info("00_GeneratePDF.pdf")

PDFInfo
```

```
## $version
## [1] "1.5"
## 
## $pages
## [1] 3
## 
## $encrypted
## [1] FALSE
## 
## $linearized
## [1] FALSE
## 
## $keys
## $keys$Author
## [1] ""
## 
## $keys$Title
## [1] "XX Department of Corrections"
## 
## $keys$Subject
## [1] ""
## 
## $keys$Creator
## [1] "LaTeX with hyperref package"
## 
## $keys$Producer
## [1] "pdfTeX-1.40.18"
## 
## $keys$Keywords
## [1] ""
## 
## $keys$Trapped
## [1] ""
## 
## $keys$PTEX.Fullbanner
## [1] "This is MiKTeX-pdfTeX 2.9.6354 (1.40.18)"
## 
## 
## $created
## [1] "2019-10-09 20:05:16 EDT"
## 
## $modified
## [1] "2019-10-09 20:05:16 EDT"
## 
## $metadata
## [1] ""
## 
## $locked
## [1] FALSE
## 
## $attachments
## [1] FALSE
## 
## $layout
## [1] "no_layout"
```

```r
# Get the text of the PDF

txt <- pdftools::pdf_text("00_GeneratePDF.pdf")

# txt is a character vector where each page is a piece of the vector
# e.g., txt[1] is the text for page 1

txt
```

```
## [1] "                                                                   10/17/2019 17:56:18\r\n                      XX Department of Corrections\r\n Age    Date of Birth  NCDC#  Offender# Offender Name          Location  Cell\r\n  52       11/06/1966   24672   706169  Perez, Kuliana         ZZCF      XX5-M101\r\n  38       02/13/1981   21893   901279  Blueeyes, Brittany     ZZCF      XX3-1114A\r\n  77       09/27/1942   50872   571941  Santacruz, Crystal     ZZCF      XX5-L101\r\n  38       07/21/1981   38476   980778  Price, Molly           ZZCF      XX3-1110A\r\n  58       08/19/1961   72013   712810  Byers, Aryan           ZZCF      XX5-L104\r\n  28       06/13/1991   94521   642542  Hood, Shelby           ZZCF      XX1-B101\r\n  20       10/07/1999   39595   594894  Johnson, Tashina       ZZCF      XX4-J108\r\n  34       03/10/1985   53564   330973  Chase, Asli            ZZCF      XX3-1105A\r\n  81       03/27/1938   35174   589531  el-Harroun, Muneefa    ZZCF      XX4-K102\r\n  54       05/25/1965   21513   153175  al-Younan, Nadheera    ZZCF      XX2-F104\r\n  72       05/29/1947   80247   828363  Juarez, Sarahy         ZZCF      XX3-1123A\r\n  78       07/09/1941   61715   387909  Williams, Brechelle    ZZCF      XX3-1122B\r\n  25       08/03/1994   35899   213496  al-Emami, Yaasmeena    ZZCF      XX5-O101\r\n  52       01/04/1967   29448   668652  Sidara, Julia          ZZCF      XX3-1117A\r\n  87       07/21/1932   33781   179719  el-Ismail, Suhaad      ZZCF      XX3-1104A\r\n  56       10/03/1963   52517   685582  Reno, Autumn           ZZCF      XX4-I108\r\n  67       10/04/1952   54085   657316  al-Arif, Hikma         ZZCF      XX3-1101B\r\n  47       11/17/1971   73925   874270  Smith, Rebekah         ZZCF      XX2-E105\r\n  68       05/09/1951   67879   637466  Shahi, Jennifer        ZZCF      XX2-E104\r\n  24       04/03/1995   67144   586885  Bedford, Rachel        ZZCF      XX1-C101\r\n  56       09/06/1963   70795   250288  Busby, Jacqueline      ZZCF      XX5-N107\r\n  39       05/20/1980   98202   792944  Watkins, Amanda        ZZCF      XX1-A106\r\n  43       11/10/1975   96801   684942  Houdek, Alyssa         ZZCF      XX2-F106\r\n  28       07/28/1991   81711   100377  Li, Raveena            ZZCF      XX5-N106\r\n  25       02/28/1994   17411   344945  Cranny, Hannah         ZZCF      XX2-F101\r\n  24       08/18/1995   69350   104636  Poole, Jacquelyn       ZZCF      XX2-G105\r\n  58       01/11/1961   65436   487567  Ditorrice, Nikki       ZZCF      XX2-H108\r\n  45       03/14/1974   45543   772574  Amen, Sheela           ZZCF      XX3-1112A\r\n  78       12/17/1940   40129   923147  Asuncion, Nicole       ZZCF      XX1-D105\r\n  74       09/03/1945   33767   419059  el-Hares, Hanoona      ZZCF      XX2-E103\r\n  66       06/10/1953   13175   609617  Melbrod, Danielle      ZZCF      XX5-O103\r\n  47       11/24/1971   81882   886636  Bass, Auna             ZZCF      XX4-J101\r\n  49       11/27/1969   70134   231479  Fluckes, Helen         ZZCF      XX2-G106\r\n  40       07/08/1979   69533   508911  Ramos, Samantha        ZZCF      XX2-E107\r\n  84       02/24/1935   37677   242471  Rodriguez, Jessica     ZZCF      XX5-O105\r\n  62       11/07/1956   62668   608128  Linsenbigler, Marissa  ZZCF      XX3-1102A\r\n  50       01/22/1969   68053   800953  Seiler, Aryan          ZZCF      XX2-E102\r\n  88       03/14/1931   13071   213264  Svenby, Adalise        ZZCF      XX3-1121A\r\n  89       06/25/1930   30532   332993  Armijo, Roxana         ZZCF      XX2-E106\r\n  22       08/23/1997   34869   159434  Sarmiento, Linh        ZZCF      XX3-1111A\r\n  85       05/12/1934   65282   896924  Sawyer, Georgina       ZZCF      XX5-L103\r\n  52       09/29/1967   97949   370255  Reyes-Juarez, Arianna  ZZCF      XX3-1123B\r\n  35       01/04/1984   71095   642331  Holub, Riley           ZZCF      XX5-M103\r\n  61       11/29/1957   13026   994546  Garrison, Carissa      ZZCF      XX5-M107\r\n  71       09/05/1948   82831   369149  Wade, Allyssa          ZZCF      XX1-D101\r\n  55       03/22/1964   81412   435893  Kim, Belicia           ZZCF      XX1-C106\r\n  47       04/22/1972   58346   262885  Rudnick, Kylie         ZZCF      XX3-1112B\r\n  63       08/23/1956   16699   678034  Walker, Kuneeshah      ZZCF      XX3-1124B\r\n  52       04/20/1967   76813   193181  Johnson-Rhoades, Tiara ZZCF      XX5-N104\r\n150 People                                                                  Page 1of 3\r\n"                                                                                                                     
## [2] "                                                                  10/17/2019 17:56:18\r\n Age    Date of Birth NCDC#  Offender# Offender Name           Location  Cell\r\n  87       10/18/1931  91524   117461  Wilkins, Morgan         ZZCF      XX3-1106A\r\n  60       04/02/1959  75487   923913  Nguyen, Thy Thy         ZZCF      XX3-1119A\r\n  60       03/23/1959  15722   426841  Garcia, Sara            ZZCF      XX2-G103\r\n  80       10/11/1938  49158   480684  Martinez, Quianah       ZZCF      XX3-1111B\r\n  31       07/19/1988  67463   555371  Quintanilla, Rachel     ZZCF      XX3-1116A\r\n  37       09/15/1982  84845   914228  Werner, Chykeiljah      ZZCF      XX3-1105B\r\n  20       04/23/1999  28093   674441  el-Soltani, Rayyana     ZZCF      XX3-1118A\r\n  42       11/24/1976  52978   672537  Lee, Kristina           ZZCF      XX2-H106\r\n  39       12/28/1979  51008   403567  Elden, Selena           ZZCF      XX3-1117B\r\n  42       08/01/1977  38144   201797  Murphy, Patricia        ZZCF      XX5-O106\r\n  32       11/22/1986  53070   980059  Knight, Kimberly        ZZCF      XX3-1113A\r\n  67       05/05/1952  45980   265648  Bugosh, Olivia          ZZCF      XX3-1107B\r\n  66       03/17/1953  18467   620785  Bolek, Danielle         ZZCF      XX5-M108\r\n  83       05/04/1936  67798   470926  Latham, Jana            ZZCF      XX3-1107A\r\n  22       01/08/1997  49347   782852  Charron, Megan          ZZCF      XX4-I104\r\n  79       03/09/1940  95410   967366  Baldino, Jennifer       ZZCF      XX3-1124A\r\n  44       02/19/1975  96059   518816  Arce Mendez, Adriana    ZZCF      XX1-A104\r\n  49       02/21/1970  56309   956635  Mack, Lazarea           ZZCF      XX3-1109B\r\n  85       02/15/1934  43234   335488  el-Anwar, Musheera      ZZCF      XX3-1108B\r\n  86       12/21/1932  15778   366887  Ruiz, Vanessa           ZZCF      XX2-H107\r\n  42       01/31/1977  55274   877274  Gallegos, Ashley        ZZCF      XX2-F107\r\n  46       04/14/1973  60809   428565  Godinez-Salmeron, Elena ZZCF      XX4-I106\r\n  88       11/01/1930  20458   725577  Johnson, Jessica        ZZCF      XX5-L102\r\n  66       08/26/1953  68152   100685  Simpson, Ashley         ZZCF      XX4-K106\r\n  55       09/04/1964  83877   994933  Brady, Alana            ZZCF      XX4-J103\r\n  35       09/11/1984  58191   486931  Tatum, Tara             ZZCF      XX4-K101\r\n  59       10/18/1959  71556   935857  Kalu, Jazmine           ZZCF      XX2-F102\r\n  78       03/01/1941  89492   277604  al-Sharif, Sahheeda     ZZCF      XX2-F105\r\n  89       08/22/1930  24635   943073  Bradshaw, Norma         ZZCF      XX2-F103\r\n  51       03/20/1968  98397   805205  el-Bari, Najlaa         ZZCF      XX3-1110B\r\n  37       03/25/1982  43485   758016  al-Qasim, Sultana       ZZCF      XX1-C102\r\n  71       08/11/1948  57395   206712  Brown, Briana           ZZCF      XX3-1115A\r\n  42       05/06/1977  31984   827205  Burds, Elizabeth        ZZCF      XX1-B107\r\n  44       01/23/1975  67724   368852  al-Allam, Aarifa        ZZCF      XX2-H101\r\n  83       12/15/1935  54669   108701  De La Cerda, Ashlee     ZZCF      XX3-1109A\r\n  21       07/05/1998  69590   777416  el-Nasser, Jasra        ZZCF      XX1-A105\r\n  61       08/19/1958  34967   380458  Larsen, Cassandra       ZZCF      XX2-E108\r\n  81       08/30/1938  49200   305640  Mcclain, Breanna        ZZCF      XX2-G108\r\n  34       09/13/1985  49496   349797  Salazar, Frankie        ZZCF      XX1-C105\r\n  76       07/11/1943  97229   178120  Kim, Jordynn            ZZCF      XX2-G104\r\n  55       04/07/1964  16949   277915  Littlefield, Marisa     ZZCF      XX1-D108\r\n  88       11/22/1930  89733   291805  al-Rahmani, Fidda       ZZCF      XX4-I101\r\n  63       10/10/1955  82363   840837  Truman, Camille         ZZCF      XX1-D106\r\n  32       05/17/1987  32387   156118  Hidalgo, Amara          ZZCF      XX5-L107\r\n  52       09/09/1967  88800   433112  Bohm, Katie             ZZCF      XX3-1114B\r\n  65       11/14/1953  99880   342615  Huynh, Tomasina         ZZCF      XX4-K104\r\n  41       02/17/1978  42901   406174  Miller, Shannon         ZZCF      XX1-D103\r\n  69       04/24/1950  82841   534221  Hornbeak, Megan         ZZCF      XX3-1108A\r\n  54       11/27/1964  59975   180356  el-Hosseini, Jaleela    ZZCF      XX1-B102\r\n  44       04/15/1975  33151   789828  Olivas, Angelique       ZZCF      XX1-C107\r\n  85       04/15/1934  11953   916782  Romero, Eunicia         ZZCF      XX4-J106\r\n150 People                                                                 Page 2of 3\r\n"
## [3] "                                                                  10/17/2019 17:56:18\r\n Age    Date of Birth NCDC#  Offender# Offender Name          Location  Cell\r\n  59       08/10/1960  13880   343542  Ciarlelli, Kaitlei     ZZCF      XX4-K103\r\n  83       06/30/1936  77104   307105  Brown, Marian          ZZCF      XX1-C103\r\n  43       07/29/1976  88738   814460  Thomas, Naznet         ZZCF      XX1-A103\r\n  78       03/04/1941  47558   234106  Kier, Kayla            ZZCF      XX5-M106\r\n  26       08/20/1993  88175   466058  Guerrero, Alejandra    ZZCF      XX5-O104\r\n  79       01/24/1940  39743   926914  el-Mahfouz, Muna       ZZCF      XX1-B103\r\n  80       06/26/1939  63852   607032  Collins, Selena        ZZCF      XX3-1104B\r\n  45       07/17/1974  40264   974333  Martin, Ashley         ZZCF      XX5-M102\r\n  60       12/10/1958  11015   443988  Boxley, Tasia          ZZCF      XX1-B108\r\n  57       07/11/1962  83827   481793  Lujan, Kara            ZZCF      XX3-1103A\r\n  87       06/04/1932  48723   181782  Linga, Jaque           ZZCF      XX1-C104\r\n  19       02/19/2000  89157   292404  Young, Nkeonye         ZZCF      XX2-H103\r\n  57       05/19/1962  16414   327701  Sobczak, Kayla         ZZCF      XX4-I102\r\n  37       10/16/1981  29246   545122  Aguirre, Alissa        ZZCF      XX1-C108\r\n  74       10/16/1944  45260   394127  Pedroza, Elenni        ZZCF      XX4-I105\r\n  31       05/07/1988  29308   761211  Foutz, Katelyn         ZZCF      XX2-G107\r\n  57       04/06/1962  56042   917160  Chang, Maya            ZZCF      XX3-1101A\r\n  80       09/28/1939  21036   473535  Saddler, Debra         ZZCF      XX2-H104\r\n  52       11/01/1966  95064   170851  Britton, Shanika       ZZCF      XX1-A107\r\n  38       11/02/1980  84446   462818  Batjargal, Avery       ZZCF      XX2-F108\r\n  70       04/17/1949  88259   242759  Lightford, Cassidy     ZZCF      XX4-J107\r\n  42       10/18/1976  92628   994842  Mills, Winona          ZZCF      XX4-K107\r\n  54       12/05/1964  26766   639644  Patterson, Vanessa     ZZCF      XX1-A102\r\n  48       01/17/1971  25635   224281  Chung, Adrie           ZZCF      XX5-O108\r\n  85       01/10/1934  99126   735604  Turner, Chantz         ZZCF      XX2-H102\r\n  27       04/12/1992  41962   294567  Gause, Fortun          ZZCF      XX5-L108\r\n  52       08/29/1967  10995   322669  al-Dib, Khadeeja       ZZCF      XX1-A101\r\n  31       07/24/1988  95996   989664  el-Hamidi, Hasnaa      ZZCF      XX2-E101\r\n  50       01/09/1969  86978   633844  Bacon, Brittany        ZZCF      XX3-1122A\r\n  50       03/31/1969  32965   593825  Xiong, Shauntel        ZZCF      XX4-J105\r\n  50       02/26/1969  45019   518291  Mars, Esther           ZZCF      XX5-O107\r\n  36       07/13/1983  42561   217699  Colorow, Tashena       ZZCF      XX4-K105\r\n  38       09/07/1981  88754   487396  Left Hand Bull, Kylina ZZCF      XX3-1113B\r\n  37       04/19/1982  10829   824695  al-Wahba, Hamna        ZZCF      XX3-1119B\r\n  20       06/17/1999  95006   729699  Nguyen, Vy             ZZCF      XX3-1115B\r\n  54       08/04/1965  24915   862783  Jauregui, Melisa       ZZCF      XX1-A108\r\n  65       08/20/1954  93233   147804  Lee, Megan             ZZCF      XX5-L105\r\n  56       12/09/1962  80047   161360  Lopez, Aspen           ZZCF      XX4-K108\r\n  30       02/13/1989  80998   882338  Radford, Addis         ZZCF      XX3-1121B\r\n  71       07/15/1948  46514   933686  Hall, Alana            ZZCF      XX5-M104\r\n  21       05/18/1998  25611   555598  Leon, Karina           ZZCF      XX3-1106B\r\n  43       05/23/1976  62969   389020  el-Khalili, Haseena    ZZCF      XX5-O102\r\n  52       12/20/1966  94907   765051  Pham, Gwendolyn        ZZCF      XX5-N101\r\n  48       12/12/1970  44338   833880  Washington, Precious   ZZCF      XX5-N103\r\n  40       09/03/1979  98425   542022  Colbert, Makayla       ZZCF      XX1-D107\r\n  77       11/11/1941  49345   689776  Engdahl, Heather       ZZCF      XX5-N108\r\n  44       02/17/1975  48761   661242  Aguilar Miranda, Tanya ZZCF      XX4-J104\r\n  34       02/14/1985  66662   240700  al-Abed, Sahheeda      ZZCF      XX1-B104\r\n  28       03/07/1991  39394   171530  Howard, Jamila         ZZCF      XX4-I103\r\n  89       04/27/1930  82544   849895  Johnson, Claudia       ZZCF      XX3-1118B\r\n150 People                                                                 Page 3of 3\r\n"
```

```r
writeLines(txt[1])
```

```
##                                                                    10/17/2019 17:56:18
##                       XX Department of Corrections
##  Age    Date of Birth  NCDC#  Offender# Offender Name          Location  Cell
##   52       11/06/1966   24672   706169  Perez, Kuliana         ZZCF      XX5-M101
##   38       02/13/1981   21893   901279  Blueeyes, Brittany     ZZCF      XX3-1114A
##   77       09/27/1942   50872   571941  Santacruz, Crystal     ZZCF      XX5-L101
##   38       07/21/1981   38476   980778  Price, Molly           ZZCF      XX3-1110A
##   58       08/19/1961   72013   712810  Byers, Aryan           ZZCF      XX5-L104
##   28       06/13/1991   94521   642542  Hood, Shelby           ZZCF      XX1-B101
##   20       10/07/1999   39595   594894  Johnson, Tashina       ZZCF      XX4-J108
##   34       03/10/1985   53564   330973  Chase, Asli            ZZCF      XX3-1105A
##   81       03/27/1938   35174   589531  el-Harroun, Muneefa    ZZCF      XX4-K102
##   54       05/25/1965   21513   153175  al-Younan, Nadheera    ZZCF      XX2-F104
##   72       05/29/1947   80247   828363  Juarez, Sarahy         ZZCF      XX3-1123A
##   78       07/09/1941   61715   387909  Williams, Brechelle    ZZCF      XX3-1122B
##   25       08/03/1994   35899   213496  al-Emami, Yaasmeena    ZZCF      XX5-O101
##   52       01/04/1967   29448   668652  Sidara, Julia          ZZCF      XX3-1117A
##   87       07/21/1932   33781   179719  el-Ismail, Suhaad      ZZCF      XX3-1104A
##   56       10/03/1963   52517   685582  Reno, Autumn           ZZCF      XX4-I108
##   67       10/04/1952   54085   657316  al-Arif, Hikma         ZZCF      XX3-1101B
##   47       11/17/1971   73925   874270  Smith, Rebekah         ZZCF      XX2-E105
##   68       05/09/1951   67879   637466  Shahi, Jennifer        ZZCF      XX2-E104
##   24       04/03/1995   67144   586885  Bedford, Rachel        ZZCF      XX1-C101
##   56       09/06/1963   70795   250288  Busby, Jacqueline      ZZCF      XX5-N107
##   39       05/20/1980   98202   792944  Watkins, Amanda        ZZCF      XX1-A106
##   43       11/10/1975   96801   684942  Houdek, Alyssa         ZZCF      XX2-F106
##   28       07/28/1991   81711   100377  Li, Raveena            ZZCF      XX5-N106
##   25       02/28/1994   17411   344945  Cranny, Hannah         ZZCF      XX2-F101
##   24       08/18/1995   69350   104636  Poole, Jacquelyn       ZZCF      XX2-G105
##   58       01/11/1961   65436   487567  Ditorrice, Nikki       ZZCF      XX2-H108
##   45       03/14/1974   45543   772574  Amen, Sheela           ZZCF      XX3-1112A
##   78       12/17/1940   40129   923147  Asuncion, Nicole       ZZCF      XX1-D105
##   74       09/03/1945   33767   419059  el-Hares, Hanoona      ZZCF      XX2-E103
##   66       06/10/1953   13175   609617  Melbrod, Danielle      ZZCF      XX5-O103
##   47       11/24/1971   81882   886636  Bass, Auna             ZZCF      XX4-J101
##   49       11/27/1969   70134   231479  Fluckes, Helen         ZZCF      XX2-G106
##   40       07/08/1979   69533   508911  Ramos, Samantha        ZZCF      XX2-E107
##   84       02/24/1935   37677   242471  Rodriguez, Jessica     ZZCF      XX5-O105
##   62       11/07/1956   62668   608128  Linsenbigler, Marissa  ZZCF      XX3-1102A
##   50       01/22/1969   68053   800953  Seiler, Aryan          ZZCF      XX2-E102
##   88       03/14/1931   13071   213264  Svenby, Adalise        ZZCF      XX3-1121A
##   89       06/25/1930   30532   332993  Armijo, Roxana         ZZCF      XX2-E106
##   22       08/23/1997   34869   159434  Sarmiento, Linh        ZZCF      XX3-1111A
##   85       05/12/1934   65282   896924  Sawyer, Georgina       ZZCF      XX5-L103
##   52       09/29/1967   97949   370255  Reyes-Juarez, Arianna  ZZCF      XX3-1123B
##   35       01/04/1984   71095   642331  Holub, Riley           ZZCF      XX5-M103
##   61       11/29/1957   13026   994546  Garrison, Carissa      ZZCF      XX5-M107
##   71       09/05/1948   82831   369149  Wade, Allyssa          ZZCF      XX1-D101
##   55       03/22/1964   81412   435893  Kim, Belicia           ZZCF      XX1-C106
##   47       04/22/1972   58346   262885  Rudnick, Kylie         ZZCF      XX3-1112B
##   63       08/23/1956   16699   678034  Walker, Kuneeshah      ZZCF      XX3-1124B
##   52       04/20/1967   76813   193181  Johnson-Rhoades, Tiara ZZCF      XX5-N104
## 150 People                                                                  Page 1of 3
```

We could use parsing to parse the data from the table in the PDF, but tabulizer may prove more helpful. I will demonstrate parsing, as time allows.

# Demonstrating using tabulizer


```r
extTables <- tabulizer::extract_tables("00_GeneratePDF.pdf",
                                       output="data.frame")
str(extTables)
```

```
## List of 3
##  $ :'data.frame':	49 obs. of  7 variables:
##   ..$ Age          : int [1:49] 52 38 77 38 58 28 20 34 81 54 ...
##   ..$ Date.of.Birth: chr [1:49] "11/06/1966" "02/13/1981" "09/27/1942" "07/21/1981" ...
##   ..$ NCDC.        : int [1:49] 24672 21893 50872 38476 72013 94521 39595 53564 35174 21513 ...
##   ..$ Offender.    : int [1:49] 706169 901279 571941 980778 712810 642542 594894 330973 589531 153175 ...
##   ..$ Offender.Name: chr [1:49] "Perez, Kuliana" "Blueeyes, Brittany" "Santacruz, Crystal" "Price, Molly" ...
##   ..$ Location     : chr [1:49] "ZZCF" "ZZCF" "ZZCF" "ZZCF" ...
##   ..$ Cell         : chr [1:49] "XX5-M101" "XX3-1114A" "XX5-L101" "XX3-1110A" ...
##  $ :'data.frame':	51 obs. of  7 variables:
##   ..$ Age          : int [1:51] 87 60 60 80 31 37 20 42 39 42 ...
##   ..$ Date.of.Birth: chr [1:51] "10/18/1931" "04/02/1959" "03/23/1959" "10/11/1938" ...
##   ..$ NCDC.        : int [1:51] 91524 75487 15722 49158 67463 84845 28093 52978 51008 38144 ...
##   ..$ Offender.    : int [1:51] 117461 923913 426841 480684 555371 914228 674441 672537 403567 201797 ...
##   ..$ Offender.Name: chr [1:51] "Wilkins, Morgan" "Nguyen, Thy Thy" "Garcia, Sara" "Martinez, Quianah" ...
##   ..$ Location     : chr [1:51] "ZZCF" "ZZCF" "ZZCF" "ZZCF" ...
##   ..$ Cell         : chr [1:51] "XX3-1106A" "XX3-1119A" "XX2-G103" "XX3-1111B" ...
##  $ :'data.frame':	50 obs. of  7 variables:
##   ..$ Age          : int [1:50] 59 83 43 78 26 79 80 45 60 57 ...
##   ..$ Date.of.Birth: chr [1:50] "08/10/1960" "06/30/1936" "07/29/1976" "03/04/1941" ...
##   ..$ NCDC.        : int [1:50] 13880 77104 88738 47558 88175 39743 63852 40264 11015 83827 ...
##   ..$ Offender.    : int [1:50] 343542 307105 814460 234106 466058 926914 607032 974333 443988 481793 ...
##   ..$ Offender.Name: chr [1:50] "Ciarlelli, Kaitlei" "Brown, Marian" "Thomas, Naznet" "Kier, Kayla" ...
##   ..$ Location     : chr [1:50] "ZZCF" "ZZCF" "ZZCF" "ZZCF" ...
##   ..$ Cell         : chr [1:50] "XX4-K103" "XX1-C103" "XX1-A103" "XX5-M106" ...
```

```r
glimpse(extTables[[1]])
```

```
## Observations: 49
## Variables: 7
## $ Age           <int> 52, 38, 77, 38, 58, 28, 20, 34, 81, 54, 72, 78, ...
## $ Date.of.Birth <chr> "11/06/1966", "02/13/1981", "09/27/1942", "07/21...
## $ NCDC.         <int> 24672, 21893, 50872, 38476, 72013, 94521, 39595,...
## $ Offender.     <int> 706169, 901279, 571941, 980778, 712810, 642542, ...
## $ Offender.Name <chr> "Perez, Kuliana", "Blueeyes, Brittany", "Santacr...
## $ Location      <chr> "ZZCF", "ZZCF", "ZZCF", "ZZCF", "ZZCF", "ZZCF", ...
## $ Cell          <chr> "XX5-M101", "XX3-1114A", "XX5-L101", "XX3-1110A"...
```

We can compare to the original data and see they are exactly the same.


```r
BigTable <- bind_rows(extTables) %>%
  as_tibble()

TrueTable <- read_rds("RosterTibble.rds") %>%
  set_names(names(BigTable))

all_equal(BigTable, TrueTable)
```

```
## [1] TRUE
```


# Importing the scanned PDF

It is much more tricky and error-prone to read in a scanned PDF or PDF that is not machine readable. We use the tesseract package to read in the PDF. It has OCR software and is powerful.


```r
library(tesseract)

txtScan <- tesseract::ocr("00_GeneratePDF_scanned.pdf")
```

```
## Converting page 1 to 00_GeneratePDF_scanned_1.png... done!
## Converting page 2 to 00_GeneratePDF_scanned_2.png... done!
## Converting page 3 to 00_GeneratePDF_scanned_3.png... done!
```

```r
str(txtScan)
```

```
##  chr [1:3] "10/17/2019 17:56:18\nXX Department of Corrections\nAge Date of Birth NCDC# Offender# Offender Name Location Cel"| __truncated__ ...
```

```r
writeLines(txtScan[[1]])
```

```
## 10/17/2019 17:56:18
## XX Department of Corrections
## Age Date of Birth NCDC# Offender# Offender Name Location Cell
## 52 11/06/1966 24672 706169 Perez, Kuliana ZLCE XX5-M101
## 38 02/13/1981 21893 901279 Blueeyes, Brittany ZZCE XX3-1114A
## 77 09/27/1942 50872 571944 Santacruz, Crystal ZZCFE XX5-L1O1
## 38 07/21/1981 38476 980778 Price, Molly ZLZCE XX3-11LIGA
## 58 08/19/1961 72013 712810 Byers, Aryan ZZCE XX9-LIO4
## 28 06/13/1991 94521 642542 Hood, Shelby LLCE AX1-Bi01
## 20) 10/07/1999 39595 594894 Johnson, Tashina ZZCE AX4-JF108
## 34 03/10/1985 9306-4 330973 Chase, Asli ZZCF XX3-1L105A
## §1 03/27/1938 30174 589531 el-Harroun, Muneefa ZLLCE NA4-K 102
## od 05/25/1965 21513 153175 al-Younan, Nadheera ZZCE XX2-F10-4
## 72 05/29/1947 80247 828363 Juarez, Sarahy ZZCF XX3-1123A
## 78 07/09/1941 61715 387909 Williams, Brechelle ZZCE AX3-1122B
## 29 08/03/1994 35899 213496 al-Einami, Yaasmeena ZLZCE XX5-O101
## o2 01/04/1967 29448 668652 Sidara, Julia LLCE AXS-LLLTA
## 87 07/21/1932 33781 179719 eLIsmail, Suhaad ZLZLCE XX3-1LL044
## O6 10/03/1963 O201L7 685082 Reno, Autumn ZLZCE XX4-T108
## OF 10/04/1952 o4085 657316 al-Arif, Hikma LZCE XX3-1101B
## AT 11/17/1971 73925 874270 Smith, Rebekah ZZCF XX2-E105
## 68 05/09/1951 67879 637-166 Shahi, Jenniter ZZCF AXAZ-E104
## 24. 04/03/1995 67144 586885 Bedford, Rachel ZZCE XX1-C101
## 56 09/06/1963 70795 250288 Busby, Jacqueline ZLLCF XX5-N1L07
## 39 05/20/1980 98202 79294-4 Watkins, Amanda LLCE XX 1-A106
## AS 11/10/1975 96801 684942 Houdek, Alyssa ZLLCE XX2-F 106
## 28 07/28/1991 81711 100377 Li, Raveena ZZCF XX5-N106
## 25 02/28/1994 17411 344945 Cranny, Hannah ZLCE XX2-F101
## 24 08/18/1995 69350 104636 Poole, Jacquelyn ZZCE XX2-G105
## as 01/11/1961 65436 AS87567 Ditorrice, Nikki LLCE XX2-H1i08
## 45 03/14/1974 45543 772574 Amen, Sheela ZLLCF XX3-1LIZA
## 78 12/17/1940 40129 923147 Asuncion, Nicole ZLCE XX1-D105
## 7A 09/03/1945 33767 419059 el-Hares, Hanoona ZLCE XX2-F103
## 66 06/10/1953 13175 609617 Melbrod, Danielle ZZCE XX5-O103
## AT 11/24/1971 81882 886636 Bass, Auna ZZCE XX4-J101
## AO 11/27/1969 70134 231479 Fluckes, Helen ZLCE XX2-G106
## AD 07/08/1979 69533 508911 Ramos, Samantha ZZCE XX2-E107
## SA 02/24/1935 37677 2.4247] Rodriguez, Jessica ZZCE XX5-O105
## 62 11/07/1956 62668 608128 Linsenbigler, Marissa ZLCE XX3-1102A
## ol) 01/22/1969 680535 800953 Seiler, Arvan LLCE XX2-H102
## 88 03/14/1931 13071 213264 Svenby, Adalise ZLCF XX3-1L1Z1A
## 89 06/25/1930 30532 332993 Armijo, Roxana ZZCF XX2-E106
## 22 08/23/1997 34869 1594134 Sarmiento, Linh ZLLCF XX3-1L111A
## 85 05/12/1934 65282 896924 Sawyer, Georgina ZLLCE XX5-L.103
## o2 09/29/1967 97949 370255 Reyes-Juarez, Arianna ZLLGE XX3-1123B
## 30 01/04/1984 71095 642331 Holub, Riley ZZCE XXS-M103
## 61 11/29/1957 13026 994546 Garrison, Carissa LZCE XX5-MI107
## 71 09/05/1948 82831 369149 Wade, Allyssa LLCF XX1-D101
## ah 03/22/1964 $1112 4135893 Kin, Belicia LLCE XX1-C106
## 17 04/22/1972 58346 262885 Rudnick, Kylie ZZCE XX3-11125
## 63 08/23/1956 16699 6780354 Walker, Kuneeshah LZCE XX3-1124B
## a2 04/20/1967 76813 193181 Johnsou-Rhoades, Tiara ZZCF XA5-N104
## 150 People Page tof 3
```

Let's work just with page 1. We know that each line ends in "\n" so let's take advanatage of that and separate it by that.


```r
FirstTibble <- tibble(AllDat=str_split(txtScan[[1]], "\n")[[1]])

head(FirstTibble)
```

```
## # A tibble: 6 x 1
##   AllDat                                                       
##   <chr>                                                        
## 1 10/17/2019 17:56:18                                          
## 2 XX Department of Corrections                                 
## 3 Age Date of Birth NCDC# Offender# Offender Name Location Cell
## 4 52 11/06/1966 24672 706169 Perez, Kuliana ZLCE XX5-M101      
## 5 38 02/13/1981 21893 901279 Blueeyes, Brittany ZZCE XX3-1114A 
## 6 77 09/27/1942 50872 571944 Santacruz, Crystal ZZCFE XX5-L1O1
```

```r
tail(FirstTibble)
```

```
## # A tibble: 6 x 1
##   AllDat                                                         
##   <chr>                                                          
## 1 ah 03/22/1964 $1112 4135893 Kin, Belicia LLCE XX1-C106         
## 2 17 04/22/1972 58346 262885 Rudnick, Kylie ZZCE XX3-11125       
## 3 63 08/23/1956 16699 6780354 Walker, Kuneeshah LZCE XX3-1124B   
## 4 a2 04/20/1967 76813 193181 Johnsou-Rhoades, Tiara ZZCF XA5-N104
## 5 150 People Page tof 3                                          
## 6 ""
```

Now, we need to remove the header and footer. Then try to separate into multiple columns.


```r
Tibble2 <- FirstTibble %>%
  filter(!(str_sub(AllDat, 1,10) %in% c("10/17/2019", "XX Departm", "150 People", "Age Date o"))) %>%
  filter(AllDat != "")

head(Tibble2)
```

```
## # A tibble: 6 x 1
##   AllDat                                                      
##   <chr>                                                       
## 1 52 11/06/1966 24672 706169 Perez, Kuliana ZLCE XX5-M101     
## 2 38 02/13/1981 21893 901279 Blueeyes, Brittany ZZCE XX3-1114A
## 3 77 09/27/1942 50872 571944 Santacruz, Crystal ZZCFE XX5-L1O1
## 4 38 07/21/1981 38476 980778 Price, Molly ZLZCE XX3-11LIGA    
## 5 58 08/19/1961 72013 712810 Byers, Aryan ZZCE XX9-LIO4       
## 6 28 06/13/1991 94521 642542 Hood, Shelby LLCE AX1-Bi01
```

```r
tail(Tibble2)
```

```
## # A tibble: 6 x 1
##   AllDat                                                         
##   <chr>                                                          
## 1 61 11/29/1957 13026 994546 Garrison, Carissa LZCE XX5-MI107    
## 2 71 09/05/1948 82831 369149 Wade, Allyssa LLCF XX1-D101         
## 3 ah 03/22/1964 $1112 4135893 Kin, Belicia LLCE XX1-C106         
## 4 17 04/22/1972 58346 262885 Rudnick, Kylie ZZCE XX3-11125       
## 5 63 08/23/1956 16699 6780354 Walker, Kuneeshah LZCE XX3-1124B   
## 6 a2 04/20/1967 76813 193181 Johnsou-Rhoades, Tiara ZZCF XA5-N104
```

```r
Tibble3 <- Tibble2 %>%
  separate(AllDat, into=c("Age", "DOB", "ID1", "ID2", "LName", "Fname", "Place", "Cell"), sep=" ", remove=FALSE, convert=TRUE)
```

```
## Warning: Expected 8 pieces. Additional pieces discarded in 3 rows [9, 22,
## 23].
```

```r
Tibble3 %>% slice(c(9, 22, 23)) %>% pull(AllDat)
```

```
## [1] "§1 03/27/1938 30174 589531 el-Harroun, Muneefa ZLLCE NA4-K 102"
## [2] "39 05/20/1980 98202 79294-4 Watkins, Amanda LLCE XX 1-A106"    
## [3] "AS 11/10/1975 96801 684942 Houdek, Alyssa ZLLCE XX2-F 106"
```

```r
head(Tibble3)
```

```
## # A tibble: 6 x 9
##   AllDat                Age   DOB     ID1   ID2   LName  Fname Place Cell  
##   <chr>                 <chr> <chr>   <chr> <chr> <chr>  <chr> <chr> <chr> 
## 1 52 11/06/1966 24672 ~ 52    11/06/~ 24672 7061~ Perez, Kuli~ ZLCE  XX5-M~
## 2 38 02/13/1981 21893 ~ 38    02/13/~ 21893 9012~ Bluee~ Brit~ ZZCE  XX3-1~
## 3 77 09/27/1942 50872 ~ 77    09/27/~ 50872 5719~ Santa~ Crys~ ZZCFE XX5-L~
## 4 38 07/21/1981 38476 ~ 38    07/21/~ 38476 9807~ Price, Molly ZLZCE XX3-1~
## 5 58 08/19/1961 72013 ~ 58    08/19/~ 72013 7128~ Byers, Aryan ZZCE  XX9-L~
## 6 28 06/13/1991 94521 ~ 28    06/13/~ 94521 6425~ Hood,  Shel~ LLCE  AX1-B~
```

```r
tail(Tibble3)
```

```
## # A tibble: 6 x 9
##   AllDat               Age   DOB     ID1   ID2    LName   Fname Place Cell 
##   <chr>                <chr> <chr>   <chr> <chr>  <chr>   <chr> <chr> <chr>
## 1 61 11/29/1957 13026~ 61    11/29/~ 13026 994546 Garris~ Cari~ LZCE  XX5-~
## 2 71 09/05/1948 82831~ 71    09/05/~ 82831 369149 Wade,   Ally~ LLCF  XX1-~
## 3 ah 03/22/1964 $1112~ ah    03/22/~ $1112 41358~ Kin,    Beli~ LLCE  XX1-~
## 4 17 04/22/1972 58346~ 17    04/22/~ 58346 262885 Rudnic~ Kylie ZZCE  XX3-~
## 5 63 08/23/1956 16699~ 63    08/23/~ 16699 67803~ Walker, Kune~ LZCE  XX3-~
## 6 a2 04/20/1967 76813~ a2    04/20/~ 76813 193181 Johnso~ Tiara ZZCF  XA5-~
```

It looks like this isn't converting very well. For example, the ZZCF location isn't converting correctly at all. We can tinker with how the images are processed to help improve this.


```r
pngClearer <- 
  pdftools::pdf_convert("00_GeneratePDF_scanned.pdf",
                        dpi=900,
                        filenames=str_c("00_GeneratePDF_scanned_", 1:3, "_alt.png"))
```

```
## Converting page 1 to 00_GeneratePDF_scanned_1_alt.png... done!
## Converting page 2 to 00_GeneratePDF_scanned_2_alt.png... done!
## Converting page 3 to 00_GeneratePDF_scanned_3_alt.png... done!
```

```r
txtClearer <- pngClearer %>%
  tesseract::ocr()
```


```r
AllDat=str_split(txtClearer[[1]], "\n")[[1]]

AllDat
```

```
##  [1] "10/17/2019 17:56:18"                                             
##  [2] "XX Department of Corrections"                                    
##  [3] "Age Date of Birth NCDC# Offender# Offender Name Location Cell"   
##  [4] "92 11/06/1966 24072 706169 Perez, Kuliana ZLCE XX5-M101"         
##  [5] "38 02/13/1981 21893 OO1L279 Blueeyes, Brittany LLOCE XASLLIAA"   
##  [6] "77 09/27/1942 HOS872 971944 Santacrng, Crystal LLC &KXS-L1O1"    
##  [7] "3d 07 /21/198] 35476 980778 Price, Molly ZLLCE AX3-1LLIGA"       
##  [8] "58 08/19/1961 72013 712810 Byers, Aryan ZLZCF XX5-L104"          
##  [9] "28 06/13/1991 94521 642542 Hood, Shelby LACK AX1-Bi01"           
## [10] "20) 10/07/1999 39495 94894 Johnson, Tashma LACE AX4-J1O8"        
## [11] "34 03/10/1985 o00-4 300973 Chase, Asli LOCr XAS-LIOSA"           
## [12] "S1 03/27/1938 3s0i74 989531 el-Harroun, Mumeefa LLG AS4-K 102"   
## [13] "Od 05/25/1965 21513 153175 al-Younan, Nadheera LLCE AX2-F 104"   
## [14] "To 05/29/1947 80247 828363 Juarez, Sarahy ZLCE KA+LI2Z3A"        
## [15] "78 07/09/1941 61715 387909 Williams, Brechelle LACH AXS-1122B"   
## [16] "20 08/03/1994 35899 213496 al-Finami, Yaasmeena LLCE XX5-O101"   
## [17] "52 01/01/1967 294.4% 668652 Sidara, Julia LLC AXB-LLLTA"         
## [18] "87 07/21/1932 33781 179719 el-Ismail, Suhaad ZZCE KX3-1104A8"    
## [19] "56 10/03/1963 52517 685582 Reno, Autumn LZCE XX-4-1108"          
## [20] "Of 10/04/1952 LOSS ba73d16 al-Arif, Hikma LACE XAXS-LIOLB"       
## [21] "AZ 11/17/1971 73925 874270 smith, Rebekah LLCH AX2-E105"         
## [22] "Gs 03/09/1953 O7879 637-166 Shahi, Jennifer LLCE KX2-E10-4"      
## [23] "24. 04/03/1995 67144 586885 Bedford, Rachel LLCE XXI1-C1O1"      
## [24] "o6 09/06/1963 T0795 250288 Bushy, Jacqueline ALOE XX5-N1LO7"     
## [25] "39 05/20/1980 98202 792944 Watkins, Amanda LLCY XX1-A106"        
## [26] "43 11/10/1975 96801 6849.42 Houdek, Alyssa ZLCE XX2-F 106"       
## [27] "28 07/28/1991 81711 100377 Li, Raveena ZLCE XX5-N106"            
## [28] "25 02/28/1994 L741} 344945 Cranny, Hannah LLCH XX2-F101"         
## [29] "24 08/18/1995 69350 104636 Poole, Jacquelyn LLCE XX2-G105"       
## [30] "as 01/11/1961 60436 AST O67 Ditorrice, Nikka LACE XX2-H108"      
## [31] "dd 03/14/1974 45543 Ti2o0T4 Amen, Sheela LACE AXS-LLIZA"         
## [32] "73 12/17/1940 40129 923147 Asuncion, Nicole LACE XX1-D105"       
## [33] "74 09/03/1045 33767 419059 el-Hares, Hanoona LLC XX2-F103"       
## [34] "66 06/10/1953 13175 609617 Melbrod, Danielle ALCE XX5-O103"      
## [35] "AT 11/24/1971 S1882 886636 Bass, Auna LACE AX4-J1014"            
## [36] "A9 11/27/1969 70134 231479 Fluckes, Helen LLC AX 2-106"          
## [37] "AQ 07/08/1979 69533 508911 Ramos, Samantha ALCE XX2-E1LOT"       
## [38] "SA G2 /24/1935 SfO77 2.4247] Rodriguez, Jessica ZLLCH KAKS-OLOD" 
## [39] "62 11/07/1956 62668 608128 Linsenbigler, Marissa Late AX3-LIOZA" 
## [40] "OU Q1 /22/1969 68053 800953 Seiler, Arvan LLCE AXA2-H1O2"        
## [41] "8X 03/14/1931 13071 213264 Svenbv, Adalise ZACE AXB-LIZLA"       
## [42] "89 06/25/1930 30032 332993 Armijo, Roxana LLCE AN2-E106"         
## [43] "22 08/23/1997 3:1869 159434 Sarmiento, Linh LLGE XX3-1111A"      
## [44] "85 05/12/1934 G5282 896924 Sawyer, Georgina LLCE XX5-L103"       
## [45] "2 09/29/1967 97949 370255 Revyes- Juarez, Arianna LLCE XX3-1123B"
## [46] "35 1/04/1984 71095 642331 Holub, Riley LLC KAD-MI1OS"            
## [47] "61 11/29/1957 13026 994546 Garrison, Carissa. LLG AKO-MIO7"      
## [48] "71 09/05/1948 82831 369149 Wade, Allyssa LACE XX1-D101"          
## [49] "8) 03 (22/1964 S1-412 435893 Kim, Belicia ALE XA1-C106"          
## [50] "17 04/22/1972 O3d46 262880 Rudnick, Kylie ZALCE AAS-11125"       
## [51] "63 08/23/1956 16699 678034 Walker, Kuneeshah ZACH AA3-11245"     
## [52] "D2 04/20/1967 76813 193181 Johnson-Rhoades, Tiara ZZCKF AAO-NLO4"
## [53] "150 People Page lof 3"                                           
## [54] ""
```

This really isn't much clearer and will need some manual work.
