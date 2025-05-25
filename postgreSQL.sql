-- Active: 1747559382400@@localhost@5432@assignment2
-- rangers table create and insert value
CREATE TABLE rangers (
                    ranger_id SERIAL PRIMARY KEY,
                    name VARCHAR(100),
                    region VARCHAR(200)
)

INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range'),
('David Black', 'Forest Edge'),
('Eva Brown', 'Coastal Plains'),
('Frank Moore', 'Desert Zone'),
('Grace Lee', 'Highland Trails');

-- species table create and insert value
CREATE TABLE species (
  species_id SERIAL PRIMARY KEY,
  common_name VARCHAR(100),
  scientific_name VARCHAR(150),
  discovery_date DATE,
  conservation_status VARCHAR(50)
);

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered'),
('Indian Pangolin', 'Manis crassicaudata', '1821-01-01', 'Endangered'),
('Great Indian Bustard', 'Ardeotis nigriceps', '1863-01-01', 'Critically Endangered'),
('Ganges River Dolphin', 'Platanista gangetica', '1801-01-01', 'Endangered'),
('Nilgiri Tahr', 'Nilgiritragus hylocrius', '1838-01-01', 'Endangered'),
('Hoolock Gibbon', 'Hoolock hoolock', '1867-01-01', 'Endangered');

-- sightings table create and insert value
CREATE TABLE sightings (
  sighting_id SERIAL PRIMARY KEY,
  species_id INTEGER REFERENCES species(species_id),
  ranger_id INTEGER REFERENCES rangers(ranger_id),
  location VARCHAR(100),
  sighting_time TIMESTAMP,
  notes TEXT
);

INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL),
(2, 1, 'Elephant Crossing', '2024-05-20 06:50:00', 'Heard trumpet sounds nearby'),
(5, 3, 'Coastal Watchpoint', '2024-05-21 14:10:00', 'Tracks found near sandbank'),
(6, 2, 'Dune Base Camp', '2024-05-22 17:35:00', 'Seen at sunset'),
(7, 1, 'High Trail North', '2024-05-23 08:00:00', 'Pair spotted grazing');

-- select all
SELECT * FROM rangers;
SELECT * FROM species;
SELECT * FROM sightings;

-- delete
DROP TABLE rangers;
DROP TABLE species;
DROP TABLE sightings;

DELETE FROM rangers 
 WHERE ranger_id = 9

-- problem-1
INSERT INTO rangers (name, region) VALUES ('Derek Fox','Coastal Plains');

-- problem-2
SELECT count(DISTINCT species_id) as unique_species_count FROM sightings;

-- problem-3
SELECT * FROM sightings
  WHERE location ILIKE '%pass';

-- problem-4
SELECT name,count(*) as total_sightings FROM sightings
NATURAL JOIN rangers
GROUP BY name;

-- problem-5
SELECT common_name FROM species 
LEFT JOIN sightings ON species.species_id = sightings.species_id
WHERE sightings.species_id IS NULL;

-- problem-6
SELECT * FROM sightings
ORDER BY sighting_time DESC LIMIT(2);

-- problem-7
UPDATE species
SET conservation_status = 'Historic'
WHERE EXTRACT(YEAR FROM discovery_date) < 1800;

-- problem-8
SELECT 
  sighting_id,
  CASE 
    WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS time_of_day
FROM sightings;

-- problem-9
DELETE FROM rangers
WHERE NOT EXISTS (
  SELECT *
  FROM sightings
  WHERE sightings.ranger_id = rangers.ranger_id
);


