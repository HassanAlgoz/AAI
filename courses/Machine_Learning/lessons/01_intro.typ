#import "@preview/touying:0.6.1": *
#import "@preview/curryst:0.5.1" as curryst: rule
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
    title: [Machine Learning],
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

= Machine Learning

== Objectives

In this lesson we learn to:

+ Define *Machine Learning* and understand its utility.
+ Identify the two main tasks in *supervised learning*.
+ Identify the two parts of a *data matrix*.
+ Distinguish *features* from *target*.
+ Recognize the foundations and related fields of ML.
+ Recognize the three main branches of ML.

== What is Machine Learning?

General: #quote(
  [the study of how automated systems can *extract useful patterns from data* automatically.],
  attribution: [Shalev-Shwartz, 2014]
)

Specific: #quote(
  [
    a computer program is said to _learn_ from experience $E$ with respect to some class of tasks $T$ and performance measure $P$, if its performance at tasks in $T$, as measured by $P$, *improves with experience $E$*. 
  ],
  attribution: [Tom Mitchell, 1997]
)

== Programming + Machine Learning

- *Programming*: you write explicit rules; the program applies them to data.
- *Machine learning*: you provide examples; the algorithm discovers the _model_.
#v(1em)
#figure(
  image("/courses/Machine_Learning/assets/01/traditional_vs_ml.png", width: 100%),
  caption: [Programming + Machine Learning.],
)

== The Utility of Machine Learning

Machine learning is a *driving force* of the current technical revolution. Two situations where rigid rule-based programming falls short: #pause

+ *Tasks that resist procedural formulation* — we cannot fully spell out perception or language as explicit rules, or the data is too large to analyze by hand. #pause
  - faces
  - speech
  - translation
  - motion
  - interaction with changing environments. #pause
+ *Need for continuous adaptation* — traditional software is fixed; ML lets systems *adapt* their behavior from experience and changing conditions.

== ML Relation to AI and Deep Learning

#align(center)[
  #box(stroke: 1pt + primary-color, radius: 5pt, inset: 0.4em)[
    *Artificial Intelligence*
    #v(0.1em)
    #box(stroke: 1pt + secondary-color, radius: 5pt, inset: 0.4em)[
      *Machine Learning*
      #v(0.1em)
      #box(stroke: 1pt + tertiary-color, radius: 5pt, inset: 0.4em)[
        *Deep Learning*
      ]
    ]
  ]
]
#pause
*Artificial Intelligence* (AI) is the capability of computational systems to perform tasks typically associated with human intelligence, such as learning, reasoning, problem-solving, perception, and decision-making. #pause

*Machine Learning* (ML) is the study of how automated systems can extract useful patterns from data automatically. #pause

*Deep Learning* is a _branch_ of ML using multi-layer neural networks that learn hierarchical features from unstructured, high-volume, low-signal, data.

== A Brief History

- *1950s — Foundations*: the Turing Test; a philosophical basis for mechanical intelligence.
- *1956 — Logic*: the Dartmouth workshop; _expert systems_ based on hand-crafted rules.
- *1990s — Data*: a shift from hand-written rules to _statistics and machine learning_.
- *2000s — Scale*: the internet and big data enable large-scale learning; GPUs accelerate progress.
- *2010s — Deep Learning*: large datasets and modern hardware enable models with millions of parameters, with breakthroughs in vision, speech, and language.
- *2020s — Foundation Models*: large language models (LLMs) like GPT-3 and GPT-4 enable general-purpose AI agents that can perform a wide range of tasks.

== Other Names for the Field

- *Machine Learning (ML)* — the most common term.
- *Statistical Learning* — common in academia.
- *Pattern Recognition* — when the focus is on finding patterns.
- *Data Mining* — when the focus is on discovering structure in large datasets.

== Three Pillars of Machine Learning

Machine learning is applied algorithms and data structures, built on mathematics and statistics:

+ *Mathematics* — linear algebra, calculus, optimization.
+ *Statistics and probability* — modeling uncertainty and inference.
+ *Computer science* — algorithms and data structures.

= The Data Matrix

== Iris Dataset

Our running example is the classic *Iris* dataset — three species of iris flower described by petal and sepal measurements.

#figure(
  image("/courses/Machine_Learning/assets/iris_flowers.png", height: 70%),
  caption: [Three classic species of iris flower.],
)

== Table terms

#align(center)[
  #set text(size: 0.8em)
  #table(
    columns: 5,
    align: center,
    table.header(
      [Sepal length], [Sepal width], [Petal length], [Petal width], [*Iris type*],
    ),
    [6 cm], [3.4 cm], [4.5 cm], [1.6 cm], [versicolor],
    [5.7 cm], [3.8 cm], [1.7 cm], [0.3 cm], [setosa],
    [6.5 cm], [3.2 cm], [5.1 cm], [2 cm], [virginica],
    [5 cm], [3 cm], [1.6 cm], [0.2 cm], [setosa],
  )
]

- *Rows*: individual flowers
- *Columns*: features (physical measurements)
- *Target*: the column "iris type" (versicolor, setosa, virginica)

== Data Matrix terms

