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

== What is Statistics?

#quote(
  [*Statistics*  (from German: _Statistik_, orig. "description of a state, a country") is the discipline that concerns the collection, organization, analysis, interpretation, and presentation of data.],
  attribution: [Wikipedia]
)


Today, Statistics is deeply related to subjects like physics, chemistry, geography, geopolitics, and especially mathematics.

In applying statistics to a scientific, industrial, or social problem, it is conventional to begin with a _statistical population_.

== Population

*Population (مجتمع إحصائي)*: is a set of similiar items which is of interest for some question or experiment.

== Observation

Each *Observation (ملاحظة)* measures one or more properties of independent objects or individuals:

- of *People*: like every person living in a specific neighborhood
    - properties: height, weight, age, gender, occupation, education, ..etc.
- of *Things*: like every lightbulb produced in a factory today
    - properties: luminosity, color, size, ..etc.
- of *Events*: like car accidents
    - properties: time, location, number of casualties, ..etc.

== Sample

*Sample (عيِّنة)*: is a subset of the _Population_, meant to represent it.

#figure(image("/courses/Data_Science/assets/stats/sampling_process.png", width: 50%), caption: [A visual representation of the sampling process])

== Sampling Frame

In many cases, collecting the whole population is impossible or practically infeasible.

*Sampling frame (إطار المعاينة)*: is the source material or device from which a sample is drawn.

It is helpful to think in levels, The smallest of which is the *Subject (مشارك)*:

#figure(image("/courses/Data_Science/assets/stats/population_sampling_reality.png", width: 40%))

#speaker-note[

  In research, these terms describe a "funnel" that narrows down from a massive group of people to the specific individuals being studied.
  + _Population:_ The entire broad group of people that your research results are intended to describe (e.g., "all adults with Type 2 diabetes").
  + _Target Population:_ The specific subset of the population that meets your formal "eligibility rules" or sampling criteria (e.g., "adults with Type 2 diabetes living in Canada, aged 40–60").
  + _Accessible Population:_ The actual portion of the target population that the researcher can realistically reach and recruit from (e.g., "adults with Type 2 diabetes at three specific clinics in Toronto").
  + _Sample:_ The small group of individuals chosen from the accessible population who actually take part in the study.
  + _Subject, Participant, or Informant:_ A single individual within the sample.
]

== Two Types of Statistical Analysis

There are essentially two types of statistcal analysis:

+ *Descriptive Statistics (الإحصاء الوصفي)*: Summarize qualities of a group (of people, things, or events).
+ *Inferential Statistics (الإحصاء الاستدلالي)*: Draw conclusions from a sample onto the population.

#figure(
  image("/courses/Data_Science/assets/stats/inferential_statistics.png", width: 48%),
  caption: [How inference works in statistics],
)

== Statistical Errors

The _sampling frame_ must be *representative* of the population and this is a question that requires *domain expertise*, to guard against common errors like:

+ *Over-coverage*: inclusion of data from outside of the population.
+ *Under-coverage*: sampling frame does not include elements in the population.
+ *Measurement error*: e.g., when respondents misunderstand a question, or find it difficult to answer.

#pagebreak()

=== Example: Survivorship bias

*Survivor bias* is a statistical error that results from concentrating on entities that passed a selection process while overlooking those that did not. This can lead to incorrect conclusions because of incomplete data.

In a 1987 study, it was reported that cats who fall from fewer than six stories and are still alive have greater injuries than cats who fall from higher than six stories. It has been proposed that this might happen because cats reach terminal velocity after righting themselves at about five stories.

In 1996, _The Straight Dope_ newspaper column proposed that another possible explanation. Cats that die in falls are less likely to be brought to a veterinarian than injured cats, and thus, many of the cats killed in falls from higher buildings are not reported in studies of the subject.

#pagebreak()

=== Example: White coat hypertension

_White coat hypertension_ in which people exhibit a blood pressure level above the normal range in a clinical setting, although they do not exhibit it in other settings.

It is believed that the phenomenon is due to anxiety experienced during a clinic visit.

This is an example of *measurement error*, which is mitigated by using the patient's daytime blood pressure as a reference as it takes into account ordinary levels of daily stress.

== Meet the Penguins!

#figure(
  image("/courses/Data_Science/assets/stats/lter_penguins.png", width: 100%),
  caption: [The Palmer Penguins],
)

