

--Sort out the major roads from minor ones
-- from https://github.com/rustprooflabs/pgosm-flex/tree/main/flex-config

function is_major_road(highway)
    if (highway == 'motorway'
        or highway == 'motorway_link'
        or highway == 'primary'
        or highway == 'primary_link'
        or highway == 'secondary'
        or highway == 'secondary_link'
        or highway == 'tertiary'
        or highway == 'tertiary_link'
        or highway == 'trunk'
        or highway == 'trunk_link')
    then
        return true
    end

    return false

end 