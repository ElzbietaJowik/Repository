setwd("~")
getwd()
setwd("./R/scripts/MSO")

library(corrplot)
library(Hmisc)
library(car)
library(Metrics)
library(caret)
library(randomForest)
library(mlbench)
library(e1071)
library(MASS)
library(VGAM)


# Funkcja pomocnicza
rmse.fun <- function(linearModel){
  pred <- predict.lm(linearModel, T[, -ncol(T)])
  res <- sqrt(mean((pred - T[, ncol(T)])^{2}))
  return(res)
}

# Ustawiam ziarno w celu zapewnienia reprodukowalnosci wynikow
set.seed(123)


# Wczytanie zbioru
communities <- read.table("./projekt/communities.data", sep = ",", na.strings = "?")

# Dodanie etykiet kolumnom
attr <- read.csv2("./projekt/attributes.csv", stringsAsFactors = FALSE)
attr <- lapply(attr, as.character)
colnames(communities) <- attr$x
head(communities)

# Usuniecie 5 pierwszych kolumn i kolumn z brakami danych
df <- communities[, -c(1:5)]
df <- df[ , apply(df, 2, function(x) !any(is.na(x)))]

# Podzial na zbiory uczacy U (obserwacje o parzystych indeksach)
# i testowy T (obserwacje o nieparzystych indeksach)
even.indexes <- seq(2, nrow(df), 2)
odd.indexes <- seq(1, nrow(df), 2)

U <- df[even.indexes, ]
rownames(U) <- NULL
T <- df[odd.indexes, ]
rownames(T) <- NULL


# Dopasowanie modelu regresji liniowej na danych U (model m).
m <- lm(ViolentCrimesPerPop~., data = U)
rmse.fun(m)


# Diagnostyka modelu 
X <- U[, -ncol(U)]
Y <- U[, ncol(U)]

# Wykres modyfikowanych rezyduow dla pelnych danych
qplot(1:nrow(X), rstudent(m))


# Nie nasuwaja sie podejrzenia dot. obecnosci problemu nierownych wariancji,
# ani ewidentnie nieliniowego charakteru danych.

summary(m)

# Wspolczynnikami przy zmiennych nie wygladaja na zdegenerowane (brak NA),
# co intuicyjnie wskazuje na niewystepowanie w danych ewidentnego problemu wspolliniowosci.

# Badanie pod katem obecnosci problemu wspolliniowosci lub przyblizonej wspolliniowosci.
# Macierz korelacji
corr <- rcorr(as.matrix(X))

flattenCorrMatrix <- function(corrMat, pMat) {
  
  # Funkcja przyjmuje na wejsciu macierz wspolczynnikow korelacji
  # i macierz p-wartosci i wyswietla je w formie czytelnego podsumowania
  
  # Wybiera tylko gorna czesc macierzy (bez diagonali), aby nie wyswietlac 
  # korelacji zmiennych z samymi soba i nie powielac wyswietlanych par zmiennych 
  
  ut <- upper.tri(corrMat, diag = FALSE)
  res <- data.frame(
    variable1 = rownames(corrMat)[row(corrMat)[ut]],
    variable2 = rownames(corrMat)[col(corrMat)[ut]],
    correlation = (corrMat)[ut],
    pValue = pMat[ut]
  )
  return(res)
}

cor.matrix <- flattenCorrMatrix(corr$r, corr$P)

cor.matrix[cor.matrix$pValue < 0.05, ]
cor.matrix[cor.matrix$correlation > 0.5 & cor.matrix$pValue < 0.05, ]
# Dla znaczacej liczby par zmiennych nie ma podstaw do odrzucenia 
# hipotezy o statystycznej istotnosci ich korelacji. 

# Macierz korelacji pozwala badac zaleznosci tylko parami
# i nie wychwytuje zaleznosci nieliniowych pomiedzy zmiennymi.

# Badanie zjawiska przyblizonej wspoliniowosci za pomoca wspolczynnikow determinacji 
# wielokrotnej i wspolczynnikow podbicia wariancji.

multiple_determination_coefficient <- function(X){
  
  # Wspolczynniki determinacji wielokrotnej
  # czyli wspolczynniki determinacji w modelach, w ktorych 
  # jedna ze zmiennych objasniajacych uzaleznia sie od
  # pozostalych zmiennych objasniajacych.
  
  p <- ncol(X)
  R2 <- numeric(p)
  for (i in 1:p) {
    mi <- lm(X[, i]~X[, -i])
    r_squared <- summary(mi)$r.squared
    R2[i] <- r_squared
  }
  return(R2)
}

