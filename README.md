# SMBG Trend and Cyclic Analysis

This project analyzes self-monitoring blood glucose (SMBG) data from a diabetic patient, collected three times a day over the course of a month. The objective is to decompose the signal into a long-term trend and a daily cyclic component using data smoothing and curve fitting techniques.

## Project Description

The analysis is based on the following model:
```matlab
y(t) = m(t) + g(t) + v(t)
```

Where:
- `m(t)` is the monthly trend
- `g(t)` is the daily cyclic component
- `v(t)` is the measurement noise

The main steps of the analysis are:
1. **Monthly Trend Estimation**  
   Implemented via exponential kernel smoothing.
2. **Daily Cyclic Pattern Extraction**  
   Performed using polynomial regression (degree 2 and 3) on daily measurements, including an additional point from the adjacent day.
3. **Variability Band Computation**  
   5th and 95th percentiles across daily realizations are used to estimate confidence bands.

## Files
- `main_script.m`: Main script performing the full analysis.
- `kernelExp.m`: Helper function to compute exponential kernel weights.

## Requirements
- MATLAB
- Basic signal processing toolbox
