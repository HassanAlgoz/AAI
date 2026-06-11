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

== Generalization Performance

*Generalization Performance*: how well a model fits unseen data.

Assuming both *in-sample* and *out-of-sample* data come from the same distribution, we can estimate the *generalization performance* of a model by sampling the statistics from a *test set* and developing a *confidence interval*:

- *Bias*: mean of the errors.
- *Variance*: margin of error in the estimated mean.


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
  image("/courses/Machine_Learning/assets/cross-validation_results.png", height: 65%),
  caption: [Models with increasing complexity (to the right)],
)
*Optimal*: _low bias_ and _low variance_.

== Bias-variance as Complexity Increases

The *bias-variance tradeoff* describes the tension between two competing sources of error in predictive models.

#figure(
  image("/courses/Machine_Learning/assets/bias-variance_tradeoff.png", height: 75%),
  caption: [Bias-variance Trade-off as complexity of the model increases.],
)

== Over-fitting and Under-fitting

- *Under-fitting*: high bias; meaning the estimated error is high.
- *Over-fitting*: high variance; meaning the error fluctuates a lot.
- *Optimal*: low bias and low variance.

= Aiming for Generalization

== Data Quantity and Quality

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

== ML Rules of Thumb

- _Order of Magnitude_: As a rule of thumb, aim for your dataset to have at least $10 times$ (or even $100 times$) examples as the number of parameters in your model.
- _Simple Models, Large Data_: Sometimes, simple models trained on massive datasets succeed even where complex models might fail with limited data.
- _Simple Tasks, Small Data_: For straightforward problems, less data might suffice—but complex tasks demand more.
- _Quality > Quantity_: While more data generally helps, ensuring the *quality* of your features is equally—if not more—important than sheer data quantity.

== The ART of Data

Good data should be _available_, _representative_, and _trusted_:

- *Available*: All inputs required for prediction must be accessible at the time you need to make a prediction and be in the correct format.
  - If obtaining certain feature values will be difficult at prediction time, exclude those features from your training dataset.

- *Representative*: Your dataset should accurately reflect the real-world events, user behaviors, or phenomena that your model will be predicting.
  - Training on unrepresentative data can result in poor real-world performance, even if the model looks good during training and validation.

- *Trusted*: Know your data sources and their reliability.
  - Is your data generated from sources you control and trust, such as your application's logs? Or does it come from other ML systems or external providers, where reliability or bias may be unknown?

== Feature Engineering

*Feature engineering* involves creating, transforming, and selecting input variables that help the model learn useful patterns. Key techniques include:

1. *Creating new variables* (features):
   - Compute `age` from `date_of_birth`
   - Derive `BMI` from `weight` and `height`
   - Determine `season` from `date` and `city`

2. *Discretizing continuous variables*:
   - Map `age` into `age_group` (e.g., `0–18`, `19–35`, `36–55`, `56+`)
   - Convert `weight` to `weight_category` (e.g., `<50kg`, `50–80kg`, `>80kg`)
   - Classify `income` into `socioeconomic_class` (e.g., `Low`, `Middle`, `High`)
#pagebreak()
3. *Data enrichment*:
   - Append `neighborhood_median_income` using `zip_code`
   - Add `historical_weather` info (such as `rainfall`, `temperature`) based on `date` and `location`

4. *Data aggregation*:
   - Summarize individual transactions into `monthly_total_spend`
   - Compute `average_session_duration` per `user_id` from raw click logs

5. *Handling date-time variables*:
   - Extract `year`, `month`, `day`, `hour`, or time intervals from timestamps  
   - Create features like `time_since_last_purchase`, `time_since_login`