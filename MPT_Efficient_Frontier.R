# Modern portfolio theory - efficient frontier
# Petri Montonen 2022

# Loading the necessary packages and data

library(ggplot2)
library(tidyr)
library(dplyr)
library(ggrepel)
library(tidyquant)
library(fPortfolio)
library(PerformanceAnalytics)
library(quadprog)
library(IntroCompFinR)

rm(list=ls())
setwd("C:/Users/petri/Desktop/GitHub töitä/R/MPT_Efficient_Frontier")

mmm = read.csv("MMM.csv")
aapl = read.csv("AAPL.csv")
cmcsa = read.csv("CMCSA.csv")
msft = read.csv("MSFT.csv")
gs = read.csv("GS.csv")

df = data.frame(MMM = mmm$Close, AAPL = aapl$Close, CMCSA = cmcsa$Close, MSFT = msft$Close, GS = gs$Close,
                Date = as.Date(aapl$Date))

anyNA(df)

# Arithmetic and logarithmic returns - arithmetic returns are used in this analysis

aapl_R = c()
mmm_R = c()
cmcsa_R = c()
msft_R = c()
gs_R = c()

aapl_r = 
mmm_r =
cmcsa_r =
msft_r =
gs_r =
  
for (i in 1:length(aapl$Close)){
  aapl_R[i] = aapl$Close[i+1]/aapl$Close[i]-1
  mmm_R[i] = mmm$Close[i+1]/mmm$Close[i]-1
  cmcsa_R[i] = cmcsa$Close[i+1]/cmcsa$Close[i]-1
  msft_R[i] = msft$Close[i+1]/msft$Close[i]-1
  gs_R[i] = gs$Close[i+1]/gs$Close[i]-1
}

for (i in 1:length(aapl$Close)){
  aapl_r[i] = log(aapl$Close[i+1]/aapl$Close[i])
  mmm_r[i] = log(mmm$Close[i+1]/mmm$Close[i])
  cmcsa_r[i] = log(cmcsa$Close[i+1]/cmcsa$Close[i])
  msft_r[i] = log(msft$Close[i+1]/msft$Close[i])
  gs_r[i] = log(gs$Close[i+1]/gs$Close[i])
}

data_R = data.frame(AAPL = aapl_R[1:length(aapl_R)-1], MMM = mmm_R[1:length(aapl_R)-1],
                  CMCSA = cmcsa_R[1:length(aapl_R)-1], MSFT = msft_R[1:length(aapl_R)-1],
                  GS = gs_R[1:length(aapl_R)-1], row.names = aapl$Date[2:(length(aapl$Date))])

data_r = data.frame(AAPL = aapl_r[1:length(aapl_r)-1], MMM = mmm_r[1:length(aapl_r)-1],
                    CMCSA = cmcsa_r[1:length(aapl_r)-1], MSFT = msft_r[1:length(aapl_r)-1],
                    GS = gs_r[1:length(aapl_r)-1], row.names = aapl$Date[2:(length(aapl$Date))])

# Visualizing the stock price for the period

df %>%
  gather(Stock, Price, MMM, AAPL, CMCSA, MSFT, GS) %>%
  mutate(label = if_else(Date == max(Date), as.character(Stock), NA_character_)) %>%
  ggplot(aes(x = Date, y = Price, colour = Stock)) +
  geom_line(aes(linetype = Stock)) +
  geom_label_repel(aes(label = label), nudge_x = 1, na.rm = TRUE)

# Visualizing the returns

vis_R = data_R %>%
  mutate(Date = as.Date(aapl$Date[2:(length(aapl$Date))]))

# vis_R %>%
#   gather(Stock, R, AAPL, MMM, CMCSA, MSFT, GS) %>%
#   ggplot(aes(x = Date, y = R, colour = Stock)) +
#   geom_line(aes(linetype = Stock))

p = vis_R %>%
  gather(Stock, R, AAPL, MMM, CMCSA, MSFT, GS) %>%
  ggplot(aes(Date, R, colour = Stock)) +
  geom_line()

p + facet_grid(Stock ~ .) +
  theme(legend.position = "none")
  
# Yearly covariance-variance matrix - diagonal values are variances - as well as correlations

covmat = cov(data_R)*252
cormat = cor(data_R)

# Obtain yearly expected returns and random portfolio weights.

y_R = (colMeans(data_R)+1)^252-1

w = runif(n = length(data_R))
w = w/sum(w)

# Random yearly expected portfolio return

port_R = sum(w*y_R)

# Portfolio volatility - standard deviation

port_sd = sqrt(t(w) %*% covmat %*% w)

# Sharpe ratio - portfolio performance measurement

SR = port_R/port_sd

# Simulating the portfolios

n = 50000

ws = matrix(nrow = n, ncol = length(data_R))
port_Rs = c()
port_sds = c()
port_SRs = c()

for (i in 1:n){
  
  w = runif(n = length(data_R))
  w = w/sum(w)
  
  ws[i,] = w
  
  port_R = sum(w*y_R)
  port_Rs[i] = port_R
  
  port_sd = sqrt(t(w) %*% covmat %*% w)
  port_sds[i] = port_sd
  
  SR = port_R/port_sd
  port_SRs[i] = SR
  
}

# Using quadratic programming optimization to find minimum as well as efficient frontier portfolios
  
global_minimum_portfolio = globalMin.portfolio(y_R, covmat, shorts = FALSE) 
global_minimum_portfolio

efficient_frontier = efficient.frontier(y_R, covmat, nport = 20, shorts = FALSE)
efficient_frontier

tangency_portfolio = tangency.portfolio(y_R, covmat, 0, shorts = FALSE)
tangency_portfolio

# Visualizing the portfolios and efficient frontier - the portfolios that have the minimum volatility for the return

colnames(ws) = c("AAPL","MMM","CMCSA","MSFT","GS")
portfolios = data.frame(ws, R = port_Rs, SD = port_sds, SR = port_SRs)

max_sharpe = portfolios[which.max(portfolios$SR),]
min_sd = portfolios[which.min(portfolios$SD),]

efdf = data.frame(R = efficient_frontier$er, SD = efficient_frontier$sd)
tpdf = data.frame(R = tangency_portfolio$er, SD = tangency_portfolio$sd)

tangency_portfolio
max_sharpe

global_minimum_portfolio
min_sd

# Purely simulated portfolios along with minimum variance portfolio and maximum sharpe ratio portfolio in red

portfolios %>%
  ggplot() +
  geom_point(aes(x = SD, y = R, color = SR)) +
  geom_point(data = min_sd, aes(x = SD, y = R), color = "red", size = 2, stroke = 1.5) +
  geom_point(data = max_sharpe, aes(x = SD, y = R), color = "red", size = 2, stroke = 1.5)

# Simulated portfolios and the efficient frontier gotten from quadratic programming optimization

portfolios %>%
  ggplot() +
  geom_point(aes(x = SD, y = R, color = SR)) +
  geom_point(data = min_sd, aes(x = SD, y = R), color = "red", size = 2, stroke = 1.5) +
  geom_point(data = max_sharpe, aes(x = SD, y = R), color = "red", size = 2, stroke = 1.5) +
  geom_point(data = tpdf, aes(SD, R), size = 2, stroke = 1.5, color = "black") +
  geom_line(data = efdf, aes(x = SD, y = R), size = 1, color = "black") +
  geom_point(data = efdf, aes(x = SD, y = R), size = 2, color = "black", shape = 21, stroke = 1.5, fill = "white")
