# Software Lineage

The ecosystem formed by these six packages is deeply interconnected, shifting from low-level multidimensional data handling and foundational graphics up to high-level domain abstractions (validation and geospatial plotting).

Below is the software lineage and dependency map, followed by a detailed historical profile for each package.

---

## 1. Software Lineage & Dependency Graph

```
           +-----------------------+
           |         NumPy         | <--------------------+
           +-----------------------+                      |
             ^                   ^                        |
             |                   |                        |
     +-------+-------+   +-------+-------+                |
     |  matplotlib   |   |    pandas     |                |
     +---------------+   +---------------+                |
       ^           ^       ^           ^                  |
       |           |       |           |                  |
+------+---+   +---+-------+---+   +---+-----------+   +--+------------+
| seaborn  |   |    folium     |   |    pandera    |   | (Other Engine)|
+----------+   +---------------+   +---------------+   +---------------+

```

### Dependency Connections

* **NumPy** is the foundation. It has zero external python dependencies in this stack.
* **matplotlib** depends directly on **NumPy** for vector manipulation.
* **pandas** depends heavily on **NumPy** as its underlying structural array engine.
* **seaborn** inherits structural concepts directly from **matplotlib** (for rendering) and **pandas** (for data structures).
* **pandera** acts as a wrapper/validator built primarily around **pandas** (and its dataframe constructs).
* **folium** uses **pandas** to process geographic/tabular data matrices, alongside rendering templates built over Leaflet.js.

---

## 2. Detailed Historical Profiles

### 📦 NumPy

* **First Release:** January 2006 (Legacy "Numeric" dates back to 1995). Released under the **BSD 3-Clause License**.
* **Major Releases:** * `v1.0` (2006) — Unified `Numeric` and `Numarray` into a singular library under the BSD license.
* `v2.0` (2024) — Complete overhaul of the C-API, string formats, and promotion of tracking rules. License remained **BSD 3-Clause**.


* **Main Contributor & Affiliation:** * **Travis Oliphant** – Brigham Young University / Mayo Clinic | *City:* Rochester, Minnesota, USA.
* **The "Why" Quote:**
> *"I wanted to unify the community around a single array package... Python needed a single, fast array type that everyone could agree on to avoid fracturing the scientific computing ecosystem."*



---

### 📦 matplotlib

* **First Release:** 2003. Released under the custom, highly permissive **Matplotlib License** (a BSD-compatible, non-copyleft license).
* **Major Releases:** * `v1.0` (2010) — Stabilized advanced environments.
* `v2.0` (2017) — Overhauled the default styles, color cycles, and presentation layers.
* `v3.0` (2018) — Dropped Python 2 support entirely. All versions remain under the **Matplotlib License / Shared Copyright Model**.


* **Main Contributor & Affiliation:** * **John D. Hunter** – University of Chicago (Postdoctoral Research in Neurobiology) | *City:* Chicago, Illinois, USA.
* **The "Why" Quote:**
> *"I began the matplotlib project while studying epilepsy seizure data... Unhappy with the state of proprietary solutions needed for my studies, I chose Python to build an open solution to my problem."*



---

### 📦 pandas

* **First Release:** January 2008 (Open-sourced in late 2009). Released under the **New BSD License (3-Clause)**.
* **Major Releases:** * `v1.0` (2020) — Introduced Native Missing values formats and dedicated ExtensionArrays.
* `v2.0` (2023) — Added Apache Arrow backend support for optimization.
* `v3.0` (2026) — Massive performance deprecation sweep. Structural license remains **BSD 3-Clause**.


* **Main Contributor & Affiliation:** * **Wes McKinney** – AQR Capital Management | *City:* Greenwich, Connecticut / New York City, USA.
* **The "Why" Quote:**
> *"I started building what would become Pandas at AQR out of the need for a high performance, flexible tool to perform quantitative analysis on financial data... I had to convince management to let me open source it."*



---

### 📦 seaborn

* **First Release:** 2013. Released under the **BSD 3-Clause License**.
* **Major Releases:** * `v0.12` (2022) — Introduced an entirely new declarative internal "Objects API" rewrite. License has consistently remained **BSD 3-Clause**.
* **Main Contributor & Affiliation:** * **Michael Waskom** – Center for Neural Science, New York University (NYU) | *City:* New York City, New York, USA.
* **The "Why" Quote:**
> *"If Matplotlib tries to make easy things easy and hard things possible, seaborn tries to make a well-defined set of hard things easy too."*



---

### 📦 pandera

* **First Release:** 2019. Released under the **MIT License**.
* **Major Releases:** * `v0.15`+ — Transitioned focus to expand beyond Pandas to multi-engine support (Polars, PySpark, Dask).
* `v0.24.0` — Re-architected namespaces specifically isolating `pandera.pandas` modules. License remains **MIT**.


* **Main Contributor & Affiliation:** * **Niels Bantilan** – Union.ai / Flyte ecosystem (previously Freenome) | *City:* San Francisco, California, USA.
* **The "Why" Quote:**
> *"The goal of Pandera is to make data processing pipelines more readable and robust with statistically typed dataframes... bringing correctness to scientists, engineers, and analysts."*



---

### 📦 folium

* **First Release:** 2013. Released under the **MIT License**.
* **Major Releases:** * `v0.10`+ (Modern Era) — Complete decoupling from pure Python structures into Jinja2 templates translating dynamically to LeafletJS hooks. Fully managed under the Python-Visualization organization. License has remained **MIT**.
* **Main Contributor & Affiliation:** * **Rob Story** – SimpleEnergy / Independent Developer | *City:* Denver, Colorado, USA.
* **The "Why" Quote:**
> *"Folium makes it easy to visualize data that’s been manipulated in Python on an interactive Leaflet map. It binds the power of data text tools seamlessly to the visualization strengths of the map engine."*