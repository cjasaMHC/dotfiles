## Pre-requisites
- Neovim 0.10.
- Nerd Font as your terminal font.
  - Make sure the nerd font you set doesn't end with Mono to prevent small icons.
- Ripgrep is required for grep searching with Telescope (OPTIONAL).
- GCC, Windows users must have mingw installed and set on path.
- Make, Windows users must have GnuWin32 installed and set on path.
- Delete old neovim folders (check commands below)

**LINK** https://nvchad.com/docs/quickstart/install
___

## Install

**Linux/MacOS** 
git clone https://github.com/NvChad/starter ~/.config/nvim && nvim

**Windows** 
git clone https://github.com/NvChad/starter $ENV:USERPROFILE\AppData\Local\nvim && nvim

**Docker** 
docker run -w /root -it --rm alpine:latest sh -uelic '
  apk add git nodejs neovim ripgrep build-base wget --update
  git clone https://github.com/NvChad/starter ~/.config/nvim
  nvim
  '


## Uninstall

**Linux / MacOS (unix)**
rm -rf ~/.config/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.local/share/nvim

**Flatpak (linux)**
rm -rf ~/.var/app/io.neovim.nvim/config/nvim
rm -rf ~/.var/app/io.neovim.nvim/data/nvim
rm -rf ~/.var/app/io.neovim.nvim/.local/state/nvim

**Windows CMD**
rd -r ~\AppData\Local\nvim
rd -r ~\AppData\Local\nvim-data

**Windows PowerShell**
rm -Force ~\AppData\Local\nvim
rm -Force ~\AppData\Local\nvim-data

