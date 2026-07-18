#import "@preview/touying:0.6.1": *
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
    title: [Judgmental Forecasts],
    subtitle: [When experts (not only models) shape the forecast],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Judgmental Forecasts

== Judgmental Forecasts

In 2012 Australia banned company logos on cigarette packs and required dark green packaging — first country in the world.

How do you forecast the effect on smoking? There is no past series of “plain packs.” A fitted model on old data cannot see this change.

People with domain knowledge must reason about the impact. That is *judgmental forecasting*: forecasts that rely on human expertise when history is missing, delayed, or not comparable.

#pause
=== Newcasting

Central banks often need GDP *now*, but GDP arrives only every quarter.

Experts fill the gap with recent indicators and judgment. That estimate of the *current* state is *nowcasting*.

== When judgment shows up

We often lack data completely or partially for cases like when:
- a new product comes out
- new law is passed
- new competitor enters the market

Pure judgment is usually weaker than a careful model. Use judgment for what the model cannot see. Combine the subjective and objective:
- build a statistical forecast
- then maybe (but not always) adjust it with judgment

= Forecasting by Analogy

== Forecasting by analogy

*Forecasting by analogy* maps your case onto past similar cases and bases the forecast on those outcomes (adjusted for how similar they are).

To value a house, appraisers compare *similar* past sales: size, bedrooms, location, garage, … They do not invent a price from thin air. They borrow the outside pattern from *analogies*.

#pagebreak()
=== Analogy Bias

*Bias* may arise if you use only one favourite story.

Evidence suggests accuracy is better when experts:
+ can name *more than two* analogies and
+ have *direct experience* with them

Hard parts of forecasting by analogy:
+ finding good analogies
+ choosing attributes

= Biases in Judgmental Forecasts

== Same question, different answers

Ask three managers for next quarter’s sales on Monday. Ask again on Friday. You may get six different numbers.

Unlike a fixed formula, human forecasts are *inconsistent*: people, moods, and memory change the answer.

== Forecasts are not targets

A sales manager knows that “the forecast” becomes the sales target.

So they forecast *low* — then beat the target and look good. The number was never “what will happen”; it was a negotiation.

Keep *forecasts* (what will happen) separate from *targets* (what we want to happen). Mixing them creates political bias.

== Wishful thinking

A launch team will not happily forecast that their product fails.

Group meetings add energy and overconfidence. Enthusiasm is not evidence.

Beware of the enthusiasm of marketing and sales colleagues.

== Stuck near the last number

People often start from the latest observation and move only a little — even when big news arrives.

That is *anchoring*: the mind sticks to a familiar reference and underweights new information. The result is *conservatism* — too little updating.

== Limitation checklist

- *Cognitive limits* — miss information; invent wrong causal stories
- *Mood* — optimistic one day, pessimistic the next
- *Politics* — forecasts bent to look good or sell a story
- *Wishful thinking* — especially on launches and in lively meetings
- *Anchoring* — stuck near the last value or a familiar baseline

Structure is how we fight these limits — next section.

#pagebreak()

= Key Principles

#pagebreak()

Research suggests that judgment is more accurate when the person:
+ has domain knowledge
+ has timely information
+ the process is *structured*

== Five principles

+ *Set the task clearly* — define exactly what to forecast; avoid vague or emotional wording. #pause
+ *Use a systematic approach* — checklist of what matters (price, competition, economy, …) and how to weight it. #pause
+ *Document and justify* — write rules and assumptions so others can check them later. #pause
+ *Evaluate systematically* — keep forecast records; compare to outcomes; improve the rules. #pause
+ *Segregate forecasters and users* — the person who predicts should not be the person whose bonus depends on beating the number. #pause

A forecast is the best prediction given the information — not a hope, a target, or a negotiation.

= The Delphi Method

#pagebreak()

The Delphi method was invented by Olaf Helmer and Norman Dalkey of the Rand Corporation in the 1950s for the purpose of addressing a specific military problem. The method relies on the key assumption that forecasts from a group are generally more accurate than those from individuals.

The aim of the Delphi method is to construct *consensus forecasts* from a group of experts in a structured iterative manner. A facilitator is appointed in order to implement and manage the process.

== How the Delphi method works

The *Delphi method* generally involves the following stages:

1. A panel of experts is assembled. #pause
2. Forecasting tasks/challenges are set and distributed to the experts. #pause
3. Experts return initial forecasts and justifications (*anonymously*). Compiled and summarised by facilitator. #pause
4. Feedback is provided to the experts, who now review their forecasts in light of the feedback. This step may be iterated until a satisfactory level of consensus is reached. #pause
5. Final forecasts are constructed by aggregating the experts’ forecasts.

#pagebreak()

The *facilitator*’s job is critical:

- design the process
- control feedback
- keep attention on outliers and their reasons

Typical panel: about 5–20 people with *diverse* expertise.

Usually 2–3 rounds. Beware that more rounds risk *dropout*.

*Anonymity* protects equal voice and reduces politics.


= Judgmental Adjustments

== Adjustments

*Do* adjust when there is strong, *extra* information missing from the model: a big promotion, a holiday spike, a very recent shock. Large, information-driven adjustments help most.

*Do not* adjust to “fix” a pattern you think you see in noise — models handle systematic patterns better. Skip *small* tweaks (especially optimistic upward ones); they tend to hurt.
#pause
=== Process habits

- Adjust *sparingly*.
- *Document and justify* every override.
- Prefer a panel / Delphi-style review over one person’s ownership tweak.

== Cautionary tale: tourism forecasts

Australia’s Tourism Forecasting Committee started from statistical forecasts, then adjusted by consensus in committee layers.

Published domestic tourism forecasts were *optimistic*, especially far ahead — a pattern that continued as more data arrived.

Questions to ask any adjustment meeting:
- are we confusing forecasts with targets?
- are forecasters and users mixed? 
- is optimism rising in the room?
- are we adjusting late in a long day?


= Takeaways

== Takeaways

+ Use judgment when history fails — new policies, new products, delayed data.
+ Prefer statistical forecasts when history is usable; then adjust only for *large, documented* gaps.
+ Fight bias with structure: clear task, checklist, documentation, evaluation, role segregation.
+ Delphi: anonymous experts, few rounds, strong facilitator.
+ Analogies: outside view from multiple scored past cases.
+ Adjust rarely; skip small feel-good tweaks.
