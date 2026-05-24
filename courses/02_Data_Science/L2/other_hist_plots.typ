
== Variation 1: Mirror Histogram

A common variation of the histogram is the #link("https://python-graph-gallery.com/density-mirror/")[_mirror histogram_]: it puts face to face 2 histograms to compare their distribution.
#figure(image("/courses/02_Data_Science/assets/stats/population_pyramid.png"))
See: #link("https://datasaudi.sa/en#population-pyramid")[Population Pyramid | DataSaudi.sa]

== Variation 2: Ridgeline Plot

A #link("https://www.data-to-viz.com/graph/ridgeline.html")[_Ridgeline plot_] (sometimes called _Joyplot_) shows the distribution of a numeric value for several groups. Distribution can be represented using histograms or density plots, all aligned to the same horizontal scale and presented with a slight overlap.

#figure(
  image("/courses/02_Data_Science/assets/stats/ridgeplot_temperature_in_lincoln_ne_in_2016.png"),
  caption: [Ridge Plot of Temperature in Lincoln NE in 2016],
)

== Example 3: Comparative IQ Distribution

#figure(image("/courses/02_Data_Science/assets/stats/comparative_sex_iq_distribution.png"))

The figure above shows two *Normal* distributions:

1. with the same *Mean* (center)
2. but different *Standard Deviation* (dispersion).

_Common Misconception_: People often see the red curve is much taller and mistakenly conclude that: "*there are more women in the dataset than men*". Wrong! In reality, the area under the curve represents the total population, not the height of the peak.

Notice that both the red curve (Women) and the blue curve (Men) peak at the same point on the x-axis (IQ ≈ `100`). This indicates that the *mean*, *median*, and *mode* for both groups are approximately equal.

Because the *variance* for men is roughly `5%` to `15%` larger than it is for women, the male distribution curve is wider and flatter, while the female distribution curve is taller and narrower around the middle.

- The Middle: Women are more heavily clustered around the dead-center average (the `85` to `115` IQ range).
- The Extremes: Men are overrepresented at both extremes of the bell curve.

If you look at the extreme right tail of the distribution (an IQ of `140` or higher), the wider male variance means there is a higher ratio of men to women. Conversely, if you look at the extreme left tail (an IQ of `60` or lower), there is also a significantly higher ratio of men to women experiencing severe cognitive deficits.
