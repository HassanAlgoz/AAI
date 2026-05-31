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

== Review: Population and Sample

- A *population* is the entire group of interest. A *sample* is a subset of the population.
- A *parameter* is a numerical summary of a population. A *statistic* is a numerical summary of a sample.

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

= Statistical Power

== Type I and Type II errors

When you make a conclusion about whether an effect is significant, you can be wrong in two ways:

You've made a *Type I Error ($alpha$)* when there really is no difference or relationship overall, but random sampling caused it to show up somehow.

#columns(2)[
  #figure(
    image("/courses/02_Data_Science/assets/stats/correlation_type_I_error_2.png"),
    caption: [Actual data showing no significant correlation],
  )

  #figure(
    image("/courses/02_Data_Science/assets/stats/correlation_type_I_error_1.png"),
    caption: [Cherry-picked data showing a significant correlation],
  )
]

#pagebreak()

You've made a *Type II Error ($beta$)* when there really is a difference or relationship overall, but random sampling caused it to not show up.

#columns(2)[
  #figure(
    image("/courses/02_Data_Science/assets/stats/correlation_type_II_error_1.png"),
    caption: [Actual data showing significant correlation],
  )
  #figure(
    image("/courses/02_Data_Science/assets/stats/correlation_type_II_error_2.png"),
    caption: [Cherry-picked data showing no significant correlation],
  )
]

== Definition: Statistical Power

$alpha = P("Type I Error") = P("Reject" H_0 | H_0 "is true")$ 
  
$beta = P("Type II Error") = P("Fail to Reject" H_0 | H_0 "is false")$  
  
*Power* is the probability that your experiment will produce a *p-value* small enough to claim statistical significance, assuming a true effect actually exists.

$ "Power" & = P("p-value" < alpha | H_a "is true") \
          & = P("Reject" H_0 | H_0 "is false") \ 
          & = 1 - beta $

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

== Another Analogy

To tie it all together, imagine trying to hear a friend talking to you across a room:

- *Effect Size* is how loud your friend is shouting (The Signal).
- *Variability* is how loud the rest of the party is (The Noise).
- *Sample Size* is how long you listen, or how good your hearing aids are (The Resolution).

== Power in 1D

== Factors that affect power

1. Effect Size
2. Sample Size
3. Variance

#pagebreak()

=== Effect Size
The larger the effect, the easier it is to detect.
  - If a new drug extends life by 10 years, that is a massive effect size. If it extends life by 2 days, that is a tiny effect size.

#pagebreak()

=== Sample Size
_how much data_ you collect.
  - If you only test 5 people, a few outliers can skew the results. If you test 5,000 people, individual quirks wash out, revealing the true average.

#pagebreak()

=== Variance
_how spread out_ or messy the data is. High variability creates "noise" that drowns out the effect you are looking for.
  - Imagine measuring the heights of two groups. If everyone in Group A is exactly 5'0" and everyone in Group B is exactly 5'2" (zero variability), the difference is immediately obvious.
  - But if both groups contain people ranging from 4'10" to 6'0" (high variability), it becomes incredibly difficult to tell the groups apart on average.
