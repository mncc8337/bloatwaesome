local gears = require("gears")

-- select a random theme (except wal)
local awesome_dir = gears.filesystem.get_configuration_dir()
local theme = gears.filesystem.get_random_file_from_dir(awesome_dir.."theme/themes"):match("(.+)%..+$")
-- lol
while theme == "wal" do
    theme = gears.filesystem.get_random_file_from_dir(awesome_dir.."theme/themes"):match("(.+)%..+$")
end

local loaded = require("theme.themes."..theme)

return loaded