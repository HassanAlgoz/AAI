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
    title: [Frequency Distribution],
    subtitle: [Interpreting Data Frequencies],
    author: [Hassan Algoz],
    date: datetime.today(),
    institution: [Alsun AI],
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Frequency Distribution

== Frequency Distribution

*Frequency Distribution (توزيع التكرار)*: is a list of all possible values of a variable, together with the number of times each value occurred in the dataset.

#columns(2, gutter: 8pt)[
  
  #figure(
    image("/courses/02_Data_Science/assets/stats/frequency_distribution_discrete.png", height: 60%),
    caption: [*Bar Plot* of species of penguins],
  )

  #colbreak()

  #figure(
    image("/courses/02_Data_Science/assets/stats/frequency_distribution_continuous.png", height: 73%),
    caption: [*Histogram* of body mass of penguins],
  )
  
]

== Visual Description: Bar Plot

#columns(2, gutter: 8pt)[
  
  #figure(
    image("/courses/02_Data_Science/assets/stats/frequency_distribution_discrete.png", height: 60%),
    caption: [*Bar Plot* of species of penguins],
  )

  #colbreak()

  *Bar Plots* help us answer questions like:

  + What is the *frequency (التكرار)* of each value?
  + What is the *proportion (النسبة)* of each value?
  + What values are *most* or *least* frequent?
]

== Visual Description: Histogram

#columns(2, gutter: 8pt)[

  *Histograms* are used to answer important questions:

  + What *range (المدى)* do the observations cover?
  + What the most typical value: i.e., *mean (المتوسط)* or *median (الوسيط)*?
  + What values are *normal (عادي)* and which are *outliers (متطرف)*?

  #colbreak()

    #figure(
    image("/courses/02_Data_Science/assets/stats/frequency_distribution_continuous.png", height: 73%),
    caption: [*Histogram* of body mass of penguins],
  )
]

== Kernel Density Plot

*Kernel Density Plot (KDE)* is a smooth curve that shows the distribution of a continuous variable.

#columns(2, gutter: 8pt)[

  #figure(
    image("/courses/02_Data_Science/assets/stats/frequency_distribution_continuous.png", height: 60%),
    caption: [*Histogram* of body mass of penguins],
  )

  #colbreak()

  #figure(
    image("/courses/02_Data_Science/assets/stats/frequency_distribution_kde.png", height: 72%),
    caption: [*Kernel Density Plot* of body mass of penguins],
  )
  
]

== Types of Frequency Distributions

#columns(2, gutter: 8pt)[
  #figure(image("/courses/02_Data_Science/assets/stats/histogram_distributions.png", width: 100%), caption: [Six named types of frequency distributions])

  #colbreak()

  + *Normal (طبيعي)*: centered and symmetric.
  + *Uniform (متساوي)*: same everywhere.
  + *Left-skewed (إلتواء يساري)*: descending left.
  + *Right-skewed (إلتواء يميني)*: descending right.
  + *Bimodal (ثنائي المنوال)*: suggests two normals.
  + *Multi-modal (متعدد المنوال)*: suggests multiple normals.
]

== Properties of Distributions

We describe a distribtuion by three properties:
+ *Measures of Center (مقاييس المركز)*: mean, median, mode
  + *Skewness (الإلتواء)*: skewness
+ *Measures of Variance (مقاييس التباين)*: variance, standard deviation, range
+ *Measures of Position (مقاييس الموقع)*: percentile, z-score

== Measures of Center

+ *Mean (المتوسط)* (a.k.a average): the center of "mass" ($overline(x)$ or $mu$).
+ *Median (الوسيط)*: the middle value when data are ordered.
+ *Mode (المنوال)*: the most frequent value.

The mean is the sum $Sigma$ divided by the count $n$:

$ mu = 1/n sum_(i=1)^n x_i $

#figure(
  image("/courses/02_Data_Science/assets/stats/mean.png", width: 38%),
  caption: [Mean is the midpoint between two values],
)

== Skewness

The *skewness (الإلتواء)* statistic is interpreted as follows:

- $<0$ Left-tailed.
- $0$ Symmetric.
- $>0$ Right-tailed.

#figure(image("/courses/02_Data_Science/assets/stats/skewness.png", width: 80%), caption: [Skewness])

== Measures of Variation

- *Range (المدى)*: the difference between the maximum and minimum values.
- *Variance (التباين)*: the average of the squared differences from the mean ($sigma^2$).
- *Standard Deviation (الانحراف المعياري)*: the square root of the variance ($sigma$).

The variance $sigma^2$ is the sum of the squared differences from the mean:

$ sigma^2 = 1/n sum_(i=1)^n (x_i - mu)^2 $

#columns(2, gutter: 8pt)[
  #figure(
    image("/courses/02_Data_Science/assets/stats/low_dispersion.png", width: 100%),
  )

  #colbreak()

  #figure(
    image("/courses/02_Data_Science/assets/stats/high_dispersion.png", width: 100%),
  )
]

== Mean and Variance; a Physical Sense

In Physics these mathematical quantities indicate:

- the _variance_ indicate the spread of the mass of the object
- the _mean_ of the lengths of the object indicates the center of its mass

#figure(image("/courses/02_Data_Science/assets/stats/variance_physical_metaphor.png", width: 65%), caption: [Same mean, different variance.])

== Measures of Position: Percentiles

A *Percentile (المئين)* is a value greater than a given percentage of all values in a sample. The *Median (الوسيط)* is the 50th percentile.

