savedir=''
prefix=''
cwd=$(pwd)
if [ "$2" = 'save' ]; then
    savedir="$(date +"%m-%d-%y_%H-%M-%S").png "
    prefix=" and saved to ~/Pictures/$(date +"%m-%d-%y_%H-%M-%S").png"
    cd ~/Pictures
fi
if [ "$1" = 'full' ]; then
    maim $savedir--hidecursor | xclip -selection clipboard -t image/png
elif [ "$1" = 'area' ]; then
    maim -s $savedir--hidecursor | xclip -selection clipboard -t image/png
fi

notify-send "<b>Screen captured</b><br>Image copied to clipboard$prefix"
cd $cwd