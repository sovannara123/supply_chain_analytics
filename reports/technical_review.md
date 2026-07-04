# Technical Portfolio Review: Supply Chain Optimization & Logistics Analytics

**Reviewer:** AI Technical Review Panel (Data Analytics, Supply Chain, ML, BI)
**Date:** July 4, 2026
**Scope:** Full project audit across 20 dimensions

---

## 1. Repository Validation — Score: 6/10

**Strengths:**
- Clean top-level structure with clear separation (notebooks/, sql/, reports/, visuals/, dashboard/)
- `.gitignore` correctly excludes large CSVs (293MB kept off-repo)
- Single commit with all 63 tracked files
- `README.md` has badges, hypothesis table, limitations section, project tree
- `requirements.txt` with pinned versions

**Weaknesses:**
- **Single commit** — no development history. A hiring manager can't see iteration, debugging, or progressive refinement. Red flag.
- `notebooks/03_logistics_and_routing.ipynb` is **32,684 lines** in git diff — mostly inline HTML/JavaScript from Plotly/Folium maps embedded in cell outputs. This inflates the repo to 47K lines of diff noise.
- **No setup script** — no `setup.sh`, no `Makefile`, no `conda env.yml`. `pip install -r requirements.txt` works but there's no instruction to run the notebooks in order.
- `dashboard/screenshots/` directory is empty — placeholder directory should either be populated or removed.
- Notebook 01 references the original CSV (`DataCoSupplyChainDataset.csv`) but only the cleaned CSV exists on disk (both exist). A fresh clone doesn't have the original unless manually downloaded from Kaggle.
- No `__init__.py` or reusable `.py` modules — all code lives in notebooks (fine for a portfolio, but limits modularity claims).

---

## 2. Business Problem Validation — Score: 7/10

**Strengths:**
- Business scenario is realistic: global manufacturer facing freight costs, lead time variance, inventory imbalances
- 20 business questions cover all major supply chain domains (executive KPIs, logistics, inventory, supplier, cost, driver analysis)
- 5 hypotheses are testable and well-defined
- Recommendations are specific (e.g., "Focus on top 20% suppliers driving 71% of delays")

**Weaknesses:**
- **No cost quantification in recommendations** — the Pareto finding says "top 20% origins → 71% of late orders," but there's no dollar estimate of what fixing this would save. Every business case needs ROI.
- **A2 (freight cost) and C4 (volume vs freight cost) and D3 (freight by supplier) are marked "no data"** — three of 20 questions dead-ended. This is a dataset limitation, but the project should acknowledge what alternative analysis could partially address these.
- **Missing key supply chain KPIs:** No calculation of **Fill Rate**, **Perfect Order Rate**, or **Cash-to-Cash Cycle Time**. OTIF is mentioned but never fully calculated (only OTD).
- **Lost revenue ($1.57M) is identified but not broken down** — is this concentrated in specific categories, regions, or seasons? That would drive action.

**Suggested additions:**
- Perfect Order Rate = (% on-time × % complete × % undamaged). We have on-time and order_status data.
- Fill Rate per product category (fraction of orders that shipped complete vs. partial)
- Lost revenue breakdown by category/region/month

---

## 3. Data Validation — Score: 8/10

**Strengths:**
- Column standardization to snake_case — professional
- Strategy for high-missingness columns (>50% → drop) is documented and appropriate
- IQR capping (1.5× rule) on 7 columns with counts logged
- Data audit report generated with missing values, duplicates, date sanity, negative values checks
- Feature engineering adds 11 datetime-derived features

**Weaknesses:**
- **`select_dtypes(include='str')` is deprecated in pandas 2+/3+** — notebook 01 uses it without the explicit `'str'` dtype argument. The warning was already suppressed, but this will break in future pandas versions.
- **`select_dtypes(include='object')` in notebook 06 for categoricals** — same deprecation issue
- **`fillna(df[num_cols].median())` fills ALL numeric NaNs with the overall column median** — this ignores feature-specific distribution. For columns with very different scales (e.g., `order_item_discount` vs `sales`), a single median per column is fine, but the vectorized fill is error-prone if a column is entirely NaN (would fill with NaN from the median calculation).
- IQR capping uses 1.5× rule on all 7 columns uniformly — some columns (e.g., `actual_shipping_delay`) have 19.8% outliers capped. This is aggressive and may remove legitimate variability in delivery delays.
- `days_for_shipping_real` is stored as integer but could be negative (though audit shows 0 negative values)
- No explicit **train/test leakage check** in the data audit — the cleaned CSV includes post-hoc features like `actual_shipping_delay` which are leaky for any predictive task

