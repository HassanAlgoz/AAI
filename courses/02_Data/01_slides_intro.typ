#set document(title: "Introduction to Data Science")

= Motivating story: John Snow and the Broad Street Pump

> Open the comic at: #link("https://notebooklm.google.com/notebook/8e9ff4ca-2054-48d5-b0d3-120db7d965f8?artifactId=ce04c28d-cadf-4431-9e82-7d15c8dc4d66")[NotebookLM] and follow the story.

== John Snow's Story: The invisible threat

- London, 1854 — cholera in Soho; hundreds died within days
- Consensus: _miasma_ (bad air)
- Data suggested contaminated water is the cause not the air

::: {.notes}
Open with the comic if you can — it sets the scene quickly. Stress how _crowded_ Soho was and how poor sanitation made “bad air” feel plausible, so the miasma story spread easily. Public health policy chased the _smell_ (cleaning up decay) while Snow asked a different question: what does the _evidence_ actually show? Within days, _hundreds_ died — this is not abstract history; it is a crisis where the wrong theory costs lives. Snow did not dismiss domain expertise (physicians cared about disease); he dismissed a consensus that was _not backed by systematic evidence_.
:::


== Gathering the data

Germ theory wasn't established yet. But Snow collected data:
+ _Where_ each household lived.
+ _Which_ drinking water they used.

He put deaths on a _map_ to see if proximity to certain locations plays a role. Deaths were clustered around the _Broad Street pump_.

#image("/assets/snows-mapped-death-frequency.png")

::: {.notes}
Germ theory was not established; microscopes could not yet nail cholera’s cause. So Snow could not win by arguing _microbiology_ — he had to argue from _observation_. Emphasize the legwork: he _walked Soho_, knocked on doors, interviewed families of the dead. That is _structured data collection_ before spreadsheets: two fields per household, repeatable and checkable. The map is not decoration; it is how you turn a table into something human perception can _see_. Mention that a list of addresses hides the cluster — the map _reveals_ it.

Walk them through the image: deaths are _not_ smeared across “the bad part of town.” They hug one infrastructure point — the pump. That is the narrative pivot: if miasma were right, you might expect something broader and wind- or smell-shaped; what you get is _water-shaped_. Keep this slide short; let the map do the talking.
:::

== Investigating anomalies

_Exceptions_ were:
+ The brewery: No deaths. Workers drank from a private well.
+ The workhouse: No deaths. They drank from their own dug well.
+ The Hampstead widow: Died far from Soho; it turns out, she drank from the _Broad Street water_.
+ Her niece, Died. He visited her.

_Conclusion:_ in other words, proximity was showed correlation, but source of water was the actual cause.

::: {.notes}
This is where many stories skip ahead — don’t. Outliers are not annoyances; here they _strengthen_ the case. The brewery and workhouse show you can be _surrounded_ by death and stay safe if you do not drink that water. The widow is the killer detail: cholera follows the _water_, not the neighborhood. Say clearly: anomalies _tested_ the hypothesis and, when explained, became some of the _strongest_ evidence. That is how rigorous analysis uses exceptions instead of hiding them.
:::

== Data to action

Snow showed the board his map and reasoning; they acted on the evidence.

> "I had an interview with the Board of Guardians of St. James's parish... In consequence of what I said, the handle of the pump was removed on the following day." — John Snow

The well was later found _near a leaking cesspit_ (حفرة صرف صحي).

::: {.notes}
Quote lands better if you pause after it — it is a rare moment where analysis becomes a _physical_ act in 24 hours. The cesspit detail is the historical “ground truth” that later vindicated Snow: contamination pathway, not moral failing of the poor. Tie it to _intervention_: evidence → decision → action that _stops harm_. That is the arc students should remember.
:::


== Why this matters for data science

John Snow’s workflow is still the template:
+ _Question assumptions_ — demand evidence, not consensus alone.
+ _Collect_ structured, verifiable information.
+ _Visualize_ to see patterns lists hide.
+ _Explain outliers_ — they often _test_ relationship is causal.
+ _Act_ — turn insight into a _specific_ intervention.

_Data science_ is using evidence to understand a situation and decide what to do — with modern tools for what Snow did on foot and on paper.

::: {.notes}
Bridge explicitly to the course: we are not training “people who only write code” or “people who only memorize formulas.” We are training the habit of _evidence, clarity, and action_ — gather, visualize, stress-test, then change something. Snow is the _through-line_ for the module: when tools get fancy, return to this story so the _purpose_ stays clear.
:::


== What is data science?

_Data_ (plural): digitally recorded pieces of information about events. Together they support a full picture — stored and processed on computers.

- Numbers, text, images, sound, …
- Types: numerical, categorical (and subtypes).
- Different _algorithms_ for different goals.

> _Data science_ is an interdisciplinary field that uses scientific methods, processes, algorithms, and systems to extract _knowledge and insights_ from structured and unstructured data. It combines _statistics_, _computer science_, and _domain knowledge_ to analyze data and support decisions and prediction.

::: {.notes}
There is far more to say about _data_ alone (types, quality, bias, scale) — that is why the field has a name. The definition on the slide is the “official” umbrella; your job in lecture is to keep it _grounded_: data science is not a buzzword, it is _disciplined_ use of data across three pillars you will name next. If students feel overwhelmed, reassure them: we unpack pieces step by step.
:::


