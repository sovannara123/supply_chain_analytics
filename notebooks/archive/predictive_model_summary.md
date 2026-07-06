# Predictive Late Delivery Risk — Summary

**Notebook:** `notebooks/06_predictive_late_delivery.ipynb`

---

## Model Performance

| Metric | Default Params | After Tuning |
|--------|---------------|--------------|
| **Test ROC-AUC** | 0.537 | **0.525** |
| 5-Fold CV ROC-AUC | 0.708 (±0.008) | 0.835 (±0.010) |
| Accuracy | 53% | 52% |
| Precision (Late) | 0.574 | 0.564 |
| Recall (Late) | 0.556 | 0.556 |
| F1-Score (Late) | 0.565 | 0.560 |

**Best params found:** `subsample=0.8, n_estimators=200, max_depth=8, learning_rate=0.1, colsample_bytree=1.0`

**Important:** The large gap between CV (0.835) and test (0.525) confirms **non-stationarity** — patterns that existed in the training period did not persist into the test period. This is common in supply chain data where operational changes, seasonal shifts, or external factors alter delivery dynamics. Tuning actually made overfitting worse.

## Feature Engineering

- **32 features** used from the cleaned dataset (62 → 32 after removing targets, IDs, leaky post-hoc features, date columns, and `order_status`)
- **13 categorical features** label-encoded
- Leaky/unknown-at-prediction-time features removed: `actual_shipping_delay`, `days_for_shipping_real`, `days_for_shipment_scheduled`, `order_to_shipping_hours`, `is_early_or_ontime`, `order_status`
- **Time-based split** (80/20 by date) instead of random split to prevent future leakage

## Top 5 Predictive Features (XGBoost Importance)

| Rank | Feature | Importance | Interpretation |
|------|---------|-----------|----------------|
| 1 | `type` | 0.087 | Transaction type (DEBIT/TRANSFER/PAYMENT) |
| 2 | `order_hour` | 0.048 | Time of day order was placed |
| 3 | `order_city` | 0.043 | Origin city geography |
| 4 | `order_state` | 0.042 | Origin state/region |
| 5 | `longitude` | 0.042 | Geographic coordinate |

## Driver Analysis (F1 / F2 / F3)

| Question | Answer |
|----------|--------|
| **F1:** What factors most predict late delivery? | None dominate — all features have low importance (<0.09); `type` edges out slightly |
| **F2:** Shipping mode vs geography — bigger impact? | **Geography** (0.082) has larger impact than shipping mode (0.0) |
| **F3:** Order size and delays correlation? | Order quantity is **not a significant predictor** |

## Key Takeaways

1. **Model cannot reliably predict late delivery** with this feature set — ROC-AUC 0.537 is barely above random
2. **Future delivery outcomes depend on time-varying factors** not captured in static order features (e.g., seasonal logistics capacity, weather, port congestion)
3. **Geography matters more than shipping mode** — consistent with earlier EDA
4. **No single feature dominates** — all importances are low, suggesting the signal is weak or spread across many factors
5. **For production:** would need live tracking data, real-time logistics feeds, and time-aware features (e.g., rolling averages) to improve performance

## Limitations Acknowledged

- `order_status` was removed as leaky (not known at prediction time)
- Time-based split revealed non-stationarity — future work should use rolling-window validation
- SHAP waterfall shows near-50% probability for most predictions, confirming model uncertainty

## Visual Assets

| File | Description |
|------|-------------|
| `visuals/27_model_performance.png` | ROC curve + confusion matrix |
| `visuals/28_feature_importance.png` | XGBoost top 15 feature importance |
| `visuals/29_shap_summary.png` | SHAP summary dot plot |
| `visuals/30_shap_bar.png` | Mean |SHAP| bar chart |
| `visuals/31_shap_dependence.png` | SHAP dependence plots (top 5 features) |
| `visuals/32_shap_waterfall.png` | Waterfall explanation for a single prediction |
