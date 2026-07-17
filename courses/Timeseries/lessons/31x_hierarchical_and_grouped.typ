#import "@preview/touying:0.6.1": *
#import "@preview/curryst:0.5.1" as curryst: rule
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#import "/template/theme.typ": *

#show: university-theme.with(
  config-colors(
    primary: primary-color,
    secondary: secondary-color,
    tertiary: tertiary-color,
    neutral-darkest: text-color
  ),
  config-info(
    title: [Hierarchical and Grouped Time Series],
    subtitle: [Aggregation structures and forecast coherence],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

#let bent-edge(from, to, ..args) = {
  let midpoint = (from, 50%, to)
  let vertices = (
    from,
    (from, "|-", midpoint),
    (midpoint, "-|", to),
    to,
  )
  edge(..vertices, "-|>", ..args)
}

= Hierarchical and Grouped Time Series

Time series can often be naturally disaggregated by various attributes of interest.

== Hierarchical Time Series

A *hierarchical time series* is a collection of time series that can be aggregated according to a nested structure of attributes (type $->$ subtypes).

#pause
For example, the total number of bicycles sold by a cycling manufacturer can be disaggregated by *product type*, such as:

- A) road bikes
- B) mountain bikes
- C) hybrids; which can be disaggregated into finer categories. For example:
  - C1) city
  - C2) commuting
  - C3) comfort
  - C4) trekking bikes

#pagebreak()

#align(center)[
  #diagram(
    node-stroke: luma(80%),
    edge-corner-radius: none,
    spacing: (12pt, 28pt),

    node((3, 0), [*Total bicycles sold*], name: <total>),
    node((0, 1.5), [road bikes], name: <road>),
    node((2, 1.5), [mountain bikes], name: <mtn>),
    node((4.5, 1.5), [hybrids], name: <hyb>),

    node((3, 3), [city], name: <city>),
    node((4, 3), [commuting], name: <comm>),
    node((5, 3), [comfort], name: <comfort>),
    node((6, 3), [trekking], name: <trek>),

    bent-edge(<total>, <road>),
    bent-edge(<total>, <mtn>),
    bent-edge(<total>, <hyb>),
    bent-edge(<hyb>, <city>),
    bent-edge(<hyb>, <comm>),
    bent-edge(<hyb>, <comfort>),
    bent-edge(<hyb>, <trek>),
  )
]

These categories are nested within the larger group categories, and so the collection of time series follows a hierarchical aggregation structure. Therefore we refer to these as *hierarchical time series*.

#pagebreak()

=== Geographic Divisions

#grid(
  columns: (1fr, 1.8fr),
  gutter: 1.5em,
  align(center + horizon)[
    #diagram(
      node-stroke: luma(80%),
      edge-corner-radius: none,
      spacing: (16pt, 28pt),

      node((0, 0), [*Country*], name: <country>),
      node((0, 1.2), [State], name: <state>),
      node((0, 2.4), [Region], name: <region>),
      node((0, 3.6), [...], name: <etc>),
      node((0, 4.8), [Outlet], name: <outlet>),

      edge(<country>, <state>, "-|>"),
      edge(<state>, <region>, "-|>"),
      edge(<region>, <etc>, "-|>"),
      edge(<etc>, <outlet>, "-|>", stroke: (dash: "dashed")),
    )
  ],
  align(horizon)[
    #pause
    Hierarchical time series often arise due to *geographic divisions*. For example, the *total bicycle sales* can be disaggregated:

    + *by country*, then within each country:
      + *by state*, within each state:
        + *by region*,
          - ... and so on down to the *outlet level*.
  ],
)

#pagebreak()

== Grouped Time Series

A *grouped time series* is a collection of time series formed by *crossing* attributes in no one unique hierarchical structure.

For example, the bicycle manufacturer may be interested in attributes such as:

- frame size (S, M, L)
- gender (male, female)
- price range (low, medium, high)

#pagebreak()

