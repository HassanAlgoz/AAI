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
    title: [Inferential Statistics],
    subtitle: [Estimating Parameters with Confidence Intervals],
    author: [Hassan Algoz],
    date: datetime.today(),
    institution: [Alsun AI],
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Inferential Statistics

== What is Inferential Statistics?

*Inferential statistics* plays a key role in data science applications, as its techniques allow researchers to infer or *generalize* observations from samples to the larger population from which they were selected. Specifically, done in two ways:

1. *Confidence Interval* estimates a range for a population parameter.
2. *Hypothesis Testing* tests claims about the population parameters that challenge the status quo.

Remember:

- A *population* is the entire group of interest. A *sample* is a subset of the population.
- A *parameter* is a numerical summary of a population. A *statistic* is a numerical summary of a sample.

#pagebreak()

In most real-world scenarios, population data cannot be obtained or is impractical to obtain, making inferential statistics essential.

#figure(
  image("/courses/02_Data_Science/assets/stats/inferential_statistics.png"),
  caption: [Left: Population, Right: Sample],
)

== Bootstrapping

In modern statistics, *Bootstrapping* has become the standard way to estimate standard error.

1. it can be used for virtually any statistic and
2. does not rely on any distributional assumptions (such as data being normally distributed)

How it works? resample with replacement from the sample to create a new sample.

Example: a sample of 1000 students, we can create 50 new samples of 100 students by resampling with replacement from the original sample.

$ overline(x)_1, overline(x)_2, overline(x)_3, ..., overline(x)_50 $

== Sampling Distribution

Such *Sampling Distribution* can then be analyzed:

1. The mean of the sample means $mu_overline(x)$ estimates the population mean $mu$.
2. The standard deviation of the sample means $sigma_overline(x)$ (known as the *Standard Error*) estimates the population standard deviation $sigma$.

The *Central Limit Theorem (CLT)* says: the distribution of the sample means is normal.

Note: as long as the sample size is large enough, the CLT holds true regardless of:

1. the distribution of the population or
2. the disitrubtions of the samples individually

== Central Limit Theorem (CLT)

#figure(
  image("/courses/02_Data_Science/assets/stats/population_distribution_vs_sampling_distribution.png"),
  caption: [Central Limit Theorem],
)

#pagebreak()

#figure(
  image("/courses/02_Data_Science/assets/stats/clt_sampling_dsitrubtion_of_means.png"),
  caption: [Sampling Distribution of Means \ Source: https://medium.com/@amanatulla1606/python-implementation-of-central-limit-theorem-exploring-sample-data-to-infer-population-595e39e0c98e
],
)

== Confidence Intervals

A *Confidence Interval (CI)* estimates the range within which a population parameter is likely to be.

Usually associated with *Type I Error* $alpha = 0.05$ (conversely, *Confidence Level* of $95%$); which translates to saying: there is only a $5%$ chance that the population parameter is outside the estimated upper and lower bounds.

#figure(
  image("/courses/02_Data_Science/assets/stats/95p_confidence_interval.png", width: 45%),
  caption: [95% Confidence Interval],
)

== Lower and Upper Bounds

Two terms make up the CI:

1. *Point Estimate* the center of the confidence interval.
2. *Margin of Error* the half-width of the confidence interval.

As such we get various formulas depending on the parameter being estimated:

- for population mean $mu in mu_overline(x) ± z sigma/sqrt(n)$
- for population proportion $p in p_hat ± z sqrt(p_hat(1-p_hat)/n)$
- for population standard deviation $sigma in sigma_s ± t sigma_s/sqrt(n)$

== Critical Value

*Critical Value ($z_c$)* is the z-score that corresponds to the desired confidence level:

#align(center)[
  #table(
    columns: (auto, auto),
    [*Level*], [*$z_c$*],
    [80%], [1.280],
    [90%], [1.645],
    [95%], [1.960],
    [99%], [2.575],
  )
]

#figure(
  image("/courses/02_Data_Science/assets/stats/critical_value_95.png", width: 35%),
  caption: [Critical Values $plus.minus z_c$ marked on the Standard Normal Curve for 95% Confidence Level],
)

== Effect of Sample Size

Notice how the _margin of error_ decreases as the *Sample Size* $n$ increases. Here, we observed the narrowing down of the 95% CI around the point estimate $mu_overline(x) = 20$:

#figure(
  image("/courses/02_Data_Science/assets/stats/ci_vs_sample_size.png", width: 60%),
  caption: [Two overlapping confidence intervals for the same point estimate of $mu_overline(x) = 20$ for $n_1 = 30$ and $n_2 = 3000$],
)