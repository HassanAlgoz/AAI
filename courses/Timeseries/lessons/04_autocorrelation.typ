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
    title: [Autocorrelation],
    subtitle: [Lag Plots, Autocorrelation, and White Noise],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Autocorrelation

Adapted from #link("https://otexts.com/fpp3/lag-plots.html")[Forecasting: Principles and Practice (3rd ed), §§2.7–2.9].

#pagebreak()

The graphs discussed so far help us identify and visualise features of *individual* time series. In the previous lesson we studied relationships *between* multiple time series using scatterplots.

A key feature of most time series is that adjacent observations tend to be correlated, i.e. *serially dependent*. Here we study how a series relates to its own past values.

= Lag plots

Adapted from #link("https://otexts.com/fpp3/lag-plots.html")[§2.7].

#pagebreak()

A *lag plot* is a scatterplot of $y_t$ against a lagged value of the same series, $y_(t-k)$. It shows how observations separated by $k$ periods relate to each other.


== The gas production data

We use `aus_production` from `data/aus_production.csv`. The dataset has seven columns — six commodity series plus `Quarter`. Here we focus on quarterly *gas* production in petajoules.

#figure(
  image("/courses/Timeseries/assets/gas_production_2000.png", height: 65%),
  caption: [
    Australian quarterly gas production from 2000 onward.
  ],
)

== Building the lag-plot grid

#figure(
  image("/courses/Timeseries/assets/gas_lag_plots.png", height: 92%),
  caption: [Lagged scatterplots for quarterly gas production. Colored by quarter.],
)

#pagebreak()
== Reading the colours

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  align(center + horizon)[
    #figure(
      image("/courses/Timeseries/assets/gas_lag_plot_lag1.png", height: 78%),
      caption: [Lag = 1 panel, coloured by quarter on the vertical axis.],
    )
  ],
  align(horizon)[
    The colours indicate the *quarter* of the variable on the *vertical* axis ($y_t$), not the lagged value on the horizontal axis.
  ],
)

#pagebreak()
=== Lag = 1

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  align(center + horizon)[
    #figure(
      image("/courses/Timeseries/assets/gas_lag_plot_lag1.png", height: 78%),
      caption: [Lag = 1: $y_t$ versus $y_(t-1)$.],
    )
  ],
  align(horizon)[
    Consider the *lag = 1* panel:

    - *Q3* points (one colour in the legend) plot quarter-three production on the vertical axis against quarter-two production of the *same year* on the horizontal axis.
    - *Q1* points plot quarter-one production against quarter-four of the *previous* year — because the observation one quarter earlier falls in the previous calendar year.

    Each colour therefore traces how one seasonal quarter relates to the quarter immediately before it.
  ],
)

#pagebreak()
=== Lag = 2

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  align(center + horizon)[
    #figure(
      image("/courses/Timeseries/assets/gas_lag_plot_lag2.png", height: 78%),
      caption: [Lag = 2: $y_t$ versus $y_(t-2)$.],
    )
  ],
  align(horizon)[
    In the *lag = 2* panel, each point compares $y_t$ with $y_(t-2)$:

    - *Q3* points plot quarter-three values against quarter-*one* values of the same year.
    - *Q1* points plot quarter-one values against quarter-three of the *previous* year.
  ],
)

== Seasonal patterns

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  align(center + horizon)[
    #figure(
      image("/courses/Timeseries/assets/gas_lag_plots_seasonal.png", height: 82%),
      caption: [
        Seasonal lag panels: negative at lags 2 and 6, positive at lags 4 and 8.
      ],
    )
  ],
  align(horizon)[
    Looking across the grid:

    - The relationship is *strongly positive* at lags 4 and 8 — peaks in Q3 align with peaks in Q3 of the previous year (and two years ago).
    - The relationship is *strongly negative* at lags 2 and 6 — Q3 peaks are plotted against Q1 troughs (and vice versa), because seasonal peaks and troughs are two quarters apart.

    This is exactly what we expect from a series with strong *quarterly seasonality*.
  ],
)

= Autocorrelation Function

Adapted from #link("https://otexts.com/fpp3/acf.html")[§2.8].

#pagebreak()

Autocorrelation is one of the key tools for understanding a time series.

Return to the lag plots from the previous section. Each panel plotted $y_t$ against a lagged version of the same series, $y_(t-k)$.

The ordinary correlation associated with each lag plot is called an *autocorrelation*.

"Auto" means *self*: we are measuring how a series is related to itself at different distances in time.

