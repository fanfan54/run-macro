#!/bin/bash
if [ $# -ge 1 ]; then
    case $1 in
        "-h"|"--help")
            echo "Usage: $0 [OPTION] MODULE [ARG 1]..."
            echo "Run shell macros (from the module called MODULE) with some arguments."
            echo "Example: $0 set-master-audio increase"
            echo
            echo "Miscellaneous:"
            echo -e "\t-h, --help\tdisplay this help text and exit"
            echo -e "\t-V, --version\tdisplay version information and exit"
            echo
            echo "Available modules:"
            echo "set-master-audio: wrapper for amixer (ALSA mixer) that can set the master audio volume on the local system."
            echo
            echo "Report bugs to: francois.lefevre@epitech.eu"
            echo "run-macro home page: <https://francoislefevre.cf/run-macro>"
            ;;
        "-V"|"--version")
            echo "run-macro 0.2"
            echo "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>."
            echo "This is free software: you are free to change and redistribute it."
            echo "There is NO WARRANTY, to the extent permitted by law."
            echo
            echo "Written by Francois Lefevre and others, see <https://github.com/fanfan54/run-macro/blob/master/AUTHORS>."
            ;;
        "set-master-audio")
            case $2 in
                "increase")
                    amixer -D pulse sset Master 5%+ unmute
                    volume=`amixer sget Master | grep "\[" | cut -d' ' -f7 | head -n1`
                    notify-send --icon=/usr/share/icons/gnome/256x256/status/audio-volume-high.png "Increased volume for master audio: $volume"
                    ;;
                "decrease")
                    amixer -D pulse sset Master 5%- unmute
                    volume=`amixer sget Master | grep "\[" | cut -d' ' -f7 | head -n1`
                    notify-send --icon=/usr/share/icons/gnome/256x256/status/audio-volume-low.png "Decreased volume for master audio: $volume"
                    ;;
                "toggle")
                    amixer set Master toggle
                    is_off=`amixer -D pulse sget Master | grep -c "off"`
                    volume=`amixer sget Master | grep "\[" | cut -d' ' -f7 | head -n1`
                    if [ $is_off = "2" ]; then
                        notify-send --icon=/usr/share/icons/gnome/256x256/status/audio-volume-muted.png "Muted master audio"
                    else
                        notify-send --icon=/usr/share/icons/gnome/256x256/status/audio-volume-medium.png "De-muted (enabled) master audio: $volume"
                    fi
                    ;;
                *)
                    echo "Usage: $0 [OPTION] set-master-audio [increase|decrease|toggle]..."
                    echo "Try '$0 set-master-audio --help' for more information."
                    ;;
            esac
            ;;
        *)
            echo "Usage: $0 [OPTION] MODULE [ARG 1]..."
            echo "Try '$0 --help' for more information."
    esac
else
    echo "Usage: $0 [OPTION] MODULE [ARG 1]..."
    echo "Try '$0 --help' for more information."
fi