---

## 4. Statistical Validation — Score: 5/10

**Weaknesses:**
- **No formal statistical tests anywhere in the project** — H1-H5 are evaluated by comparing means/proportions only. No t-tests, chi-square tests, confidence intervals, or p-values.
- **H1 conclusion ("Rejected") based on First Class 0.0% on-time rate** — the data quality note says this may be an artifact, yet the hypothesis is still marked "Rejected" based on that same data. If the data is unreliable, the conclusion is unreliable.
- **H4 conclusion ("Negligible difference" $33.08 vs $32.67)** — no confidence interval. The difference is $0.41. With 180K orders, this could be statistically significant even if practically meaningless. Need both: a test + effect size.
- **H5 conclusion ("Q4 not the peak")** — shows Q1 > Q4 by raw revenue. But revenue ≠ order volume. The hypothesis says "order volume peaks." Revenue could be higher in Q1 due to higher prices, not more orders.
- **Pareto H3** — uses raw counts without testing whether the concentration is statistically greater than what random chance would produce. 71% vs 80% target — is this significantly different?
- **No uncertainty quantification anywhere** — no standard errors, no bootstrapped estimates

---

## 5. Exploratory Data Analysis Review — Score: 7/10

**Strengths:**
- 35 visualizations covering distributions, correlations, time trends, seasonality, shipping modes, geographic patterns
- Correlation heatmap with top 10 pairs (managing 62 columns well)
- OTIF bar chart clearly shows the 42.7% on-time / 57.3% late split
- Monthly trend + seasonality by quarter and weekday
- Top products/categories/regions/markets all visualized

**Weaknesses:**
- **Visual naming collision** — `08_top_category_name.png`, `08_top_market.png`, `08_top_order_region.png`, `08_top_product_name.png` all share the same numerical prefix `08_`. Collision risk when sorting/scripting.
- **No scatter plots** — no relationship exploration beyond correlations. E.g., price vs. delay, quantity vs. profit, distance vs. delay
- **No geographic map in EDA** — the interactive map is in notebook 03 (logistics). A base map showing order origin distribution belongs in EDA.
- **Univariate distributions** are histograms only — no box plots alongside to show outliers
- **No CDF/ECDF plots** for delivery times, delays, or profits

---

## 6. Supply Chain Domain Review — Score: 6/10

**Strengths:**
- Core concepts covered: OTD, lead time, ABC/XYZ, Pareto, shipping modes, seasonal demand
- Inventory segmentation (ABC-XYZ matrix) is well-executed
- Supplier composite scoring is creative given no supplier IDs

**Missing supply chain concepts (gaps):**
| Concept | Status | Impact |
|---------|--------|--------|
| On-Time In-Full (OTIF) | ❌ Only OTD (42.7%) — no "in-full" component | Major gap. OTIF is the standard metric |
| Fill Rate | ❌ Not calculated | Essential for inventory analysis |
| Perfect Order Rate | ❌ Not calculated | Combines OTD + fill rate + damage-free + correct docs |
| Cash-to-Cash Cycle Time | ❌ Not calculated | Core working capital metric |
| Safety Stock Calculation | ❌ ABC-XYZ done but no safety stock formulas | Next logical step from ABC/XYZ |
| Reorder Point (ROP) | ❌ Not calculated | Links inventory to demand |
| Freight Cost per Unit | ❌ No freight column in data | Acknowledged but no proxy attempted |
| Carrier Performance | ❌ Not analyzed | Only shipping mode is analyzed, not carrier-level |
| Warehouse Location Optimization | ❌ Not addressed | Beyond scope but relevant to logistics analysis |

