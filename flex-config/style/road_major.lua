require "helpers"
-- SRID einfügen!



-----------------------
---- Define tables ----
-----------------------


local tables = {}

tables.road_major = osm2pgsql.define_table({
    name = 'road_major_lines',
    ids = {type= 'way', id_column = 'osm_id'},
    columns = {
        {column = 'type', type = 'text'},
        {column = 'name', type = 'text'},
        {column = 'ref', type = 'text'},
        {column = 'maxspeed', type = 'int'},
        {column = 'layer', type = 'int'},
        {column = 'tunnel', type = 'text'}
        {column = 'bridge', type = 'text'},

        {column = 'width', type = 'int'},
        {column = 'incline', type = 'int'},
        {column = 'oneway', type = 'text'},
        {column = 'sidewalk', type = 'text'},
        {column = 'cycleway', type = 'text'},

        {column = 'tags', type = 'jsonb'},
        {column = 'geom', type = 'multilinestring', projection = srid }
    },
    cluster = 'auto'
})




-------------------------------------------------------------------------------------------------------------

--------------------
--- Process Ways ---
--------------------

function road_major_process_way(object)
    --uncomment to not use print
    print(inspect(object))

    -- sort out only the highway tags
    if not object.tags.highway then
        return
    end

    if clean_tags(object.tags) then
        return
    end
    
    tables.road_major:insert({
        type = object.type,
        name = object.name,
        ref = object.ref,
        maxspeed = object.maxspeed,
        layer = object.layer,
        tunnel = object.tunnel,
        bridge = object.bridge,

        width = object.width,
        incline = object.incline,
        oneway = object.oneway,
        sidewalk = object.sidewalk,
        cycleway = object.cycleway,

        tags = object.tags,
        geom = object:as_linestring()
    })
end


