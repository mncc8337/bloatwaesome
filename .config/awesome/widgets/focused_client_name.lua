local markup = require("lain").util.markup
local utf8 = require "utf8"

local focused_client = wibox.widget.textbox()
focused_client.font = "Dosis Bold 12"
local function update_fc_widget()
    local current_focus_client = client.focus
    if current_focus_client then
        if current_focus_client.name then
            -- shorten the name
            local name = current_focus_client.name
            if utf8.len(name) > 50 then
                name = utf8.sub(name, 1, 47) .. "..."
            end
            focused_client.markup = markup.fg.color(color_subtext0, name)
        else
            focused_client.markup = markup.fg.color(color_overlay2, "unamed client")
        end
    else focused_client.markup = "" end
end
client.connect_signal("property::name", function() update_fc_widget() end)
client.connect_signal("focus", function(c) update_fc_widget() end)
client.connect_signal("unfocus", function(c) update_fc_widget() end)

return focused_client