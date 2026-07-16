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
    title: [Model Evaluation],
    subtitle: [Diagnostics and Accuracy Measures],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Model Evaluation

== Establishing a Baseline

#definition("benchmark")[
  A *benchmark* is a baseline for comparison.
]

We will use four simple forecasting methods as *benchmarks* throughout this course:

- Mean method
- Naïve method
- Seasonal naïve method
- Drift method

Any new method we develop should beat these simple alternatives — if it does not, it is not worth considering.

== Mean method

Forecasts of all future values equal the average of the historical data $y_1, dots, y_T$:

$ hat(y)_(T+h|T) = overline(y) = (y_1 + dots + y_T) / T $

#figure(
  image("/courses/Timeseries/assets/bricks_mean_forecast.png", height: 65%),
  caption: [Mean forecasts for Australian clay brick production (1970–2004).],
)

== Naïve method

All forecasts equal the last observation:

$ hat(y)_(T+h|T) = y_T $

Works well for many economic and financial series. Optimal for a random walk.

#figure(
  image("/courses/Timeseries/assets/bricks_naive_forecast.png", height: 58%),
  caption: [Naïve forecasts for Australian clay brick production (1970–2004).],
)

== Seasonal naïve method

Useful for highly seasonal data: each forecast equals the last observed value from the same season (e.g. the same month of the previous year):

$ hat(y)_(T+h|T) = y_(T+h-m(k+1)) $

where $m$ is the seasonal period, and $k$ is the integer part of $(h-1)/m$ (complete seasons in the forecast horizon before time $T+h$).

#figure(
  image("/courses/Timeseries/assets/bricks_seasonal_naive_forecast.png", height: 45%),
  caption: [Seasonal naïve forecasts for Australian clay brick production (1970–2004).],
)

== Drift method

A variation on the naïve method: forecasts increase or decrease by the average change (*drift*) seen in the historical data:

$ hat(y)_(T+h|T) = y_T + h ((y_T - y_1) / (T-1)) $

Equivalent to drawing a line between the first and last observations and extrapolating it into the future.

#figure(
  image("/courses/Timeseries/assets/bricks_drift_forecast.png", height: 40%),
  caption: [Drift forecasts for Australian clay brick production (1970–2004).],
)

= Residuals

== Fitted Values and Residuals

A *fitted value* is the forecast of an observation in a time series based on previous observations. It is denoted by $hat(y)_(t|t-1)$ (often simplified to $hat(y)_t$), representing the forecast of $y_t$ based on the historical observations $y_1, dots, y_(t-1)$.

*Residuals* in a time series model are what is left over after fitting a model. They are equal to the difference between the actual observations and their corresponding fitted values:

$ e_t = y_t - hat(y)_t $

#figure(
  image("/courses/Timeseries/assets/bricks_seasonal_naive_residuals.png", width: 100%),
  caption: [On the training window, each red vertical line is a residual $e_t = y_t - hat(y)_t$ between the observation (black) and the seasonal-naïve fitted values (blue).],
)

== Residual Diagnostics

A good forecasting method will yield residuals with the following properties:

1. *Zero mean*: If they have a mean other than zero, then the forecasts are biased.
2. *Uncorrelated*: If there are correlations between residuals, then there is information left in the residuals which should be used in computing forecasts.

Any forecasting method that does not satisfy these properties can be improved. Checking these properties shows whether a method is using all of the available information.

#pagebreak()
=== Residuals Plot

#figure(
  image("/courses/Timeseries/assets/google_2015_naive_residuals.png", width: 100%),
  caption: [Residuals from forecasting the Google stock price using the naïve method. The large spike is the unexpected jump on 17 July 2015.],
)

#pagebreak()
=== Histogram of Residuals
#figure(
  image("/courses/Timeseries/assets/google_2015_naive_residuals_hist.png", width: 80%),
  caption: [Histogram of the residuals from the naïve method. The right tail seems a little too long for a normal distribution, suggesting biased model.],
)

