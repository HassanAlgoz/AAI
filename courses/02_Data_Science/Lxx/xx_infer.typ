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
    title: [Statistical Inference],
    subtitle: [Hypothesis Testing],
    author: [Hassan Algoz],
    date: datetime.today(),
    institution: [Alsun AI],
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Confirmatory Data Analysis

== What is CDA?

*EDA (Exploratory Data Analysis)*. It is the open-ended phase: plot everything, summarize everything, let the data surprise you, and write down candidate hypotheses for later.

*CDA (Confirmatory Data Analysis)* is the closed-ended phase: state your hypothesis and analysis plan in advance, collect (or hold out) independent data, run the pre-specified test, and report what you find -- including the things you wish were not true. EDA is for learning; CDA is for proving.

Both terms were coined by John Tukey: "We Need Both Exploratory and Confirmatory" (1980), published in The American Statistician, where he explicitly argued that *the two approaches must work together in a cycle*.

== Hypothesis Testing

See: [Foundations of Inference](https://openintro-ims.netlify.app/foundations-of-inference)

*Hypothesis Testing* is the statistical procedure used to test claims about the data. This data can be from:

1. *Experiments*: studies where the researchers explicitly assign treatments to cases
    - we generate this data intentionally to test a hypothesis
2. *Observational Studies*: studies where no treatment has been explicitly applied
    - we look at past data to see if the hypothesis is supported by the data

== What is Statistical Inference?

*Statistical Inference* is the process of drawing conclusions about a population based on a sample of data.

*Confirmatory Data Analysis (CDA)*, unlike EDA, starts with a claim and uses data to see if the claim is supported by the data or not.

*Hypothesis Testing* is a method of testing claims about the data, and it is also used to quantify uncertainty in the conclusions. It is the primary tool of CDA.

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
- that's within the $3 sigma$ of the NBA Players distribution (an inlier; just normal)
