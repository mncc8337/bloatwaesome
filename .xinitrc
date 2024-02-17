/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
gio mount -d /dev/sda1 &
picom &
xautolock -time 10 -locker $HOME/.bin/auto_lock_screen.sh &
ibus-daemon -r &
awesome
