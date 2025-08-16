#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title meowvim - Connect to litterbox container
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ../assets/icon_small.png
# @raycast.packageName meowvim

# Documentation:
# @raycast.description Launches meowvim and connects to the litterbox container.
# @raycast.author Andrew Vasilyev
# @raycast.authorURL https://raycast.com/user_210516c60e2007c264d4

neovide --server localhost:5202
