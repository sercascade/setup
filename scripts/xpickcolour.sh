#!/usr/bin/env bash
color=$(/usr/bin/xcolor)
echo "${color#\#}" | xclip -selection clipboard

