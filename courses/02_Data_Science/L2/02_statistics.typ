#import "@preview/touying:0.7.3": *
#import "@preview/curryst:0.5.1" as curryst: rule
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node


#import "/template/theme.typ": *

#show: university-theme.with(
  config-colors(
    primary: primary-color,
    secondary: secondary-color,
    tertiary: tertiary-color,
    neutral-darkest: text-color,
  ),
  config-info(
    title: [Statistics],
    subtitle: [Population, Sample, and Variables],
    author: [Hassan Algoz],
    date: datetime.today(),
    institution: [Alsun AI],
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Statistics

*Statistics* (from #link("https://en.wikipedia.org/wiki/German_language")[German]: _#link("https://en.wiktionary.org/wiki/Statistik#German")[Statistik]_, orig. "description of a #link("https://en.wikipedia.org/wiki/State_(polity)")[state], a country"#link("https://en.wikipedia.org/wiki/Statistics#cite_note-:1-1")[[1]]) is the discipline that concerns the collection, organization, analysis, interpretation, and presentation of #link("https://en.wikipedia.org/wiki/Data")[data].

Today, Statistics is deeply related to subjects like physics, chemistry, geography, geopolitics, and especially mathematics.

== Population

In applying statistics to a scientific, industrial, or social problem, it is conventional to begin with a _statistical population_.

*Population (مجتمع إحصائي)*: is a set of similiar items which is of interest for some question or experiment.

Each *Observation (ملاحظة)* measures one or more properties (such as weight, location, colour or mass) of independent objects or individuals:

- People: like every person living in a specific neighborhood
    - properties: height, weight, age, gender, etc.
- Things: like every lightbulb produced in a factory today
    - properties: luminosity, color, size, etc.
- Events: like car accidents
    - properties: time, location, number of casualties, etc.


== Sample

*Sample (عيِّنة)*: is a subset of the _Population_, meant to represent it.

#figure(image("//courses/02_Data_Science/assets/stats/sampling_process.png"), caption: [A visual representation of the sampling process])

== Sampling Frame

The population from which the sample is drawn may not be the same as the population from which information is desired.

Sampling has lower costs and faster data collection compared to a census recording data from the entire population (in many cases, collecting the whole population is impossible, like getting sizes of all stars in the universe). Thus, it can provide insights in cases where it is infeasible to measure an entire population.

*Sampling frame*: is the source material or device from which a sample is drawn.

It is helpful to think in levels, The smallest of which is the *Subject (مشارك)* or *Item (عنصر)*:

#figure(image("//courses/02_Data_Science/assets/stats/population_sampling_reality.png"))

#speaker-note[

  In research, these terms describe a "funnel" that narrows down from a massive group of people to the specific individuals being studied.
  + _Population:_ The entire broad group of people that your research results are intended to describe (e.g., "all adults with Type 2 diabetes").
  + _Target Population:_ The specific subset of the population that meets your formal "eligibility rules" or sampling criteria (e.g., "adults with Type 2 diabetes living in Canada, aged 40–60").
  + _Accessible Population:_ The actual portion of the target population that the researcher can realistically reach and recruit from (e.g., "adults with Type 2 diabetes at three specific clinics in Toronto").
  + _Sample:_ The small group of individuals chosen from the accessible population who actually take part in the study.
  + _Subject, Participant, or Informant:_ A single individual within the sample.
]

== Errors in Sampling

These errors can impact final survey estimates severely:

+ *Over-coverage*: inclusion of data from outside of the population.
+ *Under-coverage*: sampling frame does not include elements in the population.
+ *Measurement error*: e.g., when respondents misunderstand a question, or find it difficult to answer.
+ *Processing error*: mistakes in the implementation of the data processing computer program.
+ *Non-response or Participation bias*: failure to obtain complete data from all selected individuals
+ *Duplicate entries*: A member of the population is surveyed more than once.
+ *Grouping*: The frame lists clusters instead of individuals.

Note: the sampling frame must be representative of the population and this is a question outside the scope of statistical theory demanding the *judgment of experts* in the particular subject matter being studied.

#link("https://en.wikipedia.org/wiki/Sampling_frame")[click here] for more details.

= Statistical Analysis

== Types of Statistical Analysis

- *Descriptive Statistics (الإحصاء الوصفي)*: Summarize qualities of a group (of people, things, or events).
- *Inferential Statistics (الإحصاء الاستدلالي)*: Draw conclusions from a sample onto the population.

At its heart, statistics is the bridge between raw observation and useful information.

#figure(
  image("/courses/02_Data_Science/assets/stats/inferential_statistics.png", width: 50%),
  caption: [Descriptive and Inferential Statistics],
  
)