#grid(
  columns: (1fr, 1fr),
  gutter: 1.5em,
  align(center)[
    *Size → Gender*
    #diagram(
      node-stroke: luma(80%),
      edge-corner-radius: none,
      spacing: (8pt, 20pt),

      node((2, 0), [*Total*], name: <total>),
      node((0, 1.2), [S], name: <s>),
      node((2, 1.2), [M], name: <m>),
      node((4, 1.2), [L], name: <l>),

      node((-0.5, 2.4), [F], name: <sf>),
      node((0.5, 2.4), [M], name: <sm>),
      node((1.5, 2.4), [F], name: <mf>),
      node((2.5, 2.4), [M], name: <mm>),
      node((3.5, 2.4), [F], name: <lf>),
      node((4.5, 2.4), [M], name: <lm>),

      edge(<total>, <s>, "-|>"),
      edge(<total>, <m>, "-|>"),
      edge(<total>, <l>, "-|>"),
      edge(<s>, <sf>, "-|>"),
      edge(<s>, <sm>, "-|>"),
      edge(<m>, <mf>, "-|>"),
      edge(<m>, <mm>, "-|>"),
      edge(<l>, <lf>, "-|>"),
      edge(<l>, <lm>, "-|>"),
    )
  ],
  align(center)[
    *Gender → Size*
    #diagram(
      node-stroke: luma(80%),
      edge-corner-radius: none,
      spacing: (8pt, 20pt),

      node((2, 0), [*Total*], name: <total>),
      node((0.5, 1.2), [Female], name: <f>),
      node((3.5, 1.2), [Male], name: <male>),

      node((-0.3, 2.4), [S], name: <fs>),
      node((0.5, 2.4), [M], name: <fm>),
      node((1.3, 2.4), [L], name: <fl>),
      node((2.7, 2.4), [S], name: <ms>),
      node((3.5, 2.4), [M], name: <mm>),
      node((4.3, 2.4), [L], name: <ml>),

      edge(<total>, <f>, "-|>"),
      edge(<total>, <male>, "-|>"),
      edge(<f>, <fs>, "-|>"),
      edge(<f>, <fm>, "-|>"),
      edge(<f>, <fl>, "-|>"),
      edge(<male>, <ms>, "-|>"),
      edge(<male>, <mm>, "-|>"),
      edge(<male>, <ml>, "-|>"),
    )
  ],
)

Such attributes do not naturally disaggregate in a unique hierarchical manner as the attributes are not nested. In this case, the number of possible permutations is: $P = n!$ where $n$ is the number of features. So for $3$ features, there are $3! = 6$ possible hierarchies.

We refer to the resulting time series of crossed attributes as *grouped time series*.

== Forecast Coherence

*Coherence* means the forecasts for sub-categories perfectly add up to the forecasts for their parents.

For example:

- forecasts of *regional sales* should add up to
  - forecasts of *state sales*, which should in turn add up to
    - forecasts for *national sales*

#pagebreak()

=== Base Forecasts vs Coherent Forecasts

If we fit a model to each series *independently*, we get *base forecasts* (often written $hat(y)$). #pause
These almost never add up: the sum of regional forecasts will not match the national forecast.

#pause
We need a rule that turns base forecasts into *coherent* forecasts (written $tilde(y)$) so parents and children agree.

#pagebreak()

Two families of methods:

+ *Single-level approaches* — trust forecasts from *one* layer of the structure, then aggregate up or disaggregate down.
+ *Forecast reconciliation* — forecast *all* layers, then jointly adjust them so they become coherent.

= Forecasting

== Single-Level Approaches

