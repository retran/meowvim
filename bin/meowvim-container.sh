#!/bin/bash
# MIT License
#
# Copyright (c) 2025 Andrew Vasilyev < me@retran.me >
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# @file: bin/meowvim-container.sh
# @brief: Raycast script to launch MeowVim and connect to litterbox container
# @author: Andrew Vasilyev
# @license: MIT
#

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
