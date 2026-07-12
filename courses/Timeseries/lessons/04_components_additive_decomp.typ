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
    title: [Time Series Decomposition],
    subtitle: [Components and seasonally adjusted data],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Time Series Decomposition

Adapted from #link("https://otexts.com/fpp3/decomposition.html")[Forecasting: Principles and Practice (3rd ed), Chapter 3].

#pagebreak()

Time series data can exhibit a variety of patterns, and it is often helpful to split a time series into several components, each representing an underlying pattern category. We can think of a time series as comprising three components:

+ *trend-cycle* component
+ *seasonal* component
+ *remainder* component (containing anything else in the time series)

In this chapter, we consider the most common methods for extracting these components from a time series. Often this is done to help improve understanding of the time series, but it can also be used to improve forecast accuracy.

When *decomposing* a time series, it is sometimes helpful to first transform or adjust the series in order to make the decomposition (and later analysis) as simple as possible. So we will begin by discussing transformations.

#pagebreak()

== Additive decomposition

The standard model describes a time series as a sum of three components:

- $T_t$: trend-cycle component
- $S_t$: seasonal component
- $R_t$: remainder component

Note the cycle is baked inside the trend comopnent; hence we call $T_t$ the *trend-cycle component*.

We write it as:

$ y_t = T_t + S_t + R_t $

Such model is called an *additive decomposition*; since the terms are added together.

#pagebreak()

=== Example: Employment in the US retail

We will decompose the number of persons employed in retail as shown in the figure below. The data shows the total monthly number of persons in thousands employed in the retail sector across the US since 1990.

#figure(
  image("/courses/Timeseries/assets/us_retail_employment_total.png", height: 60%),
  caption: [Total number of persons employed in US retail],
)

== Trend-cycle component

The `trend` column (containing the trend-cycle $T_t$) follows the overall movement of the series, ignoring any seasonality and random fluctuations (via STL decomposition):

#figure(
  image("/courses/Timeseries/assets/us_retail_employment_trend.png", height: 60%),
  caption: [Total number of persons employed in US retail: the trend-cycle component (orange) and the raw data (grey)],
)

#pagebreak()

== All components

#figure(
  image("/courses/Timeseries/assets/us_retail_employment_components.png", height: 93%),
  caption: [Original time series (top) and its three additive components.],
)
#pagebreak()

=== Properties of the components

These components can be added together to reconstruct the original time series data shown in the top panel. That is: $y_t = T_t + S_t + R_t$.

The *y-axes scales* vary across the components:
- The trend-cycle component ($T_t$) scale matches the data scale.
- Both the seasonal ($S_t$) and remainder ($R_t$) component scales are relative to the trend-cycle component ($T_t$); hence they are much smaller.


=== What the components tell us about this data
Notice the left-most start and right-most end of the seasonal component ($S_t$) are not the same. It also *changes* from year to year.

The remainder component ($R_t$) shown in the bottom panel is what is left over when the seasonal and trend-cycle components have been subtracted from the data. That is: $R_t = y_t - S_t - T_t$.

== Seasonally adjusted data

If the seasonal component is removed from the original data, the resulting values are the *“seasonally adjusted”* data. For additive decomposition, the seasonally adjusted data are given by: $y^("ad")_t = y_t - S_t$.

#figure(
  image("/courses/Timeseries/assets/us_retail_employment_season_adjust.png", height: 68%),
  caption: [Seasonally adjusted retail employment data (blue)],
)

#pagebreak()
=== Reading seasonally adjusted data

Most economic analysts who study unemployment data are more interested in the  variation due to the underlying state of the economy rather than the seasonal variation:

- An increase in unemployment due to school leavers seeking work is seasonal variation.
- While an increase in unemployment due to an economic recession is non-seasonal.

Consequently, employment data (and many other economic series) are usually *seasonally adjusted*.

However, if the purpose is to look for "turning points" in a series, and interpret any "changes in direction", then it is better to use the *trend-cycle component* rather than the seasonally adjusted data.

= Multiple seasonal components

#pagebreak()

For some time series (e.g., those that are observed at least daily), there can be more than one seasonal component, corresponding to the different seasonal periods. In fact, we have seen this in the seasonal plots for half-hourly Victorian electricity demand (2012–2015):

- *yearly*: Southern-hemisphere summers (December–February) show high variation and frequent spikes — hot days drive air-conditioning load; winters (June–August) are also high and variable; autumn and spring are quieter.
- *weekly*: demand is lower on *weekends* than on *weekdays*, with a different intraday shape — two peaks, but a lower morning peak, especially on Sundays.
- *daily*:
  - Demand is lowest around *4 AM*, when most people are asleep.
  - From about *6 AM* demand rises as people wake up; it dips mid-day, then climbs around *5–6 PM* as people return home.
  - Demand falls through the evening.

== Example: Victorian electricity demand

Half-hourly Victorian electricity demand (2012–2015) carries *multiple* seasonal patterns — yearly, weekly, and daily — as we saw in the seasonal plots lesson.

#figure(
  image("/courses/Timeseries/assets/vic_elec_time.png", width: 100%),
  caption: [Half-hourly Victorian electricity demand, 2012–2015.],
)

With three years of half-hourly readings, daily and weekly cycles blur into a *dense band* — the raw series is too noisy to read without decomposition.


#link("https://facebook.github.io/prophet/")[Prophet]'s `plot_components()` fits an additive model and splits the series into a *trend* and *one smooth seasonal curve per _frequency_* (yearly, weekly, and daily), averaging across all observations in the history.

#pagebreak()

=== Trend-cycle component

#figure(
  image("/courses/Timeseries/assets/vic_elec_prophet_trend.png", width: 100%),
  caption: [Prophet trend component for Victorian half-hourly electricity demand.],
)

*Trend-cycle component* (*T_t*) — the slow-moving baseline Prophet keeps after smoothing out seasonal swings. Demand stays in a fairly narrow band over 2012–2014, matching the time plot.

#pagebreak()

=== Yearly seasonality

#figure(
  image("/courses/Timeseries/assets/vic_elec_prophet_yearly.png", width: 100%),
  caption: [Prophet yearly seasonal component (day of year).],
)

*Yearly ($S^("year")_t$)* — average adjustment by time of year. *Winter* (June–August in Melbourne) sits above trend; *autumn* (March–April) dips below. Summer hot-day spikes add variance but do not dominate the average curve.

#pagebreak()

=== Weekly seasonality

#figure(
  image("/courses/Timeseries/assets/vic_elec_prophet_weekly.png", width: 100%),
  caption: [Prophet weekly seasonal component (day of week).],
)

*Weekly ($S^("week")_t$)* — weekday demand is above trend; *Saturday* and *Sunday* sit well below — the same weekend effect visible on the weekly seasonal plot.

#pagebreak()

=== Daily seasonality

#figure(
  image("/courses/Timeseries/assets/vic_elec_prophet_daily.png", width: 100%),
  caption: [Prophet daily seasonal component (hour of day).],
)

*Daily ($S^("day")_t$)* — within-day cycle in MWh. Demand is lowest around *4 AM*, rises through the morning, and peaks around *6 PM* — the intraday shape from the daily seasonal plot, now on one smooth curve.