#pagebreak()
=== ACF Plot of Residuals
#figure(
  image("/courses/Timeseries/assets/google_2015_naive_residuals_acf.png", height: 65%),
  caption: [ACF of the residuals from the naïve method. Lack of correlation suggests the forecasts do account for available information.],
)

Note: *Ljung-Box test* automatically checks for autocorrelation in residuals.

#pagebreak()
=== All in One
#figure(
  image("/courses/Timeseries/assets/google_2015_naive_residuals_diagnostics.png", height: 85%),
  caption: [Residual diagnostic graphs for the naïve method applied to the data.],
)

= Evaluating point forecast accuracy

== Training and test sets

The accuracy of forecasts can only be determined by considering how well a model performs on *new data* that were not used when fitting the model.

When choosing models, it is common practice to separate the available data into two portions:

+ *Training data*
+ *Test data*

#figure(
  image("/courses/Timeseries/assets/ts_train_test.png", width: 100%),
  caption: [Training and test data for a time series.],
)

The test set should ideally be at least as large as the *maximum forecast horizon* required.

#pagebreak()
=== Overfitting

- A model which fits the training data well will not necessarily forecast well.
- A perfect fit can always be obtained by using a model with enough parameters.
- *Over-fitting* a model to training data is just as bad as failing to identify a systematic pattern in it.

== Forecast errors

A forecast *error* is the difference between an observed value and its forecast — not a mistake, but the unpredictable part of an observation:

$ e_(T+h) = y_(T+h) - hat(y)_(T+h|T) $

where the training data are ${y_1, dots, y_T}$ and the test data are ${y_(T+1), y_(T+2), dots}$.

Forecast errors differ from residuals in two ways:
- residuals are computed on the *training* set; forecast errors on the *test* set
- residuals are based on *one-step* forecasts; forecast errors can be *multi-step*

We summarise forecast errors with accuracy measures.

#pagebreak()
=== Scale-dependent errors

Forecast errors are on the same scale as the data. Measures based only on $e_t$ are therefore *scale-dependent* — they cannot compare series with different units.

The two most common scale-dependent measures:

$ "MAE" = "mean"(|e_t|) $

$ "RMSE" = sqrt("mean"(e_t^2)) $

- Minimising MAE leads to forecasts of the *median*
- Minimising RMSE leads to forecasts of the *mean*

MAE is popular for a single series (or several series with the same units) because it is easy to understand and compute.

#pagebreak()
=== Percentage errors

The percentage error is $p_t = 100 e_t / y_t$. Percentage errors are unit-free, so they can compare forecast performance across data sets. The most common measure:

$ "MAPE" = "mean"(|p_t|) $

Disadvantages:
- infinite or undefined if $y_t = 0$ for any $t$ of interest
- extreme values when $y_t$ is close to zero
- require a *meaningful zero* (e.g. percentage errors make no sense for Celsius/Fahrenheit temperature)

They also penalise negative errors more heavily than positive ones. The “symmetric” MAPE (sMAPE) was proposed to address this, but Hyndman & Koehler (2006) recommend *not* using it.

#pagebreak()
=== Scaled errors

Scaled errors (Hyndman & Koehler, 2006) scale forecast errors by the training MAE of a simple benchmark, so accuracy can be compared across series with different units.

For a non-seasonal series, using naïve forecasts:

$ q_j = e_j / (1/(T-1) sum_(t=2)^T |y_t - y_(t-1)|) $

For a seasonal series with period $m$, using seasonal naïve:

$ q_j = e_j / (1/(T-m) sum_(t=m+1)^T |y_t - y_(t-m)|) $

#pagebreak()
Then:

$ "MASE" = "mean"(|q_j|) $

$ "RMSSE" = sqrt("mean"(q_j^2)) $

