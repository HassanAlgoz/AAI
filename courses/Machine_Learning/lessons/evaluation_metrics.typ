#import "@preview/touying:0.6.1": *

#import "/template/theme.typ": *

#show: university-theme.with(
  config-colors(
    primary: primary-color,
    secondary: secondary-color,
    tertiary: tertiary-color,
    neutral-darkest: text-color
  ),
  config-info(
    title: [Evaluation Metrics],
    subtitle: [How we measure model performance],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#let asset(name) = "/courses/Machine_Learning/assets/evaluation_metrics/" + name

#title-slide()

// ----- opening -----
== Why are metrics important?

Metrics turn vague business goals into measurable success:
- They help *organize team effort* toward that target, usually by improving the metric on the dev set.
- They quantify the *gap* between:
  - desired performance and a baseline (to estimate effort up front),
  - desired performance and current performance,
  - progress over time.
- They are useful for lower-level tasks and *debugging* (e.g. diagnosing bias vs variance).

== Two Types of Metrics

+ *Summary Metrics* to compare between classifiers.
+ *Point Metrics*:
  + Used in calculating summary metrics.
  + The selected model is tuned on them :
    - Minimize false positives
    - Minimize false negatives

// ===== Part A =====
= Part A — Point Metrics

// ----- binary classification -----
== Classifiers Rank Examples

Two types of classification models:

+ *Outputs a class*, directly: K-nearest Neighbors, Decision Tree.
+ *Outputs a rank*:
  + A *probability*: Logistic Regression, Random Forest, Neural Network, etc.
  + A *signed distance*: SVM, etc.

== Discriminative Power

*Discriminative power*: how well models separate classes, minimizing overlap:

#text(fill: rgb("#2e7d32"))[●] Positives ranked high

○ Negatives ranked low

#figure(
  image(asset("model_a_b.png"), height: 60%),
  caption: [Two classifiers ranking the same set of observations differently.]
)

== Classification Threshold

We need a *threshold* to turn _rank_ $in [0, 1]$ into a _class_ $in {0, 1}$. Everything above the threshold is classified as "positive"; everything below is "negative".

If the list is sorted well, you can slide the threshold until the split is right.

#figure(
  image(asset("score_rank.png"), height: 65%),
  caption: [A classifier ranking examples in the dataset.]
)

// ----- confusion matrix -----
== Confusion matrix

A threshold of $0.5$ splits the population into four cells. *Properties*:

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  align(center)[
    #figure(
      image(asset("confusion_matrix.png"), height: 70%),
      caption: [Confusion matrix at $"Th" = 0.5$]
    )
  ],
  [
    

    - *Total sum* is fixed (the population).
    - *Column sums* are fixed (the class-wise population).
    - _Power_ and _threshold_ effect how each column is *split into rows*.
    - We want the *diagonals* to be "heavy" and the *off-diagonals* to be "light".
  ],
)

// ----- TP TN FP FN -----
== The four outcomes: TP, TN, FP, FN

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  align(center)[
    #figure(
      image(asset("confusion_matrix.png"), height: 70%),
      caption: [Confusion matrix at $"Th" = 0.5$]
    )
  ],
  [
    Comparing each prediction to the true label gives four outcomes:

    #table(
      columns: (auto, auto),
      align: (left, center),
      [*True Positives* (TP)], [9],
      [*True Negatives* (TN)], [8],
      [*False Positives* (FP)], [2],
      [*False Negatives* (FN)], [1],
    )

    - *TP / TN*: correct predictions (the heavy diagonal).
    - *FP / FN*: mistakes (the light off-diagonal).
  ],
)

// ----- type I and II -----
== Type I and Type II errors

#grid(
  columns: (1.3fr, 1fr),
  gutter: 1em,
  align(center)[
    #figure(
      image(asset("fp_fs_example_pregnancy.png")),
      caption: [Type I vs Type II errors illustrated.]
    )
  ],
  [
    The two mistakes have classic names:

    - *False positive* = *Type I error*: predicting positive when the truth is negative ("You're pregnant").
    - *False negative* = *Type II error*: predicting negative when the truth is positive ("You're not pregnant").
  ],
)

// ----- accuracy -----
== Point metrics: accuracy

#grid(
  columns: (1fr, 1.1fr),
  gutter: 1em,
  align(center)[
    #figure(
      image(asset("confusion_matrix.png"), height: 70%),
      caption: [Confusion matrix at $"Th" = 0.5$]
    )
  ],
  [
    *Accuracy* is the fraction of correct predictions.

    $ "Accuracy" &= ("TP" + "TN") / ("TP" + "TN" + "FP" + "FN") \
    &= (9 + 8) / 20 = 0.85 $
  ],
)

// ----- precision -----
== Point metrics: precision

#grid(
  columns: (1fr, 1.1fr),
  gutter: 1em,
  align(center)[
    #figure(
      image(asset("confusion_matrix.png"), height: 70%),
      caption: [Confusion matrix at $"Th" = 0.5$]
    )
  ],
  [
    *Precision* (positive predictive value) answers: "of the examples we predicted positive, how many really are positive?"

    Think of it as *quality over quantity* — when the model raises a flag, how often is it right?

    $ "Precision" &= "TP" / ("TP" + "FP") \
    &= 9 / (9 + 2) approx 0.81 $
  ],
)

