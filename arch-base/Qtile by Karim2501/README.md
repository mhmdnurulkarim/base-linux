## Table of Contents

- [About](#about)
- [Keybindings](#keybind)
- [Installation](#install)
- [Dependency](#dep)
- [Troubleshooting](#trouble)

<a id="about"></a>
## About This Config
I made this configuration so that we don't have to install one by one and our work becomes easier and more efficient.

<a id="keybind"></a>
## Keybindings
In this configuration i use a default keybindings(`.config/qtile/config.py`)...

|	Keybind		|		Function	|
| --------------------- | ----------------------------- |
| Win + Enter		| Launch terminal (alacritty)	|
| Win + w		| Close window			|
| Win + ctrl + r	| Restart Qtile			|
| Win + ctrl + q	| Shutdown Qtile		|
| Win + Tab		| Toggle between layouts	|
| Win +	h / Left	| Move focus to left		|
| Win + l / Right	| Move focus to right		|
| Win + j / Down	| Move focus to down		|
| Win + k / Up		| Move focus to up		|
| Win + shift + h / Left| Move window to the left	|
| Win + shift + l / Right| Move window to the right	|
| Win + shift + j / Down| Move window to the down	|
| Win + shift + k / Up	| Move window to the up 	|
| Win + ctrl + h / Left	| Grow window to the left	|
| Win + ctrl + l / Right| Grow window to the right	|
| Win + ctrl + j / Down	| Grow window to the down	|
| Win + ctrl + k / Up	| Grow window to the up		|
| Win + n		| Reset all window sizes	|
| Win + g		| Launch Google			|
| Win + r		| Launch Rofi Installed Package	|
| Win + shift + r	| Launch Rofi All Package	|
| Win + t		| Launch Telegram		|
| Win + Drag Left Mouse	| Drag Windows			|
| Win + Drag Right	| Resize Windows		|
| Win + Midle Click	| Bring Windows to front	|

<a id="install"></a>
## Installation
You can install my configuration with my script shell.
- `chmod +x install-on-arch.sh after-install.sh`
- `./install-on-arch.sh`
- `./after-install.sh`

<a id="dep"></a>
## Dependency
- Qtile
- xorg
- alacritty
- ZSH
- oh-my-zsh(highlighting & autosuggestion)
- powerlevel10k
- feh
- rofi
- wps-office
- wps-office-fonts
- python-pip(psutil)
- moc-pulse
- pfetch
- google-chrome
- telegram-desktop

<a id="trouble"></a>
## Troubleshooting
if you have problem with source ~/.zshrc
<br>try restarting laptop and retype `source ~/.zshrc` manually
<br>then try typing `p10k configure` and powerlevel10k will be configured
<br>enjoy:)
