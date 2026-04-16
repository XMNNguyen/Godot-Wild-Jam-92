#!/bin/sh
printf '\033c\033]0;%s\a' Godot-Wild-Jam-92
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Godot-Wild-Jam-92.x86_64" "$@"