m.r2 <- multiple_determination_coefficient(model.matrix(m)[,-1])
m.r2

# Duza wartosc R^2 dla danej zmiennej oznacza, ze zmienna ta
# jest zalezna od przynajmniej czesci pozostalych. 

# Zbadanie wspolczynnikow podbicia wariancji (VIF) dla podstawowego modelu
m.vif <- 1/(1 - m.r2)
m.vif
# Bardzo wysokie wartosci wspolczynnikow (wielokrotnie wyzsze od 10)

# Pierwsza wprowadzona modyfikacja jest usuniecie polowy zmiennych sposrod tych, 
# miedzy ktorymi zdiagnozowano wysokie zaleznosci (parami)

cor.matrix <- cor(U[,-ncol(U)])
cor.matrix[lower.tri(cor.matrix)] <- 0
diag(cor.matrix) <- 0
cor.matrix <- which(cor.matrix >= 0.9, arr.ind = TRUE)
U_mod <- U[,-cor.matrix[,2]]

m_mod <- lm(ViolentCrimesPerPop~., data = U_mod)
rmse.fun(m_mod) 
# Poprawa RMSE rzedu 0.001 wzgledem RMSE uzyskanego dla podstawowego modelu m
# Ponowne badanie wspolczynnikow determinacji wielokrotnej i podbicia wariancji (VIF)
m_mod.r2 <- multiple_determination_coefficient(model.matrix(m_mod)[,-1])
m_mod.vif <- 1/(1-m_mod.r2)
m_mod.vif

# Wspolczynniki podbicia wariancji sa znacznie nizsze niz dla modelu wyjsciowego
# (maksymalna wartosc: ~41, gdzie dla poprzedniego modelu wynosila ona ~1105).
# Majac swiadomosc, ze VIF > 10 dla danej zmiennej wskazuje koniecznosc 
# zbadania tej zmiennej, kolejno usuwalam z modelu zmienne z maksymalnymi
# wartosciami rozwazanego wspolczynnika. Okazuje sie jednak, ze sekwencyjne 
# usuwanie kazdej kolejnej zmiennej powoduje pogarszanie jakosci modelu
# mierzonej za pomoca wspolczynnika RMSE.

summary(m_mod)

# Dla m_mod: Adjusted R-squared:  0.6794
# Dla m:	Adjusted R-squared:  0.6866 

# Dla modyfikowanego modelu mamy nieco gorsza jakosc dopasowania modeku do danych 
# treningowych, ale lepsza jakosc predykcji (wzgledem RMSE)

# Detekcja obserwacji wplywowych

# W pierwszej kolejnosci zajmuje sie detekcja obserwacji wplywowych, poniewaz 
# ich eliminacja moze doprowadzic do zmiany modelu i zmniejszenia rezyduow.
plot(m_mod, which = 4)

any(cooks.distance(m_mod) %in% 
      which(hatvalues(m_mod)>2*ncol(model.matrix(m_mod))/nrow(model.matrix(m_mod))))
# Heurystyka pomagajaca nam w detekcji obserwacji wplywowych
# nie musi w 100% pokrywac sie z heurystyka  uzyskana przez cooks.distance()
# Te metody sa do pewnego stopnia powiazane, ale nie tozsame.
# Dlatego jezeli chodzi o usuwanie obserwacji wplywowych najlepiej w pierwszej 
# kolejnosci usuwac te, ktore sa wskazywane jednoczesnie przez obydwie metody.
# U nas zadna obserwacja nie zostala wskazana w obydwu zastosowanych technikach detekcji,
# w zwiazku z czym na ten moment nie decyduje sie na usuwanie zadnej obserwacji.

# Diagnostyka obserwacji odstajacych w oparciu o rezydua studentyzowane

rstud <- rstudent(m_mod)
outliers <- rstud[which(abs(rstud)>2)] 
outliers

# Zdaje sobie sprawe, ze regula heurystyczna mowi o klasyfikacji obserwacji 
# jako odstajaca wowczas, gdy wartosc bezwzgledna rezyduum jest wieksza niz 2.
# Biorac jednak pod uwage, ze az 58 obs.jest potencjalnie odstajacych i 
# wiedzac, ze usuniecie zbyt wielu obserwacji mimo ze polepszy dopasowanie 
# modelu moze negatywnie wplynac na jakosc predykcji wykonam dodatkowy test -  
# test studenta z poprawka Bonferroniego.

outlierTest(m_mod)
# Wszystkie obserwacje wskazane przez test zostaly przez metode oparta na rezyduach.
U_mod <- U_mod[-c(188, 308, 75, 501, 940), ]

