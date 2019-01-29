#!/bin/bash

if ps -C cmus > /dev/null; then

artist=`cmus-remote -Q |
	grep --text '^tag artist' |
	sed '/^tag artistsort/d' |
	awk '{gsub("tag artist ", "");print}'`
title=`cmus-remote -Q  |
	grep --text '^tag title' |
	sed -e 's/tag title //' |
	awk '{gsub("tag title ", "");print}'`
album=`cmus-remote -Q |
        grep --text '^tag album' |
        sed '/^tag albumartist/d' |
        sed '/^tag albumartistsort/d' |
        sed -e 's/tag album //' |
        awk '{gsub("tag album ", "");print}'`

notify-send "$title" "$artist - $album"

fi
