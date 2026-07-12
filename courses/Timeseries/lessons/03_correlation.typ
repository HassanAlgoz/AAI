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
    title: [Scatterplots and Correlation],
    subtitle: [Relationships between time series],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Scatterplots and Correlation

Adapted from #link("https://otexts.com/fpp3/scatterplots.html")[Forecasting: Principles and Practice (3rd ed), §2.6].

#pagebreak()

The graphs discussed so far help us identify and visualise features of *individual* time series. Sometimes we are interested in relationships _between_ multiple time series.

The plot type we use for this is the *scatterplot*: put one variable on the $x$-axis and another on the $y$-axis, and each observation becomes a point.

== Electricity demand and temperature

We return to the `vic_elec` dataset in `data/vic_elec.csv` — half-hourly Victorian electricity demand — and keep only *2014*. The dataset also includes Melbourne temperature, a `Holiday` flag, and the calendar `Date`.

#figure(
  image("/courses/Timeseries/assets/vic_elec_2014_demand_temperature.png", height: 68%),
  caption: [
    Half-hourly electricity demand (top) and temperature (bottom) for 2014.
  ],
)

=== Reading the time plots

In the Southern Hemisphere, *January and February are summer* — demand and temperature both peak. *June, July, and August are the coldest months* — demand rises again as heating loads switch on. Spring and autumn sit between those extremes.

These time plots show each series on its own. To study how demand and temperature move *together*, we need a scatterplot.

== Scatterplots

#figure(
  image("/courses/Timeseries/assets/vic_elec_demand_vs_temperature_2014.png", height: 85%),
  caption: [Half-hourly electricity demand (GW) on the $y$-axis against temperature (°C) on the $x$-axis for 2014.],
)

The relationship is clearly *non-linear*:

- on the *right* (hot days), demand rises with temperature — *air-conditioning*;
- on the *left* (cold days), demand rises again — *heating*.

=== Weekdays, weekends, and holidays

The `vic_elec` table also flags public holidays. A useful trick is to label each half-hour as a *weekday* (Monday–Friday), *weekend* (Saturday–Sunday), or *holiday* (whenever it falls), then colour the scatterplot by that label.

#figure(
  image("/courses/Timeseries/assets/vic_elec_demand_vs_temperature_day_type_2014.png", height: 78%),
  caption: [
    Demand (GW) versus temperature (°C) coloured by day type.
    Weekends (green) sit below weekdays at the same temperature; holidays (pink) cluster with weekends.
    The horn-shaped temperature pattern is the same regardless of day type.
  ],
)

*Weekends* show lower demand than *weekdays* at a given temperature, but the overall shape is unchanged. *Holidays* behave similarly to weekends — offices and factories are quiet, so demand drops even when the weather is the same.

== Correlation

It is common to compute a *correlation coefficient* $r$ to measure the strength of the _linear_ relationship between two variables $x$ and $y$.

#figure(
  image("/courses/Timeseries/assets/corr_examples.png", height: 75%),
  caption: [Examples of data sets with different levels of correlation.],
)

The value of $r$ always lies between $-1$ and $+1$:

- $r = +1$: perfect positive linear relationship;
- $r = -1$: perfect negative linear relationship;
- $r approx 0$: little _linear_ association (but a non-linear pattern may still be strong).

#figure(
  image("/courses/Timeseries/assets/vic_elec_demand_vs_temperature_2014.png", height: 56%),
  caption: [$r = 0.28$.],
)

For 2014 Victorian electricity demand and temperature, $r = 0.28$. That sounds weak — and it is *misleading*: the scatterplot shows a clear U-shaped pattern that a straight-line measure cannot capture.

This is why it is important to *always plot the data*, and not rely on $r$ values alone.

We can also use a non-linear measure of correlation called *Chatterjee's xi* ($xi$)--discussed later.

#pagebreak()
=== Pairwise scatterplots

When several time series may be related, plot each variable against every other. We use the `us_change` dataset in `data/us_change.csv` — which records quarterly *percentage changes* in US macro variables:

- *Consumption*
- *Income*
- *Production*
- *Savings*
- *Unemployment*

#figure(
  image("/courses/Timeseries/assets/us_change_time_series.png", height: 93%),
  caption: [Quarterly percentage changes in US macro variables.],
)

To study how these series move together, plot each pair in a scatterplot. Each figure below shows one pair on its own.

#figure(
  image("/courses/Timeseries/assets/us_change_consumption_vs_production.png", height: 75%),
  caption: [
    *Production* and *consumption* ($r approx 0.53$) — when output rises, spending tends to rise too.
  ],
)