m_mod <- lm(ViolentCrimesPerPop~., data = U_mod)
rmse.fun(m_mod) 
# Poprawa RMSE wzgledem modyfikowanego modelu sprzed usuniecia wybranych obserwacji.

qplot(1:nrow(model.matrix(m_mod)), rstudent(m_mod))

# Heteroskedastycznoœæ
plot(m_mod, which = 1)
plot(m, which = 1)
U_mod_yj <- U_mod
# Podejrzewam wystepowanie problemu heteroskedastycznoœci. 
# Brak mozliwosci zastosowania przeksztacenia Boxa-Coxa ze wzgledu na obecnosc zer w zmiennej odpowiedzi. 
# Alternatywne podejscie - transformacja Yeo-Johnsona.
bc <- boxCox(m_mod, data = U_mod_yj, lambda = seq(-4, 0.5, by = 1e-2), family="yjPower")
lambda <- bc$x[which.max(bc$y)]

# Wyznaczone optymalne lambda
transformed_target <- yeo.johnson(U_mod_yj[["ViolentCrimesPerPop"]], lambda)
U_mod_yj["ViolentCrimesPerPop"] <- transformed_target

m_mod_yj <- lm(ViolentCrimesPerPop  ~ ., data = U_mod_yj)
plot(m_mod_yj, which = 1)
summary(m_mod_yj)

pred_mod_y <- predict(m_mod_yj, T[, -ncol(T)])
pred_y <- yeo.johnson(pred_mod_y, lambda = lambda, inverse = TRUE)
any(is.na(pred_y))
sqrt(mean((T[, ncol(T)] - pred_y)^2, na.rm = TRUE))
# Znaczne pogorszenie RMSE po przeksztalceniu, ponadto po dokonaniu
# odwrotnego przeksztalcenia NA obecne w zbiorze wartosci predykowanych

# Metoda prob i bledow wykazala, ze przeksztalcenie yeo.johnsona daje 
# lepszy rezultat dla lambda = 0.7 (choc nie wynika to z wykresu)
U_mod_yj2 <- U_mod

transformed_target2 <- yeo.johnson(U_mod_yj2[["ViolentCrimesPerPop"]], 0.7)
U_mod_yj2["ViolentCrimesPerPop"] <- transformed_target2

m_mod_yj2 <- lm(ViolentCrimesPerPop  ~ ., data = U_mod_yj2)
plot(m_mod_yj2, which = 1)
summary(m_mod_yj2)

pred_mod_y2 <- predict(m_mod_yj2, T[, -ncol(T)])
pred_y2 <- yeo.johnson(pred_mod_y2, lambda = 0.7, inverse = TRUE)
any(is.na(pred_y2))
sqrt(mean((T[, ncol(T)] - pred_y2)^2, na.rm = TRUE))
# Poprawa RMSE po transformacji

m_mod_yj2.rmse <- sqrt(mean((T[, ncol(T)] - pred_y2)^2, na.rm = TRUE))
# Z moich prob wynika, ze transformacja zmiennej odpowiedzi ma pozytywny 
# wplyw na jakosc predykcji, ale tylko przed przeprowadzeniem procedury step.
# Stad, w ogolnosci (poza konkretnym przypadkiem 67 zmiennych) zniwelowanie 
# obecnego w danych problemu heteroskedastycznosci poprawia specyfikacje modelu,
# ale negatywnie wplywa na wartosc RMSE, dlatego tez, nie transformuje danych trwale.

# Selekcja zmiennych
# F-test
summary(m_mod)
# p = 2.2e-16 < 0.05 => odrzucam H0 => co najmniej jedna zmienna jest istotna

# Test t-Studenta dla zmiennych
cols <- colnames(model.matrix(m_mod)[, -1])
t.relevant <- character(length = 0L) # wektor przechowujacy zmienne istotne

for (col in cols) {
  T1 <- summary(m_mod)$coefficients[col, 3]
  p.val <- summary(m_mod)$coefficients[col, 4]
  # pval1 > 0.05 => nie odrzucam H0 => zmienna "pop" jest nieistotna
  if(p.val <= 0.05){
    t.relevant <- c(t.relevant, col)
  }
}
summary(m_mod)$coefficients[t.relevant, ]

# Skonfrontujmy wyniki istotnosci uzyskane w wyniku przeprowadzenia 
# testu Studenta ze wskazaniami zalecanych wbudowanych metod.

m.empty <- lm(ViolentCrimesPerPop~1, data = U)
m.full <- m
m_mod.full <- m_mod

