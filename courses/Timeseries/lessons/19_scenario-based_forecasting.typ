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
    title: [Scenario-based Forecasting],
    subtitle: [Correlation, multicollinearity, and what-if forecasts],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Correlation

== Correlation $!=$ Causation

Correlation means two things *move together*. It does *not* mean one *causes* the other.

A variable $x$ can still help forecast $y$ even when $x$ does not cause $y$.

=== A hidden third variable

Ice-cream sales and beach drownings both go up in summer. You could forecast drownings from ice-cream sales — and it might work.

But ice-cream does not cause drownings. *Hot weather* causes both: more swimming *and* more ice-cream.

That hidden third variable is a *confounder*. It makes causal stories hard, but forecasts can still be useful.

=== Cause and effect the wrong way round

Suppose we forecast afternoon rain ($y$) from the number of morning cyclists ($x$).
Fewer cyclists $arrow$ higher chance of rain. That forecast can work.

But cyclists do not *cause* the rain. What happens is the reverse:

- the morning weather report already warns of rain;
- so many people leave their bikes at home;
- later, it rains as predicted.

We used $x$ to forecast $y$, but the coming rain (via the weather report) is what changed $x$.

#pagebreak()

=== Still useful for forecasting

For forecasting, correlation is often enough — even with no real cause, the wrong direction of cause, or a confounder.

A *better* model usually uses the real drivers: temperature and visitors for drownings; weather data for rain — not ice-cream or cyclists.

Use correlation as a first look. Do not treat it as proof of cause.

== Correlated predictors

When two predictors move together a lot, it is hard to say *how much* each one matters on its own.

Example: you forecast monthly sales. In 2008 a new competitor arrives *and* the economy weakens at the same time. Your model includes both competitor activity and GDP. Those two predictors are highly correlated — so you cannot cleanly split their effects.

This is often fine, unless you need more than a forecast: #pause

- *scenario forecasting* — “what if GDP rises but the competitor stays the same?” needs realistic links between predictors;
- *historical analysis* — “how much did each predictor contribute?” becomes unreliable.

== Multicollinearity

*Multicollinearity* means two or more predictors carry *similar information*. Knowing one tells you a lot about the other.

Simple example: left-foot size and right-foot size. Either can help predict height. Putting *both* in the same model does not help much (and does not usually hurt the forecast either).

= Scenario-based Forecasting

Adapted from #link("https://otexts.com/fpp3/forecasting-regression.html#scenario-based-forecasting")[FPP3 §7.6] and #link("https://otexts.com/fpp3/scenarios.html")[§6.5].

The *how* (Prophet, code, plots) is in the lab notebook. Here we only need the *idea*.

== A shop example

You run a shop. Each month you record:

- *sales* — revenue that month (what you want to forecast);
- *marketing spend* — money spent on ads (you choose this);
- *average price* — how expensive items were (you can also change this).

Sales depend on marketing (and often on price). Next quarter you might:

- keep marketing as usual (*Baseline*);
- spend much more (*Aggressive*);
- cut the budget (*Cutback*).

For each plan you ask: “If we set marketing like *this*, what do sales look like?” You get three different sales paths — one per plan.

In the lab you will build exactly this kind of comparison.

== Scenario-based Forecasting

Call sales the target $y$.

Call marketing spend (and price, if used) the *drivers* or *predictors* — we write them as $x$. A driver is an input the model uses to explain $y$. In the shop, the main $x$ is marketing spend.

That whole process is *scenario-based forecasting*:

- a normal forecast asks what is *likely* next for $y$;
- a scenario forecast asks what happens to $y$ *if* we assume a particular future path for $x$ (e.g. Aggressive marketing).

== How the model uses the plan

A regression-style model needs future values of every $x$ before it can forecast $y$.

For the shop: you must tell the model next month’s marketing spend (and price, if it is in the model). You can try to *forecast* those $x$ values — or you can *assume* them. Assuming them *is* the scenario.

Chosen future marketing path ($x$) $arrow$ plug into the model $arrow$ forecast sales path ($hat(y)$).

== Who chooses $x$?

Some $x$ you control: marketing spend, price, promotions. Changing their future path *is* the scenario (“what if we spend more?”).

Some $x$ you do not: GDP, weather, competitor moves. Then the scenario is “what if the economy is strong / weak?”

== Stay inside the data you trained on

A model only “knows” the predictor values it saw while training.

Example: in the training data, temperature ranged from $0$ to $30$°C. If you later plug in $45$°C, the forecast is a guess outside the model’s experience. That is always risky. With multicollinearity it is *more* risky, because the fitted relationships among predictors were learned only inside that old range.

== Takeaways

+ $y$ = sales; $x$ = drivers such as marketing spend (and price).
+ A scenario = assumed future values of $x$.
+ Different $x$ plans $arrow$ different sales paths $hat(y)$.

