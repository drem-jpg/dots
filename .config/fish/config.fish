# Original config from Derek Taylor (DistroTube).

### ADDING TO THE PATH
# First line removes the path; second line sets it.  Without the first line,
# your path gets massive and fish becomes very slow.
set -e fish_user_paths
set -U fish_user_paths $HOME/.bin  $HOME/.local/bin $HOME/.config/emacs/bin $HOME/Applications /var/lib/flatpak/exports/bin/ $fish_user_paths

### EXPORT ###
set fish_greeting                                 # Supresses fish's intro message
set TERMINAL "st"                         # Sets the terminal type
set EDITOR "nvim"                 # $EDITOR use nvim in terminal
set VISUAL "nvim"              # $VISUAL use nvim in terminal
set BROWSER "librewolf" 		# $BROWSER use qutebrowser as browser
set QT_STYLE_OVERRIDE "kvantum"			# Use kvantum for Qt
set QT_QPA_PLATFORMTHEME "gtk2"			#Use GTK 2 for Qt
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export XINITRC="$XDG_CONFIG_HOME/x11/xinitrc"

### SET MANPAGER
### Uncomment only one of these!

### "nvim" as manpager
set -x MANPAGER "nvim +Man!"

### "less" as manpager
# set -x MANPAGER "less"

### SET EITHER DEFAULT EMACS MODE OR VI MODE ###
function fish_user_key_bindings
  # fish_default_key_bindings
  fish_vi_key_bindings
end
### END OF VI MODE ###

### AUTOCOMPLETE AND HIGHLIGHT COLORS ###
set fish_color_normal brwhite
set fish_color_autosuggestion '#7d7d7d'
set fish_color_command brgreen
set fish_color_error brred
set fish_color_param brcyan

### FUNCTIONS ###

# Functions needed for !! and !$
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

