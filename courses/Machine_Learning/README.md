# Applied Machine Learning

**Goals**:

1. Build predictive pipelines for unknown values by fitting the patterns in data using linear and non-linear regression and classification models.
2. Diagnose and resolve ML issues tracing it back to data/features or model.
3. Tune decision thresholds to optimize metrics associated with specific domain problems.
4. Ensure reliability of pre-processing pipelines for mix-type datasets.
5. Understand and use the latest and greatest ensemble models: hist-gradient boosting trees.
6. Apply meta-learning methods like Bayesian Search to automatically tune models hyper-parameters.

## Introduction

1. [Intro: Supervised Machine Learning](https://github.com/HassanAlgoz/AAI/releases/latest/download/Machine_Learning_01_intro.pdf) (~1hr)

## M1. Supervised ML: Regression and Classification

**Goal**: Build predictive pipelines for unknown values by fitting the patterns in data using linear and non-linear regression and classification models.

**Topics**:

1. [Regression](lessons/02_regression.ipynb) (~32m)
   - [Exercise 1: Marks vs Study Hours](exercises/02/01_reg.ipynb) (~28m) ([solution](exercises/02/01_reg_solution.ipynb))
   - [Exercise 2: Salary vs Experience](exercises/02/02_reg.ipynb) (~15m) ([solution](exercises/02/02_reg_solution.ipynb))
2. [Non-linear Regression](lessons/03_regression_non-linear.ipynb) (~26m)
3. [k-NN Classification](lessons/05_knn_classification.ipynb) (~26m)
   - [Exercise: Iris Flowers](exercises/05/01_classification.ipynb) (~30m) ([solution](exercises/05/01_classification_solution.ipynb))
4. [ ] Explain model predictions globally and locally with SHAP.

## M2. Estimating and Improving Model Generalization Performance

**Goals**:

- Diagnose and resolve ML issues tracing it back to data/features or model.
- Tune decision thresholds to optimize metrics associated with specific domain problems.

**Topics**:

1. [Model Evaluation](https://github.com/HassanAlgoz/AAI/releases/latest/download/Machine_Learning_06_model_evaluation.pdf) (~42m)
2. [Regression Evaluation Metrics](lessons/04_regression_metrics.ipynb) (~24m)
   - [Exercise: Bias–Variance Tradeoff](exercises/06/01_bias-variance_tradeoff.ipynb) (~19m) ([solution](exercises/06/01_bias-variance_tradeoff_solution.ipynb))
3. [Classification Evaluation Metrics](https://github.com/HassanAlgoz/AAI/releases/latest/download/Machine_Learning_07_classifier_metrics.pdf) (the 3 labs below are optional)
   1. [Threshold Tuning A: Prioritize Recall](lessons/08a_threshold_tuning.ipynb) (~29m)
   2. [Threshold Tuning B: Weighing Errors by Cost](lessons/08b_threshold_tuning.ipynb) (~27m)
   3. [Threshold Tuning C: Dynamic Cost](lessons/08c_threshold_tuning.ipynb) (~31m)

## M3. `Pipeline`: Building Reliable Predictive Models

**Goal**: Ensure reliability of pre-processing pipelines for mix-type datasets.

**Topics**:

1. Preprocessing
   - [Missing Values](lessons/10_missing_values.ipynb) (~18m)
   - [Categorical Encoding](lessons/11_categorical_encoding.ipynb) (~18m)
       - [Exercise: Dealing with High Cardinality Categorical Features](exercises/11/01_high-cardinality.ipynb) (~16m) ([solution](exercises/11/01_high-cardinality_solution.ipynb))
2.  [Pipelines](lessons/12_pipelines.ipynb) (~28m)
3.  [Regression Target Transform](lessons/13_regression_target_transform.ipynb) (~36m)

## M4. Decision Trees and Ensembles

**Goal**: Understand and use the latest and greatest ensemble models: hist-gradient boosting trees.

**Topics**:

1.  [Decision Trees: Classifiers and Regressors](https://github.com/HassanAlgoz/AAI/releases/latest/download/Machine_Learning_14_trees.pdf) (~25m)
    - [Exercise: Exploring decision trees with `dtreeviz`](exercises/14/dtree_viz.ipynb) (~25m) ([solution](exercises/14/dtree_viz_solution.ipynb))
2.  [Ensemble Methods](https://github.com/HassanAlgoz/AAI/releases/latest/download/Machine_Learning_16_ensemble.pdf) (~40m)
    - [Lab: Random Forests and Histogram Gradient Boosted Trees (HGBT)](lessons/17_ensemble.ipynb) (~20m)

## M5. AutoML

**Goal**: Apply meta-learning methods like Bayesian Search to automatically tune models hyper-parameters.

**Topics**:

1. [Hyper-parameter Search](lessons/18_hp_search.ipynb) (~26m)
2. [AutoML with Gluon](lessons/19_auto_ml.md) (~35m)

## Tabular Datasets Repositories for Machine Learning Projects 

- [UC Irvine Machine Learning Repostiroy](https://archive.ics.uci.edu/) (661 datasets) (or [Beta](https://archive-beta.ics.uci.edu/))
- [Open Data | Python for Data Science](https://www.python4data.science/en/latest/data-processing/opendata.html): A topic-based overview of public repositories containing research data.
- [Kaggle](https://www.kaggle.com/datasets?fileType=csv&minUsabilityRating=10.00&feedbackIds=14) (144 datasets. Filters: `CSV, Usability: 10.00, Highly-voted, Original`)
- HuggingFace:
    - **[Tabular Classification](https://huggingface.co/datasets?task_categories=task_categories:tabular-classification)** (5,266 datasets): Thousands of sets for credit scoring, churn, etc.
    - **[Tabular Regression](https://huggingface.co/datasets?task_categories=task_categories:tabular-regression)** (2,762 datasets): Housing, pricing, and sensor data.
- [PMLB](https://github.com/EpistasisLab/pmlb): A large, curated repository of benchmark datasets for evaluating supervised machine learning algorithms. Provides classification and regression datasets in a standardized format that are accessible through a Python API.
- [U.S. Government open data](https://catalog.data.gov/?sort=popularity) (524,718 datasets): Here you will find data, tools, and resources to conduct research, develop web and mobile applications, design data visualizations, and more.
- [UK Governement open data](https://data.gov.uk/)
- [EU open data](http://data.europa.eu/euodp/en/data/)
- [A very long list from Forbes](https://www.forbes.com/sites/bernardmarr/2016/02/12/big-data-35-brilliant-and-free-data-sources-for-2016/)

## References

- [Scikit-learn MOOC](https://inria.github.io/scikit-learn-mooc/)
- [Hands-on ML \| Aurélien Geron](https://github.com/ageron/handson-ml3)
- [Interpretable Machine Learning](https://christophm.github.io/)

- [Hyndman, R.J., & Athanasopoulos, G. (2021) Forecasting: principles and practice, 3rd edition, OTexts: Melbourne, Australia. OTexts.com/fpp3. Accessed on June 7, 2026.](https://otexts.com/fpp3/)
- [sktime tutorial - updated introduction to sktime, 2023 feature showcase (pydata global 2023)](https://www.youtube.com/watch?v=7NXCdfzr5d8)

- [MLU-Explain | Amazon](https://mlu-explain.github.io/): Visual explanations of core machine learning concepts
- [Machine Learning Crash Course | Google](https://developers.google.com/machine-learning/crash-course/)

- [CS129 Advice for Applying ML](https://web.stanford.edu/class/cs129/advice.pdf)
- [Rules of Machine Learning: Best Practices for ML Engineering]()
- [Learn Feature Engineering | Kaggle]()
- [Machine Learning Explainability]()
