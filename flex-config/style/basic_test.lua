-------------------------------------
            --To-Do
-------------------------------------
-- Helper functions callen?  z.B.
    -- has_area_tags()
    -- clean_tags()



-------------------------------------
            -- 1. Basics
-------------------------------------

-- Variables
    epsg_id = 4326                  -- Set EPSG number
    postgres_schema = "GER_nrw"     -- Schema name for import
    table_pre = ""                  -- Prefix for all tables

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
    -- "mapper" keys
    tags.attribution = nil
    tags.comment = nil
    tags.created_by = nil
    tags.fixme = nil
    tags.['name:*'] = nil  -- möglicherweise stern nach hinten ziehen?? unklar ob das so funktioniert
    tags.note = nil
    tags.odbl = nil
    tags.['odbl:note'] = nil
    tags.source = nil
    tags['source:ref'] = nil

    -- Geo provider tags

    tags.['CLC:*'] = nil
    tags.['geobase:*'] = nil
    tags.['canvec*'] = nil
    tags.['osak:*'] = nil
    tags.['kms:*'] = nil
    tags.['ngbe:*'] = nil
    tags.['it:fvg:*'] = nil
    tags.['KSJ2:*'] = nil
    tags.['yh:*'] = nil
    tags.['LINZ2OSM:*'] = nil
    tags.['LINZ:*'] = nil
    tags.['ref:linz:*'] = nil
    tags.['WroclawGIS:*'] = nil
    tags.['naptan:*'] = nil
    tags.['tiger:*'] = nil
    tags.['gnis:*'] = nil
    tags.['mvdgis:*'] = nil
    tags.['nhd:*'] = nil
    tags.['project:eurosha_2012'] = nil
    tags.['ref:UrbIS'] = nil
    tags.['accuracy:meters'] = nil
    tags.['sub_sea:type'] = nil
    tags.['waterway:type'] = nil
    tags.['statscan:rbuid'] = nil   
    tags.['ref:ruian'] = nil
    tags.['dibavod:id'] = nil
    tags.['at_bev:addr_date'] = nil
    tags.['openGeoDB:*'] = nil
    -- AND MANY MANY MORE

    tags.['alt_name:*'] = nil,
	tags.['contact'] = nil,
	tags.['contact:*'] = nil,
	tags.['description'] = nil,    
	tags.['description:*'] = nil,
    tags.['email'] = nil,
	tags.['fax'] = nil,
	tags.['ft_link'] = nil,
	tags.['image'] = nil,
    tags.['import'] = nil,
    tags.['import_uuid'] = nil,
    tags.['opening_hours'] = nil,
	tags.['opendata_portal'] = nil,
	tags.['OBJTYPE'] = nil,
    tags.['phone'] = nil,
	tags.['ref:nuts:*'] = nil,
	tags.['SK53_bulk:load'] = nil,
    tags.['mml:class'] = nil,
	tags.['website'] = nil,
    tags.['wikidata'] = nil,
	tags.['wikipedia'] = nil


    return next(tags) == nil
end

-------------------------------------
         -- Inspect Dataset
-------------------------------------
print(inspect(object))


--------------------------------------
          --HELPER FUNCTIONS
--------------------------------------

function has_area_tags(tags)
    if tags.area == 'yes' then
        return true
    end
    if tags.area == 'no' then
        return false
    end

    return tags.aeroway
        or tags.building
        or tags.landuse
        or tags['area:highway']
        or tags['abandoned:building']
        -- and many more!
        
        

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
            boundary = object.boundary,
            name = object.name,
            population = object.population,
            admin_level = object.admin_level,
            key_gemeinde = object.['de:amtlicher_gemeindeschluessel'],
            key_region = object.['de:regionalschluessel'],
            tags = object.tags,
            geom = object:as_multipolygon()
        })
    end
end
