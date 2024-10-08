-- SQL Command to Create Materilized View GAP_PRODUCTS.FOSS_HAUL
--
-- Created by querying records from GAP_PRODUCTS.CPUE but only using hauls 
-- with ABUNDANCE_HAUL = 'Y' from the five survey areas w/ survey_definition_id:
-- "AI" = 52, "GOA" = 47, "EBS" = 98, "BSS" = 78, "NBS" = 143
--
-- Contributors: Ned Laman (ned.laman@noaa.gov), 
--               Zack Oyafuso (zack.oyafuso@noaa.gov), 
--               Emily Markowitz (emily.markowitz@noaa.gov)
--

CREATE MATERIALIZED VIEW GAP_PRODUCTS.FOSS_HAUL AS
SELECT 
cc.YEAR, 
CASE
    WHEN cc.SURVEY_DEFINITION_ID = 143 THEN 'NBS'
    WHEN cc.SURVEY_DEFINITION_ID = 98 THEN 'EBS'
    WHEN cc.SURVEY_DEFINITION_ID = 47 THEN 'GOA'
    WHEN cc.SURVEY_DEFINITION_ID = 52 THEN 'AI'
    WHEN cc.SURVEY_DEFINITION_ID = 78 THEN 'BSS'
    ELSE NULL
END AS SRVY, 
CASE
    WHEN cc.SURVEY_DEFINITION_ID = 143 THEN 'northern Bering Sea'
    WHEN cc.SURVEY_DEFINITION_ID = 98 THEN 'eastern Bering Sea'
    WHEN cc.SURVEY_DEFINITION_ID = 47 THEN 'Gulf of Alaska'
    WHEN cc.SURVEY_DEFINITION_ID = 52 THEN 'Aleutian Islands'
    WHEN cc.SURVEY_DEFINITION_ID = 78 THEN 'Bering Sea Slope'
    ELSE NULL
END AS SURVEY, 
cc.SURVEY_DEFINITION_ID, 
cc.SURVEY_NAME, 
cc.CRUISE,
cc.CRUISEJOIN,
hh.HAULJOIN, 
hh.HAUL, 
hh.STRATUM, 
hh.STATIONID AS STATION, 
hh.VESSEL AS VESSEL_ID, 
vv.NAME AS VESSEL_NAME, 
hh.START_TIME AS DATE_TIME,
hh.START_LATITUDE AS LATITUDE_DD_START, 
hh.START_LONGITUDE AS LONGITUDE_DD_START, 
hh.END_LATITUDE AS LATITUDE_DD_END, 
hh.END_LONGITUDE AS LONGITUDE_DD_END, 
hh.GEAR_TEMPERATURE AS BOTTOM_TEMPERATURE_C,
hh.SURFACE_TEMPERATURE AS SURFACE_TEMPERATURE_C, 
hh.BOTTOM_DEPTH AS DEPTH_M, 
hh.DISTANCE_FISHED AS DISTANCE_FISHED_KM, 
hh.DURATION AS DURATION_HR, 
hh.NET_WIDTH AS NET_WIDTH_M,
hh.NET_HEIGHT AS NET_HEIGHT_M,
hh.DISTANCE_FISHED * hh.NET_WIDTH * 0.001 AS AREA_SWEPT_KM2, 
hh.PERFORMANCE

FROM RACEBASE.HAUL hh

LEFT JOIN RACE_DATA.VESSELS vv
ON hh.VESSEL = vv.VESSEL_ID
LEFT JOIN GAP_PRODUCTS.AKFIN_CRUISE cc
ON hh.CRUISEJOIN = cc.CRUISEJOIN

WHERE hh.ABUNDANCE_HAUL = 'Y'
AND cc.SURVEY_DEFINITION_ID IN (143, 98, 47, 52, 78)