# Podejscie BIC backward dla wyjsciowego modelu (m)
m.step.bic <- step(m.full, direction = "backward", k = log(nrow(U)))
m.bic.coef <- names(m.step.bic$coefficients[-1])
m1 <- lm(ViolentCrimesPerPop~., data = U[, c(m.bic.coef, "ViolentCrimesPerPop")])
# Analiza wariancji
# Hipoteza zerowa H: mniejszy model (m1) zawarty w m jest adekwanty
# Hipoteza alternatywna K: !H
anova(m, m1, test = "F")
# Wniosek: p.val = 0.002259 < 0.05 czyli odrzucamy hipoteze zerowa
# (wg testu tracimy istotna informacje niesiona przez pelen model)
# Biorac pod uwage, ze analiza wariancji dotyczy zachowania modelu
# na zbiorze treningowym a jakosc predykcyji mierzona jest na zbiorze 
# testowym oraz fakt, ze przeprowadzany test obarczony jest 5%-bledem
# analize wariancji przeprowadzam kontrolnie, w celu dopelnienia obrazu,
# ale miara wiazaca wzgledem, ktorej oceniam jakosc modelu jest RMSE.

# Badanie wartosci wspolczynnika RMSE dla nowootrzymanego modelu.
rmse.fun(m1) 
# Poprawa wartosci wspolczynnika wzgledem RMSE modelu pelnego.

# Podejscie BIC backward dla modyfikowanego modelu (m_mod)
m_mod.step.bic <- step(m_mod.full, direction = "backward", k = log(nrow(U_mod)))
m_mod.bic.coef <- names(m_mod.step.bic$coefficients[-1])
m_mod1 <- lm(ViolentCrimesPerPop~., data = U_mod[, c(m_mod.bic.coef, "ViolentCrimesPerPop")])
# Analiza wariancji
# Hipoteza zerowa H: mniejszy model (m_mod1) zawarty w m_mod jest adekwanty
# Hipoteza alternatywna K: !H
anova(m_mod, m_mod1, test = "F")
# Wniosek: p.val = '0.00127 < 0.05 czyli ponownie odrzucamy hipoteze zerowa

rmse.fun(m_mod1) 
# Poprawa (subtelna) jakosci predykcji wzgledem modelu (m_mod).
# Pogorszenie wzgledem m_mod z transformowanym y

# Podejscie AIC backward dla wyjsciowego modelu (m)
m.step.aic <- step(m.full, direction = "backward")
m.aic.coef <- names(m.step.aic$coefficients[-1])
m2 <- lm(ViolentCrimesPerPop~., data = U[, c(m.aic.coef, "ViolentCrimesPerPop")])
# Analiza wariancji
# Hipoteza zerowa H: mniejszy model (m2) zawarty w m jest adekwanty
# Hipoteza alternatywna K: !H
anova(m, m2, test = "F")
# Wniosek: p.val = 0.9998 > 0.05 => brak podstaw do odrzucenia hipotezy zerowej
rmse.fun(m2)
# RMSE gorsze niz dla modelu uzyskanego po przeprowadzenia selekcji opartej
# na BIC i jednoczesnie bardzo zblizone (chociaz nieco lepsze) niz dla modelu m.

# Podejscie AIC backward dla wyjsciowego modelu (m_mod)
m_mod.step.aic <- step(m_mod.full, direction = "backward")
m_mod.aic.coef <- names(m_mod.step.aic$coefficients[-1])
m_mod2 <- lm(ViolentCrimesPerPop~., data = U_mod[, c(m_mod.aic.coef, "ViolentCrimesPerPop")])
# Analiza wariancji
# Hipoteza zerowa H: mniejszy model (m_mod2) zawarty w m_mod jest adekwanty
# Hipoteza alternatywna K: !H
anova(m_mod, m_mod2, test = "F")
# Wniosek: p.val = 0.9641 > 0.05 => brak podstaw do odrzucenia hipotezy zerowej

rmse.fun(m_mod2)
# Nieznaczne pogorszenie wzgledem poprzedniej modyfikacji - wartosc niemal identyczna
# jak dla m_mod.


# BONUS
# W ramach bonusu zbadalam efektywnosc nastepujacych modeli:
# 1. Drzew regresji -> uzyskalam duzo gorsza wartosc niz w przypadku dotychczasowych modeli, 
# uznalam, ze algorytm nie byl dobrym punktem wyjscia do poprawy rezultatu.
# 2. Modelu mieszanego -> ze wzgledu na dlugi czas oczekiwania i gorsza wartosc 
# rmse niz w przypadku dotychczasowych modeli liniowych, nie podjelam proby optymalizacji biezacego modelu
# 3. SVR (rezultaty ponizej)
# 4. Lasy losowe (rezultaty ponizej)

