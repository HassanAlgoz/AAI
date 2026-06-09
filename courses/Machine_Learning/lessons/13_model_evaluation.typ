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
    title: [Bias-Variance Trade-off],
    subtitle: [Estimating the generalization performance of a model],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Bias-variance Trade-off

== Learning Objectives

In this lesson we learn to:

+ Establish a *baseline* for learning.
+ Understand when *more data* helps (and when it does not).
+ Detect *over-fitting vs under-fitting* and reason about *generalization*.
+ Estimate generalization with proper *train/validation/test splits* and *cross-validation*.

== Classification

#figure(
  image("/courses/Machine_Learning/assets/classification_under_optimal_overfitting.png", width: 92%),
)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 1em,
  align(center)[Model cannot capture the pattern.],
  align(center)[Best balance between the two.],
  align(center)[Captures noise and fails to generalize.],
)

== Regression

#figure(
  image("/courses/Machine_Learning/assets/regression_underfit_overfit.png", width: 92%),
)

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 1em,
  align(center)[Model cannot capture the pattern.],
  align(center)[Best balance between the two.],
  align(center)[Captures noise and fails to generalize.],
)

== The Bias-variance Trade-off


#grid(
  columns: (1fr, 1.2fr),
  gutter: 0em,
  [ 
    The *bias-variance tradeoff* describes the tension between two competing sources of error in predictive models. The question is: if we repeatedly test the model:
    
    - *Bias*: mean of the errors.
    - *Variance*: margin of error in the estimated mean.
  ],
  figure(
    image("/courses/Machine_Learning/assets/bias-variance_tradeoff.png", width: 100%),
  ),
)

Both regression and classification models can:
  - *Under-fit*: high bias, low variance,
  - *Over-fit*: low bias, high variance.
  - *Optimal*: low bias, low variance,

== Cross-Validation

- *Cross-validation* uses *k folds* and averages the results:
  - fit on the training folds,
  - test on the held-out validation fold.

#figure(
  image("/courses/Machine_Learning/assets/cv_k-fold.png", height: 50%),
  caption: [K-fold cross-validation]
)

== Estimating Bias and Variance

- _Bias_: average error; corresponds to height of the bar. (lower is better)
- _Variance_: indicated by the line centered on top of the bar. (shorter is better)

#figure(
  image("/courses/Machine_Learning/assets/cross-validation_results.png", height: 75%),
  caption: [Models with increasing complexity (to the right)],
)

= Diagnosing Model Performance

== Is the model learning?

Core sanity check: the model should be: #pause

+ better than *random* predictions #pause
+ better than a *guess* (dummy model) #pause
+ better than a *baseline* (simple model) #pause

#pagebreak()

=== `DummyClassifier`

`DummyClassifier` implements simple "rules of thumb" baselines:

- `constant`: always predicts a provided constant label.
- `most_frequent`: always predicts the most frequent training label.
- `stratified`: random predictions respecting the class distribution.

*Key point*: in all cases, `predict()` ignores input features.

#pagebreak()

=== Compare dummy vs model

```python
from sklearn.dummy import DummyClassifier

dummy_clf = DummyClassifier(strategy="most_frequent")
dummy_clf.fit(X_train, y_train)

print("   Dummy Classifier Score:", dummy_clf.score(X_test, y_test))
print("Logistic Regression Score:", clf.score(X_test, y_test))
```

- Your trained model should *beat* the dummy baseline.
- If accuracy is near baseline, something is likely wrong.

#pagebreak()

=== `DummyRegressor` (for regression)

`DummyRegressor` implements simple rules:

- `mean`: always predicts the mean of training targets.
- `median`: always predicts the median of training targets.
- `quantile`: always predicts a user-provided quantile.
- `constant`: always predicts a provided constant value.

*Key point*: these strategies ignore input features during `predict()`.

== Do have enough quality data?

Data is just means to an end. Our goal is *new information*.

More data helps *only if*: #pause

+ It fills information gaps: new samples cover regions where the model lacks information. #pause
+ The model can fit it: the learning algorithm can represent the real pattern. #pause

#pagebreak()

=== Non-informative data/features

#figure(
  image("/courses/Machine_Learning/assets/adding_wrong_data_points.png", height: 55%),
  caption: [Blue is real. Orange is model.],
)

Benefit comes when new data covers *missing regions*. Adding data in regions the model already learned doesn't provide it with new information.

#pagebreak()

=== Model capacity

#figure(
  image("/courses/Machine_Learning/assets/inflexible_model.png", height: 55%),
  caption: [Blue is model. Real is invisible curve.],
)

A linear model can't capture a curve, no matter how much data we add. Here, the model is biased to look for a straight pattern, and refuses to accept that *reality is more complicated*.
