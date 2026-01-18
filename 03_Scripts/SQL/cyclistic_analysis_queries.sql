-- ============================================
-- QUERY 1: Overall Dataset Summary
-- ============================================

USE cyclistic_db;

SELECT 
    COUNT(*) as total_rides,
    COUNT(DISTINCT member_type) as member_types,
    MIN(started_at) as earliest_ride,
    MAX(ended_at) as latest_ride,
    DATEDIFF(MAX(ended_at), MIN(started_at)) as days_covered
FROM rides;

-- ============================================
-- QUERY 2: Rides by Member Type
-- ============================================

SELECT 
    member_type,
    COUNT(*) as total_rides,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM rides), 2) as percentage,
    ROUND(AVG(ride_length_min), 2) as avg_duration_min,
    ROUND(MIN(ride_length_min), 2) as min_duration_min,
    ROUND(MAX(ride_length_min), 2) as max_duration_min
FROM rides
GROUP BY member_type
ORDER BY total_rides DESC;

-- ============================================
-- QUERY 3: Usage Patterns by Day of Week
-- ============================================

SELECT 
    day_name,
    day_of_week,
    SUM(CASE WHEN member_type = 'Member' THEN 1 ELSE 0 END) as member_rides,
    SUM(CASE WHEN member_type = 'Casual' THEN 1 ELSE 0 END) as casual_rides,
    COUNT(*) as total_rides,
    ROUND(AVG(CASE WHEN member_type = 'Member' THEN ride_length_min END), 2) as avg_member_duration,
    ROUND(AVG(CASE WHEN member_type = 'Casual' THEN ride_length_min END), 2) as avg_casual_duration
FROM rides
GROUP BY day_name, day_of_week
ORDER BY day_of_week;

-- ============================================
-- QUERY 4: Seasonal Usage by Quarter
-- ============================================

SELECT 
    quarter,
    SUM(CASE WHEN member_type = 'Member' THEN 1 ELSE 0 END) as member_rides,
    SUM(CASE WHEN member_type = 'Casual' THEN 1 ELSE 0 END) as casual_rides,
    COUNT(*) as total_rides,
    ROUND(SUM(CASE WHEN member_type = 'Casual' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as casual_percentage
FROM rides
GROUP BY quarter
ORDER BY quarter;

-- ============================================
-- QUERY 5: Hourly Usage Patterns (Rush Hour)
-- ============================================

SELECT 
    hour,
    SUM(CASE WHEN member_type = 'Member' THEN 1 ELSE 0 END) as member_rides,
    SUM(CASE WHEN member_type = 'Casual' THEN 1 ELSE 0 END) as casual_rides,
    COUNT(*) as total_rides
FROM rides
GROUP BY hour
ORDER BY hour;

-- ============================================
-- QUERY 6: Most Popular Start Stations
-- ============================================

SELECT 
    start_station_name,
    COUNT(*) as total_rides,
    SUM(CASE WHEN member_type = 'Member' THEN 1 ELSE 0 END) as member_rides,
    SUM(CASE WHEN member_type = 'Casual' THEN 1 ELSE 0 END) as casual_rides,
    ROUND(SUM(CASE WHEN member_type = 'Casual' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as casual_percentage
FROM rides
WHERE start_station_name IS NOT NULL
GROUP BY start_station_name
ORDER BY total_rides DESC
LIMIT 10;

-- ============================================
-- QUERY 7: Average Duration by Member Type and Day
-- ============================================

SELECT 
    day_name,
    member_type,
    COUNT(*) as rides,
    ROUND(AVG(ride_length_min), 2) as avg_duration_min,
    ROUND(MIN(ride_length_min), 2) as min_duration,
    ROUND(MAX(ride_length_min), 2) as max_duration
FROM rides
GROUP BY day_name, member_type
ORDER BY 
    FIELD(day_name, 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
    member_type;
    
    -- ============================================
-- QUERY 8: Monthly Usage Trends
-- ============================================

SELECT 
    year,
    month,
    CASE month
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END as month_name,
    SUM(CASE WHEN member_type = 'Member' THEN 1 ELSE 0 END) as member_rides,
    SUM(CASE WHEN member_type = 'Casual' THEN 1 ELSE 0 END) as casual_rides,
    COUNT(*) as total_rides
FROM rides
GROUP BY year, month
ORDER BY year, month;

-- ============================================
-- QUERY 9: Weekend vs Weekday Analysis
-- ============================================

SELECT 
    CASE 
        WHEN day_name IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END as day_type,
    member_type,
    COUNT(*) as total_rides,
    ROUND(AVG(ride_length_min), 2) as avg_duration_min,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY member_type), 2) as pct_of_member_type
FROM rides
GROUP BY 
    CASE 
        WHEN day_name IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END,
    member_type
ORDER BY member_type, day_type;

-- ============================================
-- QUERY 10: Casual Riders - Conversion Potential
-- ============================================

-- Casual rides on weekends (prime conversion targets)
SELECT 
    'Weekend Casual Riders' as segment,
    COUNT(*) as rides,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM rides WHERE member_type = 'Casual'), 2) as pct_of_casual_rides,
    ROUND(AVG(ride_length_min), 2) as avg_duration
FROM rides
WHERE member_type = 'Casual' 
  AND day_name IN ('Saturday', 'Sunday')

UNION ALL

-- All casual riders
SELECT 
    'All Casual Riders' as segment,
    COUNT(*) as rides,
    100.00 as pct_of_casual_rides,
    ROUND(AVG(ride_length_min), 2) as avg_duration
FROM rides
WHERE member_type = 'Casual';