# C2: Data Science

Time estimation: 2-3 minutes per slide.

## L1: Introducton to Data Science

**Goal**: get to know data science; what it is, where it comes from, what it can be used for, it's processes, and what roles a data scientist can work with in the industry as a professional knowledge worker.

Learning Material:

1. [Data Science Motivation: The Cholera Outbreak and John Snow's Investigation](L1/01_story_cholera_outbreak.typ) (~24m)    
    <details><summary>Links to the Story of Broad Stree Pump (London 1854) with John Snow</summary>
     
     - Read Main Article: [1854 Broad Street cholera outbreak](https://en.wikipedia.org/wiki/1854_Broad_Street_cholera_outbreak)
     - Watch YouTube Series: [England: The Broad Street Pump - You Know Nothing, John Snow - Extra History - Part 1](https://www.youtube.com/watch?v=TLpzHHbFrHY&list=PLjLK2cYtt-VCOABKAEJypUSP68GfeBCwz&index=1)
    </details>
2. [Data Science: Composition, Roles, and Analyses](L1/02_data_science.typ) (~42m)    
    <details><summary>Links to know more about Data Science Roles</summary>

    - [Your Life As Every Data Scientist Rank](https://youtu.be/hsZDzyET9Yk?si=pqOnBlBM-4BVVLvP) (19m Video)
    - [The Data Movie | Data Literacy Explained Visually](https://youtu.be/J2rQTJby8XM?si=CHN_dMlY9KuEtA2z) (2hr Video)
    - [SDAIA Professional Training in the Fields of Data and AI](https://sdaia.gov.sa/ar/MediaCenter/KnowledgeCenter/ResearchLibrary/ProfessionalTrainingInTheFieldsOfDataAi.pdf) (60p Document)
</details>

**Exercise Sets**:

- [L1.Ex1](L1/exset_1/data_science_quiz.md) (30m; 15 questions)

## L2: Descriptive Statistics

**Goals**:

1. understand essential statistical terminology
2. learn how to interpret frequency distributions & their statistical quantities
3. and how to use Python to describe your data statistically

**Learning Material**:

1. [Statistics: Population, Sample, and Variables](L2/01_statistics.pdf) (~40m)
2. [Frequency Distribution](L2/02_frequency_distribution.pdf) (~60m)
3. [Lab 1: Normal Distribution and Outliers](L2/03_normal_and_outlier.ipynb) (~18m)


## L3: Multi-variate Analysis

**Goal**: learn to explore relationships between variables and be aware that correlation does not imply causation.

**Learning Material**:

1. [Multi-variable Analysis](L3/01_multi-variate_analysis.typ) (~32m)
2. [Lab 1: Correlation](L3/02_correlation.ipynb) (~24m)
3. [Lab 2: Association](L3/03_association.ipynb) (~42m)
4. [Lab 3: Confounders](L3/04_confounders.ipynb) (~11m)

## L4: Inferential Statistics

**Goal**: learn how to systematically generalize results from drawn samples on target population.

**Learning Material**:

1. [Inferential Statistics: Estimating Parameters with Confidence Intervals](L4/01_inferential_statistics.typ) (~29m)
2. [Bootstrapping](L4/02_confidence_interval.ipynb) (~27m)
3. [Hypothesis Testing](L4/03_hypothesis_testing.pdf) (~76m)
4. [Power Analysis](L4/04_power_analysis.ipynb) (~43m)

Learn more about the: #link("https://youtu.be/Q_pO9NzWxPY?si=nJbx_ruQrBdtK3EC")[One sample t-test vs Independent t-test vs Paired t-test | YouTube video by: numiqo]

[Bootstrapping Main Ideas!!! | StatQuest with Josh Starmer ](https://youtu.be/Xz0x-8-cgaQ?si=k9xH4e8fPvJjEGIq)

[Hypothesis Testing explained in 4 parts | Mon Jul 22 2024, retrieved Jun 1 2026](https://statsig.com/blog/hypothesis-testing-explained)

References:

1. R4DS Chaper 1 [Data Visualization](https://github.com/hadley/r4ds/blob/main/data-visualize.qmd)
2. R4DS Chapter 10 Exploratory data analysis
3. R4DS Chapter 11  Communication
4. R4DS Chapter 20 Importing data from Spreadsheets
5. R4DS Chapter 21 Importing data from Databases
6. IMS Chapter 2: [Study design](https://raw.githubusercontent.com/openintrostat/ims/main/data-design.qmd)
7. [Pie Charts](https://openintro-ims.netlify.app/explore-categorical#pie-charts)
8. [Waffle Chart](https://openintro-ims.netlify.app/explore-categorical#waffle-charts)
9. [Comparing numerical data across groups](https://openintro-ims.netlify.app/explore-categorical#comparing-numerical-data-across-groups)

Visualization Tools:

- `plotnine` is for people coming from `R`
- `matplotlib` is too low-level
- `seaborn` is statistical
- `plotly` has statistical plots, and interactive (HTML + JS via `dash`)

## References

- [Introduction to Modern Statistics (2e) by Mine Çetinkaya-Rundel and Johanna Hardin](https://openintro-ims.netlify.app/)
- [R for Data Science (2e) by Hadley Wickham, Mine, and Garrett](https://r4ds.hadley.nz/)
- [H. J. Motulsky, GraphPad Statistics Guide](https://www.graphpad.com/guides/prism/latest/statistics/stat_---_principles_of_statistics_-.htm)
- [4.8. Power analysis with statsmodels](https://jillxoreilly.github.io/StatsCourseBook_2024/Chapter7_Power/BuiltInPowerCalc.html)