== Example outcome of statistical analysis

*Experiment Question*: is the one we want to answer with our experiment.

_Question_: are NBA Players really taller than most people?

#figure(
  image("/courses/02_Data_Science/assets/stats/nba_players_are_tall.png"),
  caption: [Sketch of NBA players in a basketball game],
)

We formulate it precisely as in statistical terms as follows:

- _Null Hypothesis_: The average height of NBA Players is *not* _significantly higher_ than the average height of most people.
- _Alternative Hypothesis_: The average height of NBA Players *is* _significantly higher_ than the average height of most people.

We'll talk about *statistical significance* when we get to *Hypothesis Testing*, a central topic in *Inferential Statistics*.

== Example: visual comparison

#figure(
  image("/courses/02_Data_Science/assets/stats/nba_comparative_distribution.png", width: 50%),
  caption: [Comparative Distribution of NBA Player's Heights and Human Heights. Image Source: https://distributionofthings.com/human-height/],
)

Using statistics we can make *Generalizations* like:

1. "men are taller than women" (the phrase "on average" is implied here)
2. "most NBA players are taller than most people"
3. "most NBA players are men"

We can see *overlaps* in the distributions, hence giving us *Definitive Statements* is not possible. For example, we can't say:

- *Positive*: "All men are taller than women"
- *Negative*: "No Player is shorter than the shortest woman"

== Descriptive Statistics

*Descriptive Statistics (إحصاء وصفي)* summarizes qualities of a group (of people or things):
  
- *Numerical (رقمي)*: It sums up variables across subjects to describe them in general.
  + *Statistic*: *mean*, *median*, *variance*, *range*, *mode*, *percentiles*, ..etc.
- *Visual (بصري)*: They simplify the data by doing local statistics (e.g., *bins* of *bar plot*).
  + *Plot*: *points*, *lines*, *colors*, *size*, *text*, *bars*, ..etc.

// - The `mean` is the *average* statistic.
// - The `std` is the *standard deviation* statistic.
// - The *min* and *max* statistics constitute the *range* statistic.
// - The `25%` *percentile* is the value below which 25% of the data points are found.
// - The `50%` *percentile* (a.k.a *median*) is the middle value when data are ordered.
// - The `75%` *percentile* is the value above which 25% of the data points are found.
// - The *mode* is the *most frequent* value statistic. It is more useful when we are looking at *categorical* attribute. In our case, the attribute is *numerical*.

== Visual Description: Histogram

*Histograms* are used to answer many important questions:

1. What *range* do the observations cover?
2. What is their *center*?
3. Are they heavily *skewed* in one direction?
4. Is there evidence for *bimodality*?
5. Are there significant *outliers*?
6. Do the answers to these questions vary *across subsets* defined by other variables?

#figure(image("//courses/02_Data_Science/assets/stats/human_weight_and_height.png"), caption: [Two Histograms of Height and Weight of Humans])

== Numerical Description: Statistics

Measured properties (Variables):

- Height (m)
- Weight (kg)

In Pandas, we simply call the `df.describe()` to calculate the statistics:

```text
| Index | Height (m)   | Weight (kg)  |              |
| ----- | ------------ | ------------ | ------------ |
| mean  | 12500.500000 | 1.727025     | 57.642260    |
| std   | 7217.022701  | 0.048303     | 5.289295     |
| min   | 1.000000     | 1.531070     | 35.386902    |
| 25%   | 6250.750000  | 1.694292     | 54.117508    |
| 50%   | 12500.500000 | 1.727091     | 57.677789    |
| 75%   | 18750.250000 | 1.759533     | 61.186372    |
| max   | 25000.000000 | 1.908881     | 77.529827    |
```

But what do these statistics mean?

= Distributions

== Properties of Distributions

We describe a distribtuion by three properties:
- *Central Tendency*: mean, median, mode
- *Dispersion*: variance, standard deviation, range
- *Skewness*: skewness

== Central Tendency
- *Mode*: the most frequent value.
- *Median*: the middle value when data are ordered.
- *Mean* (a.k.a average): the center of "mass" ($\bar{x}$ or $\mu$).

