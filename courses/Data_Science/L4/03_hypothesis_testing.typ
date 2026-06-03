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
    title: [Hypothesis Testing],
    subtitle: [Testing Claims that Challenge the Status Quo],
    author: [Hassan Algoz],
    date: datetime.today(),
    institution: [Alsun AI],
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Hypothesis

== EDA vs CDA

*EDA (Exploratory Data Analysis)*. It is the open-ended phase: plot everything, summarize everything, let the data surprise you, and write down candidate hypotheses for later.

*CDA (Confirmatory Data Analysis)* is the closed-ended phase: state your hypothesis and analysis plan in advance, collect (or hold out) independent data, run the pre-specified test, and report what you find -- including the things you wish were not true.

Both terms were coined by John Tukey: "We Need Both Exploratory and Confirmatory" (1980), published in The American Statistician, where he explicitly argued that *the two approaches must work together in a cycle*. EDA is for learning; CDA is for proving and disproving.

== Definition

A *statistical hypothesis* is a claim about an unknown parameter of a population that can be evaluated using observed data.

Examples:

- "The population mean salary is 8,000 SAR."
- "The proportion of defective items is less than 2%."
- "The drug is effective in reducing blood pressure."

In statistical terms:

#align(center)[
  #table(
    columns: 2,
    align: left,
    [*Hypothesis*], [*Parameter*],
    [$mu = 8000$], [Population mean],
    [$p < 0.02$], [Population proportion],
    [$mu_2 < mu_1$], [Difference in means]
  )
]

== Types of Studies

1. *Randomized Experiments*: studies where the researchers explicitly assign treatments to cases. (We generate this data intentionally to test a hypothesis).
2. *Observational Studies*: studies where no treatment has been explicitly applied. (We look at past data to see if the hypothesis is supported by the data).

Observational studies are *hard to control for confounding variables*, which makes it difficult to draw causal conclusions. Randomized experiments are *the gold standard* for causal inference.

== Hypothesis: Null and Alternative

In every test, we pit two statements against each other:

=== $H_0$: Null Hypothesis
The statement of currently held belief. It assumes that any observed effect is due to chance.

=== $H_a$: Alternative Hypothesis
The statement you are trying to find evidence for. It assumes the existence of an effect.

== The special role of the Null Hypothesis
The null hypothesis is simply the default position.

*Examples:*
$ H_0: mu = 100 $
$ H_0: p = 0.5 $
$ H_0: mu_1 = mu_2 $

The alternative hypothesis represents competing possibilities.
$ H_1: mu != 100 $
$ H_1: p > 0.5 $
$ H_1: mu_1 < mu_2 $

== Examples of Null and Alternative Hypotheses

=== Example: Observational Study

- $H_0$: NBA players are people, why would they be taller? $mu_"NBA" = mu_"people" $
- $H_a$: NBA players are taller than people. $mu_"NBA" > mu_"people" $

=== Example: Randomized Experiment

- $H_0$: Since coffee is just food, why would it have effect on sleep? $mu_"coffee" = mu_"control" $
- $H_a$: There is relationship between coffee intake and sleep. $mu_"coffee" != mu_"control" $

== Anti-examples
These often look like hypotheses but are not statistical hypotheses.

=== A research question
The question "Does caffeine improve concentration?" translates to the hypothesis:

$ H_0: mu_"caffeine" = mu_"control" $
$ H_1: mu_"caffeine" > mu_"control" $

=== A vague claim
The claim "Method A is better than method B." is vague because it does not specify what "better" means. We can be more specific by translating it to the hypothesis:

$ H_0: mu_"A" = mu_"B" $
$ H_1: mu_"A" > mu_"B" $

= Hypothesis Testing

== The t-test

A *t-test* is a statistical procedure used to compare the means of two groups to determine if they are significantly *different* (assuming _normal distribution_).

== Types of t-tests

Depending on number of groups, we have three kinds of t-tests:

1. One Sample
2. Paired Samples
3. Independent Samples

#pagebreak()

=== One Sample

A comparison against a historic or global value:

- IQ of classroom students vs. national average.
- Cholesterol levels of patients vs. recommended levels.

=== Paired Samples

Same group measured twice:

- Grip strength — before vs. after eating spinach.
- Performance — with afternoon nap vs. without.

#pagebreak()

=== Independent Samples

+ *Control group*
  - takes a placebo
  - uses the current method
+ *Treatment group*
  - takes the real drug
  - uses the new method

== p-value

A t-test outputs a *p-value*; the probability of observing a value as extreme as the one observed, assuming the null hypothesis is true.

$ "p-value" = P(z > z_c | H_0) $

Where $z_c$ is the critical value for the given significance level $alpha$.

- If the p-value is less than $alpha$, we *reject the null hypothesis* and *accept the alternative hypothesis*.
- Otherwise, we *fail to reject the null hypothesis*.

$ "p-value" & < alpha arrow.r.double "reject" H_0 and "accept" H_a $

== Null Distribution

A null hypothesis is commonly expressed as the difference in means between the treatment and control groups being zero:

$ H_0: mu_"treatment" - mu_"control" = 0 $

By bootstrapping, we can calculate the sampling distribution of $H_0$ and plot it:

#figure(
  image("/courses/Data_Science/assets/stats/null_distribution.png", height: 50%),
  caption: [Sampling Distribution of $H_0$],
)

== p-value and Critical Value

The *p-value* is the area under the curve to the right of the critical value:

$ "p-value" = P(z > z_c | H_0) $

#figure(
  image("/courses/Data_Science/assets/stats/null_distribution_critical_value.png", height: 60%),
  caption: [Sampling Distribution of $H_0$ with the critical value $+z_c$ marked],
)

== Alternative Distribution

Here the alternative is that the drug is in fact, effective, and the difference is positive (shift right).

$ H_a: mu_"treatment" - mu_"control" > 0 $

#figure(
  image("/courses/Data_Science/assets/stats/alternative_distribution.png", height: 60%),
  caption: [Sampling Distributions of both $H_0$ and $H_a$],
)

== Type I and Type II errors

When you make a conclusion about whether an effect is significant, you can be wrong in two ways: *Type I Error ($alpha$)* and *Type II Error ($beta$)*.

#figure(
    image("/courses/Data_Science/assets/stats/beta_area.png", height: 75%),
    caption: [Type I  and Type II Errors ($alpha$ and $beta$)],
  )

== Type I Error

A *Type I Error ($alpha$)* is one where $H_0$ is true, but observed data shows otherwise. In other words, no real difference or relationship actually exists, but random sampling caused it to show up somehow.

$ alpha = P(z > z_c | H_0) $ 

#columns(2)[
  #figure(
    image("/courses/Data_Science/assets/stats/correlation_type_I_error_2.png"),
    caption: [Actual data showing no significant correlation],
  )

  #figure(
    image("/courses/Data_Science/assets/stats/correlation_type_I_error_1.png"),
    caption: [Cherry-picked data showing a significant correlation],
  )
]

== Type II Error

A *Type II Error ($beta$)* is one where $H_a$ is true, but observed data shows otherwise. In other words, a real difference or relationship does exist, but random sampling caused it to not show up.

$ beta = P(z < z_c | H_a) $ 

#columns(2)[
  #figure(
    image("/courses/Data_Science/assets/stats/correlation_type_II_error_1.png"),
    caption: [Actual data showing significant correlation],
  )
  #figure(
    image("/courses/Data_Science/assets/stats/correlation_type_II_error_2.png"),
    caption: [Cherry-picked data showing no significant correlation],
  )
]

= Statistical Power

== Definition
  
*Power ($1 - beta$)* is the probability that your experiment will produce a *p-value* small enough (less than $alpha = 0.05$) to claim statistical significance, assuming a true effect actually exists: $P(z > z_c | H_a)$.

#figure(
  image("/courses/Data_Science/assets/stats/power_1_minus_beta.png", height: 55%),
  caption: [Power is the yellow shaded area under the alternative distribution],
)

== Factors affecting power

- *Effect Size* is the magnitude of the difference between the two groups.
- *Variability* is the standard deviation of the data.
- *Sample Size* is the number of observations in each group.
- *Significance Level* ($alpha$) is the probability of rejecting the null hypothesis when it is true.

== An analogy to understand statistical power

*Looking for a tool in a basement*

The concept of statistical power is a slippery one. Here is an analogy that might help (courtesy of John Hartung, SUNY HSC Brooklyn).

You send your child into the basement to *find a tool*. He comes back and says "it isn't there". What do you conclude? Is the tool there or not? There is no way to be sure.

So let's express the answer as a *probability*. The question you really want to answer is: "What is the probability that the tool is in the basement"? But that question can't really be answered without knowing the prior probability and using Bayesian thinking. We'll pass on that, and instead ask a slightly different question: *"If the tool really is in the basement, what is the chance your child would have found it"?*

#pagebreak()

The answer depends on the answers to these questions:

- *How long did he spend looking?* If he looked for a long time, he is more likely to have found the tool.
- *How big is the tool?* It is easier to find a snow shovel than the tiny screw driver you use to fix eyeglasses.
- *How messy is the basement?* If the basement is a real mess, he was less likely to find the tool than if it is super organized.

So if he spent a long time looking for a large tool in an organized basement, there is a high chance that he would have found the tool if it were there. So you can be quite confident of his conclusion that the tool isn't there.

If he spent a short time looking for a small tool in a messy basement, his conclusion that "the tool isn't there" doesn't really mean very much.

== Analogy with sample size and power

*Power* is the answer to this question: If an effect (of a specified size) really occurs, what is the chance that an experiment of a certain size will find a "statistically significant" result?

- The time searching the basement is analogous to *sample size*. If you collect more data you have a higher power to find an effect.
- The size of the tool is analogous to the *effect size* you are looking for. You always have more power to find a big effect than a small one.
- The messiness of the basement is analogous to the *standard deviation* of your data. You have less power to find an effect if the data are very scattered.

If you use a large sample size looking for a large effect using a system with a small standard deviation, there is a high chance that you would have obtained a "statistically significant effect" if it existed. So you can be quite confident of a conclusion of "no statistically significant effect".

But if you use a small sample size looking for a small effect using a system with a large standard deviation, then the finding of "no statistically significant effect" really isn't very helpful.
