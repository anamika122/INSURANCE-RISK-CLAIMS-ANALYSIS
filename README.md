# Insurance Customer Demographics & Risk Profiling

##  Project Overview

This project analyzes an auto insurance dataset (`insurance_policies_data.csv`) using **MySQL** to extract business insights on customer demographics, vehicle risk factors, claim patterns, and profitability. The analysis helps insurers make **data-driven decisions** in pricing, risk management, and marketing.

##  Objectives

- Analyze customer demographics and their impact on insurance claims
- Identify high-risk customer segments and vehicle characteristics
- Evaluate geographic risk patterns across coverage zones
- Develop insights for premium optimization and risk management
- Profile high-frequency claimants for targeted interventions

## Dataset

**File:** `insurance_policies_data.csv`

**Key Variables:**
- Customer demographics (age, gender, marital status, income)
- Vehicle information (make, model, age, color, usage type)
- Geographic data (coverage zones)
- Claims data (frequency, amounts)
- Policy information

## 🔍 Key Analysis & Findings

### 1. Customer Demographics

#### Age Groups
- **Younger policyholders (<25)**: Higher claim frequency
- **Middle-aged groups (40–60)**: Lower claims but higher claim amounts
- **Senior groups**: Moderate risk profile

#### Gender Analysis
- Claim frequency is **similar across genders**
- Claim amounts vary slightly, but no extreme differences
- No significant bias requiring gender-based pricing adjustments

#### Marital Status & Family Structure
- **Married customers**: Lower claim frequency (more cautious driving behavior)
- **Households with children**: Higher risk profile due to multiple drivers
- **Single policyholders**: Moderate to high risk depending on age

#### Income Segmentation
- **Higher-income households**: Larger claim amounts (expensive vehicles)
- **Lower-income groups**: More frequent but smaller claims
- **Middle-income**: Most balanced risk-return profile

### 2. Vehicle & Usage Risk Analysis

#### Vehicle Age Impact
- **Newer cars (<10 years)**: 
  - Fewer claims but higher severity
  - Advanced safety features reduce accidents
  - Higher repair/replacement costs
- **Older cars (>15 years)**: 
  - Higher frequency of claims
  - Smaller average payouts
  - More maintenance-related issues

#### Usage Patterns
- **Commercial vehicles**: 
  - Significantly higher claim frequency and amounts
  - Higher mileage and exposure risk
- **Private/commute vehicles**: 
  - Lower risk profile
  - More predictable usage patterns
  - Higher profitability margins

#### Vehicle Make/Model Analysis
- **Luxury vehicles**: Dominate top claim amounts
- **Economy cars**: Lower claim severity but higher frequency
- **Sports cars**: Higher risk across all metrics
- Useful for underwriting adjustments and fraud detection

#### Vehicle Color Impact
- Minimal overall impact on claims
- Monitoring trends can assist in fraud detection
- White and silver cars show slightly lower claim rates

### 3. Geographic Risk Analysis (Coverage Zones)

#### Urban vs Rural Patterns
- **Highly Urban areas**: 
  - Higher claim frequency due to traffic density
  - More fender-benders and theft
  - Higher repair costs
- **Rural areas**: 
  - Fewer claims overall
  - Slightly higher severity when accidents occur
  - Weather-related risks more prominent

### 4. Profitability & Premium Strategy

#### Most Profitable Segments
- **Low-risk, high-income customers**:
  - Mid-aged professionals (35-55)
  - Private car owners in suburban zones
  - Married with stable employment
  - Premium vehicles with good safety records

#### High-Risk Segments Requiring Premium Adjustments
- Young drivers in urban areas
- Commercial vehicle operators
- High-mileage commuters
- Owners of high-performance vehicles

#### Premium Optimization Formula
```
Optimal Premium = Expected Claim Amount + Risk Margin + Expense Load + Profit Margin
```

### 5. High-Frequency Claimants Analysis

#### Top 5% Claimants Profile
- **Identification**: Customers with highest claim frequency using `PERCENT_RANK()` function
- **Impact**: Disproportionately increase loss ratios
- **Characteristics**:
  - Often young or elderly drivers
  - Urban location bias
  - Commercial vehicle usage
  - Multiple violations/claims history

#### Recommended Actions
- **Premium loading** for high-frequency claimants
- **Stricter underwriting rules** for renewals
- **Risk mitigation programs**:
  - Driver safety courses
  - Telematics-based monitoring
  - Defensive driving incentives

## 🛠️ Tools & Technologies

- **Database**: MySQL
- **Analysis Techniques**:
  - SQL Grouping and Aggregations
  - Window Functions (`PERCENT_RANK`, `ROW_NUMBER`)
  - Customer segmentation analysis
  - Risk profiling algorithms
  - Profitability calculations

## 📈 Business Impact & Value

### Strategic Benefits
- **Optimized Pricing**: Risk-based premium calculations by customer segment
- **Targeted Marketing**: Focus on safe, profitable customer demographics
- **Improved Risk Selection**: Data-driven underwriting decisions
- **Portfolio Management**: Better understanding of risk concentration

### Operational Improvements
- **Fraud Detection**: Pattern recognition for suspicious claims
- **Customer Retention**: Targeted programs for low-risk, high-value customers
- **Risk Mitigation**: Proactive interventions for high-risk segments
- **Regulatory Compliance**: Fair and justified pricing methodologies

## 📁 Repository Structure

```
insurance-risk-analysis/
│
├── data/
│   └── insurance_policies_data.csv
│
├── sql_queries/
│   ├── demographic_analysis.sql
│   ├── vehicle_risk_analysis.sql
│   ├── geographic_analysis.sql
│   ├── profitability_analysis.sql
│   └── high_frequency_claimants.sql
│
├── results/
│   ├── customer_segments.csv
│   ├── risk_profiles.csv
│   └── profitability_metrics.csv
│
└── README.md
```

## 🚀 Getting Started

### Prerequisites
- MySQL Server 8.0 or higher
- MySQL Workbench (recommended for visualization)
- Basic understanding of SQL and insurance concepts

### Setup Instructions
1. Clone this repository
2. Import `insurance_policies_data.csv` into your MySQL database
3. Review results and adapt queries for your specific use case

### Running the Analysis
```sql
-- Example: Analyze customer demographics by age group
select case 
when timestampdiff (year,BirthDate,curdate()) < 25 then '25'
when timestampdiff (year,BirthDate, curdate()) between 25 and 40 then '25-40'
when timestampdiff  (year,BirthDate, curdate()) between 40 and 60 then '40-60'
else '60+'
end as age_group,
count(*) as policyholders,
avg(`Claim Freq`) as avg_claim_fre,
round(avg(`Claim Amount`),2) as avg_claim_amount
from insurance_policies_data
group by age_group
```

## Key SQL Queries

- **Customer Segmentation**: Demographic analysis with risk scoring
- **Vehicle Risk Profiling**: Make, model, and age-based risk assessment
- **Geographic Analysis**: Zone-wise claim patterns and profitability
- **High-Frequency Identification**: Top 5% claimant detection using window functions
- **Profitability Analysis**: Premium vs. claim ratio calculations

## Key Learnings

- **Data-driven insights** significantly improve insurance decision-making
- **Customer segmentation** reveals hidden patterns in risk behavior
- **Geographic factors** play a crucial role in claim frequency and severity
- **Vehicle characteristics** are strong predictors of claim patterns
- **High-frequency claimants** require special attention and intervention





⭐ **Star this repository if you found it helpful!**
