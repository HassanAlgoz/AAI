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
    title: [Multi-variate Analysis],
    subtitle: [Correlation, Association, and Confounders],
    author: [Hassan Algoz],
    date: datetime.today(),
    institution: [Alsun AI],
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Multi-variate Analysis

== Correlation

Graphically, it measures how clustered the scatter diagram is around a straight line:

#figure(image("/courses/Data_Science/assets/stats/correlation_coefficient.png", width: 80%), caption: [Eight plots and their corresponding correlations.])

== Definition

*Correlation* (or *linear association*) $r$ is a measure of the relationship between two numerical varriables. The formula for correlation is the average of the products of the two z-scores:

$ r = (sum(z_x z_y)) / (n - 1) in [-1, 1] $

The interpretation of the correlation is as follows:

$ |r| &= 1 => "Perfect Correlation" \
   r &= 0 => "No Correlation" \
   r &> 0 => "Positive Correlation" \
   r &< 0 => "Negative Correlation" $

== What _Linear_ means?

Pearson's correlation coefficient $r$ doesn't measure non-linear association. Here is an example of variables that have a perfect quadratic relation but $r = 0$:

#figure(
  image("/courses/Data_Science/assets/stats/linear_correlation_non-linear_data.png", width: 32%), caption: [Quadratic relationship $y = x^2$.]
)

== Correlation Coefficient is Unitless

#figure(image("/courses/Data_Science/assets/stats/correlation_unitless.png", height: 85%), caption: [Relationship between weights and heights of `507` physically active individuals.])

- Figure a: weight is measured in kilograms (`kg`) and height in centimeters (`cm`).
- Figure b: weight has been converted to pounds (`lbs`) and height to inches (`in`)

== Association

#figure(
    image("/courses/Data_Science/assets/stats/occupation_sex_association.png", height: 90%),
    caption: [Proportion of sex in each occupation in the UCI dataset]
)

== Association via Cramer's V

*Cramer's V* ($v$) is a measure of association between two nominal (categorical, unordered) variables. It always takes values in $[0, 1]$ and may be viewed as the percentage of the maximum possible association.

The interpretation of Cramer's V is similar to the interpretation of the correlation coefficient, but there is no notion of negative here:

$ |v| &= 1 => "Perfect Association" \
   v &= 0 => "No Association" $

= Correlation is not Causation

== Confounders

A *Confounding Variable* is one that is associated with both the explanatory and response variables. Because it is associated with both variables, it prevents the study from concluding that the explanatory variable caused the response variable.

#figure(
  image("/courses/Data_Science/assets/stats/confounder.png", width: 45%),
  caption: [Confounder Variable Causes Both]
)

== 1. Ice Cream Sales & Shark Attacks

Consider a silly example with total ice-cream sales as the explanatory variable and number of boating accidents as the response variable (which may seem highly correlated).

#figure(
  image("/courses/Data_Science/assets/stats/ice_cream_sales_shark_attacks.png", width: 37%),
  caption: [Correlation between Ice Cream Sales and Shark Attacks]
)

Outside temperature is associated with both variables, and therefore we cannot conclude that high ice-cream sales is a cause of more boating accidents.

== 2. Chocolate & Nobel Prizes.

#figure(
  image("/courses/Data_Science/assets/stats/chocoNobel.png", height: 85%),
  caption: [Correlation between Countries' Annual Per Capita Choclate Consumption and the Number of Nobel Laureates per 10 Million Population.]
)


== How to establish causality?

Whether we get perfectly positive or negative correlation ($r = 1$ or $r = -1$), or whether we get complete assoication ($v = 1$), it would be too early to say that $x$ causes $y$ based on just calculation.

One needs to use rules of *logic* and domain *expertise* to say that the relationship is, in fact, *causal*.

One rule is to avoid logical fallacies of *swapping the cause and effect*:

- Larger, more destructive fire, requires a bigger team of fire fighters; hence they are correlated.
- False conclusion: more fire fighters *cause* more fire!
- True conclusion: more fire *causes* more fire fighters!

Interested in learning more about causal inference? checkout #link("https://openintro-ims.netlify.app/data-design", [chapter 2: Study Design | Intro to Modern Statistics by Mine Çetinkaya-Rundel and Johanna Hardin]).
