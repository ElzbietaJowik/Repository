library(dplyr)
library(ggplot2)

# Zależność długości życia smoka od jego BMI
data <- miceadds::load.Rdata2("dragons.rda")

# Wzrost przeliczamy z jardów na metry
data$height <- data$height * 1.0936
# a wagę z ton na kilogramy
data$weight <- data$weight * 1000

# interaktywny wykres ggplot
data <- data %>%
  mutate(bmi = data$weight / (data$height)^2)

ggplot(data = data, mapping = aes(x = bmi, y = life_length)) + 
  geom_point(color = data$colour) + 
  theme_bw() + 
  theme(title = element_text(),
        panel.grid = element_blank()) + 
  labs(title= "How does the dragon's body mass index affect his life expectancy?") + 
  ylab("Life length") + 
  xlab("Body Mass Index")

# interaktywny w ggplot dlugosc zycia - liczba straconych zębów
ggplot(data = data, aes(x = life_length, y = number_of_lost_teeth)) + 
  geom_point() + 
  geom_smooth() + 
  theme_bw() + 
  ylab("Number of lost teeth") + 
  xlab("Life length") + 
  theme(
    panel.background = element_blank(),
    panel.grid = element_blank()
  )
  

# To będzie wykres słupkowy w d3
data %>% 
  group_by(year_of_discovery) %>%
  summarise(count = n()) -> df

