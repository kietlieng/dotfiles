tell application "Finder"
    set _b to bounds of window of desktop
    set _width to item 3 of _b
    set _height to item 4 of _b
end tell
tell application "Slack"
end tell
tell application "System Events" to tell process "Slack"
    set position of window 1 to { 0, 0 }
    set size of window 1 to { 200 , 200 }
end tell


