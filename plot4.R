library(stringr)
library(readr)
library(tidyr)
library(reshape2)
library(dplyr)
library(lubridate)


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

y<- dmy(mydf1$Date)
wday(y, label=TRUE)

z<- hms(mydf1$Time)
z


mydf_w <- mydf1 %>% mutate(weekday = wday(y, label=TRUE)) %>%
  mutate(dateTime = as.POSIXct(paste(y, Time), tz="UCT"))

head(mydf_w)
str(mydf_w)

Global_Active_Power <- as.numeric(mydf_w$Global_active_power)
week_day <- mydf_w$weekday
str(week_day)
str(Global_Active_Power)

Global_Rective_Power <-as.numeric(mydf_w$Global_reactive_power)
Voltage <- as.numeric(mydf_w$Voltage)

EnergySubMetering1 <- as.numeric(mydf_w$Sub_metering_1)
EnergySubMetering2 <- as.numeric(mydf_w$Sub_metering_2)
EnergySubMetering3 <- as.numeric(mydf_w$Sub_metering_3)
EngSubMeter <- EnergySubMetering1 + EnergySubMetering2 + EnergySubMetering3

par(mfrow=c(2,2),mar=c(5,4,2,0))
plot(Global_Active_Power~ dateTime, data=mydf_w,  type="l", ylab="Global Active Power", lwd=1)

plot(Voltage~ dateTime, data=mydf_w,  type="l", ylab="Voltage", lwd=1)

plot(EnergySubMetering1 ~ dateTime, data=mydf_w,  type="l", ylab="Engery Sub Meter", lwd=1)
lines(EnergySubMetering2 ~ dateTime,  data= mydf_w,type="l",  lwd=1, col="red")
lines(EnergySubMetering3~ dateTime,  data= mydf_w, type="l",  lwd=1, col="blue")
legend("topright", legend=c("Sub Meter1", "Sub Meter 2", "Sub Meter 3"),  col=c("black","red","blue"), lwd=1, cex=0.5)

plot(Global_reactive_power~ dateTime, data=mydf_w,  type="l", ylab="Global Rective Power", lwd=1)

dev.copy(png, file="plot4.png")
dev.off()
