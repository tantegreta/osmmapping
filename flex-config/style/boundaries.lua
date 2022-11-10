local tables = {}

tables.boundaries = osm2pgsql.define_table({
    name = 'boundary_polygons',
    schema = schema_name,
    ids = {type= 'area', id_column = 'osm_id'},
    columns = {
        {column = 'type', type = 'text'},
        {column = 'name', type = 'text'},
        
        {column = 'boundary', type = 'text'},
        {column = 'admin_level', type = 'int'},
        {column = 'border_type', type = 'text'},
        {column = 'ISO1', type = 'text'},
        {column = 'ISO1_a2', type = 'text'},
        {column = 'ISO1_a3', type = 'text'},
        {column = 'ISO1_num', type = 'text'},
        {column = 'timezone', type = 'text'},

        {column = 'tags', type = 'jsonb'},
        {column = 'geom', type = 'multipolygon', projection = srid }
    },
    cluster = 'auto'
})