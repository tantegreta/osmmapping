-- Explain what this file does

-------------------------------------
--             To-Do                        
-------------------------------------

-- check style.pgosm-meta, what it does etc.
-- language settings

-- Reduce tags column (and, thus, storage space) by using object:grab_tag('name')



-------------------------------------
            -- 1. Basics
-------------------------------------

-- Variables
epsg_id = 4326                  -- Set EPSG number
postgres_schema = "GER_nrw"     -- Schema name for import
table_pre = ""                  -- Prefix for all tables
pgosm_language = ""             -- Default language

-- check osm2pgsql version
print('osm2pgsql version: ' .. osm2pgsql.version)
local pgsql_version = osm2pgsql.version    -- Version als Variable speichern



-- Loads the `conf` var from layerset INI file

-- Load the layerset configuration (e.g. PGOSM_LAYERSET, PGOSM_LAYERSET_PATH" etc.)
require "layerset"

-- Git settings, import meta data etc.
require "style.pgosm-meta"
