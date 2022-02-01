# Modern Portfolio Theory in R

This is a demo of Modern Portfolio Theory in R. The idea is that, when there are two or more risky assets, there exists an optimal portfolio of the assets for any given risk that maximizes the expected return. As long as there isn't perfect positive correlation between the assets, then the so-called unsystematic risk associated with a singular asset can be diversified away so that only the market, systematic risk remains.

## Methodology and data

One way to identify the possible portfolios is to simulate them. In this analysis 50000 portfolios are simulated using a uniform distribution, meaning that every asset in the portfolio has an equal chance to have a value in the range of [0,1], summing to 1. Other way to obtain the optimal portfolios for the risk is to express the problem as a quadratic programming optimization problem and then solve it w.r.t. the constraints. Return of a portfolio is the weighted average return of the period while standard deviation represents the risk. Sharpe ratio is also calculated, which is obtained by subtracting the risk free rate - zero in this case - from the portfolio returns and then dividing by the standard deviation. 

Apple, 3M, Microsoft, Comcast, and Goldman Sach stocks from 2.1.2019 to 12.30.2021 are used to construct the portfolios, and were gotten from Yahoo Finance. Figures 1. and 2. illustrate the stock prices and returns, respectively, for the period. The returns are calculated as arithmetic returns.

![period_prices](https://user-images.githubusercontent.com/91892495/151845968-0966aab1-a1be-45e5-b713-29862a266e3a.png)

**Figure 1.** Stock prices

![period_returns](https://user-images.githubusercontent.com/91892495/151846079-197fc681-dfe6-4dfc-9e4b-e22eb4ca22c4.png)

**Figure 2.** Stock returns

Something noteworthy is the beginning of 2020. This was an especially volatile period, which was caused by the March 2020 stock market crash.

## Results

