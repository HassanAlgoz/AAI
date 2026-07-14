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
    title: [The Prophet Model],
    subtitle: [Selecting the Best Time Series Model],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= The Prophet Model

== Models Evolution History

=== The Foundations of Modern Forecasting

*Exponential Smoothing (ETS)* (Late 1950s): Developed during the early days of computing. Because calculating power was highly limited, these models were designed to be computationally lightweight, using simple, recursive, weighted averages to smooth out trends and seasonal patterns.

*ARIMA* (1970): Developed as computer processing power advanced enough to handle more complex mathematical iterations. This framework shifted the focus from visually dissecting trends to mathematically analyzing how a data point correlates with its own past values (autocorrelation).

#pagebreak()
*Exponential smoothing (ETS)* and *ARIMA* models are the two most widely used approaches to time series forecasting, and provide complementary approaches to the problem. While exponential smoothing models are based on a description of the trend and seasonality in the data, ARIMA models aim to describe the autocorrelations in the data.

Both allow for the inclusion of information from past observations of a series, but not for the inclusion of other information that may also be relevant.

For example, these effects may explain some of the historical variation and may lead to more accurate forecasts:
+ holidays, 
+ competitor activity, 
+ changes in the law, 
+ the wider economy, 

#pagebreak()
=== Regression Models

On the other hand, *regression* models allow for that, but do not allow for the subtle time series dynamics that can be handled with ARIMA models.

Note: regression models were developed independently by Carl Friedrich Gauss (1809) to predict the motion of the planets.

*Dynamic regression models*, popularized by Box-Jenkins in the 1970s, were developed to combine the benefits of the two:
+ *ARIMA models*: inlcude information from past observations of a series
+ *Regression models*: include information from other variables that may be relevant

#pagebreak()
=== Harmonic Regression
*Harmonic Regression*, developed in 1898 by Arthur Schuster, applying Joseph Fourier's mathematics (1807-1822) for finding "hidden" cycles in nature: e.g., weather seasons, solar sunspots, ocean tides, and magnetic storms.

#quote[When there are *long seasonal periods*, a dynamic regression with *Fourier terms* is often better than any of models we have considered so far.] -- fpp3

We call this model a *Dynamic Harmonic Regression (DHR)* Model.

== Prophet
A recent development in the field of time series forecasting is the *Prophet* model, introduced by Facebook (#link("https://www.tandfonline.com/doi/full/10.1080/00031305.2017.1380080")[S. J. Taylor & Letham, 2018: Forecasting at Scale]). It is:

#quote(block: true)[A modular harmonic regression model with analyst-in-the-loop performance analysis with interpretable parameters that can be intuitively adjusted by analysts with domain knowledge.]

The model is estimated using a Bayesian approach to allow for automatic selection of the changepoints and other model characteristics.

Similar to STL; it models the series as:

$ y_t = g(t) + s(t) + h(t) + epsilon_t $

#pagebreak()
Where:
- $g(t)$ is a piecewise-linear trend (or “growth term”)
  - The knots (or changepoints) for the piecewise-linear trend are automatically selected if not explicitly specified. Optionally, a logistic function can be used to set an upper bound on the trend.
- $s(t)$ describes the various seasonal patterns
  - The seasonal component consists of Fourier terms (sines and cosines) of the relevant periods. By default, order 10 is used for annual seasonality and order 3 is used for weekly seasonality.
- $h(t)$ captures the holiday effects
  - Holiday effects are added as simple dummy variables.
- $epsilon_t$ is a white noise error term.

== Foundation Models

TimeGPT-1 and others...

