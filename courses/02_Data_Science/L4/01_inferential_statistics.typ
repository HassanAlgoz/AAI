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

In most real-world scenarios, population data cannot be obtained or is impractical to obtain, making inferential statistics essential.

*Inferential statistics* plays a key role in data science applications, as its techniques allow researchers to infer or *generalize* observations from samples to the larger population from which they were selected. Specifically, done in two ways:

1. *Confidence Interval* estimates a range for a population parameter.
2. *Hypothesis Testing* tests claims about the population parameters that challenge the status quo.

#figure(
  image("/courses/02_Data_Science/assets/stats/inferential_statistics.png", width: 50%),
)

== Sampling Distribution

Example: A researcher takes repeated samples of size 1,000 from the residents of New York to collect data on mean income of residents of New York. For each sample of size 1,000, we can calculate a sample mean $bar(x)$. If the researcher were to take 50 such samples (each of sample size 1,000), a series of sample means can be calculated:

$ bar(x)_1, bar(x)_2, bar(x)_3, ..., bar(x)_50 $

#pause

A *Sampling Distribution* can then be analyzed:

1. The mean of the sample means $mu_bar(x)$ estimates the population mean $mu$.
2. The standard deviation of the sample means $sigma_bar(x)$ (known as the *Standard Error*) estimates the population standard deviation $sigma$.

== Central Limit Theorem (CLT)

The *Central Limit Theorem (CLT)* says: the distribution of the sample means is normal.

Note: as long as the sample size is large enough, the CLT holds true regardless of:

1. the distribution of the population or
2. the disitrubtions of the samples individually

#figure(
  image("/courses/02_Data_Science/assets/stats/population_distribution_vs_sampling_distribution.png", width: 50%),
  caption: [Central Limit Theorem],
)

== Distribution of Variables vs Sampling Distribution

It is important to emphasize that the distribution we're looking at is the *Sampling Distribution* of the sample means, not the distribution of the variable itself.

#figure(
  image("/courses/02_Data_Science/assets/stats/age_and_sampling_distribution.png", width: 50%),
  caption: [Left: Age Distribution (a variable), Right: Sampling Distribution (a statistic)],
)

== Confidence Intervals

A *Confidence Interval (CI)* estimates the range within which a population parameter is likely to be.

Usually associated with *Type I Error* $alpha = 0.05$; which translates to saying: there is only a $5%$ chance that the population parameter is outside the estimated upper and lower bounds (conversely, *Confidence Level* of $95%$).

#figure(
  image("/courses/02_Data_Science/assets/stats/95p_confidence_interval.png", width: 25%),
  caption: [95% Confidence Interval],
)

#pause

=== Lower and Upper Bounds

Two terms make up the CI:

1. *Point Estimate* the center of the confidence interval.
2. *Margin of Error* the half-width of the confidence interval.

As such we get various formulas depending on the parameter being estimated:

- for population mean $mu in mu_bar(x) ± z*sigma/sqrt(n)$
- for population proportion $p in p_hat ± z*sqrt(p_hat(1-p_hat)/n)$
- for population standard deviation $sigma in sigma_s ± t*sigma_s/sqrt(n)$

== Effect of Sample Size on Confidence Interval

Notice how the _margin of error_ decreases as the *Sample Size* $n$ increases. Here, we observed the narrowing down of the interval around the point estimate $mu_bar(x) = 20$:

#figure(
  image("/courses/02_Data_Science/assets/stats/ci_vs_sample_size.png", width: 60%),
  caption: [Two overlapping confidence intervals for the same point estimate of $mu_bar(x) = 20$ and $n_1 = 30$ and $n_2 = 3000$],
)