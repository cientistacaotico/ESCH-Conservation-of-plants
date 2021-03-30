# Organizing folders ------------------------------------------------------

# Perform the following code to create folders used here

<<<<<<< HEAD
dir.create("./results/clean")

# Data cleaning process ---------------------------------------------------

load("./results/raw/occ_data.Rdata")

# checking names

check_names <- get.taxa(taxa = occ_data[,1])

for (i in 1:nrow(occ_data)) {
  names <- get.taxa(taxa = occ_data[i,1])
  if (i == 1) {
    check_names <- names
  } else {
    check_names <- rbind(check_names, names)
  }
  print(i)
}

save(check_names, file = "./results/clean/occ_data.Rdata")
=======
dir.create("./result")
dir.create("./result/clean")

>>>>>>> 49c999dfcdb5c16e5957f93250e5fce6f89ef421
