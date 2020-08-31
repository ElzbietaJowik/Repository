library(dygraphs)
library(xts)
library(tidyverse)
library(lubridate)
library(ggplot2)

############################### PIERWOWZOR ########################################

graphData <- read.csv("/home/elzbieta/twd/pracaDomowa2/anomal.csv")
# destosowanie danych do rysunku
graphData$Year <- graphData$Month %>% as.character() %>% substr(1, 4)
graphData$Month <- graphData$Month %>% as.character() %>% substr(5, 6)
graphData$Id <- 1:dim(graphData)[1]

nazwy_x <- character(42)
nazwy_x[seq(2, 42, by=5)] <- seq(1980, 2020, 5) %>% as.character()
nazwy_y <- seq(-0.3, 0.9, by=0.3) %>% as.character()

ggplot(data=graphData, aes(x=Id, y=global)) +
  geom_bar(stat= "identity", fill=ifelse(graphData$global>0, "red", "blue")) +
  scale_x_continuous(breaks=seq(0, 492, by=12), labels=nazwy_x) + 
  scale_y_continuous(breaks=seq(-0.3, 0.9, by=0.3), labels=nazwy_y) + 
  ggtitle("Monthly global surface air temperature anomalies (\\circ C) relative to 1981-2010") + 
  theme(plot.title = element_text(size=14),
        panel.background = element_rect(fill = "white", colour = "grey50"),
        axis.title.x = element_text(color="white"),
        axis.title.y = element_text(color="white"),
        axis.text.x = element_text(size=15),
        axis.text.y = element_text(size=15))


############################### MODYFIKACJA #########################################

graphData %>% 
  mutate(date = as.Date(as.yearmon(paste(Year, Month, sep = "-")))) -> graphData

globalGraphData <- xts(x = graphData$global, order.by = graphData$date)


p <-  dygraph(globalGraphData, main = "Monthly global surface air temperature anomalies (\\circ C) relative to 1981-2010") %>%
  dyOptions(fillGraph=TRUE, fillAlpha=0.7, drawGrid = FALSE, colors="#778899", drawAxesAtZero = TRUE) %>%
  dyRangeSelector() %>%
  dyHighlight(highlightCircleSize = 5, highlightSeriesBackgroundAlpha = 0.4, hideOnMouseOut = FALSE) %>%
  dyShading(from = "2015-07-01", to = "2017-06-01", color = "#C0C0C0") %>%
  dyUnzoom() %>%
  dyEvent("1979-03-01", label = "The end of the Polish winter of the century", strokePattern = "dashed", color = "black", labelLoc = "top") %>%
  dyEvent("2016-02-01", label = "February 2016 beats all records", strokePattern = "dashed", color = "black", labelLoc = "bottom") %>%
  dyEvent("2019-09-01", strokePattern = "solid", color = "black", labelLoc = "bottom")


p
