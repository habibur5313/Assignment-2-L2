-- Active: 1747559382400@@localhost@5432@assignment2

-- rangers table create and insert value
CREATE TABLE rangers (ranger_id BIGSERIAL PRIMARY KEY, name VARCHAR(100) NOT NULL, region VARCHAR(100) NOT NULL);
INSERT INTO rangers (name, region) VALUES('Alice Green', 'Northen Hills'), ('Bob White', 'River Delta'), ('Carol King', 'Mountain Range');

-- species table create and insert value
CREATE TABLE species (species_id SERIAL PRIMARY KEY, common_name VARCHAR(100) NOT NULL, scientific_name VARCHAR(150) NOT NULL, discovery_date DATE NOT NULL, conservation_status VARCHAR(50) NOT NULL);
INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES ('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'), ('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'), ('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'), ('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

-- sightings table create and insert value
CREATE TABLE sightings (sighting_id SERIAL PRIMARY KEY, species_id INTEGER REFERENCES species(species_id), ranger_id INTEGER REFERENCES rangers(ranger_id),location VARCHAR(100), sighting_time TIMESTAMP,  notes text);
INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES (1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'), (2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'), (3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'), (1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);



-- problem-1 // Register a new ranger with provided data with name = 'Derek Fox' and region = 'Coastal Plains' //
INSERT INTO rangers (name, region) VALUES ('Derek Fox','Coastal Plains');

-- problem-2 // Count unique species ever sighted. //
SELECT count(DISTINCT species_id) as unique_species_count FROM sightings;

-- problem-3 // Find all sightings where the location includes "Pass". //
SELECT * FROM sightings
  WHERE location ILIKE '%pass';

-- problem-4 // List each ranger's name and their total number of sightings. //
SELECT name,count(*) as total_sightings FROM sightings
NATURAL JOIN rangers
GROUP BY name;

-- problem-5 // List species that have never been sighted. //
SELECT common_name FROM species 
LEFT JOIN sightings ON species.species_id = sightings.species_id
WHERE sightings.species_id IS NULL;

-- problem-6 // Show the most recent 2 sightings. //
SELECT * FROM sightings
ORDER BY sighting_time DESC LIMIT(2);

-- problem-7 // Update all species discovered before year 1800 to have status 'Historic'. //
UPDATE species
SET conservation_status = 'Historic'
WHERE EXTRACT(YEAR FROM discovery_date) < 1800;

-- problem-8 // Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'. //
SELECT 
  sighting_id,
  CASE 
    WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN EXTRACT(HOUR FROM sighting_time) > 17  THEN 'Evening'
  END AS time_of_day
FROM sightings;

-- problem-9 // Delete rangers who have never sighted any species. //
DELETE FROM rangers
WHERE NOT EXISTS (
  SELECT *
  FROM sightings
  WHERE sightings.ranger_id = rangers.ranger_id
);


