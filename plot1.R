library(stringr)
library(readr)
library(tidyr)
library(reshape2)
library(dplyr)


#Downloading and unziping the data files
if (file.exists("household_power_consumption.txt")== FALSE){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile = "hpconsuption.zip")
  unzip("hpconsuption.zip")
}

#Reading data table 

df <- read.table("household_power_consumption.txt", sep=";", stringsAsFactors = FALSE )
mydf <- subset(df, (V1 == "1/2/2007" ))
mydf2 <- subset(df, (V1 == "2/2/2007" ))
mydf1 <-rbind(mydf, mydf2) 
c_names <- read.table("household_power_consumption.txt", sep=";",stringsAsFactors = FALSE, nrows = 1 )
c_names
# data subset ready with feb 1 and 2 2007 data
colnames(mydf1) <- c_names
head(mydf1)

sub("?",NA, mydf1)

head(mydf1)
str(mydf1)

Global_Active_Power <- as.numeric(mydf1$Global_active_power)


hist(x=Global_Active_Power, breaks=20, col="red", main ="Global Active Power", xlab="Global Active Power (killowatts)" )
dev.copy(png, file="plot1.png")
dev.off()


