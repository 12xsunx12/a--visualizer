#!/bin/sh
echo -ne '\033c\033]0;Astar-Visualizer\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/sun-astar.x86_64" "$@"
