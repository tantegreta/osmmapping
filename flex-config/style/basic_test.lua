
-------------------------------------
            -- 1. Basics
-------------------------------------

-- Variables
    epsg_id = 4326
    postgres_schema = "GER_nrw"

-- check osm2pgsql version
print('osm2pgsql version: ' .. osm2pgsql.version)

local pgsql_version = osm2pgsql.version    -- Version als Variable speichern

-------------------------------------
        -- 2. Create Tables
-------------------------------------

-- a place to store the SQL tables we define in this file
local tables = {}

tables.points = osm2pgsql.define_node_table('points',{
    { column = 'tags', type = 'jsonb'},
    { column = 'geom', type = 'point', not_null = true}
})

    -- Create a linestring table named "ways" with epsg_id as var for EPSG

tables.ways = osm2pgsql.define_way_table('ways', {
    { column = 'highway', type = 'text' },
    { column = 'bicycle', type = 'text' },
    { column = 'name', type = 'text'},
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'linestring', projection = epsg_id, not_null = true }
})

    -- Create a polygon table named "polygons" for all area objects

tables.polygons = osm2pgsql.define_area_table( 'polygons', {
    { column = 'type', type = 'text' },
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'geometry', not_null = true },
})

--------------------------------------
          -- 3. Clean Tags
--------------------------------------

    -- Remove tags from entries that we won't need at any stage
    -- Returns true if there are no tags left.

function clean_tags(tags)
    tags.odbl = nil
    tags.created_by = nil
    tags.source = nil
    tags['source:ref'] = nil

    return next(tags) == nil
end


-------------------------------------
         -- Inspect Dataset
-------------------------------------
print(inspect(object))


-------------------------------------
        -- 4. Process entries
-------------------------------------

-- A. Process Nodes

function osm2pgsql.process_node(object)
    if clean_tags(object.tags) then
        return
    end


    -- Example for conditional node selection

    -- if object.tags.amenity == 'restaurant' then
        --tables.restaurants:insert({
        --  name = object.tags.name,
        --  cuisine = object.tags.cuisine,
        --  geom = object:as_point()
        --})
    --else
        --tables.pois:insert({
            --tags = object.tags,
            --geom = object:as_point()
        --})
    --end

    tables.points:insert({
        name = object.name,
        tags = object.tags,
        geom = object:as_point()
    })

end




-- B. Process Ways
function osm2pgsql.process_way(object)

    if clean_tags(object.tags) then
        return
    end

    
    if object.is_closed then
        tables.polygons:insert({
            type = object.type,
            tags = object.tags,
            geom = object:as_polygon()
        })
        
    else
        tables.ways:insert({
            tags = object.tags,
            highway = object.highway
            bicycle = object.bicycle
            name = object.name
            geom = object:as_linestring()
        })
    end
end



-- C. Process Boundaries and Relations

function osm2pgsql.process_relation(object)
 
    if clean_tags(object.tags) then
        return
    end

    -- Store multipolygons and boundaries as polygons
    if object.tags.type == 'multipolygon' or
       object.tags.type == 'boundary' then
         tables.polygons:insert({
            type = object.type,
            tags = object.tags,
            geom = object:as_multipolygon()
        })
    end
end
