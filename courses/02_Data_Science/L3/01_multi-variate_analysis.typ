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

#figure(image("/courses/02_Data_Science/assets/stats/correlation_coefficient.png", width: 80%), caption: [Eight plots and their corresponding correlations.])

== Definition

*Correlation* (or *linear association*) is a measure of two things with regards to the relationship between two numerical varriables: *strength* (value $in [-1, 1]$) and *direction* (sign: positive or negative).

- Only when the relationship is perfectly linear is the correlation either -1 or +1.
- If the relationship is strong and positive, the correlation will be near +1.
- If it is strong and negative, it will be near -1.
- If there is no apparent linear relationship between the variables, then the correlation will be near zero.

== Mathematically: Product of z-scores

The formula for correlation is:

$ r = (1 / (n - 1)) sum_(i: 1 .. n) ((x_i - bar(x)) / s_x) ((y_i - bar(y)) / s_y) $

The terms inside the parentheses are exactly the definitions of $z$-scores for $x$ and $y$:

$ z_{x, i} = (x_i - bar(x)) / s_x $
$ z_{y, i} = (y_i - bar(y)) / s_y $

So, the formula simplifies to:

$ r = (sum(z_x z_y)) / (n - 1) $

In essence, *correlation $r$ is the average of the products of the two z-scores*.

== Correlation Measures *Linear* Association Only

Correlation measures only one kind of association – linear. Variables that have strong non-linear association might have very low correlation. Here is an example of variables that have a perfect quadratic relation $y = x^2$ but have correlation equal to 0.

#figure(
  image("/courses/02_Data_Science/assets/stats/linear_correlation_non-linear_data.png", width: 80%), caption: [Relationship between weights and heights of `507` physically active individuals.]
)

== Correlation Coefficient is Unitless

One important aspect of the correlation is that it’s unitless (since it is a product of two untiless quantities). The following figure shows the relationship between weights and heights of `507` physically active individuals:

#figure(image("/courses/02_Data_Science/assets/stats/correlation_unitless.png", width: 65%), caption: [Relationship between weights and heights of `507` physically active individuals.])

- Figure a: weight is measured in kilograms (`kg`) and height in centimeters (`cm`).
- Figure b: weight has been converted to pounds (`lbs`) and height to inches (`in`)

== Association

#figure(
    image("/courses/02_Data_Science/assets/stats/occupation_sex_association.png", width: 100%),
    caption: [Proportion of sex in each occupation in the UCI dataset]
)

== Association via Cramer's V

#link("https://en.wikipedia.org/wiki/Cram%C3%A9r%27s_V", [*Cramer's V*]) is a measure of association between two nominal (unordered categorical) variables, giving a value between 0 and +1 (inclusive):

- $v = 0$ (no association)
- $v = 1$ (perfect association)

It may be viewed as a percentage of maximum possible variation.

== Confounders

A *Confounding Variable* is one that is associated with both the explanatory and response variables. Because it is associated with both variables, it prevents the study from concluding that the explanatory variable caused the response variable.

#figure(
  image("/courses/02_Data_Science/assets/stats/confounder.png", width: 35%),
  caption: [Confounder Variable Causes Both]
)

Whether we get perfectly positive or negative correlation ($r = 1$ or $r = -1$), or whether we get complete assoication ($v = 1$), it would be too early to say that $x$ causes $y$ based on just calculation.

One needs to use rules of *logic* and domain *expertise* to say that the relationship is, in fact, *causal*.

== Example 1: Ice Cream Sales and Shark Attacks

Consider a silly example with total ice-cream sales as the explanatory variable and number of boating accidents as the response variable (which may seem highly correlated).

#figure(
  image("/courses/02_Data_Science/assets/stats/ice_cream_sales_shark_attacks.png", width: 35%),
  caption: [Correlation between Ice Cream Sales and Shark Attacks]
)

Outside temperature is associated with both variables, and therefore we cannot conclude that high ice-cream sales is a cause of more boating accidents.

== Example 2: Chocolate Consumption & Nobel Prizes.

In 2012, a #link("http://www.biostat.jhsph.edu/courses/bio621/misc/Chocolate%20consumption%20cognitive%20function%20and%20nobel%20laurates%20%28NEJM%29.pdf) in the respected New England Journal of Medicine examined the relation between chocolate consumption and Nobel Prizes in a group of countries. The [Scientific American](http://blogs.scientificamerican.com/the-curious-wavefunction/chocolate-consumption-and-nobel-prizes-a-bizarre-juxtaposition-if-there-ever-was-one/", [paper]) responded seriously whereas #link("http://www.reuters.com/article/2012/10/10/us-eat-chocolate-win-the-nobel-prize-idUSBRE8991MS20121010#vFdfFkbPVlilSjsB.97", [others]) were more relaxed. You are welcome to make your own decision! The following graph, provided in the paper, should motivate you to go and take a look.

#figure(
  image("/courses/02_Data_Science/assets/stats/chocoNobel.png", width: 35%),
  caption: [Correlation between Countries' Annual Per Capita Choclate Consumption and the Number of Nobel Laureates per 10 Million Population.]
)

Confounder?

== How to establish causality?

One rule is to avoid logical fallacies of *swapping the cause and effect*:

- Larger, more destructive fire, requires a bigger team of fire fighters; hence they are correlated.
- False conclusion: more fire fighters *cause* more fire!
- True conclusion: more fire *causes* more fire fighters!

Interested in learning more about causal inference? checkout #link("https://openintro-ims.netlify.app/data-design", [chapter 2: Study Design | Intro to Modern Statistics by Mine Çetinkaya-Rundel and Johanna Hardin]).
