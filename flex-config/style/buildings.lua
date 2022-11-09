
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



function address_only_building(tags)
    -- Cannot have any of these tags
    if tags.
    -- or tags.building
        then   
            return false
    end

end




function building_process_poly(object)
    --uncomment to not use print
    print(inspect(object))





    tables.road_major:insert({