---

## 7. Logistics Analysis Review — Score: 7/10

**Strengths:**
- Shipping mode performance table with orders, on-time %, avg delay, avg profit
- Geographic analysis at market × region level (heatmap)
- Top 10 delay-prone and most reliable routes
- Interactive Plotly scatter-map for geographic delivery visualization
- Expedited vs. standard comparison

**Weaknesses:**
- **"Most expensive routes" (B2) is marked "Partial"** — without freight cost, the project uses avg profit as a cost proxy. This is acknowledged but not well-explained.
- **Route analysis aggregates by `order_city` → `customer_city`** — but origin-destination pairs aren't explicitly created. The analysis shows origin cities by late rate, not actual route pairs.
- **Bottleneck identification is descriptive, not prescriptive** — "Central Africa has 60.7% late rate" is stated but no root cause analysis (port congestion? customs delays? carrier issues?).
- **No time-series decomposition of delays** — are delays getting worse over time? Only aggregate rates are shown.

---

## 8. Inventory Analysis Review — Score: 7/10

**Strengths:**
- ABC classification by product (6 A-items → 70% revenue) and by category
- XYZ classification by demand volatility (115 stable, 3 moderate, 0 volatile)
- ABC-XYZ matrix with 9-segment strategy grid
- Seasonal demand analysis for top 5 categories
- Department profitability ranking (Fan Shop $2.9M profit)
- Order status breakdown with $1.57M lost revenue

**Weaknesses:**
- **XYZ classification uses `order_item_quantity` std dev / mean** (CV) — this measures sales volatility, not demand volatility. Without actual demand data, this is a sales proxy.
- **0 Z-items (volatile)** is suspicious — with 118 products, having zero volatile items likely means the CV threshold is too loose or the data doesn't capture true demand spikes.
- **Safety stock and reorder points not calculated** — this is the natural next step after ABC-XYZ. Without it, the inventory optimization story is incomplete.
- **Inventory turnover (A5) estimated at 12.2x using 30-day COGS assumption** — the 30-day assumption is reasonable for retail but not justified or benchmarked. Faster/slower turnover changes the number by 3-5x.
- **Seasonal analysis shows peaks but doesn't recommend stocking strategies** — e.g., "Cleats peak in March" → how many weeks of inventory should be held before March?

---

## 9. Supplier Performance Review — Score: 6/10

**Strengths:**
- Creative proxy methodology (order_city | order_country as supplier) with clear disclaimer
- Composite scoring with weighted components (on-time 40%, delay 30%, consistency 20%, breadth 10%)
- Pareto confirmed: top 20% origins → 71% of late orders
- Lead time consistency ranking
- Product-level risk scoring

**Weaknesses:**
- **The supplier proxy is problematic** — `order_city | order_country` conflates multiple real suppliers in the same city into one proxy. A city with 50 different actual suppliers appears as one "supplier." The 3,665 proxy "suppliers" are not real supply chain entities. This is stated as a limitation but the entire supplier analysis chapter is built on it.
- **Composite score weights are arbitrary** — why 40/30/20/10? No sensitivity analysis, no cross-validation, no business justification. Changing weights would reorder the entire ranking.
- **Best supplier = "Paramaribo | Surinam" with 8 orders** — 8 orders is not statistically meaningful. The filter threshold (≥50 orders) was applied in some analyses but not the scoring cell.
- **No supplier trend analysis** — are problem suppliers getting better or worse over time? A supplier with improving trends is different from one with deteriorating trends.
- **Product risk scoring double-weights delay** — `avg_delay` appears in both the numerator (clipped) and the denominator (max). This creates a non-linear interaction that's not documented.

---

## 10. Machine Learning Review — Score: 5/10

