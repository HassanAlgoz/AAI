"""Load tsibble datasets from CRAN R packages into pandas DataFrames."""

from __future__ import annotations

import os
import tarfile
import warnings
from collections.abc import Callable
from pathlib import Path
from typing import Any

import matplotlib.axes
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import rdata
import requests
import seaborn as sns
from statsmodels.tsa.seasonal import STL

CACHE_DIR = Path(__file__).parent / ".cache"
CRAN_CONTRIB_URL = "https://cran.r-project.org/src/contrib"

TSIBBLEDATASETS = [
    "ansett",
    "aus_livestock",
    "aus_production",
    "aus_retail",
    "gafa_stock",
    "global_economy",
    "hh_budget",
    "nyc_bikes",
    "olympic_running",
    "PBS",
    "pelt",
    "vic_elec",
]

PACKAGES: dict[str, dict[str, Any]] = {
    "tsibbledata": {
        "archive": "tsibbledata_0.4.1.tar.gz",
        "datasets": TSIBBLEDATASETS,
    },
    "tsibble": {
        "archive": "tsibble_1.2.0.tar.gz",
        "datasets": ["tourism"],
    },
}


def _to_yearmonth(series: pd.Series) -> pd.Series:
    return pd.to_datetime(series, origin="1970-01-01", unit="D").dt.to_period("M")


def _to_yearquarter(series: pd.Series) -> pd.Series:
    return pd.to_datetime(series, origin="1970-01-01", unit="D").dt.to_period("Q")


def _rda_constructor_dict() -> dict:
    def _to_period(freq: str):
        def _constructor(obj, attrs):
            return pd.to_datetime(obj, origin="1970-01-01", unit="D").to_period(freq)

        return _constructor

    return {
        **rdata.conversion.DEFAULT_CLASS_MAP,
        "Date": lambda obj, attrs: pd.to_datetime(obj, origin="1970-01-01", unit="D"),
        "yearweek": _to_period("W"),
        "yearmonth": _to_period("M"),
        "yearquarter": _to_period("Q"),
    }


def _process_ansett(df: pd.DataFrame) -> pd.DataFrame:
    df = df.reset_index()
    start_dates = df["Week"].astype(str).str.split("/").str[0]
    df["Week"] = pd.PeriodIndex(start_dates, freq="W-SUN")
    return df.set_index(["Airports", "Class", "Week"])


def _process_aus_livestock(df: pd.DataFrame) -> pd.DataFrame:
    df = df.reset_index()
    if pd.api.types.is_numeric_dtype(df["Month"]):
        df["Month"] = _to_yearmonth(df["Month"])
    return df.set_index(["Animal", "State", "Month"])


