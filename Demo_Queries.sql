-- Query 1: Habitable Planets
SELECT *
FROM habitable_planets;

-- Query 2: Exoplanets Only
SELECT planet_name, planet_type
FROM planet
WHERE is_exoplanet = TRUE;

-- Query 3: Moons of Jupiter
SELECT m.moon_name
FROM moon m
JOIN planet p
ON m.planet_id = p.planet_id
WHERE p.planet_name = 'Jupiter';

-- Query 4: Number of Planets Around Each Star
SELECT
    s.star_name,
    COUNT(p.planet_id) AS total_planets
FROM star s
LEFT JOIN planet p
ON s.star_id = p.star_id
GROUP BY s.star_name;

-- Query 5: Stars by Spectral Class
SELECT
    spectral_class,
    COUNT(*) AS total_stars
FROM star
GROUP BY spectral_class;

-- Query 6: Potentially Hazardous Asteroids
SELECT
    asteroid_name,
    diameter_km
FROM asteroid
WHERE is_potentially_hazardous = TRUE;

-- Query 7: Full Celestial Lineage
SELECT *
FROM celestial_lineage;

-- Query 8: Average Surface Temperature of Planets
SELECT
    AVG(avg_surface_temp_c) AS average_temperature
FROM planet;

-- Query 9: Observatories Still Active
SELECT
    observatory_name,
    country
FROM observatory
WHERE is_active = TRUE;

-- Query 10: Top 5 Largest Moons
SELECT
    moon_name,
    radius_km
FROM moon
ORDER BY radius_km DESC
LIMIT 5;

-- Count planets in galaxy
SELECT
    g.galaxy_name,
    COUNT(p.planet_id) AS total_planets
FROM galaxy g
JOIN constellation c
    ON g.galaxy_id = c.galaxy_id
JOIN star_system ss
    ON c.constellation_id = ss.constellation_id
JOIN star s
    ON ss.system_id = s.system_id
JOIN planet p
    ON s.star_id = p.star_id
GROUP BY g.galaxy_name;