**Weaknesses:**
- **ROC-AUC 0.525 — near random.** The model cannot predict late delivery. This is honestly documented as non-stationarity, but a hiring manager will ask: "Why build a model that doesn't work and call it a deliverable?"
- **Test ROC-AUC (0.525) vs CV ROC-AUC (0.835) — massive gap** indicates severe overfitting to time-period-specific patterns. The time-based split exposed this, which is good practice. But the result is that the model is not usable.
- **LabelEncoder applied BEFORE train/test split** — this is data leakage. The encoder sees all categories in the test set, including ones that might not appear in training. For a real deployment, `sklearn.pipeline.Pipeline` with `ColumnTransformer` would be standard.
- **No handling of high-cardinality categoricals** — `customer_city` (1,611 unique), `order_city` (2,048 unique), `product_name` (118 unique) are label-encoded with arbitrary integers. XGBoost can handle this, but recent work shows target encoding or count encoding performs better for high-cardinality features.
- **`order_hour` as #2 feature (0.048 importance)** — this is suspiciously high for a feature that should have low predictive power. Might be a spurious correlation from the time-based split (order hours may have shifted over time).
- **No baseline model** — no comparison to logistic regression, random forest, or simple heuristic (e.g., "always predict late" = 54.8% accuracy). Without a baseline, we don't know if XGBoost adds value.
- **SHAP values explain a near-random model** — SHAP is powerful for explaining accurate models. Explaining a model with ROC-AUC 0.525 is less meaningful because the model itself has little signal.
- **Hyperparameter tuning found params that made test performance worse** — this is fine to show, but the notebook doesn't discuss why (overfitting to CV folds that don't respect time ordering).

**What would improve this section:**
- Add baseline: logistic regression + "always predict majority class"
- Move LabelEncoder to post-split with proper pipeline
- Try feature selection to reduce noise from 32 weak features
- Add time-series cross-validation (TimeSeriesSplit) instead of StratifiedKFold
- Document the honest conclusion more thoroughly: "This dataset lacks the features needed for prediction; next steps require real-time logistics data"

---

## 11. SQL Review — Score: 7/10

**Strengths:**
- 31 queries across 5 scripts, all tested against real SQLite with 180K rows
- Demonstrates CTEs, window functions (ROW_NUMBER, RUNNING TOTAL), CASE expressions
- Well-commented with business question mapping
- Composite scoring logic in script 04
- Pareto analysis via cumulative window function

**Weaknesses:**
- **All queries are SELECT-only** — no CREATE TABLE, INSERT, UPDATE, DELETE, or JOIN operations (beyond the implicit single-table design). A production analytics query set would include multi-table joins.
- **Single-table design** — all queries operate on one `orders` table. Real supply chain databases have 10-20+ normalized tables (orders, products, suppliers, inventory, shipments, carriers, returns).
- **`STDDEV` was originally written then replaced** — the final version uses `SQRT(AVG(x*x) - AVG(x)*AVG(x))` which is numerically unstable for large values (catastrophic cancellation). SQLite doesn't have built-in STDDEV, but this formula can produce negative variance for near-constant columns.
- **No indexes created** — not critical for SQLite but shows lack of SQL optimization awareness.
- **Comments note "SQLite syntax"** but originally included MySQL functions (`LEAST`) — the fix was applied but shows dialect uncertainty.
- **No parameterization or dynamic SQL** — simple static queries only.

---

## 12. Dashboard Review — Score: 6/10

**Strengths:**
- 6 interactive Plotly charts with KPI card row
- Responsive layout (CSS grid + media queries)
- Clean color palette, professional typography
- Mobile-friendly
- Single self-contained HTML file (no server needed)

**Weaknesses:**
- **Not Power BI** — the project brief promises "Power BI Control Tower Dashboard." The HTML dashboard is a functional substitute but is not equivalent. A hiring manager expecting Power BI will notice.
- **No interactivity beyond hover tooltips** — no slicers, no filters, no drill-down, no cross-filtering between charts. Power BI's core value is interactive exploration.
- **No map visualization** — given the geographic nature of supply chain, a map should be the centerpiece. The interactive map from notebook 03 is not embedded.
- **KPI cards show 6 metrics** — good start, but missing: OTIF, profit margin, lead time trend, supplier risk score
- **Static data only** — no date range selector, no ability to filter by region/mode/category. An executive dashboard without filters is a report, not a dashboard.
- **`screenshots/` directory is empty** — even a static PNG of the dashboard would help for GitHub README preview.

