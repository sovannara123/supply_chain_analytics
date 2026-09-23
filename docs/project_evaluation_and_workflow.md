# Supply Chain Analytics: Project Evaluation and Workflow

## 1. Project Flaws & Technical Debt

Based on the architectural review of the `sql/` directory, the following critical flaws must be addressed before the project can be considered production-ready.

### 1.1 Inconsistent SQL Dialects & Missing Tables
- **Issue**: `00_create_table.sql` and `04_data_quality_check.sql` are written for **PostgreSQL** (using `NUMERIC`, `jsonb_agg`, etc.). However, `01_supply_chain_kpis.sql` and `02_shipping_and_routes.sql` explicitly state they use **SQLite** syntax.
- **Missing Dependency**: Scripts 01 and 02 query a table named `orders` which is never created. Script 00 creates `datacosupplychaindataset` and a view `analysis_ready`.
- **Resolution**: Standardize on PostgreSQL. Rename the `analysis_ready` view to `orders` (or update downstream scripts to point to `analysis_ready`).

### 1.2 Data Security and PII Exposure
- **Issue**: The raw ingestion table (`datacosupplychaindataset`) loads sensitive plaintext passwords (`customer_password`) and direct PII (`customer_email`, `customer_fname`, `customer_lname`). 
- **Resolution**: Passwords must not be loaded into the analytical warehouse. PII should be masked or separated into a secured `dim_customer` dimension table with restricted role-based access.

### 1.3 Missing Workflow Steps
- **Issue**: The SQL scripts jump from `02_shipping_and_routes.sql` to `04_data_quality_check.sql`. The sequence is missing a `03` script.
- **Resolution**: Audit the pipeline to determine if analytical views for inventory, customers, or products were accidentally omitted.

### 1.4 Denormalization and Lack of Data Modeling
- **Issue**: The entire dataset is loaded into a massive, 53-column flat table. Querying flat files is inefficient and violates standard data warehousing principles.
- **Resolution**: Implement a **Star Schema** architecture (see the Target Workflow below). 

### 1.5 Unportable Data Quality Checks
- **Issue**: The data quality script uses Postgres-specific JSON aggregation. It lacks alerting mechanisms and cannot be ported if the backend changes to SQLite or another engine.
- **Resolution**: Integrate data quality checks into a pipeline orchestrator (like dbt or Airflow) rather than relying on raw SQL scripts.

---

## 2. Target Data Lifecycle & Workflow

To mature this project from raw SQL scripts to an enterprise-grade analytics pipeline, we will adopt the following Data Engineering lifecycle.

### Phase 1: Ingestion (Raw Layer / Bronze)
- **Action**: Load the `DataCoSupplyChainDataset.csv` into a staging schema.
- **Process**: 
  - Drop highly sensitive columns (e.g., `customer_password`) during the ETL extract phase.
  - Load raw data into a `raw_supply_chain` staging table using a Python script (via `src/` directory) or native `\copy`.
- **Data Quality**: Run initial structural checks (row counts, null thresholds).

### Phase 2: Transformation & Modeling (Curated Layer / Silver)
- **Action**: Normalize the flat data into a Star Schema using PostgreSQL or dbt.
- **Dimension Tables**:
  - `dim_customer`: `customer_id`, `segment`, masked PII, location data.
  - `dim_product`: `product_card_id`, `category`, `department`, `price`.
  - `dim_location`: Geographic lookup for routing and delivery tracking.
- **Fact Table**:
  - `fact_order_items`: Granular line-item data (`order_id`, `order_item_id`, `sales`, `discount`, dates, keys to dimensions).

### Phase 3: Analytics & Aggregation (Business Layer / Gold)
- **Action**: Create materialized views and business-level logic.
- **Views**:
  - `v_executive_kpis`: Consolidates OTD (On-Time Delivery) rate, revenue, and profit.
  - `v_shipping_performance`: Evaluates shipping modes and delay rates.
- **Execution**: This is where scripts `01` and `02` will be refactored to query the Star Schema instead of raw flat tables.

### Phase 4: Data Quality & Testing
- **Action**: Automated validation of the gold layer.
- **Checks**: 
  - Duplicate anomaly detection.
  - Temporal validation (e.g., `shipping_date` cannot be before `order_date`).
  - Constraint validation (e.g., `sales` >= 0).

### Phase 5: Reporting & Visualization
- **Action**: Connect Business Intelligence tools (Tableau, PowerBI, or open-source alternatives) to the Gold layer.
- **Workflow**: Dashboards query the pre-aggregated views to ensure sub-second response times for business stakeholders.
