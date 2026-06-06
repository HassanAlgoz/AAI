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
    title: [Bivariate Analysis],
    subtitle: [Correlation, Association, and Confounders],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Bivariate Analysis

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
  image("/courses/Data_Science/assets/stats/linear_correlation_non-linear_data.png", width: 40%), caption: [Quadratic relationship $y = x^2$.]
)

== Correlation Coefficient is Unitless

#columns(2)[
  #figure(
    image("/courses/Data_Science/assets/stats/correlation_unitless.png")
  )
  
  #colbreak()

  Relationship between weights and heights of `507` physically active individuals:

  - Figure a: weight is measured in kilograms (`kg`) and height in centimeters (`cm`).
  - Figure b: weight has been converted to pounds (`lbs`) and height to inches (`in`)

  Correlation coefficient $r = 0.72$. Unaffected by the units of measurement.
]

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

= Causation

== Explanatory and response variables

When we ask questions about the relationship between two variables, we sometimes also want to determine if the change in one variable causes a change in the other.

#align(center)[
  #block(
    fill: luma(245),
    inset: 12pt,
    radius: 4pt,
    [ *explanatory variable* $->$ might affect $->$ *response variable* ]
  )
]

Whether we get perfectly positive or negative correlation ($r = 1$ or $r = -1$), or whether we get complete assoication ($v = 1$), it would be too early to say that $x$ causes $y$ based on just calculation.

A formal evaluation to check whether one variable causes a change in another requires an *experiment*, using sound logic and domain expertise.

#pagebreak()

=== Experiment 1: Plant Growth (Biology)
Imagine you are a botanist trying to figure out how to make tomatoes grow faster.
- *Explanatory:* The amount of fertilizer you give each plant (e.g., 0g, 5g, or 10g). This is the variable you think _explains_ or _causes_ the change.
- *Response:* The final height of the tomato plants after one month. This is the variable that _responds_ to the fertilizer.
- *Experiment:* If you just walked into a random garden and noticed that fertilized plants were taller, you couldn't prove the fertilizer caused it. To perform a true *experiment*, you would take 30 identical tomato seeds, plant them in the exact same soil with the exact same sunlight, and randomly assign different amounts of fertilizer to each. Because you controlled all other factors, any difference in the response variable (height) was strictly caused by your explanatory variable (fertilizer).

#pagebreak()

=== Experiment 2: Studying and Grades (Education)
Suppose a teacher wants to know if using flashcards improves test scores.
- *Explanatory:* The study method used (using flashcards vs. just reading the textbook).
- *Response:* The score out of 100 on the final exam.
- *The Experiment:* If the teacher just asks students how they studied and looks at their grades, that is an _observational study_, not an experiment. Highly motivated students might choose flashcards and naturally get better grades. To check if flashcards actually *cause* the change, the teacher must conduct an experiment: randomly splitting the class in half, forcing one half to use flashcards and the other half to just read.

#pagebreak()

=== Summary Checklist
Whenever you are looking at a scenario, you can map it back to your text like this:
- *What is doing the affecting?* $->$ Explanatory Variable
- *What is being affected?* $->$ Response Variable
- *Who is deciding who gets what?* $->$ If the researcher assigns it randomly, it's an *experiment* (proves cause). If nature/the subjects decide, it's just an observation (shows a link, but not a direct cause).

== Confounders

A *confounding variable* is one that is associated with both the explanatory and response variables. Because it is associated with both variables, it prevents the study from concluding that the explanatory variable caused the response variable.

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

