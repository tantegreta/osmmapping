echo Importing the file "current-project-output.pbf" into Postgres

cd "%USERPROFILE%\OneDrive\OSM\02c_osm2pgsql\osm2pgsql-bin\osm2pgsql-1.7.0"

PAUSE
osm2pgsql.exe --slim --drop --number-processes=8 --output=flex -d pggermany --user=postgres --password --hstore --multi-geometry --log-sql --verbose --style=flex-config/germany.lua tmp/berlin-latest.osm.pbf
PAUSE