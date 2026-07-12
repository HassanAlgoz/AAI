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
    title: [Time Series Analysis],
    subtitle: [Trend, seasonality, and cycles],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()  

= Time Series Analysis

== Definition

#definition("Time series")[
  Anything that is observed sequentially over time is a *time series*.
]

They arise in virtually every application field, such as e.g:
- *Business*: Sales figures, production numbers, customer frequencies, ...
- *Economics*: Stock prices, exchange rates, interest rates, ...
- *Official Statistics*: Census data, personal expenditures, road casualties, ...
- *Natural Sciences*: Population sizes, sunspot activity, chemical process data, ...
- *Environmetrics*: Precipitation, temperature or pollution recordings, ...

== Goals in Time Series Analysis

+ *Exploratory Analysis*: visualize, decompose, and see relations.
+ *Modeling*: fit models to data correctly.
+ *Forecasting*: extrapolate into the future.

Note: we focus on time series that are observed at *regular intervals of time* (e.g., hourly, daily, weekly, monthly, quarterly, annually). *Irregularly spaced* time series can also occur, but are beyond the scope of this course.

= Descriptive Analysis

As always when working with data, i.e. “a pile of numbers”, it is important to gain an overview. In time series analysis, this encompasses several aspects:
- understanding the context of the problem and the data source
- making suitable plots, looking for general structure and outliers
- thinking about data transformations, e.g. to reduce skewness
- judging stationarity and potentially achieve it by decomposition
- for stationary series, the analysis of the autocorrelation function

We start by discussing time series plots, then discuss transformations, focus on the decomposition of time series into trend, seasonal effect and stationary random part and conclude by discussing methods for visualizing the dependency structure.

== Time Series Plot

The most important means of visualization is the time series plot, where the data are plotted versus time/index.

#figure(
  image("/courses/Timeseries/assets/fourexamples_bottom_left_electricity.png", height: 65%),
  caption: [Australian quarterly electricity production.],
)

#pagebreak()

== Patterns

Once you have plotted your data, the next step is to recognize the patterns that show up again and again across disciplines. We identify patterns because we want models that can *capture and reproduce* them when we generate forecasts.

#pause

*Stationarity* means that the probabilistic character of the series must not change over time, i.e. that any section of the time series is "typical" for every other section with the same length.

#pause

However, many of the example series exhibit either 1) *trend* and/or 2) *seasonal effect*, and/or 3) *cyclic pattern*, and thus are non-stationary.

== Trend

#definition("Trend")[
  A *trend* is a long-term change in the mean, induced by external factors. It unfolds over the long run, not as short-lived bumps within a few observations.
]

Typical examples include:

- *Air Passengers* — monthly international airline bookings (1000s of passengers), 1949–1960; classic Box–Jenkins example with rising demand.
- *SMI* — daily closing values of the Swiss Market Index, 1991–1998; more than a four-fold increase over the period.

=== Air Passengers

#figure(
  image("/courses/Timeseries/assets/trend_air_passengers.png", width: 100%),
  caption: [Air passengers with a fitted linear regression trend (green).],
)

#pagebreak()

=== SMI daily close

#figure(
  image("/courses/Timeseries/assets/trend_smi.png", width: 100%),
  caption: [SMI daily closes with a fitted linear regression trend (green).],
)

=== Non-linear Trends

If the trend changes, we call it *non-linear*. that is, no line can describe the whole, since the series can rise over one period and fall over another. So we'd need multiple line segments or a continuous curve, to describe the trend.

#figure(
  image("/courses/Timeseries/assets/aus_bricks_partial_trends.png", width: 100%),
  caption: [Australian clay-brick production with five piecewise trend segments.],
)

== Seasonal Pattern

#definition("seasonal component")[
  A *seasonal component* is a deterministic cyclic component in a time series with a fixed and known frequency, often caused by the way the measurements are obtained.
]

Examples:

- *Quarter of the year* — summer vs winter demand
- *Month of the year* — retail sales spike in Ramadan (Eid)
- *Day of the week* — office electricity use is lower on weekends
- *Time of day* — household electricity demand spikes when people wake up and return home

The timing of peaks and troughs is *predictable*.

== Cyclic pattern

#definition("Cyclic pattern")[
  A *cyclic pattern* exists when the data rises and falls, but *not on a fixed schedule*.
]

