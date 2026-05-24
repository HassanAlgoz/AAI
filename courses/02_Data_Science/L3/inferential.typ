

== Example: visual comparison

#figure(
  image("/courses/02_Data_Science/assets/stats/nba_comparative_distribution.png", width: 50%),
  caption: [Comparative Distribution of NBA Player's Heights and Human Heights. Image Source: https://distributionofthings.com/human-height/],
)

Using statistics we can make *Generalizations* like:

1. "men are taller than women" (the phrase "on average" is implied here)
2. "most NBA players are taller than most people"
3. "most NBA players are men"

We can see *overlaps* in the distributions, hence giving us *Definitive Statements* is not possible. For example, we can't say:

- *Positive*: "All men are taller than women"
- *Negative*: "No Player is shorter than the shortest woman"


== Example outcome of statistical analysis

*Experiment Question*: is the one we want to answer with our experiment.

_Question_: are NBA Players really taller than most people?

#figure(
  image("/courses/02_Data_Science/assets/stats/nba_players_are_tall.png"),
  caption: [Sketch of NBA players in a basketball game],
)

We formulate it precisely as in statistical terms as follows:

- _Null Hypothesis_: The average height of NBA Players is *not* _significantly higher_ than the average height of most people.
- _Alternative Hypothesis_: The average height of NBA Players *is* _significantly higher_ than the average height of most people.

We'll talk about *statistical significance* when we get to *Hypothesis Testing*, a central topic in *Inferential Statistics*.

== Precision in Statistics

Precise calculation gives us confidence in generalizing.

#figure(
  image("/courses/02_Data_Science/assets/stats/nba_comparative_distribution.png", width: 50%),
  caption: [Comparative Distribution of NBA Player's Heights and Human Heights. Image Source: https://distributionofthings.com/human-height/],
)

- Adult women globally (mean of `159cm` and standard deviation of `6cm`)
- Adult men globally (mean of `171cm` and standard deviation of `7cm`)
- NBA players; a specific subset of adult men (~2300 players who have been part of an NBA team roster between 1996 and 2019)

When having *outliers* in one distribution, that might signal to us that it is, in fact, a member of another distribution. In this case:

- a Male with a height of `+192cm` might be an *outlier* within males, but
- that's within the $3 sigma$ of the NBA Players distribution (an inlier; just normal)