#align(center)[
  #set text(size: 0.8em)
  #table(
    columns: 5,
    align: center,
    table.header(
      [Sepal length], [Sepal width], [Petal length], [Petal width], [*Iris type*],
    ),
    [6 cm], [3.4 cm], [4.5 cm], [1.6 cm], [versicolor],
    [5.7 cm], [3.8 cm], [1.7 cm], [0.3 cm], [setosa],
    [6.5 cm], [3.2 cm], [5.1 cm], [2 cm], [virginica],
    [5 cm], [3 cm], [1.6 cm], [0.2 cm], [setosa],
  )
]

- *Data Points* $(X, y)$
- *Features* $X in RR^4 = {x_1 in RR, x_2 in RR, x_3 in RR, x_4 in RR}$
- *Target* $y^i in {"setosa", "versicolor", "virginica"}$

#v(1em)

#figure(
  image("/courses/Machine_Learning/assets/legend_irises.svg", width: 55%),
  // caption: [The target labels the species of each observation.],
)

== Types of Machine Learning

#align(center)[
  #diagram(
    node-stroke: luma(80%),
    edge-corner-radius: none,
    spacing: (10pt, 40pt),

    node((2.5, 0), [*Machine Learning*], name: <ML>),
    node((0, 2), [*Supervised*], name: <sup>),
    node((2, 2), [*Unsupervised*], name: <unsup>),
    node((4, 2), [*Reinforcement*], name: <rl>),

    bent-edge(<ML>, <sup>),
    bent-edge(<ML>, <unsup>),
    bent-edge(<ML>, <rl>),
  )
]

Three branches, by *source of the learning signal*:

+ *Supervised*: explicit relationship: $X -> y$.
+ *Unsupervised*: implicit correlation: $X <-> X$.
+ *Reinforcement*: agent-environment interaction produces $x_i -> y_i$ instances.

= Supervised Machine Learning

== What is Supervised ML?

In *supervised machine learning* the target is known only in training; the goal is to *generalize* by learning a model that can predict $y_i$ for a new $X_i$, unseen in training.

The two tasks of supervised learning:
- *Regression* if $y in RR$ (continuous target)
- *Classification* if $y in {0, 1, ..., k}$ (discrete target)

#align(center)[
  #diagram(
    node-stroke: luma(80%),
    edge-corner-radius: none,
    spacing: (10pt, 40pt),

    node((0, 0), [*Supervised*], name: <sup>),
    node((-1, 2), [*Regression* \ (continuous target)], name: <reg>),
    node((1, 2), [*Classification* \ (discrete target)], name: <class>),

    bent-edge(<sup>, <reg>),
    bent-edge(<sup>, <class>),
  )
]

== Regression: Fitting a Line

*Regression*:
- $x = "house_area"$
- $y = "house_price"$ (continuous target)

#figure(
  image("/courses/Machine_Learning/assets/linear_data.svg", height: 65%),
  caption: [Scatter of training data.],
)

#pagebreak()

*Model* is the blue line here.
#v(1em)

#figure(
  image("/courses/Machine_Learning/assets/linear_fit.svg", height: 65%),
  caption: [A linear model fit to the data.],
)

== Estimating Model Error

The *Error* is the difference between predictions and targets.

- Difference is vertical since each error $e_i = |y_i - hat(y_i)|$ #pause
- $"Total Error" = sum_(i=1)^n e_i$

#meanwhile
#figure(
  image("/courses/Machine_Learning/assets/linear_fit_red.svg", height: 60%),
  caption: [Error: model and errors.],
)

== Regression: 2 Features

*Model* is the 2-dimensional plane here:

- $x_1 = "house_area" in (50, 300) m^2$
- $x_2 = "year_built" in (1940, 2026)$
- $y = "price" in (100, 1000) "thousand dollars"$ (continuous target)

#figure(
  image("/courses/Machine_Learning/assets/lin_reg_3D.svg", height: 55%),
  caption: [Linear regression with two input features — the model fits a plane in 3D.],
)

== Classification: 2 Features

*Binary Classificaiton Model* is the decision boundary here:
- $x_1 = "weight" in (10, 1000) "kilograms"$
- $x_2 = "height" in (0.5, 3) "meters"$
- $y = "animal" in {"penguin", "elephant"}$ (discrete target)

#figure(
  image("/courses/Machine_Learning/assets/logistic_2D.svg", height: 60%),
  caption: [Binary classification: the boundary separates two classes.],
)

== Linearly Separability

A straight boundary works only when the classes are *linearly separable*; otherwise the *Model* needs a curved boundary.

#grid(
  columns: (1fr, 1fr),
  gutter: 1em,
  figure(
    image("/courses/Machine_Learning/assets/lin_separable.svg", height: 60%),
    caption: [Separable — a line works.],
  ),
  figure(
    image("/courses/Machine_Learning/assets/lin_not_separable.svg", height: 60%),
    caption: [Not separable — a line fails.],
  ),
)

== Classification: Multiclass

*Multiclass Classification Model* splits the feature space into one region per class:
- $y in {"penguin", "elephant", "giraffe"}$ (3 classes)

#v(1em)

#figure(
  image("/courses/Machine_Learning/assets/multinomial.svg", height: 60%),
  caption: [Three decision boundaries for 3 classes.],
)

== Exercise: regression or classification?

- Forecast tomorrow's weather from historical records. #pause *(regression)* #pause
- Flag spam content. #pause *(classification)* #pause
- Object recognition and localization in images: #pause
  - task 1: "what is the object?" #pause *(classification)* #pause
  - task 2: "where is the object in the image?" #pause *(regression)*