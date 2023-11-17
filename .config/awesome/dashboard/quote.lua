local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")

local ui        = require("dashboard.ui_elements")

local quote = wibox.widget {
    widget = wibox.widget.textbox(),
    align = "center",
    valign = "center",
    font = beautiful.font_mono.." 12",
    forced_width = 165,
}
-- load quote config on start
local config = read_json(awesome_dir.."config.json")
quote.markup = config["quote"]["content"]
quote.align = config["quote"]["alignment"]

local old_quote = ""
local prompt_running = false
local function quote_edit(start)
    local prompt = ""
    if start ~= nil then
        prompt = start..'\n'
    end
    awful.prompt.run {
        prompt = prompt,
        hooks = {
            {
                {}, "Escape", function(_)
                    single_timer(0.1, function()
                        quote.markup = old_quote
                        prompt_running = false
                    end):start()
                end
            },
            {
                {"Shift"}, "Return", function(current_quote)
                    local new = current_quote
                    if start ~= nil then
                        new = start..'\n'..new
                    end
                    single_timer(0.1, function()
                        quote_edit(new)
                    end):start()
                end
            },
        },
        textbox = quote,
        exe_callback = function(text)
            if string.gsub(string.gsub(text, ' ', ''), '\n', '') == '' then
                quote.markup = old_quote
            else
                quote.markup = text
                if start ~= nil then
                    quote.markup = start..'\n'..text
                end
                
                config["quote"]["content"] = quote.markup
                save_json(config, awesome_dir.."config.json")
            end
            prompt_running = false
        end
    }
end

local quotepanel = ui.create_dashboard_panel(wibox.widget {
    quote,
    widget = wibox.container.margin,
    margins = 12,
})

quotepanel:connect_signal("button::press", function()
    if mouse.is_left_mouse_button_pressed and not prompt_running then
        old_quote = quote.markup
        prompt_running = true
        quote_edit(nil, nil)
    elseif mouse.is_right_mouse_button_pressed then
        if quote_alignment == "center" then
            quote_alignment = "left"
        elseif quote_alignment == "left" then
            quote_alignment = "right"
        elseif quote_alignment == "right" then
            quote_alignment = "center"
        else
            quote_alignment = "center"
        end
        quote.align = quote_alignment

        config["quote"]["alignment"] = quote_alignment
        save_json(config, awesome_dir.."config.json")
    end
end)

return quotepanel