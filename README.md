# dotfiles
my _dots_
### Current
![free](screenshot/2024-02-01_20-55-03.png)

## Details
- **Distro**: arch
- **WM**: awesomewm
- **Compositor**: [picom](https://github.com/yshui/picom)
- **Icons**: [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
- **Cursor**: [Bibata Modern Classic](https://github.com/ful1e5/Bibata_Cursor)
- **Launcher**: [rofi](https://github.com/davatorium/rofi)
- **Terminal**: [alacritty](https://github.com/alacritty/alacritty)
- **Shell**: zsh with [oh my zsh](https://github.com/ohmyzsh/ohmyzsh)

## Dependencies
|package               |  purpose                         |note|
|----------------------|----------------------------------|----|
|awesome-git           |the WM                            |    |
|zsh                   |the shell                         |    |
|alacritty             |the terminal                      |    |
|maim                  |screen shooting                   |    |
|rofi                  |application launcher              |    |
|cava-git              |audio visualizer                  |*   |
|alsa-utils            |volume control                    |    |
|playerctl             |music control                     |    |
|picom-git             |the compositor                    |    |
|terminus-font         |tty font                          |*   |
|ttf-cascadia-mono-nerd|mono font                         |*   |
|ttf-roboto            |system font                       |*   |
|ttf-nerd-fonts-symbols|correctly display nerd font symbol|**  |
|papirus-icon-theme    |icon theme                        |*   |
|bibata-cursor-theme   |cursor theme                      |*   |

_* : optional_  
_**: no need to install if your nerd font is working as intended_  
Any packages above can be installed by using any AUR helper  
for example `yay -S awesome-git`