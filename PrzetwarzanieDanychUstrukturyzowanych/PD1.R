# Zadanie polega na równoważnym zapisaniu tych samych instrukcji za pomocą różnych pakietów

library(sqldf)
library(dplyr)
library(data.table)
library(microbenchmark)
library(beepr)

options(stringsAsFactors=FALSE)

Badges <- read.csv("/home/elzbieta/travel_stackexchange_com/Badges.csv")
Comments <- read.csv("/home/elzbieta/travel_stackexchange_com/Comments.csv")
PostLinks <- read.csv("/home/elzbieta/travel_stackexchange_com/PostLinks.csv")
Posts <- read.csv("/home/elzbieta/travel_stackexchange_com/Posts.csv")
Tags <- read.csv("/home/elzbieta/travel_stackexchange_com/Tags.csv")
Users <- read.csv("/home/elzbieta/travel_stackexchange_com/Users.csv")
Votes <- read.csv("/home/elzbieta/travel_stackexchange_com/Votes.csv")

Badges_dt <- as.data.table(Badges)
Comments_dt <- as.data.table(Comments)
PostLinks_dt <- as.data.table(PostLinks)
Posts_dt <- as.data.table(Posts)
Tags_dt <- as.data.table(Tags)
Users_dt <- as.data.table(Users)
Votes_dt <- as.data.table(Votes)

## Zadanie 1