== Autocorrelation coefficients

There are several autocorrelation coefficients, one for each lag:

- $r_1$ measures the relationship between $y_t$ and $y_(t-1)$.
- $r_2$ measures the relationship between $y_t$ and $y_(t-2)$.
- $r_k$ measures how observations $k$ periods apart relate to each other.

So, for the gas lag plots:

- the first panel has correlation $r_1$,
- the second panel has correlation $r_2$,
- the third panel has correlation $r_3$,
- and so on.

#pagebreak()

== Autocorrelation Formula

For completeness, we provide the mathematical defintion here (not required):

#text[
  #set text(size: 0.80em)
  We start with the sample autocovariance at lag $k$:

  $
  gamma_(k) = 1 / T sum_(t=k+1)^T (y_t - bar(y))(y_(t-k) - bar(y)).
  $

  Then we divide by the variance, $gamma_0$, to get the autocorrelation:

  $
  r_(k) = gamma_(k) / gamma_0
        = (sum_(t=k+1)^T (y_t - bar(y))(y_(t-k) - bar(y)))/(sum_(t=1)^T (y_t - bar(y))^2).
  $

  where $T$ is the length of the time series. The autocorrelation coefficients make up the *autocorrelation function* or ACF.


  This formula is slightly different from taking an ordinary sample correlation between $y_t$ and a shifted copy of $y_t$. Time-series software uses this convention because it gives better properties for ACF estimation.
]

== Computing the ACF in Python

In Python, #link("https://www.statsmodels.org/stable/generated/statsmodels.tsa.stattools.acf.html")[`statsmodels.tsa.stattools.acf`] computes the same coefficients (its element 0 is always 1 — a series correlated with itself — so we keep lags 1 onward):

```python
from statsmodels.tsa.stattools import acf

coeffs = acf(gas, nlags=9)
gas_acf = pd.DataFrame({
    "lag": [f"{k}Q" for k in range(1, 10)],
    "acf": coeffs[1:],
})
```
#pagebreak()
The values in the `acf` column below are $r_1, dots, r_9$, corresponding to the nine scatterplots in the previous section.

#table(
  columns: (auto, auto),
  align: (center, right),
  table.header([*lag*], [*acf*]),
  [1Q], [$0.193$],
  [2Q], [$-0.496$],
  [3Q], [$0.235$],
  [4Q], [$0.826$],
  [5Q], [$0.104$],
  [6Q], [$-0.517$],
  [7Q], [$0.150$],
  [8Q], [$0.694$],
  [9Q], [$0.0270$],
)

#pagebreak()

== The correlogram

We usually plot the ACF to see how the correlations change with the lag $k$.

This plot is sometimes called a *correlogram*.

#figure(
  image("/courses/Timeseries/assets/gas_acf.png", height: 62%),
  caption: [Autocorrelation function of quarterly gas production (Figure 2.20).],
)
#pagebreak()
In this graph:
- $r_4$ and $r_8$ are strongly positive because they are multiples of the seasonal period. *Peaks line up with peaks, and troughs line up with troughs*.
- $r_2$ and $r_6$ are strongly negative because *peaks are plotted against troughs*.
- The shaded blue area indicates whether the correlations are significantly different from zero (at least one value outside the shaded area; here: two spikes).
  - If none is outside; the series is *white noise* (explained later in detail).

== Trend and seasonality in ACF plots

Patterns in the data show up as patterns in the ACF.

When data have a *trend*, the autocorrelations for small lags tend to be large and positive because observations nearby in time are also nearby in value. The ACF of a trended series often starts high and decreases slowly.

When data are *seasonal*, the autocorrelations are larger at seasonal lags - the multiples of the seasonal period.

When data are both trended and seasonal, the ACF combines both effects: slow decay from the trend, plus a repeating scalloped shape from seasonality.

#figure(
  image("/courses/Timeseries/assets/a10_time_plot.png", height: 58%),
  caption: [
    Monthly sales of antidiabetic drugs in Australia (`a10`, Figure 2.2).
    There is a clear increasing trend and a seasonal pattern that grows with the level of the series.
    The sudden drop at the start of each year is caused by a government subsidisation scheme.
  ],
)

#figure(
  image("/courses/Timeseries/assets/a10_acf.png", height: 62%),
  caption: [ACF of monthly Australian antidiabetic drug sales (Figure 2.21).],
)

== US retail employment

US retail employment is monthly data with both trend and seasonality: employment generally rises over time, and it peaks around the same time each year.

