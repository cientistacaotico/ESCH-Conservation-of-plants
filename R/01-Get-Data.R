# Load species' name data -------------------------------------------------

# http://ipt.jbrj.gov.br/jbrj/archive.do?r=lista_especies_flora_brasil

florabr <- read.csv("./Data/flora_do_brasil.csv", header = TRUE, sep = ";")
florabr <- florabr[1:nrow(florabr), 1]

# Organizing folders ------------------------------------------------------

# Perform the following code to create folders used here

dir.create("./results")
dir.create("./results/raw")
dir.create("./results/raw/gbif")
dir.create("./results/raw/splink")

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
      gbif <- rbind(gbif, data)
    }
  }
  print(i)
}

write.csv(gbif, file = "./results/raw/gbif/gbif.csv", row.names = FALSE)

# SpeciesLink -------------------------------------------------------------

# When reproducing this code may result in additional records

no_coordinates <- matrix(nrow = length(florabr), ncol = 1)

for (i in 1:length(florabr)) {
  data <- rspeciesLink(species = florabr[i], save = FALSE, Coordinates = "Yes", MaxRecords = 99500, Synonyms = "flora2020")
  if(class(data) == "list"){
    no_coordinates[i,1] <- florabr[i]
    no_coordinates <- na.omit(as.data.frame(no_coordinates))
    write.table(x = no_coordinates, file = "./results/raw/splink/no_coordinates.txt", col.names = "species", row.names = FALSE)
  }
  if(class(data) ==  "data.frame"){
    data <- data[,c("scientificName","decimalLongitude","decimalLatitude")]
    if(i == 1){
      splink <- data
    } else{
      splink <- rbind(splink, data)
    }
  }
  print(i)
}

splink <- bind_cols(splink[,1], as.numeric(splink[,2]), as.numeric(splink[,3]))
colnames(splink) <- colnames(gbif)

write.csv(splink, file = "./results/raw/splink/splink.csv", row.names = FALSE)

# Combining both datasets -------------------------------------------------

occ_data <- bind_rows(gbif, splink)

write.csv(occ_data, file = "./results/raw/occ_data.csv", row.names = FALSE)

save(occ_data, file = "./results/raw/occ_data.Rdata")

rm(gbif, splink, data, no_coordinates, occ_data)
