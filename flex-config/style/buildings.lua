-----------------------------------------
--            TO-DO
-----------------------------------------

-- Buildings prüfen, die kein building tag aber eine Adresse haben (dürften eigentlich nicht viele sein)


local tables = {}

tables.building = osm2pgsql.define_table({
    name = 'building_polygons',
    schema = schema_name,
    ids = {type= 'area', id_column = 'osm_id'},
    columns = {
        {column = 'type', type = 'text'},
        {column = 'name', type = 'text'},
        {column = 'street', type = 'text'},
        {column = 'housenumber', type = 'text'},
        {column = 'postcode', type = 'text'},
        {column = 'city', type = 'text'},
        
        {column = 'entrance', type = 'text'},
        {column = 'height', type = 'int'},
        {column = 'start_date', type = 'text'},
        {column = 'levels', type = 'text'},

        {column = 'tags', type = 'jsonb'},
        {column = 'geom', type = 'multipolygon', projection = srid }
    },
    cluster = 'auto'
})


--------------------------------------------------------------------------------



function building_process_poly(tags)
    -- Cannot have any of these tags
    if     tags.aeroway
        or tags.amenity
        or tags.boundary
        or tags['building:part']
        or tags.demolished
        or tags.landuse
        or tags.leisure
        or tags.natural
        or tags.office
        or tags.tourism
    -- or tags.building
        then   
            return false
    end
    
    --uncomment to not use print
    print(inspect(object))

    --so far very raw data, not much processed, necessary??
    
    tables.building_polygons:insert({
        type = object.type,
        name = object.tags.name, --alternative: name = get_name(object.tags)
        name_en = object.tags,
        building = object.tags.building,
        street = object.tags['addr:street'],
        housenumber = object.tags['addr:housenumber'],
        postcode = object.tags['addr:postcode'],
        city = object.tags['addr:city'],
        
        entrance = object.tags.entrance,
        height = object.tags.height,
        start_date = object.tags.start_date,
        levels = object.tags.levels,

        tags = object.tags,
        geom = object:as_polygon()
    })
end