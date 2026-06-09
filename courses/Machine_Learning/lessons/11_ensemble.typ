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
    title: [Tree-based Ensembles],
    subtitle: [An introduction to Machine Learning],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Ensembles of trees

== Outline

A single decision tree is rarely the best model:

- *Deep* trees *overfit* (low bias, high variance).
- *Shallow* trees *underfit* (high bias, low variance).

The fix is to combine many trees into one *ensemble*. In this lesson we learn to:

+ Build a *bagging* ensemble and understand *random forests*.
+ Build a *boosting* ensemble and understand *gradient boosting*.
+ Recognize the *hyperparameters* that control each family.
+ Tell *when to reach for which* and why.

== Two families of ensembles

We combine many decision trees into one powerful model. There are two strategies:

#grid(
  columns: (1fr, 1fr),
  gutter: 1.5em,
  [
    *Bagging* (e.g. random forests)

    - Trees are fit *independently*, in parallel.
    - Each tree is *deep* and *overfits*.
    - *Averaging* their predictions reduces overfitting.
  ],
  [
    *Boosting* (e.g. gradient boosting)

    - Trees are fit *sequentially*, one after another.
    - Each tree is *shallow* and *underfits*.
    - Each new tree *corrects the errors* of the previous ones.
  ],
)

= Bagging and Random Forests

== Bagging: bootstrap + aggregate

Random forests use bagging, which has two ingredients:

+ *Bootstrapping*: build many random subsets of the training data (sampling with replacement). In practice, hundreds of bootstrap samples are used.
+ *Aggregation*: train one independent tree on each sample, then combine the predictions.

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    image("/courses/Machine_Learning/assets/bagging0.svg", width: 90%),
    caption: [A classification task: circles vs squares.],
  ),
  figure(
    image("/courses/Machine_Learning/assets/bagging.svg", width: 100%),
    caption: [Many bootstrap samples of the data.],
  ),
)

== Bagging for classification

Each bootstrap sample trains its own tree, giving a different decision boundary.

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    image("/courses/Machine_Learning/assets/bagging0_cross.svg", width: 90%),
    caption: [A new point to classify.],
  ),
  [
    #figure(
      image("/courses/Machine_Learning/assets/bagging_trees_predict.svg", width: 100%),
      caption: [Each tree predicts independently.],
    )
    #figure(
      image("/courses/Machine_Learning/assets/bagging_vote.svg", width: 100%),
      caption: [A majority vote gives the final class.],
    )
  ],
)

== Bagging for regression

The same recipe works for regression. We start from noisy 1D data.

#figure(
  image("/courses/Machine_Learning/assets/bagging_reg_data.svg", width: 48%),
  caption: [A single feature on the $x$-axis, a continuous target on the $y$-axis.],
)

== Bagging for regression

The recipe: *select random subsets* of the data, *fit one tree on each*, then *average* their predictions. Each deep tree overfits, but averaging cancels out part of the noise — so the ensemble overfits *less* than any single tree.

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    image("/courses/Machine_Learning/assets/bagging_reg_grey_fitted.svg", width: 100%),
    caption: [One tree per random subset of the data.],
  ),
  figure(
    image("/courses/Machine_Learning/assets/bagging_reg_blue.svg", width: 70%),
    caption: [Averaging the trees gives the ensemble prediction.],
  ),
)

== Random Forests

What's a random forest?

```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import RandomForestRegressor
from sklearn.ensemble import BaggingClassifier
from sklearn.ensemble import BaggingRegressor
```

- *`Bagging*`*: a *generic wrapper*.
  - Pass it any base model (linear, neighbors, trees, ...).
  - It defaults to a `DecisionTree*`.
- *`RandomForest*`*: a *specialized* implementation hard-coded to use decision trees, with extra randomization and heavy optimization.

= Boosting and Gradient Boosting

== Boosting for classification

