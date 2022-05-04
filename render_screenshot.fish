#!/usr/bin/env fish

source functions/_render_prompt.fish

echo
set_color brblack && echo "# Exit Status"
_render_prompt success folder "" "" && set_color brblack && echo "# Status == 0"
_render_prompt failure folder "" "" && set_color brblack && echo "# Status != 0"

echo
set_color brblack && echo "# Git Status"
_render_prompt success git-repo master clean && set_color brblack && echo "# Clean Repo"
_render_prompt success git-repo master dirty && set_color brblack && echo "# Dirty Repo"
_render_prompt success git-repo master conflict && set_color brblack && echo "# Merge Conflicts"
echo