#figure(
  image("/courses/Timeseries/assets/us_retail_employment_time.png", height: 50%),
  caption: [Monthly US retail employment since 1990.],
)

#figure(
  image("/courses/Timeseries/assets/us_retail_employment_acf.png", height: 50%),
  caption: [
    ACF of monthly US retail employment.
    The correlations stay positive for many lags because of the trend, with small peaks near seasonal lags 12, 24, 36, and 48.
  ],
)

== Google stock prices

Google closing prices in 2015 have no regular seasonal cycle, but they are strongly persistent: prices on nearby trading days tend to be close together.

#figure(
  image("/courses/Timeseries/assets/google_2015_close.png", height: 50%),
  caption: [Google daily closing stock price in 2015.],
)

#figure(
  image("/courses/Timeseries/assets/google_2015_acf.png", height: 50%),
  caption: [
    ACF of Google daily closing prices in 2015.
    The correlations start near one and decay slowly, a common pattern for trended stock-price series.
  ],
)

ACF plots are useful for raw time series, and even more useful later when we inspect *model residuals*. A residual ACF can reveal leftover structure that is hard to see in a time plot.

= White noise

Adapted from #link("https://otexts.com/fpp3/wn.html")[§2.9].

#pagebreak()

The most boring time series in forecasting is *white noise*.

The name comes from signal processing: white light contains all frequencies, and white noise contains all frequencies in the spectrum. If you think of a time series as an audio signal, white noise is the static hiss from an untuned radio.

== What is white noise?

Statistically, white noise is a sequence of *random values* (independent and identically distributed).

White noise data are:

- uncorrelated across time,
- have zero mean,
- have constant variance.

== A simulated example

We generate 50 standard normal values with a fixed random seed so the example is reproducible:

```python
rng = np.random.default_rng(30)
y = pd.DataFrame({
    "sample": np.arange(1, 51),
    "wn": rng.normal(size=50),
}).set_index("sample")
```

There is no trend, no seasonality, and no pattern — just random values.

#figure(
  image("/courses/Timeseries/assets/white_noise_series.png", height: 48%),
  caption: [A white noise time series.],
)

== ACF of white noise

Even when there is no true autocorrelation, a sample ACF will show some positive and negative spikes simply because of randomness.

#figure(
  image("/courses/Timeseries/assets/white_noise_acf.png", height: 48%),
  caption: [Autocorrelation function for the white noise series (Figure 2.23).],
)

This is where the blue dashed lines become important. They show how large a spike would need to be before we suspect the series is *not* white noise.

#pagebreak()

== Significance bounds (not required)

For white noise, we expect sample autocorrelations to be close to zero.
#text[
  #set text(size: 0.80em)
  When the series really is white noise and $T$ is large enough (series is long), each sample autocorrelation $r_k$ is approximately normally distributed with mean $0$ and variance $1/T$.

  So 95% of the time we expect

  $
  r_k in [-1.96 / sqrt(T), +1.96 / sqrt(T)].
  $

  These are the blue dashed lines on an ACF plot. About 5% of spikes may fall outside the bands even for genuine white noise.

  If many spikes lie outside the bands — or if one spike is far outside — the series is probably not white noise.

  In the simulated example, $T = 50$, so the bounds are $plus.minus 1.96 / sqrt(50) approx plus.minus 0.28$. All spikes up to lag 16 lie within the bands, which is what we expect for white noise.
]

== A real example: sheep slaughter in Victoria

A time plot alone can be misleading. Consider monthly sheep slaughter in Victoria from `data/aus_livestock_vic_sheep.csv`, from 2014 to the end of 2018, scaled to thousands:

#figure(
  image("/courses/Timeseries/assets/vic_sheep_slaughter_time.png", height: 48%),
  caption: [Monthly sheep slaughter in Victoria, 2014–2018.],
)

The series looks fairly random: no obvious trend or seasonality. But an ACF plot is a better test.

#figure(
  image("/courses/Timeseries/assets/vic_sheep_slaughter_acf.png", height: 48%),
  caption: [ACF of monthly sheep slaughter in Victoria.],
)

Several of the first 16 spikes lie outside the blue bands. The clearest signal is at *lag 12* — the seasonal lag for monthly data — which suggests leftover seasonality that is hard to see in the time plot. The series does *not* appear to be white noise.

When reading an ACF, focus on spikes that are clearly outside the blue lines, especially when several spikes exceed the bounds or when a large spike occurs at a seasonal lag.