---

## 13. Code Quality Review — Score: 5/10

**Strengths:**
- Consistent use of `if col in df.columns` defensive checks
- All visuals auto-save to a centralized `visuals/` directory
- `save_fig()` helper function reused across notebooks
- Pandas options set for display consistency
- Notebooks import libraries at the top

**Weaknesses:**
- **All code is in notebooks** — 0 reusable Python modules. Functions are duplicated across notebooks (e.g., `save_fig()` defined 6 times). This is copy-paste technical debt.
- **No unit tests** — zero test coverage for any transformation, calculation, or scoring function
- **Hardcoded paths everywhere** — `'../data/supply_chain_cleaned.csv'`, `'../visuals/'` — would break if running from a different directory
- **Notebook 03 contains 32K lines of inline HTML output** — this is not code the candidate wrote, but it inflates diffs and review time
- **No exception handling** — no try/except blocks around file I/O, data transformations, or model training
- **No logging** — all status reporting is via `print()`, which is lost in production
- **`train_test_split` is imported but never used** (replaced by time-based split) — minor but shows incomplete cleanup
- **No `__main__` guard** — not applicable to notebooks, but any refactored `import`-able module would need it

---

## 14. GitHub Portfolio Review

**Would I open it?** Yes — the README badges and clear project structure catch attention.

**Would I continue reading?** The hypothesis table and limitations section hold interest. The honest ML result (ROC-AUC 0.525) is refreshing — most portfolios hide failures.

**Would I clone it?** Probably not. The single commit and 32K-line notebook diff suggest this was uploaded as a final artifact, not developed iteratively. I'd want to see commit history showing debugging, refactoring, and progressive insight.

**Would I interview the candidate?** Yes — but with reservations. The project shows breadth (SQL + Python + stats + ML + dashboard) but limited depth. I'd ask: "Why did the ML model fail?" and "How would you improve the supplier proxy?"

**Does it stand out?** Among 300 applications: **Top 25%**. The honesty about limitations is rare and valuable. The thorough documentation shows professionalism. But the single commit, near-random ML model, and lack of Power BI dashboard prevent it from being a standout.

---

## 15. Resume Impact

**Three strong bullet points:**

> **1.** Analyzed 180K supply chain orders across 62 features, identifying a 57.3% late delivery rate and quantifying $1.57M in annualized revenue loss from canceled/fraud orders, driving 7 operational recommendations.

> **2.** Built an XGBoost late-delivery prediction model with SHAP explainability; discovered non-stationarity in logistics data (test ROC-AUC 0.525 vs CV ROC-AUC 0.835), concluding that static features alone cannot predict future delays without real-time data integration.

> **3.** Implemented ABC-XYZ inventory segmentation across 118 products, identifying 6 A-items driving 70% of revenue, and a Pareto analysis confirming top 20% of origin locations cause 71% of late deliveries.

---

## 16. Hiring Manager Review

**Technical Level:** **Advanced Beginner / Early Junior**

The candidate demonstrates awareness of the right techniques (SHAP, ABC-XYZ, Pareto, composite scoring) but applies them at a surface level. The gap between "knowing about" a technique and "executing it rigorously" is the difference between junior and mid-level.

**Industry Readiness:** **Not yet production-ready** — the SQL queries are single-table, the ML model has data leakage (encoding before split), and there are no reusable modules or tests.

**Hiring Recommendation:** **Perhaps — Interview with caveats**

**For a startup:** **Interview.** Startups value breadth and initiative. The project shows someone who can jump across the analytics stack.
**For a Fortune 500:** **Maybe.** They'd want to see deeper domain knowledge (OTIF, fill rate, inventory turnover methodology).
**For FAANG/Big Tech:** **Not competitive.** Equivalent candidates would have multi-table SQL, production ML pipelines with CI/CD, A/B testing, and time-series forecasting.

