# Data Source Information

## About the Data

This project uses historical trip data from **Divvy Bikes**, Chicago's bike-share system. The data is publicly available and licensed by Lyft Bikes and Scooters, LLC.

---

## Download Instructions

### Step 1: Visit the Data Source
Go to: https://divvy-tripdata.s3.amazonaws.com/index.html

### Step 2: Download These Files
Download the following quarterly files:

| File Name | Period | Approx Size |
|-----------|--------|-------------|
| `Divvy_Trips_2019_Q1.zip` | Jan-Mar 2019 | ~30 MB |
| `Divvy_Trips_2019_Q2.zip` | Apr-Jun 2019 | ~80 MB |
| `Divvy_Trips_2019_Q3.zip` | Jul-Sep 2019 | ~120 MB |
| `Divvy_Trips_2019_Q4.zip` | Oct-Dec 2019 | ~60 MB |
| `Divvy_Trips_2020_Q1.zip` | Jan-Mar 2020 | ~40 MB |

### Step 3: Extract and Place
1. Extract each ZIP file
2. Place the CSV files in the `01_Raw_Data/` folder

---

## Data Schema Notes

The raw data uses **three different schemas** across the quarters:

### Schema A (Q1 2019)
- `trip_id`, `start_time`, `end_time`, `bikeid`, `tripduration`
- `from_station_id`, `from_station_name`, `to_station_id`, `to_station_name`
- `usertype`, `gender`, `birthyear`

### Schema B (Q2-Q4 2019)
- Similar to Schema A with minor naming variations

### Schema C (Q1 2020)
- `ride_id`, `rideable_type`, `started_at`, `ended_at`
- `start_station_name`, `start_station_id`, `end_station_name`, `end_station_id`
- `start_lat`, `start_lng`, `end_lat`, `end_lng`
- `member_casual`

**Note:** The Python cleaning script handles all schema harmonization automatically.

---

## License

Data provided by Lyft Bikes and Scooters, LLC under this license:
https://www.divvybikes.com/data-license-agreement

The data is provided "as is" and can be used for non-commercial purposes.

---

## Why Raw Data Isn't Included

The raw CSV files total ~300+ MB, which exceeds GitHub's file size recommendations. 

**What's included instead:**
- Cleaned/processed data summaries
- All analysis scripts (so you can reproduce the cleaning)
- Documentation of the cleaning process
- Final visualizations and results

To reproduce this analysis from scratch, download the raw data using the instructions above and run the Python notebook in `03_Scripts/Python/`.
