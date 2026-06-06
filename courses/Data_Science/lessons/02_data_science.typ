#import "@preview/touying:0.7.3": *
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
    title: [Introduction to Data Science],
    subtitle: [Composition, Roles, and Analyses],
    author: [Hassan Algoz],
    date: datetime.today(),
    institution: [Alsun AI],
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Data Science

== What is Data Science?

#quote(
  [*Data science* is an interdisciplinary field that uses scientific methods, processes, algorithms, and systems to extract _knowledge and insights_ from structured and unstructured data. It combines _statistics_, _computer science_, and _domain knowledge_ to analyze data and support decisions and prediction.],
  attribution: [Wikipedia]
)

== Composition of Data Science

#figure(
  image("/assets/02/ds_intro/Data-Science-Venn-Diagram.png", width: 35%),
  caption: [Data Science Venn Diagram],
)

- *Math & Statistics*: logical consistency framework.
- *Domain Knowledge*: asking the right questions and acting on the results.
- *Computer Science*: storage, processing, and big data.

== Processes and Roles of Data Science

#figure(
  image("/assets/02/ds_intro/DSLC.png", width: 85%),
  caption: [Standard path from raw data to useful insight or product, and how roles map to the pipeline.],
)

== Roles in Data Science

#align(center)[
  #image("/assets/02/ds_intro/DSLC.png", width: 65%)
]

In large orgs these lines are sharp; in startups one person may wear several hats:

- *Data Engineers* — infrastructure: making data available and ready for others. 
- *Data Analysts* — dashboards: what happened and where we are now?
- *ML Engineers* — predictive models: what if we change X?

= Data Analysis

== What is Data Analysis?

#quote(
  [*Data analysis* is the process of inspecting, cleansing, transforming, and modeling data with the goal of discovering useful information, informing conclusions, and supporting decision-making.],
  attribution: [Wikipedia]
)

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

#align(center)[
  #diagram(
    node-stroke: luma(80%),
    edge-corner-radius: none,
    spacing: (10pt, 40pt),

    // Nodes
    node((2.5,0), [*Data Analysis*], name: <DS>),
    node((0,2), [*Exploratory*], name: <EDA>),
    node((2,2), [*Confirmatory*], name: <CDA>),
    node((4,2), [*Predictive*], name: <PA>),
    
    // Edges
    bent-edge(<DS>, <PA>),
    bent-edge(<DS>, <EDA>),
    bent-edge(<DS>, <CDA>),
  )
]

Three types of analysis:

+ *Exploratory Data Analysis (EDA)*: discover patterns and exceptions.
+ *Confirmatory Data Analysis (CDA)*: test general statements.
+ *Predictive Analytics (PA)*: make informed guesses about unknowns.

== Exploratory Data Analysis (EDA)

*Exploratory Data Analysis (EDA)* is the discovery engine that finds anomalies and patterns that become the foundation for future hypotheses.

Example: You work for a ride-sharing company. The engineering team just handed you the *May 2026 User Ride Logs* (input data) for a newly launched city. You don't have a hypothesis yet; you just feed this raw dataset through your standard EDA script to see what it spits out.

== EDA Example 1: Trip Distance

#figure(
  image("/assets/02/ds_intro/eda_output_1_histogram_trip_distance.png", width: 55%),
  caption: [Histogram of trip distance.],
)

- The *histogram* for `"trip_distance"` is heavily bimodal—rides are either under 1 mile or over 25 miles, with zero mid-range trips.
- _Aha!_ You realize the new city is strictly using the app for "last-mile" train commutes or full airport runs, drastically different from your other markets.


== EDA Example 2: Drop-off Location

#figure(
  image("/assets/02/ds_intro/eda_output_2_heatmap_drop_off_location.png", width: 55%),
  caption: [Heatmap of drop-off location.],
)

- Your missing value *heatmap* shows that 100% of `"drop-off_location"` data is missing for rides booked between 2:00 AM and 4:00 AM.
- _Aha!_ You discovered a recurring server maintenance glitch you never would have thought to look for.

== Confirmatory Data Analysis (CDA)

*Confirmatory Data Analysis (CDA)* is applying rigorous statistical tests (e.g., t-tests, ANOVA, p-values) to prove or disprove specific, *falsifiable hypotheses* generated during EDA or dictated by business needs.

== Claim 1: All swordfish are dangerous!

#figure(
  image("/assets/02/ds_intro/claim1_mercury_and_swordfish.png", width: 65%),
  caption: [A man on the news got mercury poisoning from eating swordfish. *So*, all swordfish are dangerous!],
)

== Claim 2: Duke University is so hard!

#figure(
    image("/assets/02/ds_intro/claim2_graduation_from_duke.png", width: 65%),
  caption: [I met two students who took more than 7 years to graduate from Duke. *So*, it must be so hard!],
)

== Claim 3: Drug X will kill you!

#figure(
    image("/assets/02/ds_intro/claim3_heart_attack_and_drug.png", width: 65%),
    caption: [My friend’s dad had a heart attack and died after they gave him a new heart disease drug. *So*, the drug will kill you!],
  )

== Analogy to distinguish between EDA and CDA

#figure(
  image("/assets/02/ds_intro/eda_to_cda.png", width: 75%),
  caption: [  
    In EDA, you throw a wide, pre-woven net into a new body of water, simply to see what kind of fish you pull up. In CDA, you start with a target and shoot an arrow.
  ],
)

== Predictive Analytics (PA)

#quote(
  [
    *Predictive analytics* encompasses a variety of statistical techniques from 
    #link("https://en.wikipedia.org/wiki/Data_mining")[data mining], 
    #link("https://en.wikipedia.org/wiki/Predictive_modeling")[predictive modeling], and 
    #link("https://en.wikipedia.org/wiki/Machine_learning")[machine learning] 
    that analyze current and historical facts to make predictions about future or otherwise *unknown events*.
  ]
)

Examples of *future* events predictions:

- predict whether the customer would click on a specific advertisement.
- predict whether the customer would cancel their subscription.

Examples of *present* and *past* events predictions:

- identify credit card fraud as it occurs.
- identify root cause of a machine failure.

== Examples of Predictive Analytics

#figure(
  image("/assets/02/ds_intro/predictive_analytics.png"),
  caption: [Predictive analytics],
)

== The Non-linear Nature of Data Science

In reality, *Data Science* is not sequential from 1 to 5. Rather, it is continuous process of planning, doing, reviewing, and improving.

#v(10%)

#figure(
  image("/courses/Data_Science/assets/stats/whole_game.png", height: 50%),
  caption: [Iterative refinement process in Data Science],
)

== Informed Decision-making

#figure(
  image("/courses/Data_Science/assets/stats/map_is_not_territory.png", width: 60%),
  caption: [The Map is not the Territory],
)

Informed decisions require alignment of both:
+ *External*: reality (the territory)
+ *Internal*: perception of reality (the map); i.e., data and models
