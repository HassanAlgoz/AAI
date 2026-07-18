#import "@preview/touying:0.7.3": *
#import "@preview/curryst:0.5.1" as curryst: rule

#import "/template/theme.typ": *

#show: university-theme.with(
  config-colors(
    primary: primary-color,
    secondary: secondary-color,
    tertiary: tertiary-color,
    neutral-darkest: text-color
  ),
  config-info(
    title: [Data Science Motivation],
    subtitle: [The Cholera Outbreak and John Snow's Investigation],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= The Cholera Outbreak

== Back in 1854

#columns(2, gutter: 8pt)[

    #figure(
      image("/assets/02/ds_intro/punch_1852.png"),
      caption: [A Court for King Cholera. Illustration from Punch (1852)],
    )

    #colbreak()

    #figure(
      image("/assets/02/ds_intro/street_pump_replica.png", width: 60%),
      caption: [A replica pump commemorating the outbreak and John Snow's investigation of it],
    )
]

== The invisible threat

London, 1854 — cholera in Soho; hundreds died within days:
- *Germ theory* wasn't established yet.
- Consensus: _miasma_ (bad air).
- Snow's study was a major event in the history of public health and geography. It is regarded as the founding event of the science of *Epidemiology*.

== Data Collection

Snow collected data:

- _Where_ each household lived.
- _Which_ drinking water they used.

== Mapping the Data

#figure(
    image("/assets/02/ds_intro/snows-mapped-death-frequency.png", width: 37%),
    caption: [Original map by John Snow showing the clusters of cholera cases (indicated by stacked rectangles) in the London epidemic of 1854. The contaminated pump is located at the crossroads of Broad Street and Cambridge Street (now Lexington Street), running into Little Windmill Street.],
  )

== Explaining Exceptions

_Conclusion 1_: he found that deaths were clustered around the _Broad Street pump_.

#pause

However, _unexplained cases_ near the pump:
+ *The Brewery*: No deaths.
+ *The Workhouse*: No deaths.

#pause

_Explanation_: these people drank from private wells (did not drink from the pump).

#pause

Other _Exceptions_: people far away from the pump, died:
+ *The Hampstead Widow* died far from Soho;  
    - It turns out, she drank from the _Broad Street water_.
+ *Her niece* also died.  
    - It turns out, he visited her, and drank from that same water.

== Turn insight into a specific intervention

Snow showed the board his map and reasoning; they acted on the evidence:

#quote(
  [I had an interview with the Board of Guardians of St. James's parish... In consequence of what I said, the handle of *the pump was removed* on the following day.],
  attribution: [John Snow]
)

== Photo: John Snow

#figure(
  image("/assets/02/ds_intro/john_snow_photo.png", width: 30%),
  caption: [John Snow's photo],
)

== How this relates to Data Science?

John Snow’s workflow is still the template:
+ _Question assumptions_ — demand evidence, not consensus alone.
+ _Collect_ structured, verifiable information.
+ _Visualize_ to see patterns lists hide.
+ _Explain outliers_ — they often _test_ relationship is causal.
+ _Act_ — turn insight into a _specific_ intervention.
