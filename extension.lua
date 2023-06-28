--[[ centered thing ]]--
function h_centered_widget(widget, placeholder)
    if not placeholder then placeholder = wibox.widget.textbox() end
    local w = {
        layout = wibox.layout.align.horizontal,
        expand = "outside",
        core = {},
        placeholder, widget, placeholder
    }
    return w
end
function v_centered_widget(widget, placeholder)
    if not placeholder then placeholder = wibox.widget.textbox() end
    local w = {
        layout = wibox.layout.align.vertical,
        expand = "outside",
        core = {},
        placeholder, widget, placeholder
    }
    return w
end
function centered_widget(widget, placeholder)
    if not placeholder then placeholder = wibox.widget.textbox() end
    local w = h_centered_widget(widget, placeholder)
    w = v_centered_widget(w, placeholder)
    return w
end

function find_client_with_name(name_)
    local dropdown = function(c)
        return awful.rules.match(c, {name = name_})
    end
    local temp
    for c in awful.client.iterate(dropdown) do
         temp = c
    end
    return temp
end
function find_client_with_class(class_)
    local dropdown = function(c)
        return awful.rules.match(c, {class = class_})
    end
    local temp
    for c in awful.client.iterate(dropdown) do
         temp = c
    end
    return temp
end

--[[ mpd helper ]]--
function toggle_lain_mpd(state, nofitication)
    if notification == 'NO' then notification = false else notification = true end
    local common = {
        text = "MPD ",
        position = "top_middle",
        timeout = 2,
        border_width = beautiful.border_width,
    }
    local function callback(mpd_state)
        lain_mpd.update()
        mpd_off = mpd_state
        if notification then naughty.notify(common) end
    end

    local function off()
        lain_mpd.timer:stop()
        common.text = common.text .. markup.bold("OFF")
        lain_mpd.widget:set_markup(markup.fg.color(color_overlay0, "󰝛 "))
        awful.spawn.easy_async("mpd --kill", function() callback(true) end)
    end
    local function on()
        lain_mpd.timer:again()
        common.text = common.text .. markup.bold("ON")
        awful.spawn.easy_async("mpd", function() callback(false) end)
    end
    if not mpd_off then off() else on() end
    if not state then return else
        if state == 'on' then on() else off() end
    end
end

--[[ client ]]--
function move_client(c, dx, dy, dw, dh)
  c:relative_move(dx, dy, dw, dh)
end

--[[ drop down client ]]--
--drop-down terminal
function dropdownterminal()
    local temp = find_client_with_name("drop-down-terminal")
    if not temp then awful.spawn(terminal.." --title drop-down-terminal")
    elseif temp.hidden == false then
        temp.hidden = true
    else
        temp:move_to_tag(awful.tag.selected())
        temp.hidden = false
        client.focus = temp
        temp:raise()
    end
end
-- drop-down ncmpcpp
function dropdownncmpcpp()
    if mpd_off then return end
    local temp = find_client_with_name("drop-down-ncmpcpp")
    if not temp then
        awful.spawn(terminal.." --title drop-down-ncmpcpp -e ncmpcpp")
        mpd_inf4.visible = false
    elseif temp.hidden == false then
        temp.hidden = true
        if mouse.current_widget == lain_mpd.widget then
            mpd_inf4.visible = true
        end
    else
        temp:move_to_tag(awful.tag.selected())
        temp.hidden = false
        client.focus = temp
        temp:raise()
        mpd_inf4.visible = false
    end
end
tag.connect_signal("property::selected", function()
    local c = find_client_with_name("drop-down-terminal")
    if c then c.hidden = true end
    c = find_client_with_name("drop-down-ncmpcpp")
    if c then c.hidden = true end
end)

--[[ pavu control ]]--
function toggle_pavucontrol()
    local c = find_client_with_class("Pavucontrol")
    if c then
        c:kill()
        if mouse.current_widget == lain_alsa.widget then
            volume_slider_popup.visible = true
        end
    else
        if volume_slider_popup.visible then volume_slider_popup.visible = false end
        awful.spawn("pavucontrol")
    end
end

function set_volume_slider_value(val)
    volume_slider.value = val
end
function show_volume_slider()
    volume_button_triggered_timer:again()
    volume_slider_popup.visible = true
end
