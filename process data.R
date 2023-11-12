# Fichier de récuperation et transformations des données

#### Load des dataframes ##### 

df_HDI <- read.csv(file = "datasets/human-development-index.csv")
df_energy <- read.csv(file = "datasets/global-data-sustainable-energy.csv")
df_cc <- read.csv(file = "datasets/countryContinent.csv")

# print(View(df_HDI))
# print(View(df_energy))
# print(View(df_cc))


#### Choix des colonnes et simplification des noms ####

drop_variables <- c("Access.to.clean.fuels.for.cooking","Latitude","Longitude",
                    "Energy.intensity.level.of.primary.energy.(MJ/$2017.PPP.GDP)",
                    "Financial.flows.to.developing.countries..US...",
                    "Renewable.energy.share.in.the.total.final.energy.consumption....",
                    "Density.n.P.Km2.","Land.Area.Km2.")

df_energy <- df_energy[,-which(names(df_energy) %in% drop_variables)]

modif_names <- c("Country","Year","Access to Electricity","Renewable Electricity Capacity per Capita",
                 "Electricity from Fossil Fuels","Electricity from Nuclear",
                 "Electricity from Renewables","Low-Carbon Electricity",
                 "Primary Energy Consumption per Capita","CO2 Emissions",
                 "Renewables (% Equivalent Primary Energy)","GDP Growth","GDP per Capita",
                 "Population Density")

names(df_energy) <- modif_names

##### Merge des dataframes #####

# Choix des variables

# Dans dd_cc on ne veut que les variables "country", "continent" et "sub_region"
df_cc <- df_cc[c("country", "continent", "sub_region", "code_2")]
names (df_cc) <- c("Country", "Continent", "Region", "ISO2")

print(names(df_HDI))
# Dans dd_HDI on ne veut que les variables "Entity", "Year" et "Human Development Index"
df_HDI <- df_HDI[c("Entity", "Year", "Human.Development.Index")]

names(df_HDI) <- c("Country","Year","HDI")


# modification de certains noms de pays pour 3 data frame correspondent

nom_incorect <- c("United States of America","United Kingdom of Great Britain and Northern Ireland",
                  "Macedonia (the former Yugoslav Republic of)","Czech Republic","Swaziland")

nom_modif <- c("United States","United Kingdom","North Macedonia","Czechia","Eswatini")

for (i in 1:length(nom_incorect)) {
  df_cc$Country <- replace(df_cc$Country, df_cc$Country == nom_incorect[i], nom_modif[i])
}

# Merge des dataframes


temp <- merge(df_energy, df_cc, by = "Country", all.x = TRUE)

df_energy <- merge(temp, df_HDI, by = c("Country", "Year"), all.x = TRUE)

write.csv(df_energy, file = "datasets/energy-cleaned-dataset.csv", row.names = FALSE)
