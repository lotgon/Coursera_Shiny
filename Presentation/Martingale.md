Analyse of "martingale" trade strategy 
========================================================
author: Andrei Pazniak
date: 2016-03-26

Martingale idea
========================================================

Main idea for Martingale strategy can be found here.
**https://en.wikipedia.org/wiki/Martingale_(betting_system)**

Adaptation Martingale to forex/stock market
- Buy/Sell orders as head/tail toss
- probability of winning is close to 50%
- min trade size is 0.01


Source
========================================================

Quotes were taken from project https://github.com/lotgon/Coursera_Shiny/tree/master/PrepareData/. 
To simplify model only the best Bid and Asks were taken with periodicity "Minute". All qoutes were converted to pips.


![plot of chunk unnamed-chunk-2](Martingale-figure/unnamed-chunk-2-1.png)

Explanation of input parameters
========================================================

There are several input parameters
- Symbol
- Take Profit. This is a distance between opened price and next decision point. There are 2 possibilities close all positions (positive) and open new position with double volume (negative)

Results
========================================================


Trade-off between income and minimum deposit is the most difficult part for this kind of strategies.
The minimum required deposit for trade volume 0.01 is shown on the chart

```r
ggplot(r1, aes(x=openTime, y=usedMargin)) + geom_line() + ylab("Required deposit, USD") + ggtitle("Margin requirement for account")
```

![plot of chunk unnamed-chunk-4](Martingale-figure/unnamed-chunk-4-1.png)
