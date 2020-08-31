pliki <- list.files("/home/elzbieta/pdu_R/PD2/pd2-zbiory-benchmarkowe","data(\\.gz|)$", recursive=TRUE) 
# czyta zarowno pliki z rozszerzeniem .data.gz jak i .gz  
labels <- list.files("/home/elzbieta/pdu_R/PD2/pd2-zbiory-benchmarkowe","labels0(\\.gz|)$", recursive=TRUE)

# GENEROWANIE WARTOŚCI DO PLIKU CSV
names <- rep(0, length.out = length(pliki))

for(i in 1:length(pliki)){ 
  dane <- paste("/home/elzbieta/pdu_R/PD2/pd2-zbiory-benchmarkowe", pliki[i],sep="/")
  x <- read.table(dane)
  label <- paste("/home/elzbieta/pdu_R/PD2/pd2-zbiory-benchmarkowe",labels[i],sep="/")
  label <- read.table(label)
  label <- as.matrix(label)
  names[i] <- strsplit(pliki[i], ".data.gz")
  n <- length(x[[1]])
  parameters <- 1:20
  #parameters <- seq(1, n-1, length.out = 20)
  #parameters <- floor(parameters)
  AdjustedRandIndex <- 0
  FMIndex <- 0
  for (j in parameters) {
    
    result <- spectral_clustering(scale(x),length(unique(label)), j)
    
    value1 <- mclust::adjustedRandIndex(label,result)
    AdjustedRandIndex <- AdjustedRandIndex + value1
    
    value2 <- dendextend::FM_index(label, result)[1]
    FMIndex <- FMIndex + value2
  }
  spectral_d <- FMIndex/20
  spectral_m <- AdjustedRandIndex/20


  # WYNIK ALGORYTMU GENIE
  result <- cutree(genie::hclust2(dist(scale(x))), length(unique(label)))
  genie_m <- mclust::adjustedRandIndex(result, label)
  genie_d <- dendextend::FM_index(result, label)[1]
  
  # WYNIK ALGORYTMU AGNES
  result <- cutree(cluster::agnes(dist(scale(x))), length(unique(label)))
  agnes_m <- mclust::adjustedRandIndex(result, label)
  agnes_d <- dendextend::FM_index(result, label)[1] 
  
  # WYNIK HCLUST
  result <- cutree(stats::hclust(dist(scale(x)), method = "single"), length(unique(label)))
  single_m <- mclust::adjustedRandIndex(result, label)
  single_d <- dendextend::FM_index(result, label)[1] 
  
  result <- cutree(stats::hclust(dist(scale(x)), method = "complete"), length(unique(label)))
  complete_m <- mclust::adjustedRandIndex(result, label)
  complete_d <- dendextend::FM_index(result, label)[1] 
  
  result <- cutree(stats::hclust(dist(scale(x)), method = "average"), length(unique(label)))
  average_m <- mclust::adjustedRandIndex(result, label)
  average_d <- dendextend::FM_index(result, label)[1] 
  
  result <- cutree(stats::hclust(dist(scale(x)), method = "mcquitty"), length(unique(label)))
  mcquitty_m <- mclust::adjustedRandIndex(result, label)
  mcquitty_d <- dendextend::FM_index(result, label)[1]
  
  result <- cutree(stats::hclust(dist(scale(x)), method = "ward.D"), length(unique(label)))
  wardD_m <- mclust::adjustedRandIndex(result, label)
  wardD_d <- dendextend::FM_index(result, label)[1]
  
  result <- cutree(stats::hclust(dist(scale(x)), method = "ward.D2"), length(unique(label)))
  wardD2_m <- mclust::adjustedRandIndex(result, label)
  wardD2_d <- dendextend::FM_index(result, label)[1] 
  
  result <- cutree(stats::hclust(dist(scale(x)), method = "centroid"), length(unique(label)))
  centroid_m <- mclust::adjustedRandIndex(result, label)
  centroid_d <- dendextend::FM_index(result, label)[1] 
  
  result <- cutree(stats::hclust(dist(scale(x)), method = "median"), length(unique(label)))
  median_m <- mclust::adjustedRandIndex(result, label)
  median_d <- dendextend::FM_index(result, label)[1] 
  
  
  write.table(cbind(spectral_d, spectral_m, genie_d, genie_m, agnes_d, agnes_m, single_d, single_m, complete_d, complete_m, 
                    average_d, average_m, mcquitty_d, mcquitty_m, wardD_d, wardD_m, wardD2_d, wardD2_m, centroid_d, centroid_m, 
                    median_d, median_m), file = paste(names[[i]], ".csv"), quote = FALSE, sep = "\t", append = TRUE, row.names = FALSE)
}