// ----- recall -----
== Point metrics: recall (sensitivity)

#grid(
  columns: (1fr, 1.1fr),
  gutter: 1em,
  align(center)[
    #figure(
      image(asset("confusion_matrix.png"), height: 70%),
      caption: [Confusion matrix at $"Th" = 0.5$]
    )
  ],
  [
    *Recall* (sensitivity, true positive rate) answers: "of the truly positive examples, how many did we catch?"

    Think of it as *completeness* — out of everything that is actually positive, how much did we find?

    $ "Recall" &= "TP" / ("TP" + "FN") \
    &= 9 / (9 + 1) = 0.90 $
  ],
)

// ----- precision vs recall -----
== Precision vs recall
These two trade off with each other as you move the decision threshold:

#grid(
  columns: (1fr, 1.3fr),
  gutter: 1em,
  align(center)[
    #figure(
      image(asset("confusion_matrix.png"), height: 68%),
      caption: [Confusion matrix at $"Th" = 0.5$]
    )
  ],
  [
    - Want 100% recall? $"Th" = 0.0$
    - Want 100% precision? $"Th" = 1.0$

    So realistic goals become:

    - Good precision *at* 100% recall: set the threshold just low enough so the *lowest positive* is included.
    - Good recall *at* 100% precision: set the threshold just high enough so the *top negative* is still excluded.
  ],
)

// ----- specificity -----
== Point metrics: specificity (negative recall)

#grid(
  columns: (1fr, 1.1fr),
  gutter: 1em,
  align(center)[
    #figure(
      image(asset("confusion_matrix.png"), height: 70%),
      caption: [Confusion matrix at $"Th" = 0.5$]
    )
  ],
  [
    *Specificity* (true negative rate) answers: "of the truly negative examples, how many did we correctly reject?"
    It is *recall for the negative class* — recall asks "did we catch the positives?", specificity asks "did we reject the negatives?"

    $ "Specificity" &= "TN" / ("TN" + "FP") \
    &= 8 / (8 + 2) = 0.80 $

    Recall and specificity are the two *column-wise* rates (sensitivity over positives, specificity over negatives).
  ],
)

// ----- F1 -----
== Point metrics: F1-score

#grid(
  columns: (1fr, 1.35fr),
  gutter: 1em,
  align(center)[
    #figure(
      image(asset("confusion_matrix.png"), height: 64%),
      caption: [Confusion matrix at $"Th" = 0.5$]
    )
  ],
  [
    The *F1-score* is the *harmonic mean* of precision and recall — it is only high when *both* are high.

    Because it is a harmonic mean, a low value in *either* precision or recall drags F1 down — you cannot game it by maximizing only one.

    $ F_1 = 2 / ("recall"^(-1) + "precision"^(-1)) = 2 dot ("precision" dot "recall") / ("precision" + "recall") $

    $ approx 2 dot (0.81 dot 0.90) / (0.81 + 0.90) approx 0.857 $
  ],
)

#pagebreak()

=== Summary at $"Th" = 0.5$

#align(center)[
  #table(
    columns: 9,
    align: center,
    [*TP*], [*TN*], [*FP*], [*FN*], [*Acc*], [*Prec*], [*Recall*], [*Spec*], [*F1*],
    [9], [8], [2], [1], [0.85], [0.81], [0.90], [0.80], [0.857],
  )
]

// ----- changing threshold -----
== Changing the threshold

#grid(
  columns: (1fr, 1.1fr),
  gutter: 1em,
  align(center)[
    #figure(
      image(asset("confusion_matrix_th06.png"), height: 70%),
      caption: [Confusion matrix at $"Th" = 0.6$]
    )
  ],
  [
    Raising the threshold to $"Th" = 0.6$ moves two positives below the line, changing every metric:

    #table(
      columns: 9,
      align: center,
      [*TP*], [*TN*], [*FP*], [*FN*], [*Acc*], [*Prec*], [*Rec*], [*Spec*], [*F1*],
      [7], [8], [2], [3], [0.75], [0.77], [0.70], [0.80], [0.733],
    )

    The number of *effective thresholds* = *number of examples* $+ 1$.
  ],
)

// ===== Part B =====
= Part B — Summary Metrics

// ----- threshold scanning -----
== Threshold scanning

