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
    title: [Forecasting],
    subtitle: [An Introduction],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Forecastability

== Objectives

In this lesson we learn to:

+ Recognize *when* forecasting is required and why it matters.
+ Identify the four factors that drive *predictability*.
+ Distinguish situations where forecasts are useful from those no better than a coin toss.
+ Understand what *good* forecasts do — and do not — capture.

== What is forecasting?

#definition("Forecasting")[
  Forecasting is about predicting the future as accurately as possible, given all of the information available, including historical data and knowledge of any future events that might impact the forecasts.
]

Forecasting is a common statistical task in business, where it helps to inform decisions about the scheduling of production, transportation and personnel, and provides a guide to long-term strategic planning.

- Deciding whether to build another power generation plant in the next five years requires forecasts of future demand.
- Scheduling staff in a call centre next week requires forecasts of call volumes.
- Stocking an inventory requires forecasts of stock requirements.

#pagebreak()

=== Relation to goals and planning

#quote(
  [If we could first know where we are and whither we are tending, we could better judge what to do and how to do it.],
  attribution: [Abraham Lincoln],
)

- *Data*: "where we are".
- *Forecasting*: "whither we are tending".
- *Goals*: "what to do".
- *Planning*: "how to do it".

#pagebreak()

=== Forecast Horizon

- *Short-term forecasts* are needed for the scheduling of personnel, production and transportation. As part of the scheduling process, forecasts of demand are often also required.
- *Medium-term forecasts* are needed to determine future resource requirements, in order to purchase raw materials, hire personnel, or buy machinery and equipment.
- *Long-term forecasts* are used in strategic planning. Such decisions must take account of market opportunities, environmental factors and internal resources.

Forecasts can be required several years in advance (capital investments), or only a few minutes beforehand (telecommunication routing).

#pagebreak()

=== Systems, Expertise, Methods, and Organisational Support

- An organisation needs to develop a *forecasting system* that involves several approaches to predicting uncertain events.
- Such forecasting systems require the development of *expertise* in identifying forecasting problems, applying a range of *forecasting methods*, selecting appropriate methods for each problem, and evaluating and refining forecasting methods over time.
- It is also important to have strong *organisational support* for the use of formal forecasting methods if they are to be used successfully.

== Exercise: rank by difficulty

Some things are easier to forecast than others. can you rank the following from easiest to most difficult to forecast?

- daily electricity demand in 3 days time
- time of sunrise this day next year
- Google stock price tomorrow
- Google stock price in 6 months time
- maximum temperature tomorrow
- exchange rate of \$USD/AUS next week
- total sales of drugs in Australian pharmacies next month
- timing of next Halley's comet appearance

Note: while doing the exercise, think about what makes something *easy* or *difficult* to forecast.

#pagebreak()

=== Solution

1. time of sunrise this day next year
2. timing of next Halley's comet appearance
#pause
Why? highly predictable physical phenomena. Even though they are far in the future, the systems governing them are completely understood

3. #pause maximum temperature tomorrow
#pause
We have "very good models of meteorology." While we can't predict weather perfectly long-term, our models are highly accurate for short periods up to a few days.

#pagebreak()

4. daily electricity demand in 3 days time
#pause
It directly piggybacks off the accuracy of the weather forecast. Electricity demand is largely driven by heating and cooling. Because we can predict the temperature in three days well, we can easily predict how much electricity people will use to adjust to it.


5. #pause total sales of drugs in Australian pharmacies next month
#pause
Placed lower down because consumer and health behavior is "a little bit more difficult and a little bit more variable" than physical phenomena or temperature-driven metrics.

#pagebreak()
Lastly:

6. #pause Google stock price tomorrow
7. exchange rate of \$USD/AUS next week
8. Google stock price in 6 months time
#pause
Financial metrics are at the bottom of the list because they are highly volatile, fluctuate randomly, and are susceptible to feedback loops (where the forecast itself actually changes the outcome).

We only have one rule in such forecasts: the closer the event is, the easier it is to forecast, because it is likely to be similar to what it is right now.

== What makes forecasting easy or hard?