#grid(
  columns: (1fr, 1.15fr),
  gutter: 1.2em,
  align(center + horizon)[
    #diagram(
      node-stroke: luma(80%),
      edge-corner-radius: none,
      spacing: (12pt, 22pt),

      node((1.5, 0), [Total\ _(derived)_], name: <total>),
      node((0, 1.5), [*Chosen*\ *level*], fill: luma(92%), name: <mid-a>),
      node((3, 1.5), [*Chosen*\ *level*], fill: luma(92%), name: <mid-b>),
      node((-0.2, 3), [leaf], name: <aa>),
      node((0.9, 3), [leaf], name: <ab>),
      node((2.4, 3), [leaf], name: <ba>),
      node((3.6, 3), [leaf], name: <bb>),

      edge(<mid-a>, <total>, "-|>", stroke: 1.2pt, label: text(size: 0.7em)[sum ↑]),
      edge(<mid-b>, <total>, "-|>", stroke: 1.2pt),
      edge(<mid-a>, <aa>, "-|>", stroke: 1.2pt + luma(40%), label: text(size: 0.7em)[split ↓]),
      edge(<mid-a>, <ab>, "-|>", stroke: 1.2pt + luma(40%)),
      edge(<mid-b>, <ba>, "-|>", stroke: 1.2pt + luma(40%)),
      edge(<mid-b>, <bb>, "-|>", stroke: 1.2pt + luma(40%)),
    )
    #text(size: 0.8em)[Forecast *one* layer; derive the rest]
  ],
  align(horizon)[
    #pause
    Traditionally, forecasts of hierarchical or grouped time series involved selecting *one* level of aggregation and generating forecasts for that level.

    These are then either *aggregated* for higher levels, or *disaggregated* for lower levels, to obtain a set of coherent forecasts for the rest of the structure.
  ],
)

#pagebreak()

=== The Bottom-Up Approach

*Bottom-up*: forecast every series at the *bottom* level, then *sum upward* to obtain forecasts for all parents.

#grid(
  columns: (1fr, 1.1fr),
  gutter: 1.2em,
  align(center + horizon)[
    #diagram(
      node-stroke: luma(80%),
      edge-corner-radius: none,
      spacing: (14pt, 26pt),

      node((2, 0), [*Total* $tilde(y)$], name: <total>),
      node((0.5, 1.4), [A], name: <a>),
      node((3.5, 1.4), [B], name: <b>),
      node((0, 2.8), [*AA*], fill: luma(92%), name: <aa>),
      node((1, 2.8), [*AB*], fill: luma(92%), name: <ab>),
      node((3, 2.8), [*BA*], fill: luma(92%), name: <ba>),
      node((4, 2.8), [*BB*], fill: luma(92%), name: <bb>),

      edge(<aa>, <a>, "-|>", stroke: 1.2pt),
      edge(<ab>, <a>, "-|>", stroke: 1.2pt),
      edge(<ba>, <b>, "-|>", stroke: 1.2pt),
      edge(<bb>, <b>, "-|>", stroke: 1.2pt),
      edge(<a>, <total>, "-|>", stroke: 1.2pt),
      edge(<b>, <total>, "-|>", stroke: 1.2pt),
    )
    #text(size: 0.85em)[Arrows *up*: sum bottom forecasts]
  ],
  align(horizon)[
    #pause
    + Generate $h$-step forecasts for each bottom series.
    + Sum children to get each parent; sum again for the total.
    + Coherence is automatic: by construction, children add to parents.

    In software (e.g. Nixtla), this is `BottomUp()`.
  ],
)

#pagebreak()

- *Advantage*: no information lost to aggregation — we model the finest detail.
- *Disadvantage*: bottom-level data are often *noisy* and hard to forecast.

#pagebreak()

=== Top-Down Approaches

*Top-down*: forecast the *Total* series, then *disaggregate* downward using proportions $p_j$ that allocate the total to each bottom series.