== Dispersion

- *Range*: the difference between the maximum and minimum values.
- *Variance*: the average of the squared differences from the mean ($\sigma^2$).
- *Standard Deviation*: the square root of the variance ($\sigma$).

The variance ($\sigma^2$) is described mathematically as:

$ \sigma^2 = \frac{1}{N}\sum_{i=1}^{N}(x_i - \mu)^2 $

In a physical sense, we can see:

- the variance being the spread of the mass
- the mean being the center of the mass

#figure(image("//courses/02_Data_Science/assets/stats/variance_physical_metaphor.png"), caption: [Physical Metaphor])

== Percentiles

The *median* is the 50th percentile (`50%`) which means that 50% of the data points are below this value.

The `25%` and the `75%` percentiles go by other names:
- the 1st and 3rd quartiles
- the Q1 and Q3
- the lower and upper quartiles


== Skewness

We get *skewness* when the distribution is _not symmetric_:

- The _Mode_ is the peak
- The _Mean_ pulls the curve downwards
- The _Median_ follows the mean a little bit

#figure(image("//courses/02_Data_Science/assets/stats/skewness.png"), caption: [Skewness])
This can be calculated using the `.skew()` method where:

- `0` Perfectly Symmetrical (Normal).
- `>0` Right-skewed: Long tail on the right side.
- `<0` Left-skewed: Long tail on the left side.

== Types of Data Distributions

#figure(image("//courses/02_Data_Science/assets/stats/histogram_distributions.png"), caption: [Histogram Distributions])

- *Normal*: symmetric triangle.
- *Uniform*: even, like a brush.
- *Left-skewed*: right-angle triangle.
- *Right-skewed*: left-angle triangle.
- *Bimodal*: suggests two normals on the same plot.
- *Multi-modal*: suggests multiple normals on the same plot.

== The Normal Distribution

The *Normal Distribution* (or *Gaussian Distribution*) is a bell-shaped distribution that is symmetric around the mean, with the highest density of data points in the center.

#figure(image("//courses/02_Data_Science/assets/stats/normal_distribution.png"), caption: [Mathematically Drawn Normal Distribution])

== Empirical Rule

The following table shows the *Empirical Rule* for the Normal Distribution.

| _Distance from Mean_                   | _Percentage of Data Included_ |
| ---------------------------------------- | ------------------------------- |
| Within $1\sigma$ | _68.2%_                       |
| Within $2\sigma$ | _95.4%_                       |
| Within $3\sigma$ | _99.7%_                       |

The rule is empirical because it is derived from "experienced" observations (data); not purely mathematically. In fact, many things in life follow this shape, and hence it got the name, _Normal_:

- *Vital Signs*: height, birth weight of newborns, weight, blood pressure.
- *Biological Life*: leaf lengths on a tree.
- *Standardized Test Scores* (by design): SAT, IQ, etc.
- *Manufacturing Errors*: If a machine is set to cut `10cm` bolts, then:
  - most will be exactly `10cm` with a +/- 0.01cm tolerance.

== Precision in Statistics

Precise calculation gives us confidence in generalizing.

#figure(
  image("/courses/02_Data_Science/assets/stats/nba_comparative_distribution.png", width: 50%),
  caption: [Comparative Distribution of NBA Player's Heights and Human Heights. Image Source: https://distributionofthings.com/human-height/],
)

- Adult women globally (mean of `159cm` and standard deviation of `6cm`)
- Adult men globally (mean of `171cm` and standard deviation of `7cm`)
- NBA players; a specific subset of adult men (~2300 players who have been part of an NBA team roster between 1996 and 2019)

When having *outliers* in one distribution, that might signal to us that it is, in fact, a member of another distribution. In this case:

- a Male with a height of `+192cm` might be an *outlier* within males, but
- that's within the $3 sigma$ of the NBA Players distribution

== Example of Left-skewed Distribution

#figure(image("//courses/02_Data_Science/assets/stats/deaths-in-australia-in-the-year-2012.png"), caption: [Left-tailed distrubtion of death by age in Australia in the Year 2012.])

- While most people die at older ages, a smaller number of *outliers* die much younger, pulling the *average* down.
- When data is skewed, the *median* is often a better "typical" representation of the data than the *average*, because the *average* is overly sensitive to *extreme outliers* (infant mortality or early-life accidents).

== Example of Bimodal Distribution