local freedesktop = require("freedesktop")

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = freedesktop.menu.build {
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
    },
    after = {
        { "Reboot", "reboot" },
        { "Shutdown", "shutdown now"},
    }
}

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Hide the menu when the mouse leaves it
--[[
mymainmenu.wibox:connect_signal("mouse::leave", function()
    if not mymainmenu.active_child or
       (mymainmenu.wibox ~= mouse.current_wibox and
       mymainmenu.active_child.wibox ~= mouse.current_wibox) then
        mymainmenu:hide()
    else
        mymainmenu.active_child.wibox:connect_signal("mouse::leave",
        function()
            if mymainmenu.wibox ~= mouse.current_wibox then
                mymainmenu:hide()
            end
        end)
    end
end)
]]--