A scaled error is *less than one* if the forecast beats the average one-step naïve (or seasonal naïve) forecast on the training data, and *greater than one* if it is worse.

= Evaluating distributional forecast accuracy

#pagebreak()
The preceding measures all assess *point* forecast accuracy. For *distributional* forecasts (full predictive distributions or prediction intervals), we need other scores.

== Quantile scores

Let $f_(p,t)$ be the quantile forecast with probability $p$ at time $t$ — we expect $y_t < f_(p,t)$ with probability $p$. The *quantile score* (pinball loss) is:

$ Q_(p,t) = cases(
  2(1 - p)(f_(p,t) - y_t) & "if" y_t < f_(p,t),
  2p(y_t - f_(p,t)) & "if" y_t >= f_(p,t),
) $

A low $Q_(p,t)$ means a better quantile estimate.

- When $p = 0.5$, $Q_(0.5,t)$ equals the absolute error
- When $p > 0.5$, overshoots of the observation above the quantile are penalised more heavily
- When $p < 0.5$, the reverse holds

#pagebreak()
=== Winkler score

To score a whole $100(1-alpha)%$ prediction interval $[ell_(alpha,t), u_(alpha,t)]$ rather than a single quantile, use the *Winkler score*:

$ W_(alpha,t) = cases(
  (u_(alpha,t) - ell_(alpha,t)) + (2/alpha)(ell_(alpha,t) - y_t) & "if" y_t < ell_(alpha,t),
  (u_(alpha,t) - ell_(alpha,t)) & "if" ell_(alpha,t) <= y_t <= u_(alpha,t),
  (u_(alpha,t) - ell_(alpha,t)) + (2/alpha)(y_t - u_(alpha,t)) & "if" y_t > u_(alpha,t),
) $

Inside the interval, the score is just the interval length (narrower is better). Outside, a penalty grows with how far the observation falls beyond the bounds.

If $ell_(alpha,t) = f_(alpha/2,t)$ and $u_(alpha,t) = f_(1 - alpha/2,t)$, then:

$ W_(alpha,t) = (Q_(alpha/2,t) + Q_(1 - alpha/2,t)) / alpha $

#pagebreak()
== CRPS

When we care about the *entire* forecast distribution, average quantile scores over all $p$ to get the *Continuous Ranked Probability Score* (CRPS).

CRPS is like a weighted absolute error computed from the full forecast distribution, with weights reflecting the probabilities. *Lower is better*.

#pagebreak()
=== Scale-free comparisons using skill scores

To compare distributional (or point) accuracy across series on different scales, use a *skill score* relative to a benchmark. With naïve as the benchmark:

$ ("CRPS"_"Naïve" - "CRPS"_"method") / "CRPS"_"Naïve" $

This is the proportion by which the method improves on the naïve method under CRPS.

- Positive skill: better than the benchmark
- Zero skill: same as the benchmark (e.g. naïve vs itself)
- Negative skill: worse than the benchmark

For seasonal data, the usual benchmark is *seasonal naïve* rather than naïve.

Skill scores work with any accuracy measure (e.g. MSE), but the test set must be large enough for a stable denominator.

For *point forecasts*, MASE or RMSSE are often preferable scale-free measures.

= Takeaways

== Takeaways

- Models must pass simple *baseline* models to be considered useful.
- Residuals with non-zero mean indicate bias in the forecasts.
- Autocorrelated residuals indicate that the model is not using all of the available information.
- *Overfit*: A model which fits the training data well will not necessarily forecast well.
- Point Forecast Errors
    - MAE is popular for single series (or several series with the same units) because it is easy to understand and compute.
    - MAPE is unit-free, but penalise negative errors more heavily than positive ones.
    - *Scaled Errors* (MASE and RMSSE) are recommended since they are comparable across series with different units.
- Distributional Forecast Errors
    - *CRPS* is used to measure the quality of distributional forecasts.
    - It builds on the ideas of Winkler score for intervals, which is built on Quantile scores.