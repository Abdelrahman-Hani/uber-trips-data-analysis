-----------------------------------
--1. Basic Analysis و KPIs
----------------------------------
-- 1. عرض الداتا بالكامل
SELECT *
FROM dbo.final_dataset;
GO

-- 2. إجمالي عدد الرحلات
SELECT COUNT(trip_id) AS total_trips
FROM dbo.final_dataset;
GO

-- 3. عدد الرحلات الفريدة
SELECT COUNT(DISTINCT trip_id) AS unique_trips
FROM dbo.final_dataset;
GO

-- 4. عدد السائقين
SELECT COUNT(DISTINCT driver_id) AS total_drivers
FROM dbo.final_dataset;
GO

-- 5. عدد العملاء
SELECT COUNT(DISTINCT rider_id) AS total_riders
FROM dbo.final_dataset;
GO

-- 6. متوسط المسافة
SELECT AVG(distance_km) AS avg_distance
FROM dbo.final_dataset;
GO

-- 7. متوسط أجرة الرحلات المكتملة
SELECT AVG(CASE WHEN status = 'Completed'
                THEN fare_amount END) AS avg_completed_fare
FROM dbo.final_dataset;
GO

-- 8. عدد الرحلات المكتملة
SELECT COUNT(*) AS completed_count
FROM dbo.final_dataset
WHERE status = 'Completed';
GO

-- 9. عدد الرحلات الملغاة
SELECT COUNT(*) AS cancelled_count
FROM dbo.final_dataset
WHERE status = 'Cancelled';
GO

-- 10. عدد الرحلات التي لم يحضر فيها العميل
SELECT COUNT(*) AS no_show_count
FROM dbo.final_dataset
WHERE status = 'No-Show';
GO

-- 11. معدل إكمال الرحلات من الحالات المعروفة
SELECT
    CAST(
        100.0 * SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN status IN ('Completed', 'Cancelled', 'No-Show')
                          THEN 1 ELSE 0 END), 0)
        AS DECIMAL(10,2)
    ) AS completion_rate_pct
FROM dbo.final_dataset;
GO

-- 12. ملخص مؤشرات الأداء الرئيسية
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT trip_id) AS unique_trips,
    COUNT(DISTINCT driver_id) AS total_drivers,
    COUNT(DISTINCT rider_id) AS total_riders,
    SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_trips,
    SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_trips,
    SUM(CASE WHEN status = 'No-Show' THEN 1 ELSE 0 END) AS no_show_trips,
    CAST(AVG(distance_km) AS DECIMAL(10,2)) AS avg_distance_km,
    CAST(AVG(CASE WHEN status = 'Completed'
                  THEN fare_amount END) AS DECIMAL(10,2)) AS avg_completed_fare,
    CAST(SUM(CASE WHEN status = 'Completed'
                  THEN fare_amount ELSE 0 END) AS DECIMAL(18,2)) AS actual_revenue
FROM dbo.final_dataset;
GO


--------------------------------------
---2. Revenue Analysis
--------------------------------------
-- 13. حساب الإيراد الفعلي والقيمة المسجلة للرحلات غير المكتملة
SELECT
    fare_amount,
    status,
    CASE WHEN status = 'Completed'
         THEN fare_amount ELSE 0 END AS calculated_actual_revenue,
    CASE WHEN status IN ('Cancelled', 'No-Show')
         THEN fare_amount ELSE 0 END AS non_completed_fare_value
FROM dbo.final_dataset;
GO

-- 14. إجمالي الإيراد الفعلي
SELECT SUM(CASE WHEN status = 'Completed'
                THEN fare_amount ELSE 0 END) AS actual_revenue
FROM dbo.final_dataset;
GO

-- 15. إجمالي قيمة الأجرة المسجلة للرحلات غير المكتملة
SELECT SUM(CASE WHEN status IN ('Cancelled', 'No-Show')
                THEN fare_amount ELSE 0 END) AS non_completed_fare_value
