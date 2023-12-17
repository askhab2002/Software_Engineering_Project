
# Packages to install. Run at once
# install.packages("shiny")
# install.packages("bslib")
# install.packages("shinymanager")
# install.packages("thematic")
# install.packages("shinyWidgets")
# install.packages("rusquant")
# install.packages("fPortfolio")
# install.packages("BVAR")
# install.packages("xts")


library(shiny)
library(bslib)
library(shinymanager)
library(thematic)
library(shinyWidgets)

library(rusquant)
library(fPortfolio)
library(BVAR)
library(xts)


choicesForSelector <- list(
  "Газпром" = 1, 
  "Роснефть" = 2,
  "Лукойл" = 3,
  "Газпромнефть" = 4,
  "Сургут Нефтегаз" = 5
)
portfolioSelector <- list(
  "Газпром" = 2, 
  "Роснефть" = 3,
  "Лукойл" = 4,
  "Газпромнефть" = 5,
  "Сургут Нефтегаз" = 6
)

choicesForStrategy <- list(
  "Long & Short" = 2,
  "Only long" = 1
)

choicesForSolver <- list(
  "solveRshortExact" = "solveRshortExact"
)

bvar_variables_1 <- list(
  "Brent" = 1,
  "sp500" = 2,
  "stoxx600" = 3,
  "sse" = 4,
  "KASE" = 5
)
bvar_variables_2 <- list(
  "USD/RUB"= 6,
  "EUR/RUB" = 7,
  "CNY/RUB" = 8,
  "RUB/KZT" = 9,
  "PMI" = 10,
  "U10b" = 11
)
bvar_variables_3 <- list(
  "R10b" = 12,
  "R5b" = 13,
  "R1b" = 14,
  "MoexOilGas"= 15,
  "ММВБ" = 16,
  "РТС"= 17
)
weights = list()
  

source("trading_page.R")
source("invest_page.R")
