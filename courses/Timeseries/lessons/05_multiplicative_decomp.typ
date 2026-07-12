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
    title: [Multiplicative Time Series Decomposition],
    subtitle: [Box-Cox transformations and Guerrero's method],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Multiplicative Time Series Decomposition

== Multiplicative decomposition

Additive Decomposition won't work well when the *amplitude* of the seasonal component *changes* with the level of the time series. That is, the difference between the _peak_ and the _trough_ increases or decreases across seasonal periods (common with economic time series).

#figure(
  image("/courses/Timeseries/assets/air_passengers_seasonal_amplitude.png", height: 60%),
  caption: [Airline passengers; amplitude grows from 44 in 1949 to 232 in 1960.],
)

#pagebreak()
When the variation in the seasonal pattern, or the variation around the trend-cycle, appears to be "proportional to the level of the time series", then a multiplicative decomposition is more appropriate.

*Multiplicative decomposition* is expressed as:

$ y_t = S_t times T_t times R_t $

Alternatively, we can apply a *transformation* to negate the multiplicative effect. Math shows us that one way to do this is to take the logarithm of the time series:

$
  y_t = S_t times T_t times R_t quad "is equivalent to" quad log y_t = log S_t + log T_t + log R_t.
$

In practice, `Prophet` is based on an additive model, so we'll have to do this transformation ourselves if we notice multiplicative variation in the time series.

== Logarithmic transformations

*Logarithms* are useful because they are interpretable: changes in a log value are *relative* (or percentage) changes on the original scale. So if log base 10 is used, then an increase of 1 on the log scale corresponds to a multiplication of 10 on the original scale.

#pagebreak()
=== Example: Log-transformation on air passenger bookings

For illustration, we carry out a log-transformation on the air passenger bookings:

#figure(
  image("/courses/Timeseries/assets/air_passengers_log_transform.png", width: 100%),
  caption: [Original scale (left) and natural-log scale (right). Shaded bands mark 1949 and 1960; seasonal swings grow from 44 to 232 on the original scale but stay closer on the log scale (right).],
)

== Power transformations

If any value of the original series is zero or negative, then logarithms are not possible.

Sometimes other transformations are also used (although they are not so interpretable). For example, square roots and cube roots can be used. These are called *power transformations* because they can be written in the form $w_t = y_t^p$.

#table(
  columns: (auto, 0.40fr, 0.10fr, 1fr),
  inset: (x: 0.75em, y: 1em),
  table.header(
    [*Transformation*], [*Formula*], [$p$], [*Requirement on* $y_t$],
  ),
  [Square root], [$w_t = sqrt(y_t)$], [$1/2$], [$y_t >= 0$],
  [Cube root], [$w_t = root(3, y_t)$], [$1/3$], [any real value],
)

== Box-Cox family

A useful family of transformations, that includes both logarithms *and* power transformations, is the family of *Box-Cox transformations* (Box & Cox, 1964), which depend on the parameter $lambda$ and are defined as follows:

$
  w_t = cases(
    log(y_t) & "if" lambda = 0,
    (op("sign")(y_t) |y_t|^lambda - 1) / lambda & "otherwise"
  )
$
#text[
  #set text(size: 0.80em)
  This is actually a modified Box-Cox transformation, discussed in Bickel & Doksum (1981), which allows for negative values of $y_t$ provided $lambda > 0$.
]

A good value of $lambda$ is one which makes the size of the seasonal variation about the same across the whole series, as that makes the forecasting model simpler.

#pagebreak()
=== Example: Box-Cox on gas production

#figure(
  image("/courses/Timeseries/assets/box_cox_gas_lambdas.png", width: 100%),
  caption: [Increasing labmda to the right, reduces the seasonal variation.],
)

In this case, $lambda = 0.10$ works quite well, although any value of $lambda$ between 0.0 and 0.2 would give similar results.

== Guerrero's method

Fortunately, the *guerrero feature* (Guerrero, 1993) automatically selects the best value of $lambda$ for you.

#figure(
  image("/courses/Timeseries/assets/gas_box_cox_guerrero.png", height: 68%),
  caption: [Transformed Australian quarterly gas production with the $lambda = 0.11$ parameter chosen using the Guerrero method.],
)
