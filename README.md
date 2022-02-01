# Modern Portfolio Theory in R

This is a demo of Modern Portfolio Theory in R. The idea is that, when there are two or more risky assets, there exists an optimal portfolio of the assets for any given risk that maximizes the expected return. As long as there isn't perfect positive correlation between the assets, then the so-called unsystematic risk associated with a singular asset can be diversified away so that only the market, systematic risk remains.

## Methodology and data

One way to identify the possible portfolios is to simulate them. In this analysis 50000 portfolios are simulated using a uniform distribution, meaning that every asset in the portfolio has an equal chance to have a value in the range of [0,1], summing to 1. Other way to obtain the optimal portfolios for the risk is to express the problem as a quadratic programming optimization problem and then solve it w.r.t. the constraints. Return of a portfolio is the weighted average yearly return of the period while yearly standard deviation represents the risk. Sharpe ratio (SR) is also calculated, which is obtained by subtracting the risk free rate - zero in this case - from the portfolio returns and then dividing by the standard deviation. 

Apple, 3M, Microsoft, Comcast, and Goldman Sach stocks' daily values from 2.1.2019 to 12.30.2021 are used to construct the portfolios, and were gotten from Yahoo Finance. Figures 1. and 2. illustrate the stock prices and returns, respectively, for the period. The returns are calculated as arithmetic returns.

![period_prices](https://user-images.githubusercontent.com/91892495/151845968-0966aab1-a1be-45e5-b713-29862a266e3a.png)

**Figure 1.** Stock prices

![period_returns](https://user-images.githubusercontent.com/91892495/151846079-197fc681-dfe6-4dfc-9e4b-e22eb4ca22c4.png)

**Figure 2.** Stock returns

Something noteworthy is the beginning of 2020. This was an especially volatile period, which was caused by the March 2020 stock market crash.

## Results

![portfolios](https://user-images.githubusercontent.com/91892495/151999967-afbbe70e-fd2f-4204-aaa1-ab4eec27e53a.png)

**Figure 3.** Simulated portfolios

Figure 3. displays a scatterplot of the results of simulating 50000 portfolios with random weights of the chosen stocks. Heatmap is used to represent the SR of the portfolios. In red and labeled are both the minimum variance portfolio and the tangency portfolio aka the portfolio with maximum SR and being the portfolio tangent to the capital market line if it were drawn. It's possible to choose any one of these portfolios simulated here, but only the portfolios that lie on the efficient frontier, which can be seen beginning to form up and outwards off the minimum variance portfolio, make sense as they maximize the return for the risk. For example, it makes no sense to choose any of the portfolios that lie below the minimum variance portfolio if you were to draw a horizontal line from where it lies.

![portfolios_efqp](https://user-images.githubusercontent.com/91892495/152003973-776a92dc-e83b-4ca2-91af-0c5a00a922a0.png)

**Figure 4.** Simulated portfolios and the efficient frontier from the quadratic programming optimization

Figure 4. overlays the previous plot with the efficient frontier of portfolios that were gotten from the quadratic programming optimization problem. These values are not stochastic, and it's possible to obtain the optimally weighted portfolios for the given risk as long as covariance-variance matrix and return vectors are defined. It can be seen that the simulated portfolios approximate the optimal portfolios pretty nicely. However, for the higher return portfolios the simulation doesn't do so well as the weights in several stocks are zero.

|MVP|Apple|3M|Comcast|Microsoft|Goldman Sachs|R|SD|
|------|---|---|---|---|---|---|---|
|Simulated|0.0065|0.3926|0.3459|0.2478|0.0073|0.2189|0.2343|
|QP||0.0234|0.4058|0.3283|0.2425|0.0000|0.2227|0.2341|

|TP|Apple|3M|Comcast|Microsoft|Goldman Sachs|R|SD|
|---|---|---|---|---|---|---|---|
|Simulated|0.7883|0.0053|0.0288|0.1571|0.0205|0.6964|0.3166|
|QP|0.8007|0.0000|0.0000|0.1993|0.0000|0.7162|0.3226|

**Table 1.** Differences between simulated and QP portfolios
