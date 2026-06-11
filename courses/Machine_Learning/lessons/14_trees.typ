#import "@preview/touying:0.6.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#import "/template/theme.typ": *

#show: university-theme.with(
  config-colors(
    primary: primary-color,
    secondary: secondary-color,
    tertiary: tertiary-color,
    neutral-darkest: text-color
  ),
  config-info(
    title: [Decision Trees],
    subtitle: [An introduction to Machine Learning],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

#let bent-edge(from, to, ..args) = {
  let midpoint = (from, 50%, to)
  let vertices = (
    from,
    (from, "|-", midpoint),
    (midpoint, "-|", to),
    to,
  )
  edge(..vertices, "-|>", ..args)
}

= Decision Trees

== Outline

In this lesson we learn to:

+ Read a *decision tree* as a hierarchy of simple if-then rules.
+ Grow a tree for *classification* and interpret leaf probabilities.
+ Grow a tree for *regression* as a piece-wise constant function.
+ Recognize how *tree depth* drives the underfit / overfit trade-off.

== What is a decision tree?

A *decision tree* is a supervised learning algorithm that learns a hierarchy of simple if-then-else rules from data. The deeper the tree, the more detailed the rules and the more closely the model fits the training data.

How does a model arrive at a decision the same way you'd win a game of *20 Questions*? *Decision trees* ask one simple yes/no question at a time, and after a handful of questions they commit to an answer:

- Each *split node* asks a yes/no question about *one feature* and *one threshold*.
- Each *leaf node* stores a prediction (a class or a value).
- To predict, we start at the root and follow the branches until we reach a leaf.

== An example of a decision tree

#align(center)[
  #diagram(
    node-stroke: luma(80%),
    edge-corner-radius: none,
    spacing: (14pt, 50pt),

    node((2, 0), [Age < 28.5 ?], name: <A>, shape: fletcher.shapes.parallelogram),
    node((0, 1), [Low income], name: <B>, fill: blue.lighten(20%), stroke: none),
    node((3, 1), [Hours/week < 40 ?], name: <C>, shape: fletcher.shapes.parallelogram),
    node((2, 2), [Low income], name: <D>, fill: blue.lighten(20%), stroke: none),
    node((4, 2), [High income], name: <E>, fill: orange.lighten(10%), stroke: none),

    edge(<A>, <B>, [Yes], "-|>", label-side: left),
    edge(<A>, <C>, [No], "-|>", label-side: right),
    edge(<C>, <D>, [Yes], "-|>", label-side: left),
    edge(<C>, <E>, [No], "-|>", label-side: right),
  )
]

To classify a new point: check the age first; if under 28.5 predict *low income*, otherwise decide on hours per week.

= Growing a classification tree

== Classification with a decision tree

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    image("/courses/Machine_Learning/assets/tree_blue_orange1.svg", width: 100%),
    caption: [Tree after the first split.],
  ),
  figure(
    image("/courses/Machine_Learning/assets/tree2D_1split.svg", width: 100%),
    caption: [The matching cut in feature space.],
  ),
)

Each leaf stores *how many training points of each class* reached it. At each split, the feature and threshold are chosen to make the child nodes as *pure* as possible — purity is measured by the *Gini index* or *entropy*, which quantify how mixed the classes are.

== Classification with a decision tree

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    image("/courses/Machine_Learning/assets/tree_blue_orange2.svg", width: 100%),
    caption: [A second split refines one leaf.],
  ),
  figure(
    image("/courses/Machine_Learning/assets/tree2D_2split.svg", width: 100%),
    caption: [Each split focuses on a smaller subregion.],
  ),
)

We can incrementally expand any leaf into a new split to refine the decision function.

== Classification with a decision tree

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    image("/courses/Machine_Learning/assets/tree_blue_orange3.svg", width: 100%),
    caption: [After two splits the leaves are pure.],
  ),
  figure(
    image("/courses/Machine_Learning/assets/tree2D_3split.svg", width: 100%),
    caption: [One class per region.],
  ),
)

Here `max_depth` $= 2$ already gives *pure* leaves (one class each) — no need to go deeper. The leaf fractions can be read as *class probabilities*.

Notice that trees are invariant to rescaling; i.e., unlike distance-based models like K-NN, they are unaffected by the *different scales* of the numerical features.

= Growing a regression tree

== Regression with a decision tree

#figure(
  image("/courses/Machine_Learning/assets/tree_regression1.svg", width: 78%),
  caption: [A single feature on the $x$-axis, a continuous target on the $y$-axis.],
)

A straight line cannot approximate this data — a linear model would *underfit*. Decision trees can fit it instead.

== Regression with a decision tree

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    image("/courses/Machine_Learning/assets/tree_regression_structure1.svg", width: 100%),
    caption: [Tree structure after the first split.],
  ),
  figure(
    image("/courses/Machine_Learning/assets/tree_regression2.svg", width: 100%),
    caption: [The piece-wise constant prediction.],
  ),
)

Each leaf stores the *average value of $y$* over the training points that reach it; the prediction function is always *piece-wise constant*.

== Regression with a decision tree

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    image("/courses/Machine_Learning/assets/tree_regression_structure2.svg", width: 100%),
    caption: [A second split adds two leaves.],
  ),
  figure(
    image("/courses/Machine_Learning/assets/tree_regression3.svg", width: 100%),
    caption: [The fit gains another step.],
  ),
)

At each step we replace the leaf that most reduces the prediction error by a new split node and two new leaves.

== Regression with a decision tree

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    image("/courses/Machine_Learning/assets/tree_regression_structure3.svg", width: 100%),
    caption: [A deeper tree.],
  ),
  figure(
    image("/courses/Machine_Learning/assets/tree_regression4.svg", width: 100%),
    caption: [More steps approximate the curve.],
  ),
)

Growth stops at one point per leaf or at a *pre-set size* (`max_depth` / `max_leaf_nodes`). Trees are *non-parametric*: their maximum size depends on the data.

= Tree depth and overfitting

== `max_depth` and overfitting

#grid(
  columns: (1fr, 1fr, 1fr),
  gutter: 0.8em,
  [
    #figure(
      image("/courses/Machine_Learning/assets/dt_underfit.svg", width: 100%),
    )
    #align(center)[
      *Underfitting* \
      #text(size: 0.8em)[`max_depth` too small]
    ]
  ],
  [
    #figure(
      image("/courses/Machine_Learning/assets/dt_fit.svg", width: 100%),
    )
    #align(center)[
      *Best trade-off*
    ]
  ],
  [
    #figure(
      image("/courses/Machine_Learning/assets/dt_overfit.svg", width: 100%),
    )
    #align(center)[
      *Overfitting* \
      #text(size: 0.8em)[`max_depth` too large]
    ]
  ],
)

== Take home messages

- A *sequence of simple decision rules*: one feature and one threshold at a time. #pause
- The decision function is *piece-wise constant*, and therefore *non-smooth*: #pause
  - regression: *mean* $y$ value in that region #pause
  - classification: *most frequent* $y$ class in that region #pause
- *No scaling required* for numerical features — trees are invariant to rescaling, which makes them a great fit for *tabular data* with mixed units. #pause
- `max_depth` controls the trade-off between *underfitting* and *overfitting*. #pause
- A single tree is *rarely competitive on its own*, but it is the core *building block* of ensembles: #pause
  - *Random forests* (bagging),
  - *Gradient-boosted trees* (boosting).