#grid(
  columns: (0.8fr, 1.6fr),
  gutter: 1em,
  align(center)[
    #figure(
      image(asset("threshold_scanning.png"), height: 80%),
      caption: [Sweeping the threshold across every operating point.]
    )
  ],
  [
    Sweeping the threshold from $1.00$ down to $0.00$ traces out *every* operating point of the model. Each row is one threshold.
    #align(center)[
      #text(size: 0.5em)[
        #table(
          columns: 10,
          align: center,
          inset: 3pt,
          [*Th*], [*TP*], [*TN*], [*FP*], [*FN*], [*Acc*], [*Prec*], [*Rec*], [*Spec*], [*F1*],
          [1.00], [0], [10], [0], [10], [0.50], [1], [0], [1], [0],
          [0.90], [2], [10], [0], [8], [0.60], [1], [0.2], [1], [0.333],
          [0.80], [ccccc3], [9], [1], [7], [0.60], [0.750], [0.3], [0.9], [0.429],
          [0.70], [5], [9], [1], [5], [0.70], [0.833], [0.5], [0.9], [0.625],
          [0.60], [6], [8], [2], [4], [0.70], [0.750], [0.6], [0.8], [0.667],
          [0.50], [8], [8], [2], [2], [0.80], [0.800], [0.8], [0.8], [0.800],
          [0.45], [9], [8], [2], [1], [0.85], [0.818], [0.9], [0.8], [0.857],
          [0.30], [9], [5], [5], [1], [0.70], [0.643], [0.9], [0.5], [0.750],
          [0.10], [9], [1], [9], [1], [0.50], [0.500], [0.9], [0.1], [0.643],
          [0.00], [10], [0], [10], [0], [0.50], [0.500], [1], [0], [0.667],
        )
      ]
      #text(size: 0.7em)[(Rows abbreviated; the full scan has one row per effective threshold.)]
    ]
  ],
)

// ----- ROC -----
== ROC curve

#grid(
  columns: (1.1fr, 1fr),
  gutter: 1em,
  align(center)[
    #figure(
      image(asset("roc_curve.png"), height: 74%),
      caption: [ROC curve: sensitivity vs specificity.]
    )
  ],
  [
    - $"Sensitivity" = "True Pos" \/ "Pos"$
    - $"Specificity" = "True Neg" \/ "Neg"$ #pause
    Plot *sensitivity* against *specificity* as the threshold sweeps. The diagonal is *random guessing*. #pause
    
    *AUROC* ("Area Under the ROC") is the probability that a random positive is ranked higher than a random negative -- it *measures discriminative power*.
  ],
)


// ----- PR -----
== PR curve

#grid(
  columns: (1.1fr, 1fr),
  gutter: 1em,
  align(center)[
    #figure(
      image(asset("prc_curve.png"), height: 74%),
      caption: [Precision-recall curve: recall vs precision.]
    )
  ],
  [
    Plot *precision* against *recall* as the threshold sweeps. #pause
    
    *AUPRC* ("Area Under the Precision-recall Curve") is the expected precision for a random threshold (a.k.a $"AP"$).

  ],
)

// ----- class imbalance -----
== Class imbalance

*Class Imbalance* loosely defined as when the frequency of the positive class (*Prevalence*) falls below $5%$.

Problem: metrics may stop being meaningful.

In general, robustness to imbalance increases to the right:

#align(center)[ $ "Accuracy" < "AUROC" < "AUPRC" $ ]

= Choosing Metrics

== Metrics Derived from Confusion Matrix

Choosing the right metric depends on the application and its business constraints.

#align(center)[
  #figure(
    image(asset("confusion_matrix_metrics.png"), height: 80%),
    caption: [#text(size: 0.7em)[Source: Wikipedia. The whole zoo of metrics is built from TP, TN, FP and FN.]]
  )
]

== Minimize False Positives
*Pattern 1 — false positives are unacceptable* in applications like: 
- _search results_: If Google's first page is filled with irrelevant junk (false positives), you will switch to another search engine. 
- _grammar suggestions_: If Grammarly constantly gives you incorrect grammar suggestions (false positives), you will turn it off. 

Advice: 

+ Fix precision $>= 95%$.
+ Then optimize recall (find as many relevant items as possible without breaking the precision rule).

== Minimize False Negatives
*Pattern 2 — false negatives are unacceptable* in applications like:
- cancer screening: A false negative sends a sick patient home; a false positive only means a follow-up test.

Advice:

+ Fix recall $= 100%$ (catch every true case).
+ Then optimize precision (reduce false alarms once every case is found).

== Top-K
*Pattern 3 — you can only show $K$ items (Recommendation Systems)*

You have exactly, say, $K = 5$ videos to show on the homepage.

You do not care how many relevant items exist in total; you only care about the $K$ you actually show.

Optimize for: *Precision@$K$* — of the top $K$ predictions, what fraction are truly relevant?

== Summary

=== Part A
+ Classifiers rank examples
+ Threshold converts to classes
+ Discriminative power means less overlap
+ A *Point Metric* is calculated at one threshold
+ Confusion Matrix components: TP, TN, FP, FN
+ Accuracy not a good idea in most scenarios
+ False Positive (Type I error): wrong (lower Precision)
+ False Negative (Type II error): miss (lower Recall)
#pagebreak()

=== Part B
- *Summary Metrics* calculated by sweeping the threshold.
- Robustness to imbalance: $"Accuracy" < "AUROC" < "AUPRC"$
- Use Summary Metrics to select the best between different classifiers.
- Then, tune threshold to optimize for *Point Metrics* depending on your application. (Not all errors are equal)

Adapted from the CS229 "Evaluation Metrics" lecture (Nandita Bhaskhar).
