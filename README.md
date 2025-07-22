# 🧵 Design of Experiments: Additive Manufacturing (PLA Tensile Strength)

The project explores how key 3D printing parameters—specifically infill percentage and print speed—impact the tensile strength of PLA parts produced via additive manufacturing.

---

## 🔍 Problem Statement

This study investigates how **infill percentage** and **print speed** affect the **tensile strength** of PLA parts manufactured using 3D printing. A full factorial experiment was designed and executed with the following setup:

- **Factors**:
  - **Infill Percentage**: 30%, 80%
  - **Print Speed**: 1500, 2000, 2500 mm/min

- **Response Variable**: Tensile strength (MPa)

---

## 🧪 Experimental Design

- **Design Type**: Full factorial (2 × 3)
- **Replications**: 3 per treatment combination
- **Total Samples**: 18 ASTM D638 Type V dogbone specimens  
- **Statistical Analysis**: Conducted using `PROC GLM` in SAS

| Treatment # | Infill % | Print Speed (mm/min) |
|-------------|----------|----------------------|
| 1           | 30       | 1500                 |
| 2           | 30       | 2000                 |
| 3           | 30       | 2500                 |
| 4           | 80       | 1500                 |
| 5           | 80       | 2000                 |
| 6           | 80       | 2500                 |

---

## ⚙️ Calibration & Data Transformation

To satisfy ANOVA assumptions, we evaluated different response transformations:

- **Transformations Tried**: `log`, `sqrt`, `inverse`
- **Final Choice**: **Inverse transformation**
  - Effectively addressed heteroscedasticity and non-normality

---
## 📌 Key Findings

### Main Effects (Tukey Pairwise Comparisons)
- The mean max. stress at **30% infill** is significantly different from that at **80% infill**.
- For **print speed**, the mean max. stress at **1500 mm/min** and **2000 mm/min** are statistically similar.
- The mean max. stress at **2000 mm/min** and **2500 mm/min** are also similar.
- However, the mean max. stress at **1500 mm/min** and **2500 mm/min** differ significantly.

### Pre-Selected Contrasts (Bonferroni Method)
- Mean max. stress when print speed is **less than 2500 mm/min** differs significantly from when it is **2500 mm/min**.
- Mean max. stress when print speed is **greater than 1500 mm/min** differs significantly from when it is **1500 mm/min**.
- This difference between print speeds (<2500 vs. 2500 mm/min) is consistent across both infill levels (30% and 80%).

---
## Important Notice

The code in this repository is proprietary and protected by copyright law. Unauthorized copying, distribution, or use of this code is strictly prohibited. By accessing this repository, you agree to the following terms:

- **Do Not Copy:** You are not permitted to copy any part of this code for any purpose.
- **Do Not Distribute:** You are not permitted to distribute this code, in whole or in part, to any third party.
- **Do Not Use:** You are not permitted to use this code, in whole or in part, for any purpose without explicit permission from the owner.

Any violation of these terms will be subject to legal action. If you have any questions or require permission, please contact the repository owner.

Thank you for your cooperation.
