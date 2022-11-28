---
title: Credit risk with R.
author:
   - name: Dr. Martin Lozano.
     affiliation: https://mlozanoqf.github.io/
#     email: martin.lozano@udem.edu
#   - name: Jack, the Supposed Contributor
#     affiliation: Living Room Couch
date: "\\faClock \\hspace{1 mm} Last compiled on: `r format(Sys.time(), '%d/%m/%Y, %H:%M:%S.')`"
bibliography: references.bib
abstract: This material relies on John C. Hull [@Hull] credit risk chapters and Lore Dirick credit risk DataCamp course. Some mathematical background is skipped to emphasize the data analysis, model logic, discussion, graphical approach and R coding. As in the philosophy of Donald Knuth [@knuth1984literate], the objective of this document is to explain to human beings what we want a computer to do as literate programming. This is a work in progress and it is under revision.
output:
  bookdown::gitbook:
#output:
#  bookdown::html_document2: 
#    toc: true
#    toc_float: true
#    toc_depth: 2
#    number_sections: true
#    fig_caption: yes
#    code_folding: hide
#    theme: readable #darkly
    includes:
      after_body: analytics_arf.html
---
-----------------------

```{=tex}
\newpage 
\hypersetup{linkcolor=black}
\renewcommand*\contentsname{Index.}
\tableofcontents
```

```{r echo=FALSE}
# This removes all items in environment. 
# It is a good practice to start your code this way.
rm(list=ls())
```

```{r global_options, include = FALSE}
knitr::opts_chunk$set(warning = FALSE, message = FALSE)
knitr::opts_chunk$set(fig.pos = "H", out.extra = "")
```

\newpage

```{r load libraries}
# Logistic models
library(gmodels)
library(ggplot2)
library(tidyr)
library(dplyr)
library(pROC)
# Merton model
library(knitr)
library(Sim.DiffProc)
library(bazar) # para la función almost.equal
library(scatterplot3d)
# Copula models
library(MASS)
library(viridis)
library(rayshader)
```

```{r Logistic, child = 'Logistic.Rmd'}
```

\newpage

```{r Merton, child = 'Merton.Rmd'}
```

\newpage

```{r Gaussian, child = 'Gaussian.Rmd'}
```

\newpage

```{r CVaR, child = 'CVaR.Rmd'}
```

# References.

