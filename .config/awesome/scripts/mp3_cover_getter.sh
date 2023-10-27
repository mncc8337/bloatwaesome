#if [ ! -d "~/.cover" ] then
#ffmpeg -i file.mp3 -an -c:v copy file.jpg

$currd=pwd
cd $HOME/Music
rm $HOME/.config/awesome/mpd_cover.png

ffmpeg -i "$1" -an -c:v copy $HOME/.config/awesome/mpd_cover.png &&
cd $currd &&
return

# no cover? use fallback
cp $HOME/.config/awesome/fallback.png $HOME/.config/awesome/mpd_cover.png
cd $currd