############################### SVR #############################

svm.mod <- svm(ViolentCrimesPerPop~., data = U_mod)
svm.pred <- predict(svm.mod, T[,-ncol(T)])
svm.rmse <- rmse(T[,ncol(T)], svm.pred)
svm.rmse
# Proba optymalizacji modelu SVR:

svm.tune <- tune.svm(ViolentCrimesPerPop~.,  data = U_mod, epsilon = seq(0,1,0.1), cost = 2^(seq(0.5,4,.5)), gamma = 2^(-8:1), tunecontrol = tune.control(sampling = "fix"))
svm.best <- svm.tune$best.model
svm.best.pred <- predict(svm.best, T[,-ncol(T)])
svm.best.rmse <- rmse(T[,ncol(T)], svm.best.pred)
svm.best.rmse 

############################# Lasy losowe #######################

rf.mod <- randomForest(ViolentCrimesPerPop~., data=U_mod)
rf.pred <- predict(rf.mod, newdata = T[, -ncol(T)])
rf.rmse <- sqrt(mean((T[,ncol(T)] - rf.pred)^{2}))
rf.rmse

# Badanie potencjalu zmniejszenia modelu Random Forest
# Uwaga: dosc dlugi czas obliczen wewnatrz funkcji rfProfile (kilka minut)

control <- rfeControl(functions=rfFuncs, method="cv", number=10)
rfProfile <- rfe(U_mod[ ,-ncol(U_mod)], U_mod[ ,ncol(U_mod)], sizes = seq(10, 50, 5), rfeControl = control)
print(rfProfile)
print(rfProfile$resample)
# png(filename = "rfProfile.png", width = 480, height = 480)
# plot(rfProfile, type=c("g", "o"))
# dev.off()
# Uzyskany wykres zostal dolaczony do archiwum.

rf.best.rmse <- Inf
numberOfVars <- rfProfile$bestSubset

for (i in 1:10) {
  print(paste("Calculations is progress:", i/10 * 100, "%"))
  bestSubset <- rfProfile$variables[rfProfile$variables$Variables == numberOfVars, "var"][((i-1)*numberOfVars+1):(i*numberOfVars)]
  dataModif <- U_mod[, c(bestSubset, "ViolentCrimesPerPop")]
  
  mtry <- floor(sqrt(ncol(dataModif)-1))
  
  rf.tune <- tune.randomForest(ViolentCrimesPerPop~., data = dataModif, stepFactor=1.5, improve=1e-5, ntree=500, mtry = mtry)
  rf.best <- rf.tune$best.model
  rf.best.pred <- predict(rf.best, newdata = T[, -ncol(T)])
  rmse <- rmse(T[,ncol(T)], rf.best.pred)
  
  if (rmse < rf.best.rmse) {
    rf.best.rmse <- rmse
  }
}
rf.best.rmse

# Oczywiscie w calosci procedury wystepuje losowosc, ale wg uzyskanego rezultatu
# mozna pomniejszyc model tracac niewiele (wzgledem metody SVM) na RMSE

# Podsumowanie rezultatow

results <- data.frame(model = c("m.empty", "m", "m1", "m2", "m_mod", "m_mod_yj2", "m_mod1", "m_mod2", "svm", "rf"),
                      number.of.variables = c(
                        ncol(model.matrix(m.empty))-1,
                        ncol(model.matrix(m))-1,
                        ncol(model.matrix(m1))-1,
                        ncol(model.matrix(m2))-1,
                        ncol(model.matrix(m_mod))-1,
                        ncol(model.matrix(m_mod_yj2))-1,
                        ncol(model.matrix(m_mod1))-1,
                        ncol(model.matrix(m_mod2))-1,
                        ncol(U_mod)-1,
                        ncol(dataModif)-1                         
                      ),
                      rmse = c(rmse.fun(m.empty),
                               rmse.fun(m),
                               rmse.fun(m1),
                               rmse.fun(m2),
                               rmse.fun(m_mod),
                               m_mod_yj2.rmse,
                               rmse.fun(m_mod1),
                               rmse.fun(m_mod2),
                               svm.best.rmse,
                               rf.best.rmse
                      )
)
# Korekta sposobu obliczania RMSE ... + zapisac wykresy
results$rse <- round(results$rmse * sqrt(nrow(T)), 7)
results$rmse <- round(results$rmse, 7)

# Zapis do pliku
# write.table(results, "./projekt/jowik_elzbieta.txt", sep="\t", row.names=FALSE)