# The bindings for !! and !$
if [ "$fish_key_bindings" = "fish_vi_key_bindings" ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Function for creating a backup file
# ex: backup file.txt
# result: copies file as file.txt.bak
function backup --argument filename
    cp $filename $filename.bak
end

# Function for copying files and directories, even recursively.
# ex: copy DIRNAME LOCATIONS
# result: copies the directory and all of its contents.
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
	set from (echo $argv[1] | trim-right /)
	set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

# Function for printing a column (splits input on whitespace)
# ex: echo 1 2 3 | coln 3
# output: 3
function coln
    while read -l input
        echo $input | awk '{print $'$argv[1]'}'
    end
end

# Function for printing a row
# ex: seq 3 | rown 3
# output: 3
function rown --argument index
    sed -n "$index p"
end

# Function for ignoring the first 'n' lines
# ex: seq 10 | skip 5
# results: prints everything but the first 5 lines
function skip --argument n
    tail +(math 1 + $n)
end

# Function for taking the first 'n' lines
# ex: seq 10 | take 5
# results: prints only the first 5 lines
function take --argument number
    head -$number
end

# Function for org-agenda
function org-search -d "send a search string to org-mode"
    set -l output (/usr/bin/emacsclient -a "" -e "(message \"%s\" (mapconcat #'substring-no-properties \
        (mapcar #'org-link-display-format \
        (org-ql-query \
        :select #'org-get-heading \
        :from  (org-agenda-files) \
        :where (org-ql--query-string-to-sexp \"$argv\"))) \
        \"
    \"))")
    printf $output
end

### END OF FUNCTIONS ###


### ALIASES ###
# navigation
alias cd='z'
alias ..='z ..'
alias ...='z ../..'
alias .3='z ../../..'
alias .4='z ../../../..'
alias .5='z ../../../../..'

# neofetch to fastfetch
alias neofetch='fastfetch -c neofetch.jsonc'

# quick dotfiles update
alias dotspush='cd ~/dots; lazygit; cd -'
alias dotsupdate='cd ~/dots; stow .; cd -'

# lf to lfub
alias lf='lfub'

# dwm config
alias dwmedit="cd ~/dwm; v config.def.h & cp config.def.h config.h"
alias dwmupdate="cd ~/dwm; sudo make install & cd -"

# quality of life command improvements
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -vIrf"
alias bc="bc -ql"
alias rsync="rsync -vrPlu"
alias mkd="mkdir -pv"
alias yt="yt-dlp --embed-metadata -i"
alias yta="yt -x -f bestaudio/best"
alias ytt="yt --skip-download --write-thumbnail"
alias mpv="mpv --no-audio-display"
alias bgch="nvim ~/.local/bin/setbg; setbg"

# vim and emacs
alias v='nvim'
alias vim='nvim'
alias em='/usr/bin/emacs -nw'
alias emacs="emacsclient -c -a 'emacs'"
alias rem="killall emacs || echo 'Emacs server not running'; /usr/bin/emacs --daemon"

# Changing "ls" to "eza"
alias ls='eza -al --color=always --group-directories-first' # my preferred listing
alias la='eza -a --color=always --group-directories-first'  # all files and dirs
alias ll='eza -l --color=always --group-directories-first'  # long format
alias lt='eza -aT --color=always --group-directories-first' # tree listing
alias l.='eza -a | egrep "^\."'

# pacman and yay
alias pacsyu='sudo pacman -Syu'                  # update only standard pkgs
alias pacsyyu='sudo pacman -Syyu'                # Refresh pkglist & update standard pkgs
alias parsua='paru -Sua --noconfirm'             # update only AUR pkgs (paru)
alias parsyu='paru -Syu --noconfirm'             # update standard pkgs and AUR pkgs (paru)
alias unlock='sudo rm /var/lib/pacman/db.lck'    # remove pacman lock
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'  # remove orphaned packages (DANGEROUS!)

# get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist-arch"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist-arch"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist-arch"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist-arch"

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# adding flags
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# Merge Xresources
alias merge='xrdb ~/.config/x11/xresources'

# startx
alias sx='startx ~/.config/x11/xinitrc'

# colorize more commands
alias diff='diff --color=auto'
alias ccat='highlight --out-format=ansi'
alias ip='ip -color=auto'

# git
alias g='git'
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias tag='git tag'
alias newtag='git tag -a'

# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# gpg encryption
# verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
# receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

# Play audio files in current dir by type
alias playwav='mpv *.wav'
alias playogg='mpv *.ogg'
alias playmp3='mpv *.mp3'

# Play video files in current dir by type
alias playavi='mpv *.avi'
alias playmov='mpv *.mov'
alias playmp4='mpv *.mp4'

# switch between shells
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"
alias todash="sudo chsh $USER -s /bin/dash && echo 'Now log out.'"

# shorten long commands
alias ka='killall'
alias trem='transmission-remote'
alias sdm='shutdown -h now'
alias p='sudo pacman'
alias net='nmtui'
alias nm='neomutt'
alias img='nsxiv'
alias crypt='sudo cryptsetup'
alias mount='sudo mount'
alias umount='sudo umount'

# bare git repo alias for dotfiles
alias config="/usr/bin/git --git-dir=$HOME/dots --work-tree=$HOME"

# termbin
alias tb="nc termbin.com 9999"

# the terminal rickroll
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

# Mocp must be launched with bash instead of Fish!
alias mocp="bash -c mocp"

# check the weather!
alias weather='curl -s -L https://wttr.in'

### RANDOM COLOR SCRIPT ###
# Get this script from my GitLab: gitlab.com/dwt1/shell-color-scripts
# Or install it from the Arch User Repository: shell-color-scripts
#colorscript random

### FASTFETCH ###
fastfetch -c examples/8.jsonc

### SETTING THE STARSHIP PROMPT ###
starship init fish | source

### FZF INTEGRATION ###
fzf --fish | source

### ZOXIDE INTEGRATION ###
zoxide init fish | source

### SPICETIFY PATH ### 
fish_add_path /home/max/.spicetify

### AUTOSTART XORG ###
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx "$XINITRC" -- -keeptty
    end
end
