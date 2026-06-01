-- ============================================================
--  CosmoPedia — Celestial Encyclopedia Database
--  MySQL Schema — CREATE TABLE Statements
-- ============================================================

DROP DATABASE IF EXISTS cosmopedia;
CREATE DATABASE cosmopedia;
USE cosmopedia;

-- ============================================================
-- TABLE 01: GALAXY

CREATE TABLE galaxy (
    galaxy_id               INT             AUTO_INCREMENT PRIMARY KEY,
    galaxy_name             VARCHAR(100)    NOT NULL UNIQUE,
    galaxy_type             ENUM('Spiral', 'Elliptical', 'Irregular', 'Lenticular') NOT NULL,
    diameter_ly             DECIMAL(20, 2)  COMMENT 'Diameter in light-years',
    distance_from_earth_ly  DECIMAL(20, 2)  COMMENT 'Distance from Earth in light-years',
    star_count_estimate     BIGINT          COMMENT 'Estimated number of stars',
    discovery_year          INT,
    discovered_by           VARCHAR(100)
);
-- ==================================================================================
-- TABLE 02: CONSTELLATION

CREATE TABLE constellation (
    constellation_id    INT             AUTO_INCREMENT PRIMARY KEY,
    galaxy_id           INT             NOT NULL,
    constellation_name  VARCHAR(100)    NOT NULL,
    iau_abbreviation    CHAR(3)         UNIQUE COMMENT 'Official IAU 3-letter code',
    area_sq_degrees     DECIMAL(8, 2)   COMMENT 'Sky area in square degrees',
    brightest_star      VARCHAR(100),
    hemisphere          ENUM('Northern', 'Southern', 'Both') NOT NULL,

    CONSTRAINT fk_const_galaxy FOREIGN KEY (galaxy_id)
        REFERENCES galaxy(galaxy_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
-- ==================================================================================
-- TABLE 03: STAR_SYSTEM

CREATE TABLE star_system (
    system_id               INT             AUTO_INCREMENT PRIMARY KEY,
    constellation_id        INT             NOT NULL,
    system_name             VARCHAR(100)    NOT NULL,
    system_type             ENUM('Single', 'Binary', 'Trinary', 'Multiple') NOT NULL,
    distance_from_earth_ly  DECIMAL(15, 6)  COMMENT 'Distance in light-years',
    age_billion_years       DECIMAL(6, 3)   COMMENT 'Estimated age in billion years',

    CONSTRAINT fk_system_constellation FOREIGN KEY (constellation_id)
        REFERENCES constellation(constellation_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
-- ==================================================================================
-- TABLE 04: STAR

CREATE TABLE star (
    star_id             INT             AUTO_INCREMENT PRIMARY KEY,
    system_id           INT             NOT NULL,
    star_name           VARCHAR(100)    NOT NULL,
    spectral_class      ENUM('O', 'B', 'A', 'F', 'G', 'K', 'M') NOT NULL
                        COMMENT 'Harvard spectral classification',
    luminosity_solar    DECIMAL(15, 4)  COMMENT 'Luminosity relative to Sun (Sun = 1)',
    mass_solar          DECIMAL(10, 4)  COMMENT 'Mass relative to Sun (Sun = 1)',
    radius_solar        DECIMAL(10, 4)  COMMENT 'Radius relative to Sun (Sun = 1)',
    surface_temp_k      INT             COMMENT 'Surface temperature in Kelvin',
    age_billion_years   DECIMAL(6, 3),
    life_stage          ENUM('Protostar', 'Main Sequence', 'Subgiant', 'Red Giant',
                             'White Dwarf', 'Neutron Star', 'Black Hole', 'Supernova')
                        NOT NULL,

    CONSTRAINT fk_star_system FOREIGN KEY (system_id)
        REFERENCES star_system(system_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
-- ==================================================================================
-- TABLE 05: PLANET

CREATE TABLE planet (
    planet_id               INT             AUTO_INCREMENT PRIMARY KEY,
    star_id                 INT             NOT NULL,
    planet_name             VARCHAR(100)    NOT NULL,
    planet_type             ENUM('Terrestrial', 'Gas Giant', 'Ice Giant',
                                 'Dwarf Planet', 'Super Earth') NOT NULL,
    mass_earth              DECIMAL(12, 4)  COMMENT 'Mass relative to Earth (Earth = 1)',
    radius_earth            DECIMAL(8, 4)   COMMENT 'Radius relative to Earth (Earth = 1)',
    orbital_period_days     DECIMAL(12, 4)  COMMENT 'Days to complete one orbit',
    distance_from_star_au   DECIMAL(10, 6)  COMMENT 'Distance from host star in AU',
    avg_surface_temp_c      DECIMAL(8, 2)   COMMENT 'Average surface temperature in Celsius',
    has_atmosphere          BOOLEAN         DEFAULT FALSE,
    in_habitable_zone       BOOLEAN         DEFAULT FALSE,
    is_exoplanet            BOOLEAN         DEFAULT FALSE,

    CONSTRAINT fk_planet_star FOREIGN KEY (star_id)
        REFERENCES star(star_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
-- ==================================================================================
-- TABLE 06: MOON

CREATE TABLE moon (
    moon_id                     INT             AUTO_INCREMENT PRIMARY KEY,
    planet_id                   INT             NOT NULL,
    moon_name                   VARCHAR(100)    NOT NULL,
    radius_km                   DECIMAL(12, 4)  COMMENT 'Radius in kilometers',
    mass_kg                     DECIMAL(30,4)  COMMENT 'Mass in kilograms',
    orbital_period_days         DECIMAL(12, 5)  COMMENT 'Days to orbit the planet',
    distance_from_planet_km     DECIMAL(15, 2)  COMMENT 'Average orbital distance in km',
    has_atmosphere              BOOLEAN         DEFAULT FALSE,
    surface_type                ENUM('Rocky', 'Icy', 'Oceanic', 'Mixed', 'Volcanic')
                                NOT NULL,

    CONSTRAINT fk_moon_planet FOREIGN KEY (planet_id)
        REFERENCES planet(planet_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
-- ==================================================================================
-- TABLE 07: ASTEROID

CREATE TABLE asteroid (
    asteroid_id             INT             AUTO_INCREMENT PRIMARY KEY,
    system_id               INT             NOT NULL,
    asteroid_name           VARCHAR(100)    NOT NULL,
    classification          ENUM('C-type', 'S-type', 'M-type', 'V-type', 'X-type')
                            NOT NULL COMMENT 'Compositional classification',
    diameter_km             DECIMAL(10, 3),
    mass_kg                 DECIMAL(35, 4),
    orbital_period_years    DECIMAL(10, 4),
    is_potentially_hazardous BOOLEAN        DEFAULT FALSE
                            COMMENT 'NASA PHO classification',

    CONSTRAINT fk_asteroid_system FOREIGN KEY (system_id)
        REFERENCES star_system(system_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
-- ==================================================================================
-- TABLE 08: OBSERVATORY

CREATE TABLE observatory (
    observatory_id      INT             AUTO_INCREMENT PRIMARY KEY,
    observatory_name    VARCHAR(150)    NOT NULL UNIQUE,
    obs_type            ENUM('Ground', 'Space', 'Radio', 'Infrared', 'X-Ray') NOT NULL,
    country             VARCHAR(100),
    established_year    YEAR,
    mirror_diameter_m   DECIMAL(6, 3)   COMMENT 'Primary mirror diameter in meters',
    is_active           BOOLEAN         DEFAULT TRUE
);

-- ============================================================
-- JUNCTION TABLE: DISCOVERY
-- Links observatories to what they discovered
-- ============================================================
CREATE TABLE discovery (
    discovery_id        INT             AUTO_INCREMENT PRIMARY KEY,
    observatory_id      INT             NOT NULL,
    discovered_type     ENUM('Galaxy', 'Star', 'Planet', 'Moon', 'Asteroid') NOT NULL,
    discovered_id       INT             NOT NULL COMMENT 'ID of the discovered object',
    discovery_year      INT,
    discovery_method    ENUM('Direct Imaging', 'Transit', 'Radial Velocity',
                             'Gravitational Lensing', 'Visual', 'Spectroscopy','X-Ray')
                        NOT NULL,

    CONSTRAINT fk_discovery_observatory FOREIGN KEY (observatory_id)
        REFERENCES observatory(observatory_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ==================================================================================
-- USEFUL VIEWS

-- View: All planets in the habitable zone
CREATE VIEW habitable_planets AS
    SELECT
        p.planet_name,
        p.planet_type,
        p.avg_surface_temp_c,
        p.has_atmosphere,
        p.is_exoplanet,
        s.star_name,
        s.spectral_class,
        ss.system_name,
        g.galaxy_name
    FROM planet p
    JOIN star s          ON p.star_id        = s.star_id
    JOIN star_system ss  ON s.system_id      = ss.system_id
    JOIN constellation c ON ss.constellation_id = c.constellation_id
    JOIN galaxy g        ON c.galaxy_id      = g.galaxy_id
    WHERE p.in_habitable_zone = TRUE;

-- View: Full celestial lineage (Galaxy → Moon)
CREATE VIEW celestial_lineage AS
    SELECT
        g.galaxy_name,
        c.constellation_name,
        ss.system_name,
        s.star_name,
        s.spectral_class,
        p.planet_name,
        p.planet_type,
        m.moon_name
    FROM galaxy g
    JOIN constellation c ON g.galaxy_id         = c.galaxy_id
    JOIN star_system ss  ON c.constellation_id  = ss.constellation_id
    JOIN star s          ON ss.system_id         = s.system_id
    JOIN planet p        ON s.star_id            = p.star_id
    LEFT JOIN moon m     ON p.planet_id          = m.planet_id;

-- ============================================================
-- END OF SCHEMA
-- ==================================================================================
-- ==================================================================================
--  CosmoPedia — Sample Data (Moderate)
--  Real celestial bodies with accurate values
-- ============================================================

USE cosmopedia;
-- ==================================================================================
-- GALAXIES

INSERT INTO galaxy (galaxy_name, galaxy_type, diameter_ly, distance_from_earth_ly, star_count_estimate, discovery_year, discovered_by) VALUES
('Milky Way',           'Spiral',    105000,     0,              250000000000, NULL,  'Known since antiquity'),
('Andromeda',           'Spiral',    220000,     2537000,        1000000000000, 964,  'Abd al-Rahman al-Sufi'),
('Triangulum',          'Spiral',    60000,      2730000,        40000000000,  1764,  'Charles Messier'),
('Large Magellanic Cloud', 'Irregular', 32000,   163000,         30000000000,  NULL,  'Known since antiquity'),
('Whirlpool Galaxy',    'Spiral',    76900,      23000000,       100000000000, 1773,  'Charles Messier'),
('Sombrero Galaxy',     'Lenticular',50000,      31100000,       100000000000, 1781,  'Pierre Méchain');
-- ==================================================================================
-- CONSTELLATIONS

INSERT INTO constellation (galaxy_id, constellation_name, iau_abbreviation, area_sq_degrees, brightest_star, hemisphere) VALUES
(1, 'Orion',        'ORI', 594.12, 'Rigel',        'Both'),
(1, 'Ursa Major',   'UMA', 1279.66,'Alioth',        'Northern'),
(1, 'Scorpius',     'SCO', 496.78, 'Antares',       'Southern'),
(1, 'Lyra',         'LYR', 286.48, 'Vega',          'Northern'),
(1, 'Centaurus',    'CEN', 1060.42,'Alpha Centauri', 'Southern'),
(1, 'Cygnus',       'CYG', 803.98, 'Deneb',         'Northern');
-- ==================================================================================
-- STAR SYSTEMS

INSERT INTO star_system (constellation_id, system_name, system_type, distance_from_earth_ly, age_billion_years) VALUES
(1, 'Solar System',         'Single',  0.000016,  4.603),
(1, 'Betelgeuse System',    'Single',  700.0,     8.0),
(2, 'Sirius System',        'Binary',  8.611,     0.3),
(3, 'Antares System',       'Binary',  550.0,     12.0),
(4, 'Vega System',          'Single',  25.04,     0.455),
(5, 'Alpha Centauri System','Trinary', 4.367,     4.85),
(6, 'Cygnus X-1 System',   'Binary',  6070.0,    5.0);
-- ==================================================================================
-- STARS

INSERT INTO star (system_id, star_name, spectral_class, luminosity_solar, mass_solar, radius_solar, surface_temp_k, age_billion_years, life_stage) VALUES
(1, 'Sun',              'G', 1.0000,     1.0000,  1.0000,  5778,  4.603, 'Main Sequence'),
(2, 'Betelgeuse',       'M', 126000.0,   11.6000, 887.0000,3500,  8.0,   'Red Giant'),
(3, 'Sirius A',         'A', 25.4000,    2.0630,  1.7110,  9940,  0.3,   'Main Sequence'),
(3, 'Sirius B',         'A', 0.0260,     0.9780,  0.0084,  25200, 0.3,   'White Dwarf'),
(4, 'Antares',          'M', 57500.0,    12.0000, 700.0000,3400,  12.0,  'Red Giant'),
(5, 'Vega',             'A', 40.1200,    2.1350,  2.3620,  9602,  0.455, 'Main Sequence'),
(6, 'Alpha Centauri A', 'G', 1.5190,     1.1000,  1.2270,  5790,  4.85,  'Main Sequence'),
(6, 'Alpha Centauri B', 'K', 0.5002,     0.9070,  0.8650,  5260,  4.85,  'Main Sequence'),
(6, 'Proxima Centauri', 'M', 0.0017,     0.1221,  0.1542,  3042,  4.85,  'Main Sequence'),
(7, 'Cygnus X-1',       'B', 200000.0,   21.0000, 22.3000, 31000, 5.0,   'Black Hole');
-- ==================================================================================
-- PLANETS

INSERT INTO planet (star_id, planet_name, planet_type, mass_earth, radius_earth, orbital_period_days, distance_from_star_au, avg_surface_temp_c, has_atmosphere, in_habitable_zone, is_exoplanet) VALUES
-- Solar System
(1, 'Mercury',  'Terrestrial',  0.0553, 0.3829, 87.97,   0.387,  167.0,  FALSE, FALSE, FALSE),
(1, 'Venus',    'Terrestrial',  0.8150, 0.9499, 224.70,  0.723,  464.0,  TRUE,  FALSE, FALSE),
(1, 'Earth',    'Terrestrial',  1.0000, 1.0000, 365.25,  1.000,  15.0,   TRUE,  TRUE,  FALSE),
(1, 'Mars',     'Terrestrial',  0.1070, 0.5320, 686.97,  1.524, -60.0,   TRUE,  FALSE, FALSE),
(1, 'Jupiter',  'Gas Giant',    317.83, 11.209, 4332.59, 5.203, -108.0,  TRUE,  FALSE, FALSE),
(1, 'Saturn',   'Gas Giant',    95.159, 9.449,  10759.22,9.537, -138.0,  TRUE,  FALSE, FALSE),
(1, 'Uranus',   'Ice Giant',    14.536, 4.007,  30688.50,19.191,-195.0,  TRUE,  FALSE, FALSE),
(1, 'Neptune',  'Ice Giant',    17.147, 3.883,  60182.00,30.070,-200.0,  TRUE,  FALSE, FALSE),
-- Exoplanets
(7, 'Kepler-452b','Super Earth',5.000,  1.600,  384.84,  1.046,  0.0,    TRUE,  TRUE,  TRUE),
(9, 'Proxima b', 'Terrestrial', 1.270,  1.100,  11.186,  0.049,  -39.0,  TRUE,  TRUE,  TRUE),
(7, 'Kepler-22b','Super Earth', 9.100,  2.400,  289.86,  0.849,  22.0,   TRUE,  TRUE,  TRUE);
-- ==================================================================================
-- MOONS

INSERT INTO moon (planet_id, moon_name, radius_km, mass_kg, orbital_period_days, distance_from_planet_km, has_atmosphere, surface_type) VALUES
-- Earth
(3,  'Luna',      1737.4,  7.342e22,  27.3217,  384400,    FALSE, 'Rocky'),
-- Mars
(4,  'Phobos',    11.267,  1.0659e16, 0.31891,  9376,      FALSE, 'Rocky'),
(4,  'Deimos',    6.200,   1.4762e15, 1.26244,  23463,     FALSE, 'Rocky'),
-- Jupiter
(5,  'Io',        1821.6,  8.9319e22, 1.76914,  421800,    TRUE,  'Volcanic'),
(5,  'Europa',    1560.8,  4.7998e22, 3.55118,  671100,    TRUE,  'Icy'),
(5,  'Ganymede',  2634.1,  1.4819e23, 7.15455,  1070400,   TRUE,  'Mixed'),
(5,  'Callisto',  2410.3,  1.0759e23, 16.6890,  1882700,   FALSE, 'Icy'),
-- Saturn
(6,  'Titan',     2574.7,  1.3452e23, 15.9454,  1221870,   TRUE,  'Rocky'),
(6,  'Enceladus', 252.1,   1.0802e20, 1.37022,  237948,    TRUE,  'Icy'),
(6,  'Mimas',     198.2,   3.7493e19, 0.94242,  185539,    FALSE, 'Icy'),
-- Uranus
(7,  'Titania',   788.4,   3.5270e21, 8.70587,  435910,    FALSE, 'Mixed'),
(7,  'Oberon',    761.4,   3.0140e21, 13.46324, 583520,    FALSE, 'Mixed'),
-- Neptune
(8,  'Triton',    1353.4,  2.1390e22, 5.87685,  354759,    TRUE,  'Icy');
-- ==================================================================================
-- ASTEROIDS

INSERT INTO asteroid (system_id, asteroid_name, classification, diameter_km, mass_kg, orbital_period_years, is_potentially_hazardous) VALUES
(1, 'Ceres',     'C-type', 939.40,  9.3835e20, 4.6050,  FALSE),
(1, 'Vesta',     'V-type', 525.40,  2.5908e20, 3.6290,  FALSE),
(1, 'Pallas',    'C-type', 511.00,  2.1100e20, 4.6170,  FALSE),
(1, 'Hygiea',    'C-type', 433.00,  8.6700e19, 5.5570,  FALSE),
(1, 'Bennu',     'C-type', 0.4920,  7.3290e10, 1.1960,  TRUE),
(1, 'Apophis',   'S-type', 0.3700,  6.1000e10, 0.8860,  TRUE),
(1, 'Eros',      'S-type', 16.840,  6.6870e15, 1.7610,  FALSE);
-- ==================================================================================
-- OBSERVATORIES

INSERT INTO observatory (observatory_name, obs_type, country, established_year, mirror_diameter_m, is_active) VALUES
('Hubble Space Telescope',          'Space',    'USA',          1990, 2.400,  TRUE),
('James Webb Space Telescope',      'Space',    'USA',          2021, 6.500,  TRUE),
('Very Large Telescope',            'Ground',   'Chile',        1998, 8.200,  TRUE),
('Arecibo Observatory',             'Radio',    'Puerto Rico',  1963, 304.800,FALSE),
('Chandra X-Ray Observatory',       'X-Ray',    'USA',          1999, 1.200,  TRUE),
('Keck Observatory',                'Ground',   'USA',          1993, 10.000, TRUE),
('Atacama Large Millimeter Array',  'Radio',    'Chile',        2013, NULL,   TRUE),
('Mount Wilson Observatory',        'Ground',   'USA',          1904, 2.540,  TRUE);
-- ==================================================================================
-- DISCOVERIES

INSERT INTO discovery (observatory_id, discovered_type, discovered_id, discovery_year, discovery_method) VALUES
(1, 'Galaxy',  2, 1994, 'Direct Imaging'),   -- Hubble imaged Andromeda detail
(1, 'Planet',  9, 2015, 'Transit'),           -- Hubble studied Kepler-452b atmosphere
(2, 'Planet',  10,2022, 'Radial Velocity'),   -- JWST observed Proxima b
(2, 'Galaxy',  5, 2022, 'Direct Imaging'),    -- JWST imaged Whirlpool
(3, 'Star',    2, 2000, 'Spectroscopy'),      -- VLT observed Betelgeuse
(5, 'Star',    10,2002, 'X-Ray'),             -- Chandra studied Cygnus X-1
(6, 'Planet',  11,2011, 'Transit'),           -- Keck confirmed Kepler-22b
(8, 'Star',    1, 1910, 'Spectroscopy');      -- Mount Wilson studied the Sun

-- END OF DATA