FROM dbo.final_dataset;
GO

-- 16. الإيراد وقيمة الأجرة غير المكتملة حسب الحالة
SELECT
    status,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN status = 'Completed'
             THEN fare_amount ELSE 0 END) AS actual_revenue,
    SUM(CASE WHEN status IN ('Cancelled', 'No-Show')
             THEN fare_amount ELSE 0 END) AS non_completed_fare_value
FROM dbo.final_dataset
GROUP BY status
ORDER BY actual_revenue DESC;
GO

-- 17. الإيرادات حسب المدينة
SELECT
    city,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_trips,
    SUM(CASE WHEN status = 'Completed'
             THEN fare_amount ELSE 0 END) AS actual_revenue
FROM dbo.final_dataset
GROUP BY city
ORDER BY actual_revenue DESC;
GO

-- 18. الإيرادات حسب طريقة الدفع
SELECT
    payment_method,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN status = 'Completed'
             THEN fare_amount ELSE 0 END) AS actual_revenue
FROM dbo.final_dataset
GROUP BY payment_method
ORDER BY actual_revenue DESC;
GO

-- 19. متوسط الأجرة حسب المدينة
SELECT
    city,
    AVG(CASE WHEN status = 'Completed'
             THEN fare_amount END) AS avg_completed_fare
FROM dbo.final_dataset
GROUP BY city
ORDER BY avg_completed_fare DESC;
GO

-- 20. متوسط الأجرة حسب طريقة الدفع
SELECT
    payment_method,
    AVG(CASE WHEN status = 'Completed'
             THEN fare_amount END) AS avg_completed_fare
FROM dbo.final_dataset
GROUP BY payment_method
ORDER BY avg_completed_fare DESC;
GO
------------------------------------------------------------
--3. Time Analysis

-------------------------------------------------------------
-- 21. الرحلات حسب الساعة
SELECT
    hour,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_trips,
    SUM(CASE WHEN status = 'Completed'
             THEN fare_amount ELSE 0 END) AS actual_revenue
FROM dbo.final_dataset
GROUP BY hour
ORDER BY hour;
GO

-- 22. أكثر 5 ساعات فيها رحلات
SELECT TOP 5
    hour,
    COUNT(*) AS total_trips
FROM dbo.final_dataset
GROUP BY hour
ORDER BY total_trips DESC;
GO

-- 23. الرحلات حسب يوم الأسبوع
SELECT
    day_name,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN status = 'Completed'
             THEN fare_amount ELSE 0 END) AS actual_revenue
FROM dbo.final_dataset
GROUP BY day_name
ORDER BY total_trips DESC;
GO

-- 24. الرحلات حسب الشهر
SELECT
    month_name,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN status = 'Completed'
             THEN fare_amount ELSE 0 END) AS actual_revenue
FROM dbo.final_dataset
GROUP BY month_name
ORDER BY total_trips DESC;
GO

-- 25. إنشاء الفترة الزمنية للرحلة لو العمود مش موجود
IF COL_LENGTH('dbo.final_dataset', 'time_slot') IS NULL
BEGIN
    ALTER TABLE dbo.final_dataset
    ADD time_slot VARCHAR(50);
END;
GO

-- 26. تحديث الفترة الزمنية لكل رحلة
UPDATE dbo.final_dataset
SET time_slot =
    CASE
        WHEN hour >= 6 AND hour < 10 THEN 'Morning Rush'
        WHEN hour >= 10 AND hour < 16 THEN 'Midday'
        WHEN hour >= 16 AND hour < 20 THEN 'Evening Rush'
        WHEN hour >= 20 AND hour <= 23 THEN 'Night'
        WHEN hour >= 0 AND hour < 6 THEN 'Late Night'
        ELSE 'Unknown'
    END;
GO

-- 27. تحليل الرحلات حسب الفترة الزمنية
SELECT
    time_slot,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN status = 'Completed'
             THEN fare_amount ELSE 0 END) AS actual_revenue
