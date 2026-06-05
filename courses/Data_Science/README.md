# C2: Data Science

## L1. Introductions

**Goal**: get to know data science; what it is, where it comes from, what it can be used for, it's processes, and what roles a data scientist can work with in the industry as a professional knowledge worker.

Lessons:

1. [Data Science Motivation: The Cholera Outbreak and John Snow's Investigation](lessons/01_story_cholera_outbreak.pdf) (~24m)    
    <details><summary>Links to the Story of Broad Stree Pump (London 1854) with John Snow</summary>
     
     - Read Main Article: [1854 Broad Street cholera outbreak](https://en.wikipedia.org/wiki/1854_Broad_Street_cholera_outbreak)
     - Watch YouTube Series: [England: The Broad Street Pump - You Know Nothing, John Snow - Extra History - Part 1](https://www.youtube.com/watch?v=TLpzHHbFrHY&list=PLjLK2cYtt-VCOABKAEJypUSP68GfeBCwz&index=1)
    </details>
2. [Data Science: Composition, Roles, and Analyses](lessons/02_data_science.pdf) (~42m)    
    <details><summary>Links to know more about Data Science Roles</summary>

    - [Your Life As Every Data Scientist Rank](https://youtu.be/hsZDzyET9Yk?si=pqOnBlBM-4BVVLvP) (19m Video)
    - [The Data Movie | Data Literacy Explained Visually](https://youtu.be/J2rQTJby8XM?si=CHN_dMlY9KuEtA2z) (2hr Video)
    - [SDAIA Professional Training in the Fields of Data and AI](https://sdaia.gov.sa/ar/MediaCenter/KnowledgeCenter/ResearchLibrary/ProfessionalTrainingInTheFieldsOfDataAi.pdf) (60p Document)
</details>

**Exercise Sets**:

- [L1.Ex1](exercises/01/data_science_quiz.md) (30m; 15 questions)

## L2. Univariate Analysis

**Goals**:

1. understand essential statistical terminology
2. learn how to interpret frequency distributions & their statistical quantities
3. and how to use Python to describe your data statistically

**Lessons**:

1. [Statistics: Population, Sample, and Variables](lessons/03_statistics.pdf) (~40m)
2. [Frequency Distribution](lessons/04_frequency_distribution.pdf) (~60m)
3. [Lab 1: Normal Distribution and Outliers](lessons/05_normal_and_outlier.ipynb) (~18m)

**Exercises**:

1. [Interpreting Distributions](exercises/02/01_interpreting_distributions.md)

## L3. Bivariate Analysis

**Goal**: learn to explore relationships between variables and be aware that correlation does not imply causation.

**Lessons**:

1. [Bivariate Analysis](lessons/06_bivariate_analysis.pdf) (~20m)
2. [Lab 1: Correlation](lessons/07_correlation.ipynb) (~10m)
3. [Lab 2: Association](lessons/08_association.ipynb) (~10m)
4. [Lab 3: Confounders](lessons/09_confounders.ipynb) (~15m)

## L4: Inferential Statistics

**Goal**: learn how to systematically generalize results from drawn samples on target population.

**Lessons**:

1. [Inferential Statistics: Estimating Parameters with Confidence Intervals](lessons/10_inferential_statistics.pdf) (~29m)
2. [Bootstrapping](lessons/11_confidence_interval.ipynb) (~27m)
3. [Hypothesis Testing](lessons/12_hypothesis_testing.pdf) (~76m)
4. [Power Analysis](lessons/13_power_analysis.ipynb) (~43m)

**Exercises**:

1. [Exercise: Hypothesis Testing: Waiter's Tips](exercises/03/Waiters_Tips.ipynb)

**Resources**:

- [Hypothesis Testing explained in 4 parts | Mon Jul 22 2024, retrieved Jun 1 2026](https://statsig.com/blog/hypothesis-testing-explained)
- [Bootstrapping Main Ideas!!! | StatQuest with Josh Starmer ](https://youtu.be/Xz0x-8-cgaQ?si=k9xH4e8fPvJjEGIq)

**Extra**:

1. [Communicating with Plots](lessons/extra_01_communicate_plots.ipynb)

## Tools

### Visualization Tools

- `plotnine` is for people coming from `R`.
- `matplotlib` is low-level plotting library.
- `seaborn` is statistical, built on top of `matplotlib`.
- `plotly` is interactive (HTML + JS via `dash`).

## References

- [Introduction to Modern Statistics (2e) by Mine Çetinkaya-Rundel and Johanna Hardin](https://openintro-ims.netlify.app/)
- [R for Data Science (2e) by Hadley Wickham, Mine, and Garrett](https://r4ds.hadley.nz/)
- [H. J. Motulsky, GraphPad Statistics Guide](https://www.graphpad.com/guides/prism/latest/statistics/stat_---_principles_of_statistics_-.htm)
- [4.8. Power analysis with statsmodels](https://jillxoreilly.github.io/StatsCourseBook_2024/Chapter7_Power/BuiltInPowerCalc.html)
- [Principles of Data Science - Jan 24, 2025 | OpenStax](https://openstax.org/details/books/principles-data-science)