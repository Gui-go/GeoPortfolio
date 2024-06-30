


CREATE TABLE teste (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  geom GEOMETRY(Polygon, 4326)
);

INSERT INTO teste (name, geom)
VALUES (
  'Circle Example',
  ST_Buffer(ST_SetSRID(ST_MakePoint(-73.935242, 40.730610), 4326)::geography, 1000)::geometry
);

