import numpy as np
import pandas as pd
from scipy.stats import chi2_contingency
from scipy.stats.contingency import association


def interpret_cramers_v(v: float, dof: int) -> str:
    """Label Cramér's V effect size using Cohen (1988) benchmarks, scaled by dof."""
    benchmarks = {
        "Small": 0.1 / np.sqrt(dof),
        "Medium": 0.3 / np.sqrt(dof),
        "Large": 0.5 / np.sqrt(dof),
    }
    if v < benchmarks["Small"]:
        return "Negligible"
    if v < benchmarks["Medium"]:
        return "Small"
    if v < benchmarks["Large"]:
        return "Medium"
    return "Large"


def test_association(
    contingency_table: pd.DataFrame,
    alpha: float = 0.05,
) -> dict:
    """Test association between two categorical variables.

    Runs the Chi-square test for significance, then Cramér's V for effect
    size and prints a readable summary. The contingency table must be the
    raw counts (unnormalized).
    """
    res = chi2_contingency(contingency_table)
    significant = res.pvalue <= alpha

    cramers_v = association(
        observed=contingency_table,
        method="cramer",
        correction=True,
    )
    return cramers_v, bool(significant)
    # effect_size = interpret_cramers_v(cramers_v, dof)

    # return {
    #     "cramers_v": cramers_v,
    #     "chi2": float(chi2_stat).round(2),
    #     "significant": bool(significant),
    #     "effect_size": effect_size,
    #     "p_value": float(p_value),
    #     "dof": dof,
    # }


