DROP FUNCTION IF EXISTS insert_crowd_mapping_data(text,text,text,text,text,text,text,text,text);
--Assumes only one value being inserted

CREATE OR REPLACE FUNCTION insert_crowd_mapping_data (
    _geojson TEXT,
    _name TEXT,
    _muni TEXT,
    _brgy TEXT,
    _address TEXT,	
    _number TEXT,
    _approxnum TEXT,
    _needs TEXT,
    _more TEXT)    
--Has to return something in order to be used in a "SELECT" statement
RETURNS integer
AS $$
DECLARE 
    _the_geom GEOMETRY;
	--The name of your table in cartoDB
	_the_table TEXT := 'maringph';
BEGIN
    --Convert the GeoJSON to a geometry type for insertion. 
    _the_geom := ST_SetSRID(ST_GeomFromGeoJSON(_geojson),4326); 
	

	--Executes the insert given the supplied geometry, description, and username, while protecting against SQL injection.
    EXECUTE ' INSERT INTO '||quote_ident(_the_table)||' (the_geom, name, muni, brgy, address, number, approxnum, needs, more)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
            ' USING _the_geom, _name, _muni, _brgy, _address, _number, _approxnum, _needs, _more;
            
    RETURN 1;
END;
$$
LANGUAGE plpgsql SECURITY DEFINER ;

--Grant access to the public user
GRANT EXECUTE ON FUNCTION insert_crowd_mapping_data(text, text, text, text, text, text, text, text, text) TO publicuser;
