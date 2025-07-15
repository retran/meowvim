#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title MeowVim
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ../assets/icon_small.png
# @raycast.packageName MeowVim

# Documentation:
# @raycast.description Launches MeowVim with a specific window size
# @raycast.author Andrew Vasilyev
# @raycast.authorURL https://raycast.com/user_210516c60e2007c264d4

open -a neovide --args --size 2200x1600