def bootstraps(
    data,
    statistic=np.mean,
    n_resamples=1000,
    confidence_level=95,
    n=30,
    trace=False,
    return_bootstrap_stats=False,
):
    """Compute a two-sided bootstrap confidence interval for a given statistic.

    Args:
        data: Original 1-D array-like of observations.
        statistic: Callable applied to each bootstrap sample (e.g. np.mean,
            lambda x: np.std(x, ddof=1)). Defaults to np.mean.
        n_resamples: Number of bootstrap resamples to draw. Defaults to 1000.
        confidence_level: Confidence level as a percentage (e.g. 95). Defaults to 95.
        n: Size of each bootstrap sample (drawn with replacement). Defaults to 30.
        trace: When True, prints progress while bootstrapping.
        return_bootstrap_stats: When True, also returns the full array of
            per-resample statistics (the sampling distribution).

    Returns:
        (point_estimate, standard_error, (ci_lower, ci_upper))
        Or with `bootstrap_stats` appended if `return_bootstrap_stats=True`.
    """
    # 1. Bootstrapping (The Algorithm & The Loop)
    # Pre-allocate array for speed
    bootstrap_stats = np.empty(n_resamples)
    if trace:
        print(f"Bootstrapping {n_resamples} samples...")
    for i in range(n_resamples):
        # Draw n items with replacement
        sample = np.random.choice(data, size=n, replace=True)
        bootstrap_stats[i] = statistic(sample)
        if trace:
            if i % (n_resamples // 100) == 0:
                print(f"The {i}-th sample of size {n} is bootstrapped...")

    # 2. Sampling Distribution is now fully populated in 'bootstrap_stats'
    if trace:
        print(f"Sampling Distribution is now fully populated in 'bootstrap_stats' with {n_resamples} samples, each of size {n}")
        print("Calculating Standard Error...")

    # 3. Standard Error (Standard deviation of the sampling distribution)
    # Using ddof=1 for sample standard deviation
    standard_error = np.std(bootstrap_stats, ddof=1)

    # 4. Confidence Interval (Array bounds via percentiles)
    # For a 95% CI, alpha is 2.5 on each tail
    alpha = (100 - confidence_level) / 2
    ci_lower = np.percentile(bootstrap_stats, alpha)
    ci_upper = np.percentile(bootstrap_stats, 100 - alpha)

    point_estimate = np.mean(bootstrap_stats)

    if return_bootstrap_stats:
        return point_estimate, standard_error, (ci_lower, ci_upper), bootstrap_stats
    return point_estimate, standard_error, (ci_lower, ci_upper)


def bootstraps_mean(data, **kwargs):
    """Bootstrap CI for the population mean. See `bootstraps` for kwargs."""
    return bootstraps(data, statistic=np.mean, **kwargs)


def bootstraps_std(data, **kwargs):
    """Bootstrap CI for the population standard deviation (ddof=1)."""
    return bootstraps(data, statistic=lambda x: np.std(x, ddof=1), **kwargs)


def bootstraps_proportion(data, **kwargs):
    """Bootstrap CI for a population proportion.

    `data` should be binary (0/1 or boolean). The proportion is the mean of
    the binary indicator.
    """
    return bootstraps(data, statistic=np.mean, **kwargs)

def calculate_cohens_d(*groups, popmean=None):
    """
    Calculate effect size for various t-test cases.

    Cases:
        - 1-sample t-test: Provide one group and popmean.
        - 2-sample t-test: Provide two groups.
        - >2 groups: Returns np.nan (not supported here).

    Args:
        *groups: One or more arrays/pd.Series representing groups.
        popmean (float, optional): Population mean for 1-sample t-test.

    Returns:
        Cohen's d (float) or np.nan for >2 groups.
    """
    import numpy as np

    if len(groups) == 1 and popmean is not None:
        # 1-sample t-test
        g = groups[0]
        mean = np.mean(g)
        std = np.std(g, ddof=1)
        d = (mean - popmean) / std
        return d
    elif len(groups) == 2:
        # 2-sample t-test (independent)
        g1, g2 = groups
        mean1, mean2 = np.mean(g1), np.mean(g2)
        std1, std2 = np.std(g1, ddof=1), np.std(g2, ddof=1)
        n1, n2 = len(g1), len(g2)
        # Pooled standard deviation for independent samples
        pooled_var = ((n1 - 1)*std1**2 + (n2 - 1)*std2**2) / (n1 + n2 - 2)
        pooled_std = np.sqrt(pooled_var)
        d = (mean1 - mean2) / pooled_std
        return d
    else:
        # More than 2 groups: conventionally use f, not d
        return np.nan

def qualify_cohens_d_effect_size(value: float):
    if value <= 0.2:
        return 'small'
    elif value <= 0.5:
        return 'medium'
    else:
        return 'large'

def calculate_cohens_f(*groups):
    """
    Calculate effect size for ANOVA.

    Args:
        *groups: One or more arrays/pd.Series representing groups.

    Returns:
        Cohen's f (float)
    """
    import numpy as np

    if len(groups) == 1:
        return np.nan
    
    # Calculate the between-group variance
    group_means = np.array([np.mean(group) for group in groups])
    grand_mean = np.mean(group_means)
    between_group_variance = np.sum((group_means - grand_mean) ** 2)

    # Calculate the within-group variance
    within_group_variance = np.sum([np.sum((group - group_mean) ** 2) for group, group_mean in zip(groups, group_means)])
    
    # Calculate Cohen's f
    f = np.sqrt(between_group_variance / within_group_variance)
    return f

def qualify_cohens_f_effect_size(value: float):
    if value <= 0.1:
        return 'small'
    elif value <= 0.25:
        return 'medium'
    else:
        return 'large'
    
def calculate_effect_size(*groups, popmean=None):
    """
    Calculate effect size for various t-test cases.

    Args:
        *groups: One or more arrays/pd.Series representing groups.
        popmean (float, optional): Population mean for 1-sample t-test.

    Returns:
        Cohen's d (float) >2 groups.
    """
    if len(groups) == 1 and popmean is not None:
        return calculate_cohens_d(*groups, popmean=popmean)
    elif len(groups) == 2:
        return calculate_cohens_d(*groups)
    else:
        return calculate_cohens_f(*groups)

def qualify_effect_size(value: float, n_groups: int):
    if n_groups <= 2:
        return qualify_cohens_d_effect_size(value)
    else:
        return qualify_cohens_f_effect_size(value)