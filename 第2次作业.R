#----------------------------------------------------------------------------
#Script Name：pak_info.R
#Purpose:This scribes how to access information about the tidyverse package
#Author:Honghong Wang
#Email:873751229@qq.com
#Date:2024-3-13
#----------------------------------------------------------------------------
#Finding and selecting packages
install.packages("tidyverse")
library(tidyverse)
library(packagefinder)
findPackage("ggplot2")

#helping yourself
help(package="tidyverse")
help(package="ggplot2")

#Vignettes Demonstrations
vignette("tidyverse")
browseVignettes(package="tidyverse")
demo(package="tidyverse")
vignette("ggplot2")
browseVignettes(package="ggplot2")
demo(package="ggplot2")

#Searching for help
apropos("^tidyverse")
ls("package:tidyverse")
help.search("^tidyverse")
apropos("^ggplot2")
ls("package:ggplot2")
help.search("^ggplot2")
#------------------------------------------------------------------------

