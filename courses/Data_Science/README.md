# C2: Data Science

## M1. Introductions

**Goal**: get to know data science; what it is, where it comes from, what it can be used for, it's processes, and what roles a data scientist can work with in the industry as a professional knowledge worker.

**Lessons**:

1. [Data Science Motivation: The Cholera Outbreak and John Snow's Investigation](lessons/01_story_cholera_outbreak.pdf) (~24m)    
    <details><summary>Links to the Story of Broad Stree Pump (London 1854) with John Snow</summary>
     
     - Read Main Article: [1854 Broad Street cholera outbreak](https://en.wikipedia.org/wiki/1854_Broad_Street_cholera_outbreak)
     - Watch YouTube Series: [England: The Broad Street Pump - You Know Nothing, John Snow - Extra History - Part 1](https://www.youtube.com/watch?v=TLpzHHbFrHY&list=PLjLK2cYtt-VCOABKAEJypUSP68GfeBCwz&index=1)
    </details>
2. [Data Science: Composition, Roles, and Analyses](lessons/02_data_science.pdf) (~47m)    
    <details><summary>Links to know more about Data Science Roles</summary>

    - [Your Life As Every Data Scientist Rank](https://youtu.be/hsZDzyET9Yk?si=pqOnBlBM-4BVVLvP) (19m Video)
    - [The Data Movie | Data Literacy Explained Visually](https://youtu.be/J2rQTJby8XM?si=CHN_dMlY9KuEtA2z) (2hr Video)
    - [SDAIA Professional Training in the Fields of Data and AI](https://sdaia.gov.sa/ar/MediaCenter/KnowledgeCenter/ResearchLibrary/ProfessionalTrainingInTheFieldsOfDataAi.pdf) (60p Document)
</details>

**Exercises**:

- `DS 1` [Exercise: What is Data Science?](exercises/01/data_science_quiz.md) (~25m; 15 questions)

## M2. Univariate Analysis

**Goals**:

1. understand essential statistical terminology
2. learn how to interpret frequency distributions & their statistical quantities
3. and how to use Python to describe your data statistically

**Lessons**:

1. [Statistics: Population, Sample, and Variables](lessons/03_statistics.pdf) (~48m)
2. [Frequency Distribution](lessons/04_frequency_distribution.pdf) (~58m)
3. [Lab 1: Normal Distribution and Outliers](lessons/05_normal_and_outlier.ipynb) (~18m)

**Exercises**:

1. `DS 2` [Exercise: Interpreting Distributions](exercises/02/01_interpreting_distributions.md) (~36m)

## M3. Bivariate Analysis

**Goal**: learn to explore relationships between variables and be aware that correlation does not imply causation.

**Lessons**:

1. [Bivariate Analysis](lessons/06_bivariate_analysis.pdf) (~43m)
2. [Lab 1: Correlation](lessons/07_correlation.ipynb) (~24m)
3. [Lab 2: Association](lessons/08_association.ipynb) (~22m)

**Exercises**:

1. `DS 3` [Exercise: Simpson's Paradox](exercises/03/Simpsons_Paradox.ipynb) (~13m)

**Extra**:

1. [Communicating with Plots](lessons/extra_01_communicate_plots.ipynb) (~70m)

## M4. Inferential Statistics

**Goal**: learn how to systematically generalize results from drawn samples on target population.

**Lessons**:

1. [Inferential Statistics: Estimating Parameters with Confidence Intervals](lessons/09_inferential_statistics.pdf) (~29m)
2. [Bootstrapping](lessons/10_confidence_interval.ipynb) (~28m)
3. [Hypothesis Testing](lessons/11_hypothesis_testing.pdf) (~76m)
4. [Power Analysis](lessons/12_power_analysis.ipynb) (~43m)

**Exercises**:

1. `DS 4` [Exercise: Power Analysis: Waiter's Tips](exercises/04/Waiters_Tips.ipynb) (~23m)

**Resources**:

- [Hypothesis Testing explained in 4 parts | Mon Jul 22 2024, retrieved Jun 1 2026](https://statsig.com/blog/hypothesis-testing-explained)
- [Bootstrapping Main Ideas!!! | StatQuest with Josh Starmer ](https://youtu.be/Xz0x-8-cgaQ?si=k9xH4e8fPvJjEGIq)

## Tools

### Visualization Tools

- [`matplotlib`](https://matplotlib.org/) is a low-level plotting library.
- [`seaborn`](https://seaborn.pydata.org/) is statistical, built on top of `matplotlib`.
- [`plotly`](https://plotly.com/python/) is interactive (HTML + JS via `dash`).
- [`plotnine`](https://plotnine.readthedocs.io/en/stable/) is for people coming from `R`.

### Statistics

- [`statsmodels`](https://www.statsmodels.org/) statistical models, statistical tests, and statistical data exploration.

## References

- [Principles of Data Science - Jan 24, 2025 | OpenStax](https://openstax.org/details/books/principles-data-science)
- [Introduction to Modern Statistics (2e) by Mine Çetinkaya-Rundel and Johanna Hardin](https://openintro-ims.netlify.app/)
- [R for Data Science (2e) by Hadley Wickham, Mine, and Garrett](https://r4ds.hadley.nz/)
- [H. J. Motulsky, GraphPad Statistics Guide](https://www.graphpad.com/guides/prism/latest/statistics/stat_---_principles_of_statistics_-.htm)
- [4.8. Power analysis with statsmodels](https://jillxoreilly.github.io/StatsCourseBook_2024/Chapter7_Power/BuiltInPowerCalc.html)