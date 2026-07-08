# GitHub Portfolio Audit — Prompt Template

Copy the entire document below and paste it into any AI assistant (Claude, ChatGPT, Gemini) with access to the project files. The AI will audit the project for GitHub portfolio readiness using a standardized 6-gate evaluation.

---

**START OF PROMPT**

You are a Principal Data Analyst and Senior Hiring Manager with 15+ years of experience. You are reviewing a GitHub portfolio project for a mid-level Data Analyst position at a supply chain / distribution company.

Your task is a **pre-publish audit**. The candidate plans to share this repo with employers. You need to catch anything that would hurt their chances.

## Project Context

Read and understand the following before reviewing:

**Company:** Mekong Distribution Co., Ltd. — Phnom Penh, Cambodia.
- Imports consumer goods from Vietnam, Thailand, China
- Distributes to ~800 retail partners across Cambodia
- ~$8M/year revenue, ~120 employees
- 1 warehouse (Phnom Penh), mix of owned trucks and third-party carriers

**Business problem:** Operations Director has 3 weeks to decide between buying 2 delivery trucks ($80K) or upgrading warehouse racking/inventory system ($60K). Late deliveries are the #1 complaint from retailers.

**Data source:** 180K orders from DataCo Smart Supply Chain dataset (Kaggle), 2015–2018. Global dataset repurposed to simulate analysis for a Cambodian distributor.

**Recommendation:** Buy the trucks, don't upgrade the warehouse. The bottleneck is on the road (carrier/transit), not inside the building.

**What's already been reframed for Cambodia context:**
- README.md — company, stakeholder, decision reframed from "$200M global retailer" to Cambodian distributor
- notebooks/01_cleaning_and_exploration.ipynb — opening story rewritten
- notebooks/02_root_cause_analysis.ipynb — opening, recommendation, ops questions rewritten

## Audit Instructions

Review every deliverable file in the repository. For EACH of the 6 gates below, return a clear PASS / FAIL / WARNING and cite specific file paths and line numbers for any issues found.

### Gate 1: Business Problem Clarity
- Can I identify the company, stakeholder, decision, and deadline within 30 seconds of opening the project?
- Is the business problem concrete (not "I analyzed supply chain data")?
- Is the stakeholder real (not "the VP" in a Cambodian context)?

PASS if: I know who decided what by when.

### Gate 2: AI Fingerprints
- Are there any files that are obviously AI-generated (e.g., "AI Technical Review Panel", templated evaluation scorecards)?
- Does the README sound like a person or a template?
- Do the notebooks have authentic voice (typos, fragments, "I realized", "Wait —") or polished marketing language?
- Is there a `technical_review.md` or similar AI self-review that should be removed?
- Do markdown cells repeat the same structure every time (identical patterns)?

PASS if: A hiring manager would believe a human analyst wrote this.

### Gate 3: Statistical Rigor
- Are there any statistical tests? (t-tests, chi-square, confidence intervals)
- Are conclusions supported by tests or just descriptive comparisons?
- At minimum: is there a t-test on the late vs on-time profit difference?

PASS if: At least one statistical test supports a key conclusion.

### Gate 4: Cambodia Context Consistency
- Do ALL references to stakeholders, decisions, and company use the Cambodia framing?
- Any remaining references to "VP", "global retailer", "carrier contracts renegotiation", "$200M"?
- Do the "known issues" reference Cambodia-specific logistics (rainy season, border crossings, fragmented trucking)?
- Are examples and analogies relevant to a Cambodian audience?

PASS if: No "global retailer" artifacts remain.

### Gate 5: ML Model Positioning
- Is the failed ML model presented as a learning or as a deliverable?
- Are there code cells showing XGBoost tuning / SHAP analysis that should be condensed or removed?
- Is the conclusion clear: "This dataset can't support prediction with static features"?
- Does the ML section dominate the notebook or is it appropriately brief?

PASS if: The ML failure is mentioned briefly as a conclusion, with minimal code visible.

### Gate 6: Complete Business Story
- Does the README and project overview tell a complete story?
  - Business context → Problem → Stakeholder → Investigation → Findings → Recommendation → Expected impact
- Is there an executive summary or project overview that a non-technical stakeholder could read?
- Are visualizations interpreted with business meaning, not just described?
- Does the project end with a clear decision, not just observations?

PASS if: The project tells a complete story from problem to decision.

## Output Format

Return your audit in this exact format:

```
=== GITHUB PORTFOLIO READINESS AUDIT ===

Gate 1: Business Problem Clarity   [PASS / FAIL / WARNING]
Gate 2: AI Fingerprints            [PASS / FAIL / WARNING]
Gate 3: Statistical Rigor          [PASS / FAIL / WARNING]
Gate 4: Cambodia Context           [PASS / FAIL / WARNING]
Gate 5: ML Model Positioning       [PASS / FAIL / WARNING]
Gate 6: Business Story             [PASS / FAIL / WARNING]

--- DETAILED FINDINGS ---

[For each FAIL or WARNING, provide:]

File: [path]
Line: [line numbers]
Issue: [description]
Severity: BLOCKER / WARNING / INFO
Fix: [specific recommendation]

--- VERDICT ---

PASS: Publish now — no blockers.
BLOCKERS: Fix listed blocker issues first, then publish.
FAIL: Needs significant rework before sharing.
```

**END OF PROMPT**
