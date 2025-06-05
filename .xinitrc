#!/usr/bin/env dash
xrdb ~/.Xresources
unset XCURSOR_THEME

setxkbmap -option caps:swapescape
xset r rate 200 50
xset s off
xset -dpms
xset s noblank

~/.fehbg &
polybar &
xbindkeys &
dunst &
mpdas &

exec sxwm
