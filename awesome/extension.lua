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
tag.connect_signal("property::selected", function()
    local c = find_client_with_name("drop-down-terminal")
    if c then c.hidden = true end
end)

function utf8.sub(s, start_char_idx, end_char_idx)
    start_byte_idx = utf8.offset(s, start_char_idx)
    end_byte_idx = utf8.offset(s, end_char_idx + 1) - 1
    return string.sub(s, start_byte_idx, end_byte_idx)
end
