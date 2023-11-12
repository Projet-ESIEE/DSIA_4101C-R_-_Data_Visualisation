# <center>Rapport app Shiny</center>

Ce fichier contient un détail de nos observations et conclusions sur nos données. 

#### Pour faire première analyse :
Nous nous intéressons particulièrement ici à la production d'électricité par continent pour une date donnée. L'idée est d'analyser cette évolution avec 3 aspects. 
1. Une carte pour avoir une overview de la production. 
2. Un Pie chart qui montre le mix de production énergétique pour l'année courante. 
3. Un barchart qui montre l'évolution dans el temps. 

**On remarque que les plus gros producteurs d'énergie dans les années 2000 ont maintenu leur statue pendant deux décennies**

**Par contre, on remarque une évolution dans le mix énergétique, où il y a une tendance au renouvelable**, du sans aucun doute aux nouvelles normes et aspirations. 

**Il est aussi surprenant de voir à quel point l'Asie a connu une explosion de la production/consolation d'énergie.** 

On constate aussi que hors Europe, il y a une vraie prédominance de l'énergie fossile, dès 2012 la part nucléaire + renouvelable a dépassé la production d'énergie via un combustible fossile. 


#### Pour faire une analyse plus en détail : 
Nous regardons la consommation/hab pour une année donnée en triant les pays en fonction de leur IDH. L'intérêt est de voir outre le nombre d'habitants s'il y a bien un rapport entre l'IDH et la production d'énergie. 
On constate que les données sont extrêmement corrélées ! Avec une échelle en $log_{10}$ la distribution est quasi-linéaire. 
Cela veut dire que quand l'IDH grandit, la consommation grandit d'un facteur 10. De manière attendue aussi la 