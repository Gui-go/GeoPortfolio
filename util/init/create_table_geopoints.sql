CREATE TABLE geopoints(
    id serial PRIMARY KEY,
    name varchar(255),
    geom geometry(LineString, 3857)
);

INSERT INTO
    geopoints(name, geom)
VALUES
    (
        'test',
        ST_SetSRID(
            ST_MakeLine(
                ST_GeomFromText('POINT(-48.564151 -27.593550)'),
                ST_GeomFromText('POINT(37.6173 55.7558)')
            ),
            3857
        )
    ),
    (
        'test2',
        ST_SetSRID(
            ST_MakeLine(
                ST_GeomFromText('POINT(-48.564151 -27.593550)'),
                ST_GeomFromText('POINT(7.6261 51.9607)')
            ),
            3857
        )
    );

-- INSERT INTO geopoints (name, geom)
-- VALUES 
--     ('Florianópolis, Santa Catarina', ST_GeomFromText('POINT(-48.564151 -27.593550)', 4326)),
--     ('Central point', ST_GeomFromText('POINT(0 0)', 4326));




