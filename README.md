# 🚗 Uber Trips Data Analysis | SQL & Power BI

## 📌 Project Overview

This project analyzes **50,000 Uber trip records** to understand trip performance, revenue trends, cancellations, no-shows, and city-level performance.

Using **SQL Server** and **Power BI**, I explored the dataset, analyzed key business metrics, and developed insights that could help improve operational efficiency and support data-driven decision-making.

## 🎯 Business Objectives

- Analyze overall trip performance and trip status distribution.
- Measure revenue generated from completed trips.
- Investigate cancelled trips and no-show patterns.
- Compare trip volume and revenue across cities.
- Identify peak time slots and daily trends.
- Translate analytical findings into actionable business recommendations.

## 🛠️ Tools & Technologies

- **SQL Server:** Data querying, aggregation, and analysis.
- **Power BI:** Interactive dashboard development and data visualization.
- **DAX:** KPI calculations and business metrics.
- **Data Analysis:** Trend analysis, performance comparison, and business insight generation.

## 📊 Key Metrics

| KPI | Result |
|---|---:|
| Total Trips | 50,000 |
| Completed Trips | 42,540 |
| Cancelled Trips | 4,984 |
| No-Show Trips | 2,476 |
| Completion Rate | 85.08% |
| Cancellation Rate | 9.97% |
| No-Show Rate | 4.95% |
| Reported Revenue | ~$680K |

*Note: Revenue figures should be interpreted according to the dataset's financial definitions. The reported revenue requires validation against completed trips and the relevant business rules.*

## 🔍 Analysis Performed

### 1. Trip Status Analysis
- Evaluated completed, cancelled, and no-show trips.
- Calculated the percentage distribution of each status.
- Identified opportunities to investigate unsuccessful trips.

### 2. Revenue Analysis
- Examined revenue patterns across cities and time slots.
- Distinguished revenue from completed trips from amounts associated with cancelled trips.
- Flagged cancelled-trip amounts for further validation before classifying them as actual revenue or financial loss.

### 3. City Performance
- Compared trip volume and revenue across different cities.
- Identified Boston as a leading city in the initial analysis.
- Explored differences in operational performance between locations.

### 4. Time-Based Analysis
- Compared trip demand and revenue across time slots.
- Analyzed performance across days of the week.
- Explored how demand patterns could inform driver allocation and shift planning.

### 5. Driver Performance
- Explored driver-level trip activity and revenue metrics.
- Compared driver performance to identify patterns worth investigating.
- Considered the importance of validating aggregations and report filters before drawing conclusions.

## 💡 Business Recommendations

Based on the initial findings, the following actions could be investigated:

- **Improve driver allocation:** Review driver availability in high-demand cities and time slots.
- **Investigate cancellations:** Collect cancellation reasons to distinguish between rider-related and driver-related issues.
- **Review no-show patterns:** Identify recurring cases and evaluate appropriate operational policies.
- **Optimize driver shifts:** Align staffing with observed demand patterns.
- **Evaluate driver incentives:** Investigate whether targeted incentives could improve coverage during busy periods.
- **Validate financial metrics:** Confirm the meaning of cancelled-trip amounts before using them in revenue or loss calculations.

These recommendations should be tested against validated data before implementation.

## 📈 Dashboard

The Power BI dashboard explores:

- Trip status distribution
- Revenue performance
- City-level comparisons
- Time-slot trends
- Daily trip patterns
- Driver-level performance

**Dashboard screenshots:** Add your exported dashboard images here to make the project easier to explore.

Example:

```markdown
![Uber Trips Dashboard](images/uber-trips-dashboard.png)
```

## 📁 Repository Structure

```text
uber-trips-data-analysis/
│
├── data/
│   └── uber_trips_dataset_50k.csv
│
├── sql/
│   └── uber_trips_analysis.sql
│
├── powerbi/
│   └── uber_trips_dashboard.pbix
│
├── images/
│   └── uber-trips-dashboard.png
│
└── README.md
```

*Adjust the file names and folders to match the files actually included in your repository. Do not upload the dataset if you do not have permission to share it.*

## 🧠 Key Learning

This project strengthened my ability to analyze operational data, work with business KPIs, investigate data quality and financial definitions, and communicate findings through interactive dashboards.

One of the main challenges was interpreting the monetary amounts associated with cancelled trips. This reinforced an important principle of data analysis: **understand and validate what a number represents before using it to draw conclusions or make business decisions.**

## 👨‍💻 Author

**Abdelrahman Hani Essa**

Aspiring Data Analyst | SQL | Power BI | Python | Excel | Tableau

---

## 🏷️ Tags

`Data Analysis` `SQL Server` `Power BI` `DAX` `Business Intelligence` `Data Visualization` `Uber` `Portfolio Project`