def _process_aus_production(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df["Quarter"] = pd.PeriodIndex(df["Quarter"], freq="Q")
    return df.set_index("Quarter")


def _process_aus_retail(df: pd.DataFrame) -> pd.DataFrame:
    df = df.reset_index()
    if pd.api.types.is_numeric_dtype(df["Month"]):
        df["Month"] = _to_yearmonth(df["Month"])
    return df.set_index(["State", "Industry", "Month"])


def _process_gafa_stock(df: pd.DataFrame) -> pd.DataFrame:
    df = df.reset_index()
    return df.set_index(["Symbol", "Date"])


def _process_global_economy(df: pd.DataFrame) -> pd.DataFrame:
    return df.copy().set_index(["Country", "Year"])


def _process_hh_budget(df: pd.DataFrame) -> pd.DataFrame:
    df = df.reset_index()
    df.columns = [
        "Year",
        "Country",
        "Debt",
        "DI",
        "Expenditure",
        "Savings",
        "Wealth",
        "Unemployment",
    ]
    return df.set_index(["Country", "Year"])


def _process_nyc_bikes(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df["start_time"] = pd.to_datetime(df["start_time"], unit="s")
    df = df.reset_index()
    return df.set_index(["bike_id", "start_time"])


def _process_olympic_running(df: pd.DataFrame) -> pd.DataFrame:
    return df.copy()


def _process_pbs(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    if pd.api.types.is_numeric_dtype(df["Month"]):
        df["Month"] = _to_yearmonth(df["Month"])
    return df.set_index(["Concession", "Type", "ATC1", "ATC2", "Month"])


def _process_pelt(df: pd.DataFrame) -> pd.DataFrame:
    return df.copy()


def _process_vic_elec(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    df["Time"] = pd.to_datetime(df["Time"], unit="s")
    return df.set_index("Time")


def _process_tourism(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    if pd.api.types.is_numeric_dtype(df["Quarter"]):
        df["Quarter"] = _to_yearquarter(df["Quarter"])
    return df.set_index(["Region", "State", "Purpose", "Quarter"])


DATASET_PROCESSORS: dict[str, Callable[[pd.DataFrame], pd.DataFrame]] = {
    "ansett": _process_ansett,
    "aus_livestock": _process_aus_livestock,
    "aus_production": _process_aus_production,
    "aus_retail": _process_aus_retail,
    "gafa_stock": _process_gafa_stock,
    "global_economy": _process_global_economy,
    "hh_budget": _process_hh_budget,
    "nyc_bikes": _process_nyc_bikes,
    "olympic_running": _process_olympic_running,
    "PBS": _process_pbs,
    "pelt": _process_pelt,
    "vic_elec": _process_vic_elec,
    "tourism": _process_tourism,
}


def _package_for_dataset(name: str) -> str:
    for package, meta in PACKAGES.items():
        if name in meta["datasets"]:
            return package
    known = sorted(dataset for meta in PACKAGES.values() for dataset in meta["datasets"])
    raise ValueError(f"Unknown dataset {name!r}. Valid names: {known}")


def _cached_archive_path(archive: str) -> Path:
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    return CACHE_DIR / archive


def _download_archive(archive: str) -> Path:
    archive_path = _cached_archive_path(archive)
    if archive_path.exists():
        return archive_path

    response = requests.get(f"{CRAN_CONTRIB_URL}/{archive}", timeout=120)
    response.raise_for_status()
    archive_path.write_bytes(response.content)
    return archive_path


def _extracted_dir(archive: str) -> Path:
    return CACHE_DIR / archive.removesuffix(".tar.gz")


def _ensure_extracted(archive_path: Path) -> Path:
    extract_dir = _extracted_dir(archive_path.name)
    if extract_dir.exists() and extract_dir.stat().st_mtime >= archive_path.stat().st_mtime:
        return extract_dir

    extract_dir.mkdir(parents=True, exist_ok=True)
    with tarfile.open(archive_path) as tar:
        tar.extractall(path=extract_dir, filter="data")
    return extract_dir


def _find_rda_path(extract_dir: Path, name: str) -> Path:
    for root, _, files in os.walk(extract_dir):
        if f"{name}.rda" in files:
            return Path(root) / f"{name}.rda"
    raise FileNotFoundError(f"Could not find {name}.rda under {extract_dir}")


def _read_rda(path: Path) -> pd.DataFrame:
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        dataset = rdata.read_rda(path, constructor_dict=_rda_constructor_dict())
    if len(dataset) != 1:
        raise ValueError(f"Expected one object in {path.name}, found {len(dataset)}")
    return next(iter(dataset.values())).copy()


def load_tsibbledata(name: str) -> pd.DataFrame:
    """Load a dataset from a CRAN tsibble data package into a pandas DataFrame."""
    package = _package_for_dataset(name)
    archive = PACKAGES[package]["archive"]
    archive_path = _download_archive(archive)
    extract_dir = _ensure_extracted(archive_path)
    df = _read_rda(_find_rda_path(extract_dir, name))
    processor = DATASET_PROCESSORS.get(name)
    if processor is None:
        return df
    return processor(df)


def load_a10() -> pd.DataFrame:
    """Monthly antidiabetic drug sales (ATC2 A10) in millions of dollars."""
    pbs = load_tsibbledata("PBS")
    pbs_a10 = pbs.reset_index().query('ATC2 == "A10"')
    monthly = (
        pbs_a10[["Month", "Concession", "Type", "Cost"]]
        .groupby("Month", as_index=False)
        .agg(TotalC=("Cost", "sum"))
        .assign(Cost=lambda frame: frame["TotalC"] / 1e6)
    )
    return monthly.set_index("Month")


def load_tourism() -> pd.DataFrame:
    """Australian domestic overnight trips by region, state, and purpose."""
    return load_tsibbledata("tourism")


def _normalize_ts_frame(df: pd.DataFrame, y: str) -> tuple[pd.DataFrame, list[str]]:
    if y not in df.columns:
        raise KeyError(f"Column {y!r} not found in DataFrame.")

    if isinstance(df.index, pd.MultiIndex):
        frame = df.reset_index()
        key_cols = [col for col in frame.columns if col not in {y} and col != df.index.names[-1]]
        time_col = df.index.names[-1]
        if time_col not in frame.columns:
            raise ValueError("Could not identify the time index column.")
        key_cols = [col for col in key_cols if col != time_col]
        frame = frame.rename(columns={time_col: "_time"})
    else:
        frame = pd.DataFrame({"_time": _to_timestamp_index(df.index), y: df[y].to_numpy()})
        key_cols = []

    if isinstance(frame["_time"].dtype, pd.PeriodDtype):
        frame["_time"] = frame["_time"].dt.to_timestamp()
    frame = frame.sort_values(key_cols + ["_time"] if key_cols else ["_time"])
    return frame, key_cols


def _season_labels(times: pd.Series) -> pd.Series:
    median_delta = times.sort_values().diff().median()
    if median_delta is not None and median_delta >= pd.Timedelta(days=60):
        return "Q" + times.dt.quarter.astype(str)
    return times.dt.strftime("%b")


def _add_season_columns(
    frame: pd.DataFrame,
    *,
    period: str | None,
) -> pd.DataFrame:
    plot_df = frame.copy()
    times = plot_df["_time"]

    if period is None:
        median_delta = times.sort_values().diff().median()
        if median_delta is not None and median_delta >= pd.Timedelta(days=60):
            plot_df["season_id"] = times.dt.year.astype(str)
            plot_df["season_pos"] = times.dt.quarter
            return plot_df
        plot_df["season_id"] = times.dt.year.astype(str)
        plot_df["season_pos"] = times.dt.month
        return plot_df

    if period == "day":
        plot_df["season_id"] = times.dt.strftime("%Y-%m-%d")
        minutes = times.dt.hour * 60 + times.dt.minute
        plot_df["season_pos"] = minutes // 30
        return plot_df

    if period == "week":
        iso = times.dt.isocalendar()
        plot_df["season_id"] = iso.year.astype(str) + "-W" + iso.week.astype(str).str.zfill(2)
        week_start = times.dt.to_period("W-SUN").dt.start_time
        plot_df["season_pos"] = ((times - week_start) / pd.Timedelta(minutes=30)).astype(int)
        return plot_df

    if period == "year":
        plot_df["season_id"] = times.dt.year.astype(str)
        year_start = pd.to_datetime(plot_df["season_id"] + "-01-01")
        plot_df["season_pos"] = ((times - year_start) / pd.Timedelta(minutes=30)).astype(int)
        return plot_df

    raise ValueError(
        f"Unsupported period {period!r}. Use None, 'day', 'week', or 'year'."
    )


def time_plot_panel(
    df: pd.DataFrame,
    y: str,
    *,
    col_wrap: int | None = None,
    height: float = 2.5,
    aspect: float = 1.6,
    **line_kws: Any,
) -> sns.axisgrid.FacetGrid:
    """Faceted time plots for each key series (R's `autoplot()` on a keyed tsibble)."""
    frame, key_cols = _normalize_ts_frame(df, y)
    if not key_cols:
        _, ax = plt.subplots(figsize=(10, 4))
        sns.lineplot(data=frame, x="_time", y=y, ax=ax, **line_kws)
        return ax

    facet_col = key_cols[0]
    grid_kws: dict[str, Any] = {
        "data": frame,
        "col": facet_col,
        "sharey": False,
        "height": height,
        "aspect": aspect,
    }
    if col_wrap is not None:
        grid_kws["col_wrap"] = col_wrap

    grid = sns.FacetGrid(**grid_kws)
    grid.map_dataframe(sns.lineplot, x="_time", y=y, **line_kws)
    for axis in grid.axes.flatten():
        for label in axis.get_xticklabels():
            label.set_rotation(90)
    return grid


def seasonal_subseries_plot(
    df: pd.DataFrame,
    y: str,
    *,
    period: str | None = None,
    height: float = 2.0,
    aspect: float = 1.4,
    **line_kws: Any,
) -> sns.axisgrid.FacetGrid | matplotlib.axes.Axes:
    """Seasonal subseries plot (R's `gg_subseries()`)."""
    del period  # reserved for future custom seasonal periods
    frame, key_cols = _normalize_ts_frame(df, y)
    frame["season"] = _season_labels(frame["_time"])
    group_cols = key_cols + ["season"]
    frame["season_mean"] = frame.groupby(group_cols, observed=True)[y].transform("mean")
    season_order = sorted(frame["season"].unique(), key=_season_sort_key)

    if not key_cols:
        grid = sns.FacetGrid(
            frame,
            col="season",
            col_order=season_order,
            sharey=True,
            height=height,
            aspect=aspect,
        )
        grid.map_dataframe(sns.lineplot, x="_time", y=y, color="0.3", **line_kws)
        for season_name, axis in zip(grid.col_names, grid.axes.flatten()):
            subset = frame.loc[frame["season"] == season_name]
            if not subset.empty:
                axis.axhline(subset["season_mean"].iloc[0], color="blue", linewidth=1)
            for label in axis.get_xticklabels():
                label.set_rotation(90)
        return grid

    facet_col = key_cols[0]
    grid = sns.FacetGrid(
        frame,
        row=facet_col,
        col="season",
        row_order=sorted(frame[facet_col].unique()),
        col_order=season_order,
        sharey=False,
        height=height,
        aspect=aspect,
    )
    grid.map_dataframe(sns.lineplot, x="_time", y=y, color="0.3", **line_kws)
    for row_index, row_name in enumerate(grid.row_names):
        for col_index, season_name in enumerate(grid.col_names):
            axis = grid.axes[row_index, col_index]
            subset = frame.loc[
                (frame[facet_col] == row_name) & (frame["season"] == season_name)
            ]
            if not subset.empty:
                axis.axhline(subset["season_mean"].iloc[0], color="blue", linewidth=1)
            for label in axis.get_xticklabels():
                label.set_rotation(90)
    return grid


def _season_sort_key(label: str) -> tuple[int, str]:
    if label.startswith("Q") and label[1:].isdigit():
        return (0, f"{int(label[1:]):02d}")
    months = {
        "Jan": 1,
        "Feb": 2,
        "Mar": 3,
        "Apr": 4,
        "May": 5,
        "Jun": 6,
        "Jul": 7,
        "Aug": 8,
        "Sep": 9,
        "Oct": 10,
        "Nov": 11,
        "Dec": 12,
    }
    if label in months:
        return (0, f"{months[label]:02d}")
    return (1, label)


def _to_timestamp_index(index: pd.Index) -> pd.DatetimeIndex:
    if isinstance(index, pd.PeriodIndex):
        return index.to_timestamp()
    if isinstance(index, pd.DatetimeIndex):
        return index
    raise TypeError("Expected a DatetimeIndex or PeriodIndex on the DataFrame.")


def _seasonal_frame(
    df: pd.DataFrame,
    y: str,
    *,
    period: str | None,
) -> tuple[pd.DataFrame, list[str]]:
    frame, key_cols = _normalize_ts_frame(df, y)
    plot_df = _add_season_columns(frame, period=period)
    return plot_df, key_cols


def seasonal_plot(
    df: pd.DataFrame,
    y: str,
    *,
    period: str | None = None,
    labels: str = "none",
    ax: matplotlib.axes.Axes | None = None,
    legend: bool = True,
    height: float = 2.5,
    aspect: float = 1.6,
    **line_kws: Any,
) -> matplotlib.axes.Axes | sns.axisgrid.FacetGrid:
    """Seasonal plot: one line per season cycle, x-axis is position within the season."""
    if labels not in {"none", "left", "right", "both"}:
        raise ValueError("labels must be one of 'none', 'left', 'right', or 'both'.")

    plot_df, key_cols = _seasonal_frame(df, y, period=period)

    if key_cols:
        grid = sns.FacetGrid(
            plot_df,
            col=key_cols[0],
            sharey=False,
            height=height,
            aspect=aspect,
        )
        grid.map_dataframe(
            sns.lineplot,
            x="season_pos",
            y=y,
            hue="season_id",
            palette="husl",
            linewidth=1,
            legend=legend,
            **line_kws,
        )
        if labels in {"left", "both", "right"}:
            for facet_name, axis in zip(grid.col_names, grid.axes.flatten()):
                subset = plot_df.loc[plot_df[key_cols[0]] == facet_name]
                if labels in {"left", "both"}:
                    left = subset.loc[subset.groupby("season_id")["season_pos"].idxmin()]
                    for _, row in left.iterrows():
                        axis.text(
                            row["season_pos"],
                            row[y],
                            row["season_id"],
                            fontsize=8,
                            ha="right",
                            va="center",
                        )
                if labels in {"right", "both"}:
                    right = subset.loc[subset.groupby("season_id")["season_pos"].idxmax()]
                    for _, row in right.iterrows():
                        axis.text(
                            row["season_pos"],
                            row[y],
                            row["season_id"],
                            fontsize=8,
                            ha="left",
                            va="center",
                        )
        return grid

    if ax is None:
        _, ax = plt.subplots(figsize=line_kws.pop("figsize", (10, 6)))

    sns.lineplot(
        data=plot_df,
        x="season_pos",
        y=y,
        hue="season_id",
        palette="husl",
        linewidth=1,
        legend=legend,
        ax=ax,
        **line_kws,
    )

    if labels in {"left", "both"}:
        left = plot_df.loc[plot_df.groupby("season_id")["season_pos"].idxmin()]
        for _, row in left.iterrows():
            ax.text(
                row["season_pos"],
                row[y],
                row["season_id"],
                fontsize=8,
                ha="right",
                va="center",
            )

    if labels in {"right", "both"}:
        right = plot_df.loc[plot_df.groupby("season_id")["season_pos"].idxmax()]
        for _, row in right.iterrows():
            ax.text(
                row["season_pos"],
                row[y],
                row["season_id"],
                fontsize=8,
                ha="left",
                va="center",
            )

    return ax


TSA_ARCHIVE = "TSA_1.3.1.tar.gz"


def _tsa_extract_dir() -> Path:
    archive_path = _cached_archive_path(TSA_ARCHIVE)
    if not archive_path.exists():
        response = requests.get(f"{CRAN_CONTRIB_URL}/{TSA_ARCHIVE}", timeout=120)
        response.raise_for_status()
        archive_path.write_bytes(response.content)
    return _ensure_extracted(archive_path)


def _read_rda_without_ts(path: Path) -> dict:
    with warnings.catch_warnings():
        warnings.simplefilter("ignore")
        constructor_dict = {
            key: value
            for key, value in rdata.conversion.DEFAULT_CLASS_MAP.items()
            if key != "ts"
        }
        return rdata.read_rda(path, constructor_dict=constructor_dict)


def load_milk() -> pd.Series:
    """Monthly milk production per cow from the TSA package (Jan 1962–Dec 1973)."""
    extract_dir = _tsa_extract_dir()
    dataset = _read_rda_without_ts(_find_rda_path(extract_dir, "milk"))
    values = np.asarray(dataset["milk"]).ravel()
    index = pd.period_range("1962-01", periods=len(values), freq="M")
    return pd.Series(values, index=index, name="milk")


def monthdays(index: pd.Index) -> pd.Series:
    """Number of calendar days in each month (R's `TSA::monthdays()`)."""
    if isinstance(index, pd.PeriodIndex):
        return pd.Series(index.days_in_month, index=index, name="monthdays")
    if isinstance(index, pd.DatetimeIndex):
        return pd.Series(index.daysinmonth, index=index, name="monthdays")
    raise TypeError("index must be a PeriodIndex or DatetimeIndex.")


FPP3_ARCHIVE = "fpp3_1.0.3.tar.gz"


def _fpp3_extract_dir() -> Path:
    archive_path = _cached_archive_path(FPP3_ARCHIVE)
    if not archive_path.exists():
        local_archive = Path(__file__).parent / "data" / "raw" / FPP3_ARCHIVE
        if local_archive.exists():
            archive_path.write_bytes(local_archive.read_bytes())
        else:
            response = requests.get(f"{CRAN_CONTRIB_URL}/{FPP3_ARCHIVE}", timeout=120)
            response.raise_for_status()
            archive_path.write_bytes(response.content)
    return _ensure_extracted(archive_path)


def load_fpp3(name: str) -> pd.DataFrame:
    """Load a dataset bundled with the fpp3 R package."""
    extract_dir = _fpp3_extract_dir()
    return _read_rda(_find_rda_path(extract_dir, name))


def load_us_retail_employment(since: int = 1990) -> pd.DataFrame:
    """Monthly US retail employment from the fpp3 package."""
    employment = load_fpp3("us_employment")
    retail = employment.loc[employment["Title"] == "Retail Trade"].copy()
    retail = retail.loc[retail["Month"].dt.year >= since]
    retail = retail.drop(columns=["Series_ID"]).set_index("Month").sort_index()
    if isinstance(retail.index, pd.PeriodIndex):
        retail.index = retail.index.to_timestamp()
    return retail


def load_vic_elec() -> pd.DataFrame:
    """Half-hourly Victorian electricity demand with Melbourne temperature.

    Source: half-hourly Victorian electricity demand (2012–2015), stored locally as
    ``data/vic_elec.csv``. Timestamps are converted to Australia/Melbourne.
    """
    vic_elec = pd.read_csv(
        Path(__file__).parent / "data" / "vic_elec.csv",
        parse_dates=["Time", "Date"],
        index_col="Time",
    )
    vic_elec.index = (
        vic_elec.index.tz_localize("UTC")
        .tz_convert("Australia/Melbourne")
        .tz_localize(None)
    )
    return vic_elec


def add_vic_elec_day_type(vic_elec: pd.DataFrame) -> pd.DataFrame:
    """Label each row as Weekday, Weekend, or Holiday for scatterplot colour."""
    frame = vic_elec.copy()

    def _day_type(row: pd.Series) -> str:
        if row["Holiday"]:
            return "Holiday"
        if row.name.dayofweek >= 5:
            return "Weekend"
        return "Weekday"

    frame["DayType"] = frame.apply(_day_type, axis=1)
    return frame


def load_us_change() -> pd.DataFrame:
    """Quarterly US macro percentage changes (consumption, income, production, savings, unemployment)."""
    return load_fpp3("us_change")


def modified_box_cox(y: pd.Series | np.ndarray, lam: float) -> np.ndarray:
    """Box-Cox transform for strictly positive series via ``scipy.stats.boxcox``.

    For $y_t > 0$ this matches the modified Box-Cox formula in the lesson when
    $lambda > 0$; for negative $y_t$ use the sign-based formula in the slides
    instead (not covered by SciPy's implementation).
    """
    from scipy.stats import boxcox

    values = np.asarray(y, dtype=float)
    if np.any(values <= 0):
        raise ValueError("scipy.stats.boxcox requires strictly positive values.")
    return boxcox(values, lam)


def guerrero_lambda(
    y: pd.Series,
    *,
    period: int = 4,
    bounds: tuple[float, float] | None = None,
) -> float:
    """Choose a Box-Cox lambda using Guerrero's method (Guerrero, 1993).

    Delegates to ``sktime.transformations.series.boxcox.BoxCoxTransformer``
    with ``method="guerrero"`` — the same approach as R's ``feasts::guerrero()``.
    """
    from sktime.transformations.series.boxcox import BoxCoxTransformer

    if not isinstance(y, pd.Series):
        y = pd.Series(y)

    transformer = BoxCoxTransformer(method="guerrero", sp=period, bounds=bounds)
    transformer.fit(y)
    return float(transformer.lambda_)


def stl_decompose(
    series: pd.Series,
    *,
    period: int = 12,
    robust: bool = True,
) -> pd.DataFrame:
    """Return an additive STL decomposition table for a univariate series."""
    if not isinstance(series.index, (pd.DatetimeIndex, pd.PeriodIndex)):
        raise TypeError("series must have a DatetimeIndex or PeriodIndex.")

    y_name = series.name or "y"
    stl = STL(series.astype(float), period=period, robust=robust)
    result = stl.fit()
    components = pd.DataFrame(
        {
            y_name: series.to_numpy(),
            "trend": result.trend,
            "seasonal": result.seasonal,
            "remainder": result.resid,
        },
        index=series.index,
    )
    components["season_adjust"] = components[y_name] - components["seasonal"]
    return components


def plot_stl_components(
    components: pd.DataFrame,
    *,
    y: str | None = None,
    figsize: tuple[float, float] = (10, 8),
) -> plt.Figure:
    """Plot the original series and STL components (FPP3 Figure 3.7 style)."""
    y_name = y or next(col for col in components.columns if col not in {"trend", "seasonal", "remainder", "season_adjust"})
    panels = [
        (y_name, "Observed"),
        ("trend", "Trend"),
        ("seasonal", "Seasonal"),
        ("remainder", "Remainder"),
    ]

    fig, axes = plt.subplots(len(panels), 1, figsize=figsize, sharex=True)
    for axis, (column, title) in zip(axes, panels):
        axis.plot(components.index, components[column], color="#333333", linewidth=1)
        axis.set_ylabel(title)
        axis.grid(True, alpha=0.3)
    axes[-1].set_xlabel("Time")
    fig.tight_layout()
    return fig


def plot_component_overlay(
    components: pd.DataFrame,
    *,
    y: str | None = None,
    component: str,
    component_color: str,
    title: str,
    ylabel: str,
    ax: matplotlib.axes.Axes | None = None,
) -> matplotlib.axes.Axes:
    """Overlay one STL component on the observed series."""
    y_name = y or next(col for col in components.columns if col not in {"trend", "seasonal", "remainder", "season_adjust"})
    if ax is None:
        _, ax = plt.subplots(figsize=(10, 4))

    ax.plot(components.index, components[y_name], color="0.75", linewidth=1, label="Observed")
    ax.plot(
        components.index,
        components[component],
        color=component_color,
        linewidth=1.5,
        label=component.replace("_", " ").title(),
    )
    ax.set(title=title, ylabel=ylabel, xlabel="")
    ax.legend()
    return ax


def _acf_lag_label(lag: int, index: pd.Index) -> str:
    """Human-readable lag label (e.g. ``1Q`` for quarterly series)."""
    if isinstance(index, pd.PeriodIndex) and "Q" in str(index.freqstr or ""):
        return f"{lag}Q"
    if isinstance(index, pd.DatetimeIndex):
        median_delta = index.to_series().diff().median()
        if median_delta is not None and median_delta >= pd.Timedelta(days=60):
            return f"{lag}Q"
    return str(lag)


def acf_significance_bounds(n_obs: int, *, alpha: float = 0.05) -> float:
    """Approximate 95% ACF significance bound: $\\pm z / \\sqrt{T}$."""
    from scipy.stats import norm

    z = norm.ppf(1 - alpha / 2)
    return float(z / np.sqrt(n_obs))


def acf_table(series: pd.Series, *, lag_max: int | None = None) -> pd.DataFrame:
    """Autocorrelation coefficients as a DataFrame (R's ``feasts::ACF()`` table)."""
    from statsmodels.tsa.stattools import acf

    values = series.dropna().astype(float)
    max_lag = lag_max if lag_max is not None else min(40, len(values) // 2 - 1)
    coeffs = acf(values, nlags=max_lag, fft=False)
    lags = range(1, len(coeffs))
    return pd.DataFrame(
        {
            "lag": [_acf_lag_label(k, values.index) for k in lags],
            "acf": coeffs[1:],
        }
    )


def plot_lag_grid(
    series: pd.Series,
    *,
    lags: int = 9,
    ncol: int = 3,
    figsize: tuple[float, float] | None = None,
    geom: str = "point",
    legend: bool = True,
) -> plt.Figure:
    """Lagged scatterplot grid (R's ``feasts::gg_lag()``).

    Parameters
    ----------
    geom:
        ``"point"`` for scatterplots (``gg_lag(..., geom = "point")`` in R), or
        ``"line"`` for the default that connects observations in time order.
    """
    if geom not in {"point", "line"}:
        raise ValueError("geom must be 'point' or 'line'.")

    y_name = series.name or "y"
    values = series.dropna().astype(float)
    frame = pd.DataFrame({y_name: values.to_numpy()}, index=values.index)

    if isinstance(values.index, (pd.PeriodIndex, pd.DatetimeIndex)):
        frame["season"] = "Q" + values.index.quarter.astype(str)
        season_order = ["Q1", "Q2", "Q3", "Q4"]
    else:
        frame["season"] = "all"
        season_order = ["all"]

    nrows = int(np.ceil(lags / ncol))
    if figsize is None:
        figsize = (3.6 * ncol, 3.2 * nrows)

    fig, axes = plt.subplots(nrows, ncol, figsize=figsize)
    axes = np.atleast_1d(axes).flatten()

    for lag, axis in enumerate(axes[:lags], start=1):
        lagged = frame[y_name].shift(lag)
        plot_df = pd.DataFrame(
            {
                f"lag({y_name}, {lag})": lagged,
                y_name: frame[y_name],
                "season": frame["season"],
            },
            index=frame.index,
        ).dropna()
        plot_df = plot_df.sort_index()

        plot_kws = {
            "data": plot_df,
            "x": f"lag({y_name}, {lag})",
            "y": y_name,
            "hue": "season",
            "hue_order": season_order,
            "palette": "husl",
            "ax": axis,
            "legend": False,
        }
        if geom == "point":
            sns.scatterplot(**plot_kws, s=28)
        else:
            sns.lineplot(**plot_kws, linewidth=1, marker="o", markersize=3)

        axis.set_title(f"lag = {lag}")

    for axis in axes[lags:]:
        axis.set_visible(False)

    if legend and season_order != ["all"]:
        palette = sns.color_palette("husl", n_colors=len(season_order))
        handles = [
            plt.Line2D([0], [0], marker="o", color="w", markerfacecolor=color, markersize=6, label=label)
            for color, label in zip(palette, season_order, strict=True)
        ]
        fig.legend(
            handles,
            [handle.get_label() for handle in handles],
            title="Quarter",
            loc="lower center",
            bbox_to_anchor=(0.5, -0.01),
            ncol=len(season_order),
            frameon=False,
        )
        fig.tight_layout(rect=(0, 0.04, 1, 1))
    else:
        fig.tight_layout()
    return fig


def plot_acf_correlogram(
    series: pd.Series,
    *,
    lag_max: int | None = None,
    title: str | None = None,
    ax: matplotlib.axes.Axes | None = None,
    figsize: tuple[float, float] = (10, 4),
) -> matplotlib.axes.Axes:
    """Correlogram with 95% significance bounds (R's ``ACF() |> autoplot()``)."""
    from statsmodels.graphics.tsaplots import plot_acf

    values = series.dropna().astype(float)
    if ax is None:
        _, ax = plt.subplots(figsize=figsize)

    plot_acf(
        values,
        lags=lag_max,
        ax=ax,
        alpha=0.05,
        title=title or "",
    )
    return ax


def plot_diagnostics(data):
    _, axes = plt.subplot_mosaic([["resid", "resid"], ["acf", "hist"]])
    ax = axes["resid"]
    ax.plot(data["ds"], data["resid"])
    ax.set(title="Innovation Residuals")
    ax = axes["acf"]
    plot_acf(data["resid"].dropna(),
        zero=False, bartlett_confint=False, auto_ylims=True, ax=ax)
    ax.set(title="ACF Plot", xlabel="lag[1]", ylabel="acf")
    ax = axes["hist"]
    ax.hist(data["resid"], bins=20)
    ax.set(title="Histogram", xlabel="resid", ylabel="count")
