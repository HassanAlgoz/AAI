"""Generate a simulated monthly retailer series for scenario-based forecasting.

Columns
-------
date             : month start (YYYY-MM-DD)
sales            : monthly revenue (USD thousands)
marketing_spend  : controllable ad/promo budget (USD thousands)
avg_price        : average unit price (USD); optional second regressor

The DGP is deliberately simple so that marketing scenarios produce visibly
different forecasts under Prophet's additive regressor model.
"""

from __future__ import annotations

from pathlib import Path

import numpy as np
import pandas as pd

SEED = 42
N_MONTHS = 72  # 6 years of monthly history
START = "2018-01-01"
OUT_PATH = Path(__file__).with_name("retail_marketing.csv")


def main() -> None:
    rng = np.random.default_rng(SEED)
    dates = pd.date_range(start=START, periods=N_MONTHS, freq="MS")
    t = np.arange(N_MONTHS)

    # Controllable marketing budget: base level + mild seasonality + noise.
    marketing_spend = (
        40.0
        + 8.0 * np.sin(2 * np.pi * t / 12)  # spend a bit more in peak seasons
        + rng.normal(0.0, 4.0, size=N_MONTHS)
    )
    marketing_spend = np.clip(marketing_spend, 15.0, None)

    # Average price drifts slowly and has small seasonal wobble.
    avg_price = (
        28.0
        + 0.02 * t
        + 1.5 * np.sin(2 * np.pi * (t - 3) / 12)
        + rng.normal(0.0, 0.4, size=N_MONTHS)
    )
    avg_price = np.clip(avg_price, 20.0, None)

    # Sales = trend + yearly seasonality + marketing lift − price drag + noise.
    beta_marketing = 2.8  # each $1k of marketing lifts sales by ~$2.8k
    beta_price = -3.5  # higher prices reduce volume/revenue a little
    trend = 180.0 + 1.2 * t
    seasonality = 35.0 * np.sin(2 * np.pi * (t - 10) / 12)  # peak near Nov/Dec
    noise = rng.normal(0.0, 8.0, size=N_MONTHS)

    sales = trend + seasonality + beta_marketing * marketing_spend + beta_price * avg_price + noise
    sales = np.clip(sales, 50.0, None)

    frame = pd.DataFrame(
        {
            "date": dates.strftime("%Y-%m-%d"),
            "sales": np.round(sales, 2),
            "marketing_spend": np.round(marketing_spend, 2),
            "avg_price": np.round(avg_price, 2),
        }
    )
    frame.to_csv(OUT_PATH, index=False)
    print(f"Wrote {len(frame)} rows to {OUT_PATH}")


if __name__ == "__main__":
    main()