== The Palmer Penguins Dataset

This table shows 3 observations from the Palmer Penguins dataset:

```text
|     | species   | island    | flipper | mass   | sex    |
| --- | --------- | --------- | ------- | ------ | ------ |
| 39  | Adelie    | Dream     | 184.0   | 4650.0 | Male   |
| 118 | Adelie    | Torgersen | 189.0   | 3350.0 | Female |
| 157 | Chinstrap | Dream     | 198.0   | 3950.0 | Female |
```

The goal of palmerpenguins is to provide a great dataset for data exploration & visualization. Very useful for teaching with the data.

Data were collected and made available by #link("https://www.uaf.edu/cfos/people/faculty/detail/kristen-gorman.php", [Dr. Kristen Gorman]) and the #link("https://pallter.marine.rutgers.edu/", [Palmer Station, Antarctica LTER]), a member of the #link("https://lternet.edu/", [Long Term Ecological Research Network]).

The dataset has: 342 penguins from 3 species: Adelie, Chinstrap, and Gentoo.

== Variables

*Variables (متغيرات)* are the shared attributes of the subjects under study.

We deal with variables differently based on two types:

#columns(2, gutter: 8pt)[

  - *Quantitative (كمي)*:
    - Age
    - Temperature
    - Price
    - Duration

  #colbreak()

  - *Qualitative (نوعي)*:
    - Answer: yes / no
    - Direction: north / south / east / west
    - Size: small / medium / large
]

== Exercise: variable types

Classify the variables below into quantitative and qualitative:

#align(center)[
  #table(
    columns: 6,
    [], [`species`], [`island`], [`flipper_length`], [`mass`], [`sex`],

    [0], [Adelie], [Torgersen], [181], [3750], [Male],
    [1], [Gentoo], [Torgersen], [186], [3800], [Female],
    [2], [Gentoo], [Biscone], [195], [3250], [Female],
    [3], [Adelie], [Biscone], [180], [3700], [Male],
    [4], [Adelie], [Torgersen], [193], [3450], [Female],
  )
]

== Tidy Data

The following three rules make a dataset *tidy (منظم)*:

- Each column represent a *variable (متغير)*.
- Each row represent an *observation (ملاحظة)*.
- Each cell represent a *value (قيمة)*.

#figure(
  image("/courses/Data_Science/assets/stats/variables_observations_values.png", width: 90%),
  caption: [Tidy data: variables, observations and values],
)

== Variables, Observations, and Values

To make the discussion easier, let's define some terms:

- A *variable* is a quantity, quality, or property that you can measure.

- A *value* is the state of a variable when you measure it. The value of a variable may change from measurement to measurement.

- An *observation* is a set of measurements made under similar conditions (you usually make all of the measurements in an observation at the same time and on the same object). An observation will contain several values, each associated with a different variable. We'll sometimes refer to an observation as a *data point (نقطة بيانات)*.

- *Tabular data* is a set of values, each associated with a variable and an observation. Tabular data is *tidy* if each value is placed in its own “cell”, each variable in its own column, and each observation in its own row.

== Descriptive Statistics

*Descriptive Statistics (إحصاء وصفي)* summarizes qualities of a group (of people or things):
  
+ *Numerical (رقمي)*: It sums up variables across subjects in few numbers.
  - *Statistic (إحصاء)*: average, median, variance, ..etc.
+ *Visual (بصري)*: They represent the data in graphical forms.
  - *Plot (رسم)*: points, lines, colors, bars, ..etc.

== Numerical Description: Statistics

In Pandas, we simply call the `df.describe()` method to calculate the statistics:

#columns(2, gutter: 8pt)[

  *Quantitative* variable statistics:

  ```text
  |       |    mass     |
  | ----- | ----------- |
  | count | 342.000000  |
  | mean  | 4201.754386 |
  | std   | 801.954536  |
  | min   | 2700.000000 |
  | 25%   | 3550.000000 |
  | 50%   | 4050.000000 |
  | 75%   | 4750.000000 |
  | max   | 6300.000000 |
  ```

  #colbreak()

  *Qualitative* variable statistics:

  ```text
  sex   
  Male      168
  Female    165
  ```
]

But what do these statistics mean? And how do we represent them visually? And what do they tell us about the data? Let's find out in the next section.