The predictability of an event or a quantity depends on several factors:

+ *Causality* — how well we understand the factors that contribute to it #pause
+ *Information* — how much high-signal-to-noise data is available #pause
+ *Similarity* — how similar the future is to the past #pause
+ *Reflexivity* — whether the forecasts can affect the thing we are trying to forecast (harder)

#pagebreak()

#figure(
  image("/courses/Timeseries/assets/four_factors.png", height: 90%),
  caption: [The four factors that make forecasting easy or hard.],
)

== Easy to predict: electricity demand

#figure(
  image("/courses/Timeseries/assets/fourexamples_bottom_left_electricity.png", height: 75%),
  caption: [Electricity demand is often highly predictable in the short term.],
)

Short-term forecasts of residential electricity demand can be highly accurate because all four conditions are usually satisfied.
#pagebreak()
+ Causality: demand is driven largely by temperatures, with smaller effects for calendar variation and economic conditions. #pause
+ Information: several years of demand data and many decades of weather data are usually available. #pause
+ Similarity: for short horizons (up to a few weeks), demand behaviour is similar to the past. #pause
+ Reflexivity: for most residential users, price does not depend on demand, so forecasts have little effect on behaviour.

== Difficult to predict: exchange rate

*Exchange rate*: is the price of one currency in terms of another. For example, the price of one US dollar in terms of one Australian dollar.

When forecasting exchange rates, only one of the conditions is satisfied:

+ there is plenty of available data.
However,

2. we have a limited understanding of the factors that affect exchange rate (causality)
3. the future may well differ from the past during a financial or political crisis (similarity)
4. and forecasts of the exchange rate have a direct effect on the exchange rate itself (reflexivity)

=== Self-fulfilling forecasts

If there are well-publicised forecasts that the exchange rate will increase, people immediately adjust the price they are willing to pay — the *forecasts are self-fulfilling*.

In a sense, the exchange rates become their own forecasts. This is an example of the *efficient market hypothesis*.

Consequently, forecasting whether the exchange rate will rise or fall tomorrow is about as predictable as forecasting whether a tossed coin will come down as a head or a tail. In both situations, you will be correct about 50% of the time.

== Limitations of forecasting

Often in forecasting, a key step is knowing when something can be forecast accurately, and when forecasts will be no better than tossing a coin.

Forecasters need to be aware of their own limitations, and not claim more than is possible.

See: #link("https://otexts.com/fpp3/judgmental.html#judgmental")[Chapter 6 Judgmental forecasts] in *Forecasting: Principles and Practice* by Rob J Hyndman and George Athanasopoulos.

== Good forecasts subtract noise

Good forecasts capture the genuine patterns and relationships which exist in the historical data, *but do not replicate past events that will not occur again* — i.e., spikes or dips caused by specific events or policies.

#figure(
  image("/courses/Timeseries/assets/us_retail_employment.png", height: 60%),
  caption: [A series with genuine structure — and occasional one-off shocks.],
)

== Good forecasts capture change

Many people wrongly assume that forecasts are not possible in a changing environment. Every environment is changing, and a good forecasting model captures the way in which things are changing.

What is normally assumed is that the *way* the environment is changing will continue into the future:

- a highly volatile environment will continue to be highly volatile;
- a business with fluctuating sales will continue to have fluctuating sales;
- an economy that has gone through booms and busts will continue to go through booms and busts.

A forecasting model is intended to capture the way things *move*, not just where things are.

== Conclusion

Forecasting is not about predicting everything — it is about knowing *when* a forecast is worth making and *what* a good forecast should capture.

+ *Not all targets are equally forecastable* — physical systems and temperature-driven demand are often easier than financial markets.
+ *Four factors drive predictability*: causality, information, similarity, and reflexivity.
+ *Honesty matters* — when reflexivity and volatility dominate, a coin toss may be as good as any model.
+ *Good forecasts* extract repeatable structure from history without copying one-off shocks, and model how things *change*, not just where they are today.

Next: we define *time series* and learn to read the patterns — trend, seasonality, and noise — that forecasting methods build on.