The `25%` and the `75%` percentiles go by other names:
- the *1st quartile / lower quartile / Q1 (الربع الأول)*
- the *3rd quartile / upper quartile / Q3 (الربع الثالث)*

#figure(
  image("/courses/02_Data_Science/assets/stats/percentiles.png", width: 63%),
  caption: [Percentiles],
)

== Histogram and percentiles

#figure(image("/courses/02_Data_Science/assets/stats/percentiles_on_histogram.png", width: 65%), caption: [The 20th percentile shown on a histogram])

== Kernel Density Plot and percentiles

#figure(image("/courses/02_Data_Science/assets/stats/percentile_on_kde.png", width: 100%), caption: [The 20th percentile shown on a Kernel Density Plot])

== Interquartile Range (IQR)

The *Interquartile Range* (a.k.a _midspread_) is defined as the difference between the 75th and 25th percentiles of the data: $"IQR" = Q_3 - Q_1$ which is the range spanned by the middle 50% of the data points.

#figure(image("/courses/02_Data_Science/assets/stats/iqr_on_iq_kde.png", width: 50%), caption: [KDE Plot with shaded area showing the IQR = 120 - 80 = 40])

== The Normal Distribution

The *Normal Distribution* is a bell-shaped distribution that is symmetric around the mean, with the highest density of data points in the center.


#figure(image("/courses/02_Data_Science/assets/stats/normal_distribution.png", width: 55%), caption: [The Normal Distribution])

#quote(
  [It is the most widely used piece of statistics by far.],
  attribution: [Wikipedia]
)

== Empirical Rule

The *Empirical Rule* for the Normal Distribution is that:

- 68.2% observations $in mu ± 1 sigma$.
- 95.4% observations $in mu ± 2 sigma$.
- 99.7% observations $in mu ± 3 sigma$.

#columns(3, gutter: 8pt)[
  #figure(image("/courses/02_Data_Science/assets/stats/normal_1.png", width: 100%), caption: [$mu ± 1 sigma$ \ "Likely"])
  #colbreak()

  #figure(image("/courses/02_Data_Science/assets/stats/normal_2.png", width: 100%), caption: [$mu ± 2 sigma$ \ "Very Likely"])
  #colbreak()

  #figure(image("/courses/02_Data_Science/assets/stats/normal_3.png", width: 100%), caption: [$mu ± 3 sigma$ \ "Almost Certainly"])
]

== Examples of the empirical rule

The rule is _empirical_ because it is derived from "experienced" observations (data); not purely mathematically nor arbitrary. In fact, measurements in life have this central tendency and dispersion naturally. Hence, the shape got it's name: _Normal_:

#figure(image("/courses/02_Data_Science/assets/stats/human_weight_and_height.png", width: 100%), caption: [Two Histograms of Height and Weight of Humans ($n=25000$)])


== Measures of Position: Z-score

The *z-score* measures the position of a data point as: the number of standard deviations $sigma$ by which a data value differs from the mean $mu$:

$ z = (x - mu) / sigma $

We want to quantify that a person who is 1.85m tall is significantly taller than average. This is how we calculate it:

$ z = (x - mu) / sigma = ("1.89m" - "1.73m") / ("0.048m") = 3.47 $

A z-score of $3.47$ means this person's height is $3.47$ standard deviations *above* the mean. A *significantly high* value compared to the center!

== Z-score Distribution

If we translate all the values of a distribution into z-score values, the shape won't change (since it is a linear transformation) but the scale will change:

#figure(image("/courses/02_Data_Science/assets/stats/in_unit_and_z_score_kde.png", width: 40%), caption: [Z-score Distribution of Human Heights])

== Example 2: Z-score below the mean

Another example: suppose that in a certain neighborhood:

- the mean selling price of a home $mu = dollar"350,000"$
- the standard deviation, calculated as $sigma = dollar"40,000"$
- a particular home sells for $x = dollar"270,000"$

How cheap or expensive this house is, compared to the average price in the neighborhood?

$ z = (x - mu) / sigma = (dollar"270,000" - dollar"350,000") / (dollar"40,000") = -(dollar"80,000")/(dollar"40,000") = -2 $

This z-score of $-2$ indicates a signifiance of $2 sigma$ *below* the mean sale price $mu$; a relatively cheap house!

== Other examples of the Normal Distribution

- Physical/Biological Traits:
    - Human *height* and *weight* (within a specific gender/age group).
    - *Blood pressure* measurements.  

- Performance/Academic Metrics:
    - Standardized test scores (e.g., *IQ*, *SAT*).
    - Athletic performance times (e.g., *100m sprint*). 

- Measurement and Quality Control:
    - Random *measurement errors* in physical experiments.
    - Manufacturing variations (e.g., *weight of packaged products* like sugar or coffee).

== Example: Left-skewed Distribution

- While *most people* die of old age,
- *a smaller number of them* die much younger, pulling the average down.

#figure(image("/courses/02_Data_Science/assets/stats/deaths-in-australia-in-the-year-2012.png", width: 60%), caption: [Left-tailed distrubtion of death by age in Australia in the Year 2012.])

== Example: Bimodal Distribution

Frequency distribution of restaurant visits per hour shows two peaks:

+ peak during *lunch hours*
+ peak during *dinner hours*

#figure(
  image("/courses/02_Data_Science/assets/stats/bimodal_example-1.png", width: 55%),
  caption: [Bimodal distribution of customers at a restaurant by hour],
)