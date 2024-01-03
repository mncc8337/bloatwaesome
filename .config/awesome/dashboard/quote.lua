local config       = require("config")
local gears     = require("gears")
local awful     = require("awful")
local beautiful = require("beautiful")
local wibox     = require("wibox")

local ui        = require("dashboard.ui_elements")

local quote = wibox.widget {
    widget = wibox.widget.textbox(),
    align = "center",
    valign = "center",
    font = beautiful.font_type.mono.." 12",
    forced_width = 165,
}
-- load quote config on start
local saveinfo = read_json(config.awesome_dir.."saved.json")
quote.markup = saveinfo["quote"]["content"]
quote.align = saveinfo["quote"]["alignment"]

local function _format(str)
    local bold_opened = false -- `*`
    local italic_opened = false -- `|`
    local strike_opened = false -- `-`
    local underline_opened = false -- `_`

    local new_str = str .. ' '
    local increased = 0

    local function insert(stt, at)
        new_str = new_str:sub(0, at + increased - 1) .. stt .. new_str:sub(at + increased + 1, #str + increased)
        increased = increased + #stt - 1
    end

    for i = 1, #str do
        local c = str:sub(i,i)
        if c == '*' then
            bold_opened = not bold_opened
            if bold_opened then
                insert("<b>", i)
            else
                insert("</b>", i)
            end
        elseif c =='|' then
            italic_opened = not italic_opened
            if italic_opened then
                insert("<i>", i)
            else
                insert("</i>", i)
            end
        elseif c =='-' then
            strike_opened = not strike_opened
            if strike_opened then
                insert("<s>", i)
            else
                insert("</s>", i)
            end
        elseif c =='_' then
            underline_opened = not underline_opened
            if underline_opened then
                insert("<u>", i)
            else
                insert("</u>", i)
            end
        end
    end

    -- syntax error
    if bold_opened or strike_opened or underline_opened or italic_opened then
        return str
    end

    return new_str
end

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
                quote.markup = _format(quote.markup)
                
                saveinfo["quote"]["content"] = quote.markup:gsub('\n', "\\n")
                save_json(saveinfo, config.awesome_dir.."saved.json")
            end
            quote.font = beautiful.font_type.mono.." 12"
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

        saveinfo["quote"]["alignment"] = quote_alignment
        save_json(saveinfo, config.awesome_dir.."saved.json")
    end
end)

return quotepanel