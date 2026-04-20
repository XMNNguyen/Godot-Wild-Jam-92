#!/bin/sh
printf '\033c\033]0;%s\a' Godot-Wild-Jam-92
base_path="$(dirname "$(realpath "$0")")"
"$base_path/In_A_Jam_v2.x86_64" "$@"
