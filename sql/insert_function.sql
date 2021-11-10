DROP FUNCTION IF EXISTS insert_crowd_mapping_data(text,text,text,text,text,text,text,text,text,text,text,text,text);
--Assumes only one value being inserted

CREATE OR REPLACE FUNCTION insert_crowd_mapping_data (
    _geojson TEXT,
    _name TEXT,
    _address TEXT,
    _number TEXT,
    _email TEXT,	
    _socmed TEXT,
    _freepaid TEXT,
    _initial TEXT,
    _succeeding TEXT,	
    _insti TEXT,
    _accessibility TEXT,
    _opening TEXT,	
    _more TEXT)    
--Has to return something in order to be used in a "SELECT" statement
RETURNS integer
AS $$
DECLARE 
    _the_geom GEOMETRY;
	--The name of your table in cartoDB
	_the_table TEXT := 'mhaph2021';
BEGIN
    --Convert the GeoJSON to a geometry type for insertion. 
    _the_geom := ST_SetSRID(ST_GeomFromGeoJSON(_geojson),4326); 
	

	--Executes the insert given the supplied geometry, description, and username, while protecting against SQL injection.
    EXECUTE ' INSERT INTO '||quote_ident(_the_table)||' (the_geom, name, address, number, email, socmed, freepaid, initial, succeeding, insti, accessibility, opening, more)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
            ' USING _the_geom, _name, _address, _number, _email, _socmed, _freepaid, _initial, _succeeding, _insti, _accessibility, _opening, _more;
            
    RETURN 1;
END;
$$
LANGUAGE plpgsql SECURITY DEFINER ;

--Grant access to the public user
GRANT EXECUTE ON FUNCTION insert_crowd_mapping_data(text, text, text, text, text, text, text, text, text, text, text, text, text) TO publicuser;