#figure(
  image("/courses/Timeseries/assets/us_change_income_vs_savings.png", height: 78%),
  caption: [
    *Savings* and *income* ($r approx 0.72$) — higher income quarters tend to save more.
  ],
)

#figure(
  image("/courses/Timeseries/assets/us_change_consumption_vs_unemployment.png", height: 78%),
  caption: [
    *Consumption* and *unemployment* ($r approx -0.53$) — as unemployment rises, consumption falls.
  ],
)

#figure(
  image("/courses/Timeseries/assets/us_change_production_vs_unemployment.png", height: 78%),
  caption: [
    *Production* and *unemployment* ($r approx -0.77$) — higher output goes with lower unemployment.
  ],
)

#figure(
  image("/courses/Timeseries/assets/us_change_consumption_vs_income.png", height: 78%),
  caption: [Income versus consumption ($r approx 0.38$).],
)

#figure(
  image("/courses/Timeseries/assets/us_change_consumption_vs_savings.png", height: 78%),
  caption: [Savings versus consumption ($r approx -0.26$).],
)

#figure(
  image("/courses/Timeseries/assets/us_change_income_vs_production.png", height: 78%),
  caption: [Production versus income ($r approx 0.27$).],
)

#figure(
  image("/courses/Timeseries/assets/us_change_income_vs_unemployment.png", height: 78%),
  caption: [Unemployment versus income ($r approx -0.22$).],
)

#figure(
  image("/courses/Timeseries/assets/us_change_production_vs_savings.png", height: 78%),
  caption: [Savings versus production ($r approx -0.06$).],
)

#figure(
  image("/courses/Timeseries/assets/us_change_savings_vs_unemployment.png", height: 78%),
  caption: [Unemployment versus savings ($r approx 0.11$).],
)

== Scatterplot matrices

We can summarise pairwise linear association in a *correlation matrix*:

#figure(
  image("/courses/Timeseries/assets/us_change_correlation_matrix.png", height: 80%),
  caption: [
    Pearson correlation matrix for quarterly US macro percentage changes.
  ],
)

== Correlation $!=$ Causation

These numbers describe *association*, not *causation*.

Nevertheless, they are a useful first step before building a model.

= Beyond linear correlation: Chatterjee's xi
#pagebreak()
Recall the *problem* with the demand-versus-temperature scatterplot: the relationship is clearly horn-shaped, yet Pearson $r = 0.28$ made it look weak.

Correlation only sees *straight lines*.

*Chatterjee's xi* ($xi$):

- Unlike Pearson $r$, $xi$ can detect *non-linear* and *non-monotonic* patterns (such as the horn-shaped demand–temperature curve).
- Unlike correlation, $xi$ is *asymmetric*: $xi(x, y) eq.not xi(y, x)$ — the order of variables matters.

We use #link("https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.chatterjeexi.html")[`scipy.stats.chatterjeexi`].

#pagebreak()
=== Example: Chatterjee's xi on demand and temperature
Computed on the 2014 half-hourly `vic_elec` data:
#table(
  columns: (auto, auto),
  inset: (x: 0.9em, y: 0.9em),
  align: (left, center),
  table.header([*Direction*], [$xi$]),
  [Temperature $arrow.r$ Demand], [$0.34$],
  [Demand $arrow.r$ Temperature], [$0.06$],
)

Notice: $xi approx 0.34$ is *higher than* $r = 0.28$, reflecting the horn-shaped pattern that linear correlation understates. The reverse direction ($xi approx 0.06$) is much weaker.

== Chatterjee's xi matrix

#figure(
  image("/courses/Timeseries/assets/us_change_chatterjee_xi_matrix.png", height: 85%),
  caption: [
    Chatterjee $xi$ matrix: $xi$ for *every ordered pair* of variables. Since $xi$ is directional, the matrix is *not symmetric* — cell $(i, j)$ is $xi(x_i, y_j)$
  ],
)

#pagebreak()
=== Reading the matrix

Compare this matrix to the Pearson correlation matrix above:

- *Production* and *Unemployment* had $r approx -0.77$, but $xi approx 0.24$–$0.33$ — a strong negative linear link still shows up as moderate association strength.
- *Savings* and *Income* had $r approx 0.72$; the corresponding $xi$ cells are also among the highest in the matrix.
- *Unemployment $arrow.r$ Production* ($xi approx 0.33$) exceeds *Production $arrow.r$ Unemployment* ($xi approx 0.24$) — the same pair of variables, but association strength runs mostly one way.

*Correlation and Chatterjee's xi measure different things.* Use $r$ to describe _linear association_ (including sign), and $xi$ when you suspect _non-linear_ or _non-monotonic_ dependence — and, as always, *plot the data first*.
