savedir=''
if [ "$2" = 'save' ]; then
    current_date=$(date +"%m-%d-%y_%H-%M-%S")
    savedir="$current_date.png"
    cd ~/Pictures
fi
if [ "$1" = 'full' ]; then
    maim $savedir --hidecursor| xclip -selection clipboard -t image/png
elif [ "$1" = 'area' ]; then
    maim -s $savedir --hidecursor| xclip -selection clipboard -t image/png
fi
