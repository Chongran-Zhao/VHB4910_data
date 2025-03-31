# Experimental Data on VHB4910

![specimen](figures/specimen.jpg)
---

## Introduction
This repository contains experimental data on VHB4910, a viscoelastic material. The data includes results from various uniaxial loading-unloading tests performed at different displacement rates and stretch ratios. This data is valuable for understanding the material's deformation behavior and for validating computational models.

## Uniaxial Loading-Unloading Tests
- **Maximum Displacements**: $\Delta_{\text{max}} = \{4,8,12,16\} \text{cm}$.
  - **Nominal Stretch Ratios**: $\lambda = \{1.5,2.0,2.5,3.0\}$.
    - *Note*: For $L_0 = 8 \text{cm}$, $\lambda = 1 + \Delta/L_0$.
    - *Anomaly Resolved*: Updated stretch ratios align with $\Delta/L_0$.

- **Strain Rate Modulation**:
  - **Displacement Rates**: $\dot{\Delta} = \{0.08,0.24,0.4\} \text{cm/s}$.
  - **Normalized Strain Rates**: $\dot{\lambda} = \dot{\Delta}/L_0 = \{0.01,0.03,0.05\} \text{s}^{-1}$.
    - *Validation*: Confirms undeformed length $L_0 = 8\text{cm}$.
---
## Single-step Relaxation Tests
- **Relaxation Displacements**: $\Delta_{\text{max}} = \{4,8,12,16,20,24,32,40\} \text{cm}$.
  - **Nominal Stretch Ratios**: $\lambda = \{1.5,2.0,2.5,3.0,3.5,4.0,5.0,6.0\}$.
    - *Note*: For $L_0 = 8 \text{cm}$, $\lambda = 1 + \Delta/L_0$.
    - *Anomaly Resolved*: Updated stretch ratios align with $\Delta/L_0$.
- **Strain Rate Modulation**:
  - **Displacement Rates**: $\dot{\Delta} = \{2\} \text{cm/s}$.
  - **Normalized Strain Rates**: $\dot{\lambda} = \dot{\Delta}/L_0 = 0.25 \text{s}^{-1}$.
    - *Validation*: Confirms undeformed length $L_0 = 8\text{cm}$.
---
### 3. ​**Dataset Structure**  
```plaintext
VHB4910_data/  
├── unaxial-loading-unloading/  
│   ├── original_data/  
│   │   ├── 0d01_1d5.csv  
│   │   ├── 0d01_2d0.csv
│   │   ├── 0d01_2d5.csv  
│   │   ├── 0d01_3d0.csv
│   │   ├── 0d03_1d5_1.csv  
│   │   ├── 0d03_1d5_2.csv
│   │   ├── 0d03_2d0_1.csv  
│   │   ├── 0d03_2d0_2.csv
│   │   ├── 0d03_2d5.csv  
│   │   ├── 0d03_3d0.csv
│   │   ├── 0d05_1d5_1.csv  
│   │   ├── 0d05_1d5_2.csv
│   │   ├── 0d05_2d0.csv
│   │   ├── 0d05_2d5_1.csv
│   │   ├── 0d05_2d5_2.csv
│   │   └── 0d05_3d0.csv
│   ├── time_strain_stress/  
│   │   ├── 0d01_1d5.xlsx
│   │   ├── 0d01_2d0.xlsx  
│   │   ├── 0d01_2d5.xlsx  
│   │   ├── 0d01_3d0.xlsx  
│   │   ├── 0d03_1d5.xlsx
│   │   ├── 0d03_2d0.xlsx  
│   │   ├── 0d03_2d5.xlsx  
│   │   ├── 0d03_3d0.xlsx
│   │   ├── 0d05_1d5.xlsx
│   │   ├── 0d05_2d0.xlsx  
│   │   ├── 0d05_2d5.xlsx  
│   │   └── 0d05_3d0.xlsx  
│   └── smooth.m  
│
├── single-step-relaxation/  
│   ├── original_data/  
│   │   ├── 1d5.csv  
│   │   ├── 2d0.csv
│   │   ├── 2d5.csv  
│   │   ├── 3d0.csv
│   │   ├── 3d5.csv  
│   │   ├── 4d0.csv
│   │   ├── 5d0.csv
│   │   └── 6d0.csv
│   ├── time_strain_stress/  
│   │   ├── 1d5.xlsx  
│   │   ├── 2d0.xlsx
│   │   ├── 2d5.xlsx  
│   │   ├── 3d0.xlsx
│   │   ├── 3d5.xlsx  
│   │   ├── 4d0.xlsx
│   │   ├── 5d0.xlsx
│   │   └── 6d0.xlsx
│   └── smooth.m  
├── figures/  
│   └── specimen.jpg
├── .gitignore
├── loading_unloading_report.pdf
└── README.md  