FROM dbo.final_dataset
GROUP BY time_slot
ORDER BY total_trips DESC;
GO
--------------------------------------------------------------
---4. Driver Analysis
----------------------------------------------------------------
-- 28. أكثر 5 سائقين من حيث إجمالي الرحلات
SELECT TOP 5
    driver_id,
    COUNT(*) AS total_trips
FROM dbo.final_dataset
GROUP BY driver_id
ORDER BY total_trips DESC;
GO

-- 29. أكثر 10 سائقين من حيث الرحلات المكتملة
SELECT TOP 10
    driver_id,
    COUNT(*) AS completed_trips,
    SUM(fare_amount) AS actual_revenue
FROM dbo.final_dataset
WHERE status = 'Completed'
GROUP BY driver_id
ORDER BY completed_trips DESC;
GO

-- 30. معدل إكمال الرحلات لكل سائق
SELECT
    driver_id,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_trips,
    CAST(
        100.0 * SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN status IN ('Completed', 'Cancelled', 'No-Show')
                          THEN 1 ELSE 0 END), 0)
        AS DECIMAL(10,2)
    ) AS completion_rate_pct
FROM dbo.final_dataset
GROUP BY driver_id
HAVING COUNT(*) >= 5
ORDER BY completion_rate_pct DESC;
GO

-- 31. أكثر السائقين تحقيقًا للإيرادات
SELECT TOP 10
    driver_id,
    COUNT(*) AS completed_trips,
    SUM(fare_amount) AS actual_revenue
FROM dbo.final_dataset
WHERE status = 'Completed'
GROUP BY driver_id
ORDER BY actual_revenue DESC;
GO

