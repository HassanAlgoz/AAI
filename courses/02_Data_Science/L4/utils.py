import numpy as np

def bootstraps_mean(data, n_resamples=10000, confidence_level=95, trace=False, return_bootstrap_means=False):
    """Compute a two-sided bootstrap confidence interval of the mean.

    Args:
        data (_type_): _description_
        n_resamples (int, optional): _description_. Defaults to 10000.
        confidence_level (int, optional): _description_. Defaults to 95.
        trace (bool, optional): _description_. Defaults to False.
        return_bootstrap_means (bool, optional): _description_. Defaults to False.

    Returns:
        _type_: _description_
    """
    # Sample only 10% at a time for speed
    n = len(data) // 10
    
    # 1. Bootstrapping (The Algorithm & The Loop)
    # Pre-allocate array for speed
    bootstrap_means = np.empty(n_resamples) 
    if trace:
        print(f"Bootstrapping {n_resamples} samples...")
    for i in range(n_resamples):
        # Draw N items with replacement
        sample = np.random.choice(data, size=n, replace=True)
        bootstrap_means[i] = np.mean(sample)
        if trace:
            if i % (n_resamples // 100) == 0:
                print(f"Bootstrapped {i} samples...")
        
    # 2. Sampling Distribution is now fully populated in 'bootstrap_means'
    if trace:
        print(f"Sampling Distribution is now fully populated in 'bootstrap_means' with {n_resamples} samples, each of size {n}")
        print("Calculating Standard Error...")
    
    # 3. Standard Error (Standard deviation of the sampling distribution)
    # Using ddof=1 for sample standard deviation
    standard_error = np.std(bootstrap_means, ddof=1) 
    
    # 4. Confidence Interval (Array bounds via percentiles)
    # For a 95% CI, alpha is 2.5 on each tail
    alpha = (100 - confidence_level) / 2 
    ci_lower = np.percentile(bootstrap_means, alpha)
    ci_upper = np.percentile(bootstrap_means, 100 - alpha)
    
    if return_bootstrap_means:
        return np.mean(bootstrap_means), standard_error, (ci_lower, ci_upper), bootstrap_means
    return np.mean(bootstrap_means), standard_error, (ci_lower, ci_upper)

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