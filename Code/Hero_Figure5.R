# load libraries ggplot2 and ggally 
library(ggplot2) 
library(GGally) 

sample_data <- read.csv('outputFiles/MFA_input.csv', header=TRUE, row.names="COUNTRY")

# create pairs plot 
ggpairs( sample_data )