== Three pillars

- _Domain knowledge_ — the right questions and interpreting results.
- _Math & statistics_ — sound conclusions from _incomplete_ information.
- _Computer science_ — storage, algorithms, scale.

#image("/assets/Data-Science-Venn-Diagram.png")

::: {.notes}
Image source (if asked): ResearchGate figure used widely in teaching — the _idea_ matters more than the brand: three circles that _overlap_ in practice. No single pillar is enough; weak domain knowledge asks the wrong question, weak stats trusts noise, weak CS cannot ship or scale. Keep the diagram on screen while you speak so they associate the words with the picture.
:::

== Data science life cycle

#image("/assets/DSLC.png")

Standard path from raw data to useful insight or product, and how roles map to the pipeline.

::: {.notes}
Set expectations: this diagram is a _map_, not a law. Real projects loop back (deployment reveals new cleaning needs, etc.). The point is to see _where_ different jobs sit so vocabulary matches industry — especially when students read job posts that mix “analyst,” “scientist,” and “engineer.”
:::

== The process
+ _Collection_ — databases, logs, files, sensors, …
+ _Cleaning_ — missing values, duplicates, formats, errors.
+ _EDA_ — summaries and plots; trends, correlations, anomalies.
+ _Model building_ — learn patterns / predict on new data.
+ _Deployment_ — ship models into apps, APIs, or pipelines that run on _new_ data.

::: {.notes}
Narrate as a _pipeline_: garbage in → garbage out, so cleaning matters; EDA before big models is _cheap insurance_; deployment is where many academic courses stop — in industry, if it is not deployed, it often does not count. Mention that “model” is broad here: from a simple rule to deep learning, the _lifecycle_ stage is the same.
:::


== The roles

In large orgs these lines are sharp; in startups one person may wear several hats:

- _Data engineers_ — infrastructure: ingestion, storage, pipelines (collection & cleaning).
- _Data analysts_ — clean data, EDA, reports and dashboards (cleaning & EDA).
- _ML engineers_ — reliable, efficient models in production (build & deploy).
- _Data scientists_ — can span the whole cycle; often deepest in EDA and modeling, with enough engineering to get data and ship value.

See: #link("https://sdaia.gov.sa/ar/MediaCenter/KnowledgeCenter/ResearchLibrary/ProfessionalTrainingInTheFieldsOfDataAi.pdf")[SDAIA Professional Training in the Fields of Data and AI].

::: {.notes}
Contrast _big tech_ (narrow roles, handoffs) vs _small teams_ (generalists). Data scientists as _generalists_ still usually lean hardest on EDA and modeling — but they get stuck if they cannot read a pipeline or talk to engineers about deployment. Analysts answer “what happened?”; many DS/ML roles aim at “what will happen?” or “what should we do?” — overlap is normal; titles are messy.
:::

== The Data Movie | Data Literacy Explained Visually

{{< video https://www.youtube.com/embed/J2rQTJby8XM width="100%" height="75%"  >}}

== The Non-linear Nature of Data Science

- The view of data science as a multi-stage process can be attributed to Box (@box1976science) and Cox and Snell (@cox1981applied)
- In reality, DSLC is a non-linear problem-specific path of iterative refinement

#image("/assets/iterative_refinement.png")

== The Map is not the Territory

#image("/assets/map_is_not_territory.png")

== The Map is not the Territory

As Data Scientists, our work spans the _three realms_:
+ reality
+ an approximation of reality (the data)
+ and mental constructs (the analyses/algorithms)

#image("/assets/three_realms.png")

> The trustworthiness of our data-driven results depends heavily upon (1) the _current data_ that we are conducting our analysis on and (2) the _future data_ that we are applying our conclusions to being an effective approximation of reality, as well as our analyses and algorithms involving realistic assumptions and capturing relevant patterns. 

== Our World in Data

Want to look at the world through data? See many examples at: #link("https://ourworldindata.org/")[Our World in Data] — research and data on global challenges.

::: {.notes}
Homework-style nudge: OWID is a _trusted_ entry point for global health, environment, and inequality — good for capstones and for calibrating “what good visualization + sourcing looks like.” Encourage them to bookmark it.
:::


== Data Analysis

> _Data analysis_ is the process of inspecting, cleansing, transforming, and modeling data with the goal of discovering useful information, informing conclusions, and supporting decision-making.

Two approaches:

:::: {.columns}
::: {.column}
+ _Confirmatory Data Analysis (CDA)_  
   A top-down approach in which we start with a question and use data to answer it.  
   
   Example: Hypothesis: "people are addicted to smart phones". Let's see if the data supports this.  
   
   #link("./02_lab_cda_blind_typing.ipynb")[Lab 1: Blind Typing Experiment].
:::
::: {.column}
+ _Exploratory Data Analysis (EDA)_  
   A bottom-up approach in which we start with the data and try to find something interesting.

   Example Data: "people who exercise at the gym". Let's find out what are their: ages, occupations, and common interests are.  

   #link("./03_lab_eda_census.ipynb")[Lab 2: Exploring US Census 2010-2019 Data].
:::
::::
<!-- end columns -->

= The End