df_sql_1 <- function()return(
  sqldf("SELECT
                      Users.DisplayName,
                      Users.Age,
                      Users.Location,
                      SUM(Posts.FavoriteCount) AS FavoriteTotal,
                      Posts.Title AS MostFavoriteQuestion,
                      MAX(Posts.FavoriteCount) AS MostFavoriteQuestionLikes
                  FROM Posts
                  JOIN Users ON Users.Id=Posts.OwnerUserId
                  WHERE Posts.PostTypeId=1
                  GROUP BY OwnerUserId
                  ORDER BY FavoriteTotal DESC
                  LIMIT 10"))

df_base_1 <- function(){
  tmp <- Posts[Posts$PostTypeId == 1, ]
  tmp_1_1 <- aggregate(tmp$FavoriteCount, by = tmp["OwnerUserId"], function(x) sum(x, na.rm = TRUE))
  colnames(tmp_1_1)[2] <- "FavoriteTotal"
  tmp_1_2 <- aggregate(tmp$FavoriteCount, by = tmp["OwnerUserId"], function(x) max(x, na.rm = TRUE))
  # warnings !
  colnames(tmp_1_2)[2] <- "MostFavoriteQuestionLikes"
  # żadna z tych dwóch wartości nie jest w tmp unikatowa, ale jeśli łączymy  po oby
  # w dalszym rozrachunku wychodzi ok, zdaję sobie sprawę...
  tmp_1_3 <- merge(tmp_1_2, tmp[, c("Title", "OwnerUserId", "FavoriteCount")], by.x = c("OwnerUserId", "MostFavoriteQuestionLikes"), by.y = c("OwnerUserId", "FavoriteCount"), )
  colnames(tmp_1_3)[3] <- "MostFavoriteQuestion"
  tmp_1_4 <- merge(tmp_1_3, tmp_1_1, by.x = "OwnerUserId", by.y = "OwnerUserId")
  Result <- merge(Users[, c("DisplayName", "Age", "Location", "Id")], tmp_1_4, by.x = "Id", by.y = "OwnerUserId")
  
  Result <- Result[, c("DisplayName", "Age", "Location", "FavoriteTotal", "MostFavoriteQuestion", "MostFavoriteQuestionLikes")]
  sort_permutation_1 <- order(Result$FavoriteTotal, decreasing = TRUE)
  Result <- Result[sort_permutation_1, ][1:10, ]
  rownames(Result) <- NULL
  return(Result)
}

df_dplyr_1 <- function(){
  tmp_1_1 <- inner_join(Posts, Users, by = c("OwnerUserId" = "Id")) %>%
    select(DisplayName, Age, Location, FavoriteCount, PostTypeId, OwnerUserId) %>%
    filter(PostTypeId == 1) %>%
    group_by(OwnerUserId) %>%
    mutate(FavoriteTotal = sum(FavoriteCount, na.rm = TRUE), MostFavoriteQuestionLikes = max(FavoriteCount, na.rm = TRUE)) %>%
    select(DisplayName, Age, Location, OwnerUserId, FavoriteTotal, MostFavoriteQuestionLikes) %>%
    ungroup()
  
  Posts1 <- Posts %>%
    select(OwnerUserId, FavoriteCount, Title)
  
  Result <- inner_join(tmp_1_1, Posts1, by = c("OwnerUserId", "MostFavoriteQuestionLikes" = "FavoriteCount")) %>%
    distinct(DisplayName, Age, Location, OwnerUserId, FavoriteTotal, MostFavoriteQuestionLikes, MostFavoriteQuestion = Title) %>%
    arrange(desc(FavoriteTotal)) %>% head(10) %>% select(DisplayName, Age, Location, FavoriteTotal, MostFavoriteQuestionLikes, MostFavoriteQuestion)
}

df_table_1 <- function(){
  tmp <- Posts_dt[PostTypeId == 1, ]
  tmp_1_1 <- tmp[, sum(FavoriteCount, na.rm = TRUE), by = OwnerUserId]
  setnames(tmp_1_1, "V1", "FavoriteTotal")
  tmp_1_2 <- tmp[, max(FavoriteCount, na.rm = TRUE), by = OwnerUserId]
  setnames(tmp_1_2, "V1", "MostFavoriteQuestionLikes")
  
  x <- tmp[, .(Title, OwnerUserId, FavoriteCount)]
  
  setkeyv(x, c("OwnerUserId",  "FavoriteCount"))
  setkeyv(tmp_1_2, c("OwnerUserId", "MostFavoriteQuestionLikes"))
  
  tmp_1_3 <- x[tmp_1_2]
  setnames(tmp_1_3, c("Title", "FavoriteCount"), c("MostFavoriteQuestion", "MostFavoriteQuestionLikes"))
  
  
  Result <- tmp_1_1[tmp_1_3, on = "OwnerUserId"]
  
  Users1 = Users_dt[, .(DisplayName, Age, Location, Id)]
  
  setkey(Result, OwnerUserId)
  setkey(Users1, Id)
  
  Result <- Result[Users1][, .(DisplayName, Age, Location, FavoriteTotal, MostFavoriteQuestion, MostFavoriteQuestionLikes)][order(-FavoriteTotal)][1:10, ]
  
}
x <-capture.output(microbenchmark(sqldf = df_sql_1(),base = df_base_1(),
                                  dplyr = df_dplyr_1(),data.table = df_table_1()))
cat(x, sep = "\n")
beepr::beep(4)
saveRDS(x, file = "bench_1.rds")
y1 <- readRDS(file = "bench_1.rds")
cat(y1, sep = "\n")
## Zadanie 2

df_sql_2 <- function(){
 sqldf("SELECT
        Posts.ID,
        Posts.Title,
        Posts2.PositiveAnswerCount
        FROM Posts
        JOIN (
        SELECT
        Posts.ParentID,
        COUNT(*) AS PositiveAnswerCount
        FROM Posts
        WHERE Posts.PostTypeID=2 AND Posts.Score>0
        GROUP BY Posts.ParentID
        ) 
        AS Posts2
        ON Posts.ID=Posts2.ParentID
        ORDER BY Posts2.PositiveAnswerCount DESC
        LIMIT 10")
}

df_base_2 <- function(){
  Posts2 <- as.data.frame(table("ParentId" = Posts[Posts$PostTypeId == 2 & Posts$Score > 0, "ParentId"]), stringsAsFactors = FALSE, responseName = "PositiveAnswerCount")
  df_2 <- as.data.frame(cbind(Posts[, "Id"], Posts[, "Title"]), stringsAsFactors = FALSE)
  colnames(df_2) <- c("Id", "Title")
  
  Result <- as.data.frame(merge(df_2,Posts2, by.x = "Id", by.y = "ParentId", all.x = TRUE, all.y = FALSE ))
  sort_permutation_2 <- order(Result$PositiveAnswerCount, decreasing = TRUE)
  Result <- Result[sort_permutation_2, ]
  Result <- Result[1:10, ]
  rownames(Result) <- NULL
  Result$Id <- as.integer(Result$Id)
  return(Result)
}

dplyr::all_equal(df_base_2(), df_sql_2(), convert = TRUE)


df_dplyr_2 <- function(){
  Posts2 <- Posts %>% 
    filter(PostTypeId == 2, Score > 0) %>%
    group_by(ParentId) %>%
    summarise(PositiveAnswerCount = n())
  
  Posts1 <- Posts %>% 
    select(c(Id, Title))
  
  Result <- inner_join(Posts1, Posts2, by = c("Id" = "ParentId")) %>%
    arrange(desc(PositiveAnswerCount)) %>% slice(1:10)
}

df_table_2 <- function(){
  
  Posts2 <- Posts_dt[PostTypeId == 2 & Score > 0, .(ParentId, PostTypeId, Score)][, .N, by = ParentId]
  setnames(Posts2, "N", "PositiveAnswerCount")
  setkey(Posts_dt, Id)
  setkey(Posts2, ParentId)
  Result <- Posts_dt[Posts2][,.(Id, Title, PositiveAnswerCount)][order(-PositiveAnswerCount)][1:10]
}
x <-capture.output(microbenchmark(sqldf = df_sql_2(),base = df_base_2(),
                                  dplyr = df_dplyr_2(),data.table = df_table_2()))
cat(x, sep = "\n")
beepr::beep(4)
saveRDS(x, file = "bench_2.rds")
y2 <- readRDS(file = "bench_2.rds")
cat(y2, sep = "\n")
## Zadanie 3
df_sql_3 <- function()return(
  sqldf("SELECT
        Posts.Title,
        UpVotesPerYear.Year,
        MAX(UpVotesPerYear.Count) AS Count
        FROM (
        SELECT
        PostId,
        COUNT(*) AS Count,
        STRFTIME('%Y', Votes.CreationDate) AS Year
        FROM Votes
        WHERE VoteTypeId=2
        GROUP BY PostId, Year
        ) AS UpVotesPerYear
        JOIN Posts ON Posts.Id=UpVotesPerYear.PostId
        WHERE Posts.PostTypeId=1
        GROUP BY Year")
)

df_base_3 <- function(){
  tmp_3_1 <- Votes[Votes$VoteTypeId == 2, c("PostId", "CreationDate")]
  tmp_3_1[, "CreationDate"] <- as.Date(tmp_3_1$CreationDate, format='%Y-%m-%d')
  tmp_3_1[,"CreationDate"] <- as.numeric(format(tmp_3_1$CreationDate, '%Y'))
  colnames(tmp_3_1)[2] <- "Year"
  UpVotesPerYear <- as.data.frame(table(tmp_3_1), responseName = "Count", stringsAsFactors = FALSE)
  
  tmp_3_2 <- merge(Posts, UpVotesPerYear, by.x = "Id", by.y = "PostId")
  tmp_3_3 <- tmp_3_2[tmp_3_2$PostTypeId == 1, ]
  tmp_3_3 <- tmp_3_3[, c("Title", "Year", "Count")]
  tmp_3_4 <- aggregate(tmp_3_3["Count"], by = tmp_3_3["Year"], FUN = max)
  Result <- merge(tmp_3_3, tmp_3_4, by.x = "Count", by.y = "Count")
  Result <- Result[Result$Year.x == Result$Year.y,]
  Result <- Result[, c("Title", "Year.x", "Count")]
  colnames(Result)[2] <- "Year"
  Result <- Result[order(Result$Year), ]
  rownames(Result) <- NULL
  return(Result)
}
df_dplyr_3 <- function(){
  UpVotesPerYear <- Votes %>%
    select(c(PostId, CreationDate, VoteTypeId)) %>% 
    filter(VoteTypeId == 2) %>%
    mutate(Year = substring(CreationDate, 1, 4)) %>%
    select(c(PostId, Year)) %>%
    group_by(PostId, Year) %>%
    summarise(Count = n())
  
  tmp_3_1 <- inner_join(Posts, UpVotesPerYear, by = c("Id" = "PostId")) %>%
    filter(PostTypeId == 1) %>%
    group_by(Year) %>%
    select(Title, Year, Count)
  
  tmp_3_2 <- tmp_3_1 %>%
    summarise(Count = max(Count))
  
  Result <- inner_join(tmp_3_1, tmp_3_2, by = c("Count", "Year"))
}
df_table_3 <- function(){
  UpVotesPerYear <- Votes_dt[ VoteTypeId == 2, .(PostId, CreationDate)]
  Year <-  substring(UpVotesPerYear$CreationDate, 1, 4)
  UpVotesPerYear <- cbind(UpVotesPerYear, Year)
  UpVotesPerYear <- UpVotesPerYear[, .N, by = c("PostId","Year")]
  setnames(UpVotesPerYear, "N", "Count")
  
  setkey(UpVotesPerYear, PostId)
  setkey(Posts_dt, Id)
  
  tmp_3_1 <- Posts_dt[UpVotesPerYear][PostTypeId == 1,]
  tmp_3_2 <- tmp_3_1[, max(Count), by = Year]
  tmp_3_3 <- tmp_3_1[, .(Count, Title, Year)]
  
  setkey(tmp_3_3, Count)
  setkey(tmp_3_2, V1)
  
  Result <- tmp_3_3[tmp_3_2]
  Result <- Result[Year == i.Year, .(Title, Year, Count)]
  Result <- Result[order(Year)]
}
cat(x, sep = "\n")
beepr::beep(4)
saveRDS(x, file = "bench_3.rds")
y3 <- readRDS(file = "bench_3.rds")
cat(y3, sep = "\n")## Zadanie 4

df_sql_4 <- function() return(
  sqldf("SELECT
        Questions.Id,
        Questions.Title,
        BestAnswers.MaxScore,
        Posts.Score AS AcceptedScore,
        BestAnswers.MaxScore-Posts.Score AS Difference
        FROM (
        SELECT Id, ParentId, MAX(Score) AS MaxScore
        FROM Posts
        WHERE PostTypeId==2
        GROUP BY ParentId
        ) AS BestAnswers
        JOIN (
        SELECT * FROM Posts
        WHERE PostTypeId==1
        ) AS Questions
        ON Questions.Id=BestAnswers.ParentId
        JOIN Posts ON Questions.AcceptedAnswerId=Posts.Id
        WHERE Difference>50
        ORDER BY Difference DESC")
)

df_base_4 <- function(){
  BestAnswers <- Posts[Posts$PostTypeId == 2, ]
  BestAnswers <- BestAnswers[order(BestAnswers$ParentId, decreasing = TRUE),]
  BestAnswers <- BestAnswers[order(BestAnswers$Score, decreasing = TRUE), ]
  BestAnswers_1 <- aggregate(BestAnswers["Id"], by = BestAnswers["ParentId"], function(x){x[1]})
  BestAnswers_2 <- aggregate(BestAnswers["Score"], by = BestAnswers["ParentId"], function(x) max(x, na.rm = TRUE))
  colnames(BestAnswers_2)[2] <- "MaxScore"
  BestAnswers <- cbind(BestAnswers_1[2], BestAnswers_2)
  
  Questions <- Posts[Posts$PostTypeId == 1, ]
  tmp_4 <- merge(Questions[, c("Id", "Title", "AcceptedAnswerId")], BestAnswers, by.x = "Id", by.y = "ParentId")
  ######## komunikaty ostrzegawcze !!!!!!!!!!!!
  Result <- merge(tmp_4, Posts[, c("Score", "Id")], by.x = "AcceptedAnswerId", by.y = "Id")
  Difference <- Result$MaxScore - Result$Score
  Result <- cbind(Result, "Difference" = Difference)
  Result <- Result[Difference > 50, c("Id", "Title", "MaxScore", "Score", "Difference")]  
  sort_permutation_4 <- order(Result$Difference, decreasing = TRUE)  
  Result <- Result[sort_permutation_4,  ]
  colnames(Result)[4] <- "AcceptedScore"
  rownames(Result) <- NULL
  return(Result)
}
df_dplyr_4 <- function(){
  BestAnswers <- Posts %>%
    select(Id, ParentId, Score, PostTypeId) %>%
    filter(PostTypeId == 2) %>%
    group_by(ParentId) %>%
    summarise(MaxScore = max(Score))
  
  Questions <- Posts %>%
    filter(PostTypeId == 1) %>%
    select(Id, Title, AcceptedAnswerId)
  
  tmp_4_1 <- inner_join(Questions, BestAnswers, by = c("Id" = "ParentId")) %>% 
    select(c(Id, Title, MaxScore, AcceptedAnswerId))
  
  Post <- Posts %>%
    select(c(Score, Id))
  
  Result <- inner_join(tmp_4_1, Post, by = c("AcceptedAnswerId" = "Id")) %>%
    mutate(Difference = MaxScore - Score) %>% 
    filter(Difference > 50) %>%
    arrange(desc(Difference)) %>%
    select(Id, Title, MaxScore, AcceptedScore = Score, Difference)
}
df_table_4 <- function(){
  BestAnswers <- Posts_dt[PostTypeId == 2, .(Id, ParentId, Score), by = ParentId][order(-ParentId)][order(-Score)]
  BestAnswers_1 <- BestAnswers[, Id[1], by = .(ParentId)]
  setnames(BestAnswers_1, "V1", "Id")
  BestAnswers_2 <- BestAnswers[, max(Score), by = .(ParentId)]
  setnames(BestAnswers_2, "V1", "MaxScore")
  
  BestAnswers <- cbind(BestAnswers_1, BestAnswers_2)
  BestAnswers <- BestAnswers[, 2:4]
  
  Questions <- Posts_dt[PostTypeId == 1, .(Id, Title, AcceptedAnswerId)]
  
  setkey(Questions, Id)
  setkey(BestAnswers, ParentId)
  
  tmp_4_1 <- BestAnswers[Questions]
  tmp_4_2 <- Posts_dt[, .(Id, Score)]
  setkey(tmp_4_2, Id)
  setkey(tmp_4_1, AcceptedAnswerId)
  
  tmp_4_3 <- tmp_4_2[tmp_4_1]
  Difference <- tmp_4_3[, .(MaxScore)] - tmp_4_3[, .(Score)]
  setnames(Difference, "MaxScore", "Difference")
  
  Result <- cbind(tmp_4_3, Difference)
  setnames(Result, c("Score", "ParentId"), c("AcceptedScore", "Id"))
  Result <- Result[, -c(1, 3)][Difference > 50, ][order(-Difference)]
}
cat(x, sep = "\n")
beepr::beep(4)
saveRDS(x, file = "bench_4_.rds")
y4<- readRDS(file = "bench_4.rds")
cat(y4, sep = "\n")
## Zadanie 5
df_sql_5 <- function() return(
  sqldf("SELECT
        Posts.Title,
        CmtTotScr.CommentsTotalScore
        FROM (
        SELECT
        PostID,
        UserID,
        SUM(Score) AS CommentsTotalScore
        FROM Comments
        GROUP BY PostID, UserID
        ) AS CmtTotScr
        JOIN Posts ON Posts.ID=CmtTotScr.PostID AND Posts.OwnerUserId=CmtTotScr.UserID
        WHERE Posts.PostTypeId=1
        ORDER BY CmtTotScr.CommentsTotalScore DESC
        LIMIT 10")
)

df_base_5 <- function(){
  CmtTotScr <- Comments[c("Score","PostId", "UserId")]
  CmtTotScr <- aggregate(CmtTotScr["Score"], by = CmtTotScr[c("PostId", "UserId")], sum, na.rm = TRUE)
  colnames(CmtTotScr)[3] <- "CommentsTotalScore"
  
  df_5 <- as.data.frame(cbind(Id = Posts[ ,"Id"], OwnerUserId = Posts[, "OwnerUserId"],PostTypeId = Posts[, "PostTypeId"], Title = Posts[, "Title"]), stringsAsFactors = FALSE)
  
  Result <- merge(df_5, CmtTotScr, by.x = "Id", by.y = "PostId")
  Result <- Result[Result$OwnerUserId == Result$UserId & Result$PostTypeId == 1, ]
  sort_permutation_5 <- order(Result$CommentsTotalScore, decreasing = TRUE)
  Result <- Result[sort_permutation_5, c("Title", "CommentsTotalScore")]
  rownames(Result) <- NULL
  Result <- Result[1:10, ]
  return(Result)
}
df_dplyr_5 <- function(){
  CmtTotScr <- Comments %>%
    select(c(Score, PostId, UserId)) %>%
    group_by(PostId, UserId) %>%
    summarise(CommentsTotalScore = sum(Score))
  
  Post <- Posts %>% 
    select(c(Id, Title, OwnerUserId, PostTypeId))
  
  Result <- inner_join(CmtTotScr, Post, by = c("PostId" = "Id", "UserId" = "OwnerUserId")) %>%
    filter(PostTypeId == 1) %>% arrange(desc(CommentsTotalScore)) %>%
    ungroup() %>%
    select(c("Title", "CommentsTotalScore")) %>% slice(1:10)
  # ungroup bo Adding missing grouping variables: `PostId`
}
df_table_5 <- function(){
  CmtTotScr <- Comments_dt[, .(PostId, UserId, Score)]
  CmtTotScr <- CmtTotScr[, sum(Score), by = list(PostId, UserId)]
  setnames(CmtTotScr, "V1", "CommentsTotalScore")
  setkeyv(Posts_dt, c("Id","OwnerUserId"))
  setkeyv(CmtTotScr, c("PostId", "UserId"))
  Result <- Posts_dt[CmtTotScr][PostTypeId == 1, c("Title", "CommentsTotalScore")][order(-CommentsTotalScore)][1:10]
}
cat(x, sep = "\n")
beepr::beep(4)
saveRDS(x, file = "bench_5.rds")
y5 <- readRDS(file = "bench_5.rds")
cat(y5, sep = "\n")

## Zadanie 6
df_sql_6 <- function() return(
  sqldf("SELECT DISTINCT
        Users.Id,
        Users.DisplayName,
        Users.Reputation,
        Users.Age,
        Users.Location
        FROM (
        SELECT
        Name, UserID
        FROM Badges
        WHERE Name IN (
        SELECT
        Name
        FROM Badges
        WHERE Class=1
        GROUP BY Name
        HAVING COUNT(*) BETWEEN 2 AND 10
        )
        AND Class=1
        ) AS ValuableBadges
        JOIN Users ON ValuableBadges.UserId=Users.Id")
  
)



df_base_6 <- function(){
  tmp_6_1 <- as.data.frame(table("Name" = Badges[Badges$Class == 1, "Name"]), stringsAsFactors = FALSE, responseName = "howmany")
  tmp_6_1 <- tmp_6_1[tmp_6_1$howmany >= 2 & tmp_6_1$howmany <= 10, "Name"]
  ValuableBadges <- Badges[Badges$Name %in% tmp_6_1 & Badges$Class == 1, c("Name", "UserId")]
  Result <- merge(Users, ValuableBadges, by.x = "Id", by.y = "UserId")
  Result <- unique(Result[c("Id", "DisplayName", "Reputation", "Age", "Location")])
  rownames(Result) <- NULL
  return(Result)
}
df_dplyr_6 <- function(){
  tmp_6_1 <- Badges %>% 
    select(c(Name, Class)) %>%
    filter(Class == 1) %>%
    group_by(Name) %>%
    summarise(Count = n()) %>%
    filter(Count >= 2 & Count <= 10)  %>%
    select("Name")
  
  ValuableBadges <- Badges %>%
    select(c(Name, UserId, Class)) %>%
    filter(Name %in% pull(tmp_6_1, Name) & Class == 1)
  
  Result <- inner_join(Users, ValuableBadges, by = c("Id" = "UserId")) %>% 
    distinct(Id, DisplayName, Reputation, Age, Location)
}
df_table_6 <- function(){
  tmp_6_1 <- Badges_dt[Class == 1, .(Name)][, .N, by = Name][N >= 2 & N <= 10, .(Name)] # nazwy z ktorych będziemy wybierać
  
  ValuableBadges <- Badges_dt[Name %in% pull(tmp_6_1, Name) & Class == 1, .(Name, UserId)]
  
  setkey(ValuableBadges, UserId)
  setkey(Users_dt, Id)
  
  Result <- Users_dt[ValuableBadges]
  Result <- unique(Result[, .(Id, DisplayName, Reputation, Age, Location)])
}
cat(x, sep = "\n")
beepr::beep(4)
saveRDS(x, file = "bench_6.rds")
y6 <- readRDS(file = "bench_6.rds")
cat(y6, sep = "\n")

## Zadanie 7
df_sql_7 <- function() return(
  sqldf("SELECT
        Posts.Title,
        VotesByAge2.OldVotes
        FROM Posts
        JOIN (
        SELECT
        PostId,
        MAX(CASE WHEN VoteDate = 'new' THEN Total ELSE 0 END) NewVotes,
        MAX(CASE WHEN VoteDate = 'old' THEN Total ELSE 0 END) OldVotes,
        SUM(Total) AS Votes
        FROM (
        SELECT
        PostId,
        CASE STRFTIME('%Y', CreationDate)
        WHEN '2017' THEN 'new'
        WHEN '2016' THEN 'new'
        ELSE 'old'
        END VoteDate,
        COUNT(*) AS Total
        FROM Votes
        WHERE VoteTypeId=2
        GROUP BY PostId, VoteDate
        ) AS VotesByAge
        GROUP BY VotesByAge.PostId
        HAVING NewVotes=0
        ) AS VotesByAge2 ON VotesByAge2.PostId=Posts.ID
        WHERE Posts.PostTypeId=1
        ORDER BY VotesByAge2.OldVotes DESC
        LIMIT 10"))



df_base_7 <- function(){
  tmp_7_1 <- Votes[Votes["VoteTypeId"] == 2, c("PostId", "CreationDate")]
  tmp_7_1[, "CreationDate"] <- as.Date(tmp_7_1$CreationDate, format='%Y-%m-%d')
  tmp_7_1[,"CreationDate"] <- as.numeric(format(tmp_7_1$CreationDate, '%Y'))
  
  x <- ifelse(tmp_7_1["CreationDate"] == 2017 | tmp_7_1["CreationDate"] == 2016, "new", "old")
  
  tmp_7_2 <- cbind(tmp_7_1, x) # KOLEJNOSC w X identyczna jak w .... wiec spokojnie mozna zrobic cbind
  tmp_7_2 <- tmp_7_2[, -2]
  
  VotesByAge <- as.data.frame(table("PostId" = tmp_7_2[c("CreationDate", "PostId")]), stringsAsFactors = FALSE, responseName = "Total")
  colnames(VotesByAge)[1] <- c("VoteDate") # table ładnie zlicza, bo dla niewystępujących daje old
  rownames(VotesByAge) <- NULL
  
  VotesByAge2_1 <- VotesByAge[VotesByAge$VoteDate == "old", ]
  colnames(VotesByAge2_1)[3] <- "OldVotes"
  VotesByAge2_2 <- VotesByAge[VotesByAge$VoteDate == "new", ]
  colnames(VotesByAge2_2)[3] <- "NewVotes"
  VotesByAge2 <- merge(VotesByAge2_1, VotesByAge2_2, by = "PostId")
  VotesByAge2 <- VotesByAge2[VotesByAge2$NewVotes == 0, ]
  
  Result <- merge(Posts, VotesByAge2, by.x = "Id", by.y = "PostId" )
  Result <- Result[Result$PostTypeId == 1, c("Title", "OldVotes")]
  sort_permutation_7 <- order(Result$OldVotes, decreasing = TRUE)
  Result <- Result[sort_permutation_7, ]
  Result <- Result[1:10, ]
  rownames(Result) <- NULL
  return(Result)
}
df_dplyr_7 <- function(){
  VotesByAge <- Votes %>% 
    select(PostId, CreationDate, VoteTypeId) %>%
    filter(VoteTypeId == 2) %>% 
    mutate(Year = substring(CreationDate, 1, 4)) %>%
    mutate(VoteDate = if_else(Year == 2017 | Year == 2016, "new", "old")) %>%
    group_by(PostId, VoteDate) %>%
    summarise(Total = n())
  
  NewVotes <- ifelse(VotesByAge %>%
                       pull(VoteDate) == "new", pull(VotesByAge, Total), 0)
  OldVotes <- ifelse(pull(VotesByAge, VoteDate) == "old", pull(VotesByAge, Total), 0)
  
  VotesByAge2 <- cbind(VotesByAge[, -2], NewVotes = NewVotes, OldVotes = OldVotes) %>%
    group_by(PostId) %>% 
    summarise(Votes = sum(Total), NewVotes = max(NewVotes), OldVotes = max(OldVotes)) %>%
    filter(NewVotes == 0)
  
  
  Result <- inner_join(Posts, VotesByAge2, by = c("Id" = "PostId")) %>%
    filter(PostTypeId == 1) %>%
    arrange(desc(OldVotes)) %>%
    select(Title, OldVotes) %>%
    slice(1:10)
}
df_table_7 <- function(){
  VotesByAge <- Votes_dt[VoteTypeId == 2, .(Id, PostId, CreationDate  = substring(CreationDate, 1, 4))][
    ,.(CreationDate = ifelse(CreationDate == 2017 | CreationDate == 2016, "new", "old"), Id, PostId)][
      , .N, by = .(PostId, CreationDate)][,.(NewVotes = ifelse(CreationDate == "new", N, 0), OldVotes = ifelse(CreationDate == "old", N, 0), PostId, Total = N)][
        ,.(Votes = sum(Total), NewVotes = max(NewVotes), OldVotes = max(OldVotes)), by = PostId][NewVotes == 0]
  
  tmp_7_1 <- Posts_dt[PostTypeId == 1, .(Id, Title, PostTypeId)]
  
  setkey(tmp_7_1, Id)
  setkey(VotesByAge, PostId)
  
  Result <- tmp_7_1[VotesByAge, nomatch = 0][, .(Title, OldVotes)][order(-OldVotes)][1:10]
}
x <-capture.output(microbenchmark(sqldf = df_sql_7(),base = df_base_7(),
                                  dplyr = df_dplyr_7(),data.table = df_table_7()))
cat(x, sep = "\n")
beepr::beep(4)
saveRDS(x, file = "bench_7.rds")
y7 <- readRDS(file = "bench_7.rds")
cat(y7, sep = "\n")
