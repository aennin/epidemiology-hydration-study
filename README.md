# Sports Drink vs Water: Post-Exercise Hydration Recovery Study

## Project Overview
A simulated randomized controlled trial investigating whether carbohydrate-electrolyte sports drinks lead to better post-exercise rehydration compared to plain water in healthy adults.

### Research Question
"In healthy adults undergoing moderate-intensity exercise, does rehydration with a sports drink result in better recovery of hydration status compared to water?"

### Key Findings
- **Primary Outcome**: Sports drinks significantly improved urine specific gravity (USG) recovery (β = -0.008, p < 0.001)
- **Weight Recovery**: 3.25× greater odds of complete weight recovery with sports drinks
- **Thirst Perception**: 97.7% reduction in thirst scores with sports drinks
- **Tolerability**: No significant difference in side effects between groups

##  Methods
- **Design**: Simulated RCT with 100 participants (50 per group)
- **Analysis**: Multiple regression approaches (linear, beta, logistic, ordinal)
- **Software**: R with comprehensive model diagnostics

## Statistical Models
1. **Primary**: Linear regression for urine specific gravity
2. **Secondary**: 
   - Beta regression for weight recovery percentage
   - Logistic regression for tolerability
   - Ordinal logistic regression for thirst scores

## 🚀 Quick Start
```r
# Run data simulation
source("analysis/data_codes.R")

# Run complete analysis
source("analysis/statistical_analysis.R")
```

## Skills Demonstrated
- Clinical trial design and simulation
- Multiple regression techniques
- Statistical model diagnostics
- Epidemiological research methods
- R programming and data visualization
- Academic writing and documentation