Unlike bagging, boosting fits trees *sequentially* on the *full* training set. Each new tree focuses on the *mistakes* of the previous ones (enlarged).

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    image("/courses/Machine_Learning/assets/boosting1.svg", width: 92%),
    caption: [A first shallow tree, with its mistakes enlarged.],
  ),
  figure(
    image("/courses/Machine_Learning/assets/boosting_trees1.svg", width: 92%),
    caption: [Tree 1.],
  ),
)

== Boosting for classification

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    image("/courses/Machine_Learning/assets/boosting2.svg", width: 92%),
    caption: [The second tree refines the first.],
  ),
  figure(
    image("/courses/Machine_Learning/assets/boosting_trees2.svg", width: 92%),
    caption: [Trees 1 + 2 (weighted sum).],
  ),
)

#pagebreak()

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    image("/courses/Machine_Learning/assets/boosting3.svg", width: 92%),
    caption: [More trees progressively refine the boundary.],
  ),
  figure(
    image("/courses/Machine_Learning/assets/boosting_trees3.svg", width: 92%),
    caption: [Trees 1 + 2 + 3.],
  ),
)

Even if the first models *underfit* (shallow trees), adding more trees lets the ensemble classify the whole training set.

== Boosting for regression

A first constrained tree (blue) underfits and leaves large *residuals*. The next tree (orange) focuses on the badly-predicted points (enlarged), and we add it to the ensemble.

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    image("/courses/Machine_Learning/assets/boosting/boosting_iter1.svg", width: 100%),
    caption: [Stage 1: a single underfitting tree.],
  ),
  figure(
    image("/courses/Machine_Learning/assets/boosting/boosting_iter_orange1.svg", width: 100%),
    caption: [The next tree targets the largest errors.],
  ),
)

#pagebreak()

We look at the residual errors, reweight the data toward what is still wrong, and add another shallow tree. Each stage stays simple, yet the ensemble keeps improving.

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    image("/courses/Machine_Learning/assets/boosting/boosting_iter2.svg", width: 100%),
    caption: [Stage 2: ensemble of two trees.],
  ),
  figure(
    image("/courses/Machine_Learning/assets/boosting/boosting_iter_orange2.svg", width: 100%),
    caption: [Reweighting toward the remaining errors.],
  ),
)

#pagebreak()

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    image("/courses/Machine_Learning/assets/boosting/boosting_iter3.svg", width: 100%),
    caption: [Stage 3: the fit gets closer.],
  ),
  figure(
    image("/courses/Machine_Learning/assets/boosting/boosting_iter4.svg", width: 100%),
    caption: [With enough stages, training error becomes small.],
  ),
)

This is the opposite philosophy of bagging: each tree stays *simple and underfits on its own*, but the sequence *reduces underfitting*. Watch a validation set to decide how many stages to keep.

== Boosting vs gradient boosting

*`AdaBoostClassifier`* is the classical boosting algorithm (explained earlier):

- Mispredicted *samples are re-weighted* at each step.
- Works with any model that accepts a `sample_weight`.
- Slow for $n > 10,000$ #pause

*`HistGradientBoostingClassifier`* is the latest and greatest:

- Each new tree predicts the *negative error* of the previous ensemble.
- *Discretizes* numerical features (256 bins) to approximate the split search.
- *Much, much faster* on large datasets (hundreds of features, millions of rows).
- Efficient, multi-core implementation.

== Take away

#align(center)[
  #table(
    columns: (1fr, 1fr),
    align: left,
    inset: 8pt,
    stroke: 0.5pt + luma(70%),
    table.header([*Bagging (Random Forests)*], [*Boosting*]),
    [Fit trees *independently*], [Fit trees *sequentially*],
    [Each *deep tree overfits*], [Each *shallow tree underfits*],
    [Averaging *reduces overfitting*], [Adding trees *reduces underfitting*],
    [More trees keep *improving*], [Too many trees may *overfit*],
  )
]