#grid(
  columns: (1fr, 1.1fr),
  gutter: 1.2em,
  align(center + horizon)[
    #diagram(
      node-stroke: luma(80%),
      edge-corner-radius: none,
      spacing: (14pt, 26pt),

      node((2, 0), [*Total* $hat(y)$], fill: luma(92%), name: <total>),
      node((0.5, 1.4), [A], name: <a>),
      node((3.5, 1.4), [B], name: <b>),
      node((0, 2.8), [AA\ $p_1$], name: <aa>),
      node((1, 2.8), [AB\ $p_2$], name: <ab>),
      node((3, 2.8), [BA\ $p_3$], name: <ba>),
      node((4, 2.8), [BB\ $p_4$], name: <bb>),

      edge(<total>, <a>, "-|>", stroke: 1.2pt),
      edge(<total>, <b>, "-|>", stroke: 1.2pt),
      edge(<a>, <aa>, "-|>", stroke: 1.2pt),
      edge(<a>, <ab>, "-|>", stroke: 1.2pt),
      edge(<b>, <ba>, "-|>", stroke: 1.2pt),
      edge(<b>, <bb>, "-|>", stroke: 1.2pt),
    )
    #text(size: 0.85em)[Arrows *down*: split with proportions]
  ],
  align(horizon)[
    #pause
    Once bottom-level coherent forecasts exist, sum them upward for the middle levels.

    In software: `TopDown()`.
  ],
)

#pagebreak()

- *Advantage*: simple — model only the top series; often reliable for aggregates and useful with *low-count* data.
- *Disadvantage*: aggregation hides series-specific dynamics, seasonality, and special events.

#pagebreak()

=== Middle-Out Approach

*Middle-out*: choose a *middle* level; forecast there, *sum upward* (bottom-up), and *disaggregate downward* (top-down).

#grid(
  columns: (1fr, 1.1fr),
  gutter: 1.2em,
  align(center + horizon)[
    #diagram(
      node-stroke: luma(80%),
      edge-corner-radius: none,
      spacing: (14pt, 26pt),

      node((2, 0), [Total], name: <total>),
      node((0.5, 1.4), [*A*], fill: luma(92%), name: <a>),
      node((2, 1.4), text(size: 0.8em)[sum ↑ · split ↓], stroke: none),
      node((3.5, 1.4), [*B*], fill: luma(92%), name: <b>),
      node((0, 2.8), [AA], name: <aa>),
      node((1, 2.8), [AB], name: <ab>),
      node((3, 2.8), [BA], name: <ba>),
      node((4, 2.8), [BB], name: <bb>),

      edge(<a>, <total>, "-|>", stroke: 1.2pt),
      edge(<b>, <total>, "-|>", stroke: 1.2pt),
      edge(<a>, <aa>, "-|>", stroke: 1.2pt + luma(40%)),
      edge(<a>, <ab>, "-|>", stroke: 1.2pt + luma(40%)),
      edge(<b>, <ba>, "-|>", stroke: 1.2pt + luma(40%)),
      edge(<b>, <bb>, "-|>", stroke: 1.2pt + luma(40%)),
    )
  ],
  align(horizon)[
    #pause
    Combines the two previous ideas: trust the middle layer as the "source of truth".

    - Only for *strict hierarchies* (not crossed grouped structures).
    - The downward step still needs a top-down proportion method.

    In software: `MiddleOut()` with a chosen `middle_level`.
  ],
)

#pagebreak()

=== Comparing Single-Level Methods

#table(
  columns: (auto, 1fr, 1fr),
  stroke: 0.5pt + luma(80%),
  inset: 8pt,
  [*Method*], [*Trusts*], [*Main failure mode*],
  [Bottom-up], [Bottom series], [Noisy leaves → weak parents],
  [Top-down], [Total series], [Loses local patterns; may be biased],
  [Middle-out], [Chosen middle level], [Wrong middle level; hierarchy only],
)

All three use information from *only one* chosen level — everything else is derived.

#pagebreak()

== Forecast Reconciliation

Single-level methods are limited: they discard base forecasts outside the chosen level.

*Forecast reconciliation* forecasts *all* series (base forecasts), then jointly *adjusts* them so the collection becomes coherent — a projection onto the set of forecasts that obey the aggregation structure.

#pause

