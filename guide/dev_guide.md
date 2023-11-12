# <center>Developer Guide :</center> 

The purpose is to allows you to understand the architecture of the code and modify or extend it.

--- 

## Project structure : 
### Mermaid magic: 
```mermaid
graph TB

%% Directories
mainR(serveur.R)
ui(ui.R)
dataset(Dataset) -->|Data files| datasetFiles
guide(Guide) -->|Documentation| guideFiles

%% Files
mainpy(Main.py)
.gitignore(.gitignore)
LICENSE(LICENSE)
README(README.md)
requirement(requirement.txt)

subgraph datasetFiles[Data Files]
    data1[global-data-sustainable-energy.csv]
    data2[countryContinent.csv]
    data3[human-development-index.csv]
   
end

subgraph guideFiles[Documentation]
    doc1[User Guide]
    doc2[Developer Guide]
    doc3[Rapport]
end
```


### Multi-pages :
This multi-pages repository is set like the [official documentation](https://shiny.posit.co/r/gallery/application-layout/navbar-example/) guidelines.

Here were going through each folder and give a little detail of what is it.
- The dataset folder contain each dataset csv and the ipython notebook associated to the data cleaning and aggregation.
- The guide folder contain some markdown files
- The **serveur.R** is the entry point of the project. It is the luncher of the Shiny app.
- The `.gitignore` is the file which indicate the file and folder to do not commit and push on the git repo (set by GitHub and modify by us)
- The `README.md` fie is the landing page on GitHub. contain a brief description of the project.
- The `requirement.txt` is the list of all necessary dependency with the version.
- The `.Rhsitory`, `.Rproj` et `.Rdata` are needed file (init by RStudio)


```mermaid
---
title: Shiny app Flow chart
---
flowchart TD
subgraph "Run the App"
  main{{serveur.R}} x---x ui.R{{ui.R}}
  ui.R{{ui.R}} x---x main{{serveur.R}}
  ui.R{{ui.R}} -- plots ---> barchart[/barchart/]
  ui.R{{ui.R}} -- plots ---> histo[/histo/]
  ui.R{{ui.R}} -- plots ---> scatter[/scatter/]
  ui.R{{ui.R}} -- plots ---> line[/line/]
  ui.R{{ui.R}} -- plots ---> pie[/pie/]
  
  ui.R{{ui.R}} -- display --> readme.md
  ui.R{{ui.R}} -- display --> userguide.md
  
  ui.R{{ui.R}} -.query .-> df_energy_cleaned

end


subgraph "Build our dataset"
  process_data{{process data.R}} -- "read" --> db[(.csv)]
  db[(.csv)] -- "process + clean + merge" -->  dataframes
  dataframes -- create ---> df_energy_cleaned.csv
end
```