-- 32. تحليل إلغاء الرحلات لكل سائق
SELECT
    driver_id,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_trips,
    CAST(
        100.0 * SUM(CASE WHEN status = 'Cancelled' THEN 1 ELSE 0 END)
        / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS cancellation_rate_pct
FROM dbo.final_dataset
GROUP BY driver_id
HAVING COUNT(*) >= 5
ORDER BY cancellation_rate_pct DESC;
GO
-----------------------------------------------------------------
--5. Rider Analysis
-----------------------------------------------------------------
-- 33. أكثر 10 عملاء من حيث الرحلات المكتملة
SELECT TOP 10
    rider_id,
    COUNT(*) AS completed_trips,
    SUM(fare_amount) AS total_spend
FROM dbo.final_dataset
WHERE status = 'Completed'
GROUP BY rider_id
ORDER BY completed_trips DESC;
GO

-- 34. إجمالي إنفاق كل عميل
SELECT
    rider_id,
    COUNT(*) AS total_trips,
    SUM(CASE WHEN status = 'Completed'
             THEN fare_amount ELSE 0 END) AS total_spend
FROM dbo.final_dataset
GROUP BY rider_id
ORDER BY total_spend DESC;
GO

-- 35. تقسيم العملاء حسب عدد الرحلات المكتملة
WITH RiderStats AS (
    SELECT
        rider_id,
        SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_trips,
        SUM(CASE WHEN status = 'Completed'
                 THEN fare_amount ELSE 0 END) AS total_spend
    FROM dbo.final_dataset
    WHERE rider_id IS NOT NULL
    GROUP BY rider_id
)
SELECT
    CASE
        WHEN completed_trips = 0 THEN 'No Completed Trips'
        WHEN completed_trips = 1 THEN 'One-Time'
        WHEN completed_trips BETWEEN 2 AND 5 THEN 'Occasional'
        ELSE 'Frequent'
    END AS rider_segment,
    COUNT(*) AS total_riders,
    AVG(total_spend) AS avg_spend
FROM RiderStats
GROUP BY
    CASE
        WHEN completed_trips = 0 THEN 'No Completed Trips'
        WHEN completed_trips = 1 THEN 'One-Time'
        WHEN completed_trips BETWEEN 2 AND 5 THEN 'Occasional'
        ELSE 'Frequent'
    END
ORDER BY total_riders DESC;
GO
----------------------------------------------------------------------
--6. Distance & Fare Analysis
----------------------------------------------------------------------
-- 39. CTE لحساب الإيرادات وترتيب المدن حسب الأداء
WITH CityRevenue AS (
    SELECT
        city,
        COUNT(*) AS total_trips,
        SUM(CASE WHEN status = 'Completed'
                 THEN fare_amount ELSE 0 END) AS actual_revenue
    FROM dbo.final_dataset
    GROUP BY city
)
SELECT
    city,
    total_trips,
    actual_revenue
FROM CityRevenue
WHERE actual_revenue > 0
ORDER BY actual_revenue DESC;
GO

-- 40. CTE لتحديد السائقين الأعلى من متوسط الرحلات
WITH DriverTrips AS (
    SELECT
        driver_id,
        COUNT(*) AS total_trips
    FROM dbo.final_dataset
    GROUP BY driver_id
),
AverageTrips AS (
    SELECT AVG(total_trips * 1.0) AS avg_trips
    FROM DriverTrips
)
SELECT
    d.driver_id,
    d.total_trips,
    a.avg_trips
FROM DriverTrips d
CROSS JOIN AverageTrips a
WHERE d.total_trips > a.avg_trips
ORDER BY d.total_trips DESC;
GO

-- 41. CTE لحساب معدل الإكمال حسب المدينة
WITH CityStats AS (
    SELECT
        city,
        COUNT(*) AS total_trips,
        SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_trips,
        SUM(CASE WHEN status IN ('Completed', 'Cancelled', 'No-Show')
                 THEN 1 ELSE 0 END) AS known_status_trips
    FROM dbo.final_dataset
    GROUP BY city
)
SELECT
    city,
    total_trips,
    completed_trips,
    CAST(100.0 * completed_trips /
         NULLIF(known_status_trips, 0) AS DECIMAL(10,2)) AS completion_rate_pct
FROM CityStats
ORDER BY completion_rate_pct DESC;
GO

-- 42. CTE لتحديد الرحلات ذات الأجرة الأعلى من متوسط المدينة
WITH TripStats AS (
    SELECT
        trip_id,
        city,
        fare_amount,
        AVG(fare_amount) OVER (PARTITION BY city) AS city_avg_fare
    FROM dbo.final_dataset
    WHERE status = 'Completed'
)
SELECT
    trip_id,
    city,
    fare_amount,
    city_avg_fare
FROM TripStats
WHERE fare_amount > city_avg_fare
ORDER BY city, fare_amount DESC;
GO

---------------------------------------------------
-- 43. ترتيب المدن حسب الإيرادات باستخدام RANK
WITH CityRevenue AS (
    SELECT
        city,
        SUM(CASE WHEN status = 'Completed'
                 THEN fare_amount ELSE 0 END) AS actual_revenue
    FROM dbo.final_dataset
    GROUP BY city
)
SELECT
    city,
    actual_revenue,
    RANK() OVER (ORDER BY actual_revenue DESC) AS revenue_rank
FROM CityRevenue;
GO

-- 44. ترتيب السائقين حسب الرحلات باستخدام ROW_NUMBER و DENSE_RANK
WITH DriverTrips AS (
    SELECT
        driver_id,
        COUNT(*) AS total_trips
    FROM dbo.final_dataset
    GROUP BY driver_id
)
SELECT
    driver_id,
    total_trips,
    ROW_NUMBER() OVER (ORDER BY total_trips DESC) AS row_num,
    RANK() OVER (ORDER BY total_trips DESC) AS driver_rank,
    DENSE_RANK() OVER (ORDER BY total_trips DESC) AS dense_rank
FROM DriverTrips;
GO

-- 45. حساب المتوسط المتحرك للإيرادات اليومية
-- يتطلب وجود pickup_time من نوع تاريخ/وقت
WITH DailyRevenue AS (
    SELECT
        CAST(pickup_time AS DATE) AS trip_date,
        SUM(CASE WHEN status = 'Completed'
                 THEN fare_amount ELSE 0 END) AS daily_revenue
    FROM dbo.final_dataset
    WHERE pickup_time IS NOT NULL
    GROUP BY CAST(pickup_time AS DATE)
)
SELECT
    trip_date,
    daily_revenue,
    AVG(daily_revenue * 1.0) OVER (
        ORDER BY trip_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS rolling_7_day_avg_revenue
FROM DailyRevenue
ORDER BY trip_date;
GO

-- 46. حساب الإيرادات التراكمية اليومية
WITH DailyRevenue AS (
    SELECT
        CAST(pickup_time AS DATE) AS trip_date,
        SUM(CASE WHEN status = 'Completed'
                 THEN fare_amount ELSE 0 END) AS daily_revenue
    FROM dbo.final_dataset
    WHERE pickup_time IS NOT NULL
    GROUP BY CAST(pickup_time AS DATE)
)
SELECT
    trip_date,
    daily_revenue,
    SUM(daily_revenue) OVER (
        ORDER BY trip_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_revenue
FROM DailyRevenue
ORDER BY trip_date;
GO

-- 47. مقارنة إيراد كل يوم باليوم السابق باستخدام LAG
WITH DailyRevenue AS (
    SELECT
        CAST(pickup_time AS DATE) AS trip_date,
        SUM(CASE WHEN status = 'Completed'
                 THEN fare_amount ELSE 0 END) AS daily_revenue
    FROM dbo.final_dataset
    WHERE pickup_time IS NOT NULL
    GROUP BY CAST(pickup_time AS DATE)
),
RevenueComparison AS (
    SELECT
        trip_date,
        daily_revenue,
        LAG(daily_revenue) OVER (ORDER BY trip_date) AS previous_day_revenue
    FROM DailyRevenue
)
SELECT
    trip_date,
    daily_revenue,
    previous_day_revenue,
    daily_revenue - previous_day_revenue AS revenue_change
FROM RevenueComparison
ORDER BY trip_date;
GO

-- 48. مقارنة إيراد كل يوم باليوم التالي باستخدام LEAD
WITH DailyRevenue AS (
    SELECT
        CAST(pickup_time AS DATE) AS trip_date,
        SUM(CASE WHEN status = 'Completed'
                 THEN fare_amount ELSE 0 END) AS daily_revenue
    FROM dbo.final_dataset
    WHERE pickup_time IS NOT NULL
    GROUP BY CAST(pickup_time AS DATE)
)
SELECT
    trip_date,
    daily_revenue,
    LEAD(daily_revenue) OVER (ORDER BY trip_date) AS next_day_revenue
FROM DailyRevenue
ORDER BY trip_date;
GO

-- 49. نسبة إيراد كل مدينة من إجمالي الإيرادات
WITH CityRevenue AS (
    SELECT
        city,
        SUM(CASE WHEN status = 'Completed'
                 THEN fare_amount ELSE 0 END) AS actual_revenue
    FROM dbo.final_dataset
    GROUP BY city
)
SELECT
    city,
    actual_revenue,
    CAST(100.0 * actual_revenue /
         NULLIF(SUM(actual_revenue) OVER (), 0)
         AS DECIMAL(10,2)) AS revenue_share_pct
FROM CityRevenue
ORDER BY actual_revenue DESC;
GO

-- 50. ترتيب الرحلات داخل كل مدينة حسب الأجرة
SELECT
    trip_id,
    city,
    fare_amount,
    ROW_NUMBER() OVER (
        PARTITION BY city
        ORDER BY fare_amount DESC
    ) AS fare_rank_in_city
FROM dbo.final_dataset
WHERE status = 'Completed'
  AND fare_amount IS NOT NULL;
GO
---------------