**What I'd ask in an interview:**
1. "Walk me through the supplier proxy limitation. If you had real supplier IDs, how would your scoring change?"
2. "The ML model has ROC-AUC 0.525. Why did you include it in the portfolio?"
3. "How would you calculate safety stock from your ABC-XYZ analysis?"
4. "What's the difference between OTD and OTIF, and how would you calculate OTIF here?"
5. "Your SQL is on a single table. Design a 3-table schema for this dataset."

---

## 17. Red Team Review — Flaws

| # | Flaw | Severity |
|---|------|----------|
| 1 | **ML LabelEncoder before train/test split (data leakage)** | Critical — invalidates ML pipeline methodology |
| 2 | **Supplier proxy (city|country) is not a supplier identifier** | High — entire supplier chapter is built on a proxy with 3,665 entities that aren't real suppliers |
| 3 | **No statistical tests on any hypothesis** | High — conclusions are based on means/proportions without confidence intervals |
| 4 | **First Class data anomaly acknowledged but not excluded from H1 conclusion** | High — rejecting H1 based on known-bad data is contradictory |
| 5 | **ABC classification uses `order_id` nunique as sales proxy** (not actual `sales` in the first classification) | Medium — need to verify. Subsequent cells use sales properly |
| 6 | **XYZ uses sales CV, not demand CV** | Medium — without actual demand data, this is a sales volatility measure |
| 7 | **"16 cells (+ tuning)" ≠ actual cell count** | Low — minor accuracy issue |
| 8 | **Dashboard has no interactive filters** | Medium — reduces utility from "dashboard" to "report" |
| 9 | **No baseline model in ML** | Medium — can't evaluate if XGBoost outperforms simple heuristics |
| 10 | **Q1 vs Q4: revenue vs volume conflation in H5** | Low — hypothesis says "order volume peaks" but analysis shows revenue |
| 11 | **IQR capping at 1.5× on `actual_shipping_delay` removes 19.8% of data** | Medium — aggressive capping removes legitimate delay variance |
| 12 | **SQL STDDEV formula numerically unstable** | Low — unlikely to cause issues with this data size |

---

## 18. Improvement Roadmap

### Critical (must fix before sharing with employers)
| Improvement | Why | Effort |
|-------------|-----|--------|
| Move LabelEncoder **after** train-test split | Current ML pipeline has data leakage; invalidates methodology | 30 min |
| Add multiple commits showing iteration | Single commit looks like a dump, not development | 30 min |
| Swap H1 conclusion caveat: "Cannot reject/confirm due to data quality" | Current conclusion contradicts own data quality note | 15 min |

### High Impact
| Improvement | Why | Effort |
|-------------|-----|--------|
| Add baseline model (logistic regression, always-predict-late) | Provides context for XGBoost evaluation | 20 min |
| Add statistical tests (t-test H4, chi-square H1, bootstrap for H3) | Converts opinions into evidence | 1 hr |
| Implement proper time-series CV (TimeSeriesSplit) | Current CV overestimates performance | 30 min |
| Add Perfect Order Rate (OTD × complete %) | Fills gap in supply chain metrics | 15 min |

### Medium Impact
| Improvement | Why | Effort |
|-------------|-----|--------|
| Create `utils.py` with shared functions (save_fig, metrics) | Eliminates 6× copy-pasted code | 1 hr |
| Add target encoding for high-cardinality categoricals | Better ML feature handling | 1 hr |
| Embed interactive map in dashboard HTML | Geographic visualization is core to supply chain | 2 hr |
| Add fill rate calculation per category | Essential inventory metric | 30 min |

### Nice to Have
| Improvement | Why | Effort |
|-------------|-----|--------|
| Time-series decomposition of monthly delays | Shows trend vs seasonality | 1 hr |
| Safety stock calculation from ABC-XYZ | Natural extension of inventory analysis | 2 hr |
| Multi-table SQL schema (normalize to 3NF) | Demonstrates database design skills | 3 hr |
| Dollar-cost estimate for Pareto fix | Makes recommendations actionable | 2 hr |

---

## 19. Final Scorecard

