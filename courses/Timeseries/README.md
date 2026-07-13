# Applied Timeseries Analysis

## M1. Visualizing Time Series

**Goals**:

1. Visualize time series and recognize trend, seasonality, and cycles.
2. Apply calendar, population, and inflation adjustments before modelling.

**Lessons**:

1. [Time Series Analysis](https://github.com/HassanAlgoz/AAI/releases/latest/download/Timeseries_01_time_series_analysis.pdf) (~70m)
2. [Seasonal plots](lessons/02_seasonal_plots-1.ipynb) (~64m)
3. [Adjustments](https://github.com/HassanAlgoz/AAI/releases/latest/download/Timeseries_05_adjustments.pdf) (~56m)

## M2. Correlation and Autocorrelation

**Goals**:

1. Explore relationships between series with scatterplots and correlation.
2. Measure autocorrelation within a series using lag plots and the ACF.

**Lessons**:

1. [Scatterplots and Correlation](https://github.com/HassanAlgoz/AAI/releases/latest/download/Timeseries_03_correlation.pdf) (~40m)
   - [Lab: Scatterplots and correlation](lessons/03_correlation.ipynb) (~44m)
2. [Autocorrelation](https://github.com/HassanAlgoz/AAI/releases/latest/download/Timeseries_04_autocorrelation.pdf) (~94m)
   - [Lab: Lag plots, autocorrelation, and white noise](lessons/04_autocorrelation.ipynb) (~83m)

## M3. Time Series Decomposition

**Goal**: decompose series into trend, seasonal, and remainder components.

**Lessons**:

1. [Additive Time Series Decomposition](https://github.com/HassanAlgoz/AAI/releases/latest/download/Timeseries_06_components_additive_decomp.pdf) (~67m)
2. [Multiplicative Time Series Decomposition](https://github.com/HassanAlgoz/AAI/releases/latest/download/Timeseries_07_multiplicative_decomp.pdf) (~38m)

## M4. Time Series Features

**Goal**: summarize series behavior with statistical, STL, and ACF features — and use them to characterize large collections of series.

**Lessons**:

1. [Time series features](lessons/09_ts_features-statistics.ipynb) (~41m)
2. [STL features](lessons/10_ts_features-stl.ipynb) (~42m)
3. [ACF features](lessons/11_ts_features-acf.ipynb) (~8m)

## M5. Forecasting

**Goals**:

1. Recognize when forecasting is required and what drives predictability.
2. Fit a baseline forecasting model with Prophet.

**Lessons**:

1. [Forecasting: An Introduction](https://github.com/HassanAlgoz/AAI/releases/latest/download/Timeseries_12_intro_forecast.pdf) (~74m)
2. [Quick start: forecasting page views with Prophet](lessons/13_prophet_forecast_quick_start.ipynb) (~27m)

## References

- [Forecasting: Principles and Practice (3rd ed)](https://otexts.com/fpp3/):
  - "We use it ourselves for masters students and third-year undergraduate students at Monash University, Australia".
  - "we only assume that readers are familiar with introductory statistics, and with high-school algebra. There are a couple of sections that also require knowledge of matrices, but these are flagged".
- [Dettling, M. (2020). Applied time series analysis. Seminar for Statistics, ETH Zürich.](https://ethz.ch/content/dam/ethz/special-interest/math/statistics/sfs/Education/Advanced_Studies/course-material-1921/Zeitreihen/ATSA_Script_v200504.pdf)
- [`Nixtla/tsfeatures`](https://github.com/Nixtla/tsfeatures): Python implementation of the R package `tsfeatures`.
- [Non-linear correlation detection with mutual information](https://polsys.github.io/ennemi/)
- [Abhishek Murthy - Backtesting Time Series Forecasting Algorithms in SKTime and SKForecast](https://www.youtube.com/watch?v=7NXCdfzr5d8)
- Datasets: https://opentimeseries.com/datasets/public_datasets/
- Kaggle: https://www.kaggle.com/learn/time-series
- Coursera: https://www.coursera.org/learn/practical-time-series-analysis
- Geospatial (Kaggle): https://www.kaggle.com/learn/geospatial-analysis
