# Bash Aliases



# My custom aliases
alias nf='neofetch'
alias ff='fastfetch'
alias cl='clear'
alias eb='exec bash'
alias e.='explorer.exe .'
alias gs='git status'
alias v='nvim $xargs'
alias ps='pwsh.exe -NoLogo'
alias wp='powershell.exe -NoLogo'
alias nvn='nvim ~/.config/nvim'
alias nvt='nvim ~/.tmux.conf'
alias nvp='nvim ~/.bashrc'
alias nva='nvim ~/.bash_aliases'
alias nvw='nvim /mnt/c/Users/cjasa/.wezterm.lua'
alias nvs='nvim /mnt/c/Users/cjasa/starship.toml'
alias nvj='nvim ~/Notes-etc/'
alias nvf='nvim ~/.config/fastfetch'

alias man='batman $xargs'
alias cat='bat $xargs'


# Functions for Eza (ls alternative)

# LS using eza w/colors + icons
function ls { eza -1 --color=always --icons=auto; }

# LS - Tree view
function lt { eza -laT --level=2 --color=always --no-permissions --icons=auto; }

# LS - All (Includes hidden files)
function la { eza -la --color=always --icons=auto --no-permissions; }

# LS - Last Modified
function lm { eza -1arl --sort=modified --color=always --icons=auto --no-permissions; }