#align(center)[
  #grid(
    columns: (1fr, auto, 1fr, auto, 1fr),
    gutter: 0.6em,
    align(center)[
      *Before* (don't add up)
      #v(0.4em)
      #diagram(
        node-stroke: luma(80%),
        spacing: (10pt, 18pt),
        node((1, 0), [Total: 100], name: <t>),
        node((0, 1.2), [A: 40], name: <a>),
        node((2, 1.2), [B: 50], name: <b>),
        edge(<t>, <a>, "--"),
        edge(<t>, <b>, "--"),
      )
      #text(size: 0.75em, fill: luma(40%))[40 + 50 ≠ 100]
    ],
    align(horizon)[$arrow.r.double$],
    align(center + horizon)[
      *Nudge*
      #v(0.3em)
      #text(size: 0.9em)[make them agree]
    ],
    align(horizon)[$arrow.r.double$],
    align(center)[
      *After* (add up)
      #v(0.4em)
      #diagram(
        node-stroke: luma(80%),
        spacing: (10pt, 18pt),
        node((1, 0), [Total: 95], name: <t2>),
        node((0, 1.2), [A: 42], name: <a2>),
        node((2, 1.2), [B: 53], name: <b2>),
        edge(<t2>, <a2>, "-|>"),
        edge(<t2>, <b2>, "-|>"),
      )
      #text(size: 0.75em, fill: luma(40%))[42 + 53 = 95]
    ],
  )
]

#pagebreak()

=== The MinT Optimal Reconciliation Approach

*MinT* (*Minimum Trace*) — Wickramasuriya, Athanasopoulos & Hyndman (2019) — is a smart nudging rule:

#grid(
  columns: (1fr, 1.3fr),
  gutter: 1.2em,
  align(center + horizon)[
    #diagram(
      node-stroke: luma(80%),
      edge-corner-radius: none,
      spacing: (12pt, 22pt),

      node((1.5, 0), [Total\ ★★★], fill: luma(92%), name: <t>),
      node((0, 1.5), [A\ ★★], name: <a>),
      node((3, 1.5), [B\ ★★], name: <b>),
      node((-0.3, 3), [AA\ ★], name: <aa>),
      node((0.8, 3), [AB\ ★], name: <ab>),
      node((2.5, 3), [BA\ ★], name: <ba>),
      node((3.8, 3), [BB\ ★], name: <bb>),

      edge(<aa>, <a>, "-|>"),
      edge(<ab>, <a>, "-|>"),
      edge(<ba>, <b>, "-|>"),
      edge(<bb>, <b>, "-|>"),
      edge(<a>, <t>, "-|>"),
      edge(<b>, <t>, "-|>"),
    )
  ],
  align(horizon)[
    #pause
    - Big totals are often smoother → more ★.
      - Less nudge needed.
    - Tiny leaf series are often noisy → fewer ★.
      - More nudge needed.
  ],
)

#pagebreak()

==== Practical Weighting Recipes

Common `MinTrace()` options:

- *OLS* (`ols`) — treat everyone equally (simple, ignores scale).
- *Variance scaling* (`wls_var`) — series with bigger errors get fewer ★.
- *Structural scaling* (`wls_struct`) — ★ from the tree shape only (handy when you have no residuals, e.g. human judgment forecasts).
- *MinT covariance / shrinkage* (`mint_cov`, `mint_shrink`) — use how errors move together; shrink when you have many series and little history.

A common default in practice: `mint_shrink`.

#pagebreak()

=== Why Reconciliation Helps

In real studies (tourism, prison data in FPP; Panagiotelis et al., 2021):

- Reconciled forecasts usually beat plain bottom-up.
- They also tend to beat the original (incoherent) base forecasts *on average* — not necessarily for every single series.

#pagebreak()

== Takeaways

+ *Coherence* matters: child forecasts must add up to their parents whenever nested totals drive decisions.
+ *Single-level* methods (bottom-up, top-down, middle-out) are simple, but they use information from only one layer.
+ *Reconciliation* — especially *MinT* (Wickramasuriya et al., 2019) — combines base forecasts from all levels and usually improves accuracy.
+ Prefer reconciliation when you can model every level; fall back to single-level methods when that is impractical.
