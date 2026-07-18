#import "@preview/touying:0.6.1": *
#import "@preview/curryst:0.5.1" as curryst: rule

#import "/template/theme.typ": *

#show: university-theme.with(
  config-colors(
    primary: primary-color,
    secondary: secondary-color,
    tertiary: tertiary-color,
    neutral-darkest: text-color
  ),
  config-info(
    title: [Adjustments],
    subtitle: [Smoothing and corrections before modelling],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Adjustments

#pagebreak()

In Professional practice, analysts rarely work with time series data as is. Quite often, transforming the data:
+ yields better models
+ speeds up the analysis
+ and more importantly, makes the underlying patterns much *easier to interpret*
#pause
In this section, we will explore several transformations and adjustments:
+ *Calendar* adjustments
+ *Population* adjustments
+ *Inflation* adjustments
+ *Mathematical* transformations (next lesson)

The purpose of these adjustments and transformations is to simplify the patterns in the historical data by removing known sources of variation, or by making the pattern more consistent across the whole data set.

== Calendar adjustments

=== #link("https://en.wikipedia.org/wiki/Month")[Table]: A year is divided into twelve months
#table(
  columns: (auto, 1fr, 2fr),
  table.header(
    [*No.*], [*Name*], [*Length in days*],
  ),
  [1], [January], [31],
  [2], [February], [28 (29 in #link("https://en.wikipedia.org/wiki/Leap_year")[leap years])],
  [3], [March], [31],
  [4], [April], [30],
  [5], [May], [31],
  [6], [June], [30],
  [7], [July], [31],
  [8], [August], [31],
  [9], [September], [30],
  [10], [October], [31],
  [11], [November], [30],
  [12], [December], [31],
)
Number of work / trading days in a month: 20 - 23.

Often in time series analysis we consider monthly data and often these are delivered as monthly totals. However, this adds unnecessary noise to the series, simply because of the different number of days per month. 

Often, the seasonal effect becomes much cleaner and easier to understand if we switch to the "daily average per month" rather than considering the "monthly total". 

From simplified patterns, we humans as well as prediction models usually are more successful in extracting the relevant information.

Additionally, using daily averages also manages to deal with the leap year problem, since in every fourth year, February will have 29 rather than 28 days. Obviously, this affects the monthly total, whereas the daily average is hardly affected.

#pagebreak()
=== Milk Production

#figure(
  image("/courses/Timeseries/assets/monthly_milk_per_cow.png", height: 78%),
  caption: [
    #set text(size: 0.80em)
    Monthly milk production per cow (top) and the same series divided by the number of days in each month (bottom).
    The daily average removes noise from varying month lengths and leap years.
  ],
)

== Population adjustments

Any data that are affected by population changes can be adjusted to give #link("https://ourworldindata.org/grapher/gdp-per-capita-worldbank")[*per-capita*] data. That is, consider the data per person (or per thousand people, or per million people) rather than the total.

For example, if you are studying the "number of hospital beds in a particular region over time", the results are much easier to interpret if you remove the effects of population changes by considering the *"number of beds per thousand people"*. Then you can see whether there have been real increases in the number of beds, or *whether the increases are due entirely to population increases*.

It is possible for the total number of beds to increase, but the number of beds per thousand people to decrease. This occurs when the population is increasing faster than the number of hospital beds.

*For most data that are affected by population changes, it is best to use per-capita data rather than the totals*.

=== GDP per capita

#figure(
  image("/courses/Timeseries/assets/gdp_per_capita_australia.png", width: 100%),
  caption: [Australian GDP per capita from 1960 to 2018. See: #link("https://ourworldindata.org/grapher/gdp-per-capita-worldbank")[OurWorldInData.org]],
)

#pagebreak()

== Inflation adjustments

Data which are affected by the *value of money* are best adjusted before modelling.

For example, the average cost of a new house will have increased over the last few decades *due to inflation*. A \$200,000 house this year is not the same as a \$200,000 house twenty years ago. For this reason, financial time series are usually adjusted so that all values are stated in dollar values from a particular year. For example, the house price data may be stated in *year 2000 dollars*.

To make these adjustments, a *price index* is used. If $z_t$ denotes the price index and $y_t$ denotes the original house price in year $t$, then the adjusted house price at year 2000 dollar values is given by:

$
  x_t = y_t / z_t times z_(2000)
$

#pagebreak()
#grid(
  columns: (1fr, 1fr),
  gutter: 0em,
  align: (left + top, left + top),
  [
    Price indexes are often constructed by government agencies. For consumer goods, a common price index is the #link("https://en.wikipedia.org/wiki/Consumer_price_index")[Consumer Price Index (CPI)].


    Figure: #link("https://en.wikipedia.org/wiki/Consumer_price_index#/media/File:How_is_the_Consumer_Prices_Index_(CPI)_calculated?.png")[How is the Consumer Prices Index (CPI) calculated? - Wikipedia].
  ],
  [
    #figure(
      image("/courses/Timeseries/assets/cpi_index_2014.png", height: 100%),
      // caption: [],
    )
  ],
)