| Category | Score | Notes |
|----------|-------|-------|
| Business Understanding | 7/10 | Strong problem framing, 20 questions |
| Supply Chain Knowledge | 6/10 | OTD, ABC-XYZ, Pareto; missing OTIF, fill rate, safety stock |
| Logistics Analytics | 7/10 | Good route/geographic analysis, no cost data |
| Inventory Analytics | 7/10 | Solid ABC-XYZ, missing reorder points |
| Supplier Analytics | 6/10 | Creative proxy but statistically fragile |
| Data Cleaning | 8/10 | Thorough pipeline, documented decisions |
| EDA | 7/10 | Comprehensive visuals, no scatter/CDF plots |
| Statistics | 4/10 | **No statistical tests anywhere** — biggest gap |
| SQL | 7/10 | Clean queries, single-table limitation |
| Python | 6/10 | Notebook-only, no modules, no tests |
| Machine Learning | 5/10 | Data leakage, near-random result, no baseline |
| Dashboard | 6/10 | Clean HTML, no Power BI, no interactivity |
| Visualization | 8/10 | 35+ plots, consistent style, saved to files |
| Storytelling | 7/10 | Hypothesis-driven, findings documented |
| Documentation | 8/10 | Reports, data dictionary, checklist, limitations |
| GitHub Quality | 5/10 | Single commit, inflated diffs, no setup script |
| Code Quality | 5/10 | No reuse, no tests, no error handling |
| Reproducibility | 6/10 | requirements.txt + notebooks, but original data missing |

**Overall Score:** **115/180 = 64%**

**Portfolio Quality:** **Good** — solid for a junior/entry-level position, demonstrates awareness of the right tools and concepts, with honest documentation of limitations.

**Expected Candidate Level:** **Advanced Junior Data Analyst** (with potential to grow into mid-level in 6-12 months)

**Estimated Interview Probability by Company Type:**
- Startup: **70%** — breadth and initiative are valued
- Mid-size Company: **50%** — would need to fill domain knowledge gaps
- Fortune 500: **30%** — competing against candidates with deeper domain expertise
- Consulting Firm: **40%** — storytelling is strong, technical rigor is weaker
- FAANG/Big Tech: **10%** — not competitive at this level

---

## 20. Final Verdict

**Top Strengths:**
1. **Honest documentation of limitations** — rare in portfolios, highly valued by senior reviewers
2. **Breadth of techniques** — data cleaning, EDA, ABC-XYZ, Pareto, SHAP, composite scoring, geographic visualization, SQL
3. **Professional structure** — notebooks labeled, reports organized, checklist tracked, visuals centralized
4. **Hypothesis-driven approach** — 5 testable hypotheses with clear pass/fail conclusions

**Top Weaknesses:**
1. **No statistical tests** — all conclusions are based on descriptive statistics only
2. **Data leakage in ML pipeline** — encoding before train/test split invalidates the methodology
3. **Single git commit** — no evidence of iterative development
4. **Supplier proxy is fundamentally flawed** — the entire supplier chapter rests on an approximation that doesn't map to real supply chain entities

**Biggest Risks:**
- An interviewer with supply chain domain expertise will challenge the supplier proxy within the first 2 minutes
- The ML model (ROC-AUC 0.525) can be framed as "you built a model that doesn't work" — the candidate must proactively explain non-stationarity
- The missing Power BI dashboard is a letdown if the project description promises it

**Most Impressive Elements:**
- The time-based split decision (rejecting random split despite worse performance) shows integrity
- The Limitations section in README is comprehensive and self-aware
- The SQL scripts were actually executed and validated against real data (rare in portfolios)

**Is it portfolio-ready?** **Yes, with caveats.** Fix the ML data leakage (30 min), add 2-3 more commits showing iteration (30 min), and add statistical tests to at least one hypothesis (1 hr). After those three fixes, it's a strong junior-to-mid-level portfolio.

**Would I hire based on this project?** **Conditionally yes.** I would bring this candidate in for an interview, specifically to probe: (1) depth of understanding behind the techniques, (2) ability to handle critique of the supplier proxy, and (3) whether the candidate can articulate what they'd do differently with more data or more time. If they can handle those questions well, they'd get an offer for a junior analyst role.

---

*End of Review*
