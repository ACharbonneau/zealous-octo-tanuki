rm(list = ls())

# Install function for packages
packages<-function(x){
  x<-as.character(match.call()[[2]])
  if (!require(x,character.only=TRUE)){
    install.packages(pkgs=x,repos="http://cran.r-project.org")
    require(x,character.only=TRUE)
  }
}
packages(knitr)
packages(rmarkdown)


genomes <- c("Moghe2014", "Jeong2016", "Kitashiba2014", "Mitsui2015", "RR3NYEST")

for (genome in genomes){
  rmarkdown::render("TopGo.Rmd", output_file=paste( genome, "_GoAnalysis.html", sep=""),
                    output_dir=paste("../DEseqOutput/", genome, "_GS", sep=""))
}