#pagebreak()
=== Print media turnover

#figure(
  image("/courses/Timeseries/assets/print_media_turnover.png", height: 60%),
  caption: [Annual newspaper and book retail turnover in Australian dollars, aggregated across all states.],
)

In the unadjusted data, annual "*newspaper and book retail turnover*" appears to grow until around 2010 before falling.
#pagebreak()

That first impression suggests a healthy industry followed by a recent decline. After adjusting for CPI from `global_economy`, the same industry *tells a very different story!*.

#figure(
  image("/courses/Timeseries/assets/print_media_turnover_adjusted.png", height: 68%),
  caption: [Turnover divided by CPI and rescaled to 2010 Australian dollars.],
)

After adjusting for CPI, the conclusion is much stronger: the industry has been declining in *real* terms since the 1980s! The rise in the original series was mostly the rising value of money, not a real increase in newspaper and book retailing.

This is why *inflation adjustment is not a minor detail; it can reverse the interpretation of the trend!*

== Local Data for Reference: Saudi Arabia

=== Population

#figure(
  image("/courses/Timeseries/assets/saudi_arabia_population_1950_2030.png", height: 85%),
  caption: [Population of Saudi Arabia from 1950 to 2030. See: #link("https://ourworldindata.org/grapher/population-of-saudi-arabia")[OurWorldInData.org]],
)

=== Consumer Price Index (CPI)

#figure(
  image("/courses/Timeseries/assets/saudi_arabia_cpi.png", width: 100%),
  caption: [
    #link("https://tradingeconomics.com/saudi-arabia/consumer-price-index-cpi")[tradingeconomics.com - General Authority for Statistics, Saudi Arabia].
  ],
)

#align(center)[
See also: #link("https://statbase.org/data/sau-consumer-price-index/")[StatBase.org - Saudi Arabia Consumer Price Index (CPI)].
]

#pagebreak()
=== More in: OurWorldInData.org

- #link("https://ourworldindata.org/grapher/population-with-un-projections?tab=map&mapSelect=~SAU&globe=1&globeRotation=24.09%2C44.64&globeZoom=2.5")[OurWorldInData.org - Population with UN projections].
- #link("https://ourworldindata.org/grapher/median-age?tab=map&mapSelect=~SAU&globe=1&globeRotation=24.09%2C44.64&globeZoom=2.21")[OurWorldInData.org - Median age].
- #link("https://ourworldindata.org/grapher/gdp-per-capita-worldbank?mapSelect=~SAU")[OurWorldInData.org - GDP per capita].
- #link("https://ourworldindata.org/grapher/consumer-price-index?country=IND~USA~JPN~ZAF~CHN~MEX~SAU")[OurWorldInData.org - Consumer Price Index (CPI)].

== Summary

Adjustments simplify patterns by removing known sources of variation before modelling.

+ *Calendar*: use daily averages (total ÷ days in month) instead of monthly totals — cleaner seasonality and fewer leap-year artefacts.
+ *Population*: express totals _per capita_ when population growth matters — totals can rise while per-person measures fall.
+ *Inflation*: rescale nominal values with a _price index_, e.g. $x_t = y_t / z_t times z_(2000)$ — real trends can differ sharply from nominal ones.
