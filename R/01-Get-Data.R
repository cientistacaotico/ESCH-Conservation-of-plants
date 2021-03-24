# Load species' name data -------------------------------------------------

# http://ipt.jbrj.gov.br/jbrj/archive.do?r=lista_especies_flora_brasil

florabr <- read.csv("./Data/flora_do_brasil.csv", header = TRUE, sep = ";")
florabr <- florabr[1:nrow(florabr), 1]

# GBIF --------------------------------------------------------------------

# When reproducing this code may result in additional records

no_coordinates <- matrix(nrow = length(florabr), ncol = 1)

for (i in 1:length(florabr)) {
  data <- rgbif2(species = florabr[i], save = FALSE, limit = 99500)
  if(nrow(data) == 0){
    no_coordinates[i,1] <- florabr[i]
    no_coordinates <- na.omit(as.data.frame(no_coordinates))
    write.table(x = no_coordinates, file = "./results/raw/gbif/no_coordinates.txt", col.names = "species", row.names = FALSE)
  }
  if(nrow(data) !=  0){
    data <- data[,c("species_search","decimalLongitude","decimalLatitude")]
    if(i == 1){
      gbif <- data
    } else{
      gbif <- rbind(gbif,data)
    }
  }
  print(i)
}

write.csv(gbif, file = "./results/raw/gbif/gbif.csv", row.names = FALSE)

# SpeciesLink -------------------------------------------------------------

splink <- rspeciesLink(dir = "results/",species = florabr[1], filename = "splink")


