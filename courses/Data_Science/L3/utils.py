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