- Cycles are usually at least two years long — e.g. the business cycle, typically lasting between two and nine years.
- Cyclic swings are often *asymmetric*: long periods of growth followed by short, sharp downturns.
- Cycles have *variable length* and more *variable magnitude* than seasonal patterns.
- Crucially, we *cannot predict* when a cycle will turn — we do not know in advance when the next recession will hit, even though we can see cycles in hindsight.

== Do not say "seasonal cycle"

#showybox(
  title: [Keep the ideas separate],
  [
    A *season* repeats regularly — every summer, every Eid, every weekend.

    A *cycle* does not.

    *Do not say "seasonal cycle."*
  ],
)

== Exercise

Identify whether each of characteristics are present in the time series:

- *Trends*
- *Seasonal pattern*
- *Cyclic pattern*

== Housing sales (monthly, USA)

#figure(
  image("/courses/Timeseries/assets/fourexamples_top_left_housing_sales.png", height: 65%),
  caption: [Sales of new one-family houses, USA.],
)
#pause
Strong *seasonality* within each year, plus some *cyclic* behaviour with a period of about 6–10 years. No apparent *trend* over this period.

== Treasury bill contracts (daily, 1981)

#figure(
  image("/courses/Timeseries/assets/fourexamples_top_right_treasury_bills.png", height: 65%),
  caption: [US treasury bill contracts — 100 consecutive trading days, Chicago, 1981.],
)
#pause
No *seasonality*, but an obvious downward *trend*. Over a longer series, this might appear as part of a long *cycle*; over 100 days it looks like a trend.

== Electricity production (quarterly, Australia)

#figure(
  image("/courses/Timeseries/assets/fourexamples_bottom_left_electricity.png", height: 65%),
  // caption: [Australian quarterly electricity production.],
)
#pause
Strong increasing *trend* and strong *seasonality* — regular peaks every four observations (one per year). No evidence of *cyclic* behaviour.

As air conditioning became widespread, the seasonal peak shifted from winter heating to summer cooling.

== Google stock price changes (daily)

#figure(
  image("/courses/Timeseries/assets/fourexamples_bottom_right_google_stock.png", height: 75%),
  // caption: [Daily changes in Google closing stock price.],
)
#pause
No *trend*, *seasonality*, or *cycle* in the usual sense. Instead, wandering behaviour — sometimes up, sometimes down — with random fluctuations.

== Australian clay brick production (quarterly)

#figure(
  image("/courses/Timeseries/assets/australian_clay_brick_productino.png", height: 58%),
  // caption: [Australian clay brick production.],
)
#pause
From the mid-1950s to the mid-1970s: strong upward *trend*. Recessions in the mid-1970s and early 1980s appear as sharp busts, followed by alternating increases and busts — a *cyclical* pattern.

Also *seasonality*: more bricks are produced in the summer quarter because drier weather makes construction easier.

== US retail employment (monthly)

#figure(
  image("/courses/Timeseries/assets/us_retail_employment.png", height: 70%),
  // caption: [US retail employment.],
)
#pause
Overall upward *trend*, strong seasonal spikes in summer (June, July, August), and slower *cyclical* swings as employment expands and contracts over multi-year periods.

== Hudson Bay lynx trappings (annual)

#figure(
  image("/courses/Timeseries/assets/annual_canadian_lynx_trappings.png", height: 58%),
  // caption: [Hudson Bay lynx trappings.],
)
#pause
The smooth up-and-down pattern *looks* seasonal, but annual data cannot have a seasonal component — there are very few exceptions (Olympic records spike every four years).

What we see here is a *cycle*: population dynamics of the lynx and its prey play out over several years.

== Amazon closing stock price (daily)

#figure(
  image("/courses/Timeseries/assets/amazon_closing_stock_price.png", height: 80%),
  // caption: [Amazon closing stock price],
)

Same wandering behaviour as the Google series — sometimes up, sometimes down, with no fixed seasonal or cyclic structure.

== Conclusion

Time series often combine several patterns at once.

Financial time series, show little repeating structure at all.

=== Key terms

- *Trend* — long-term increase or decrease.
- *Season* — fixed-length, predictable repetition driven by calendar factors (year, month, week, day, or hour).
- *Cycle* — variable-length, unpredictable swings, usually spanning at least two years.
