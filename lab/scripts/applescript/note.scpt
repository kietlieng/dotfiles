tell application "Finder"
    set _b to bounds of window of desktop
    set _width to item 3 of _b
    set _height to item 4 of _b
    set _kittyTabHeight to 25
end tell
tell application "Preview"
    set bounds of front window to {0, 0, _width / 2, _height}
end tell
tell application "Firefox"
    set bounds of front window to { _width / 2, 0, _width, _height / 2}
end tell
-- tell application "System Events" to get name of every process
tell application "System Events" to tell process "kitty"
    set _newHeight to (_height / 2)
    set position of window 1 to { _width / 2, _newHeight + _kittyTabHeight }
    set size of window 1 to {_width / 2 , _newHeight - _kittyTabHeight }
end tell

