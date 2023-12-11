tell application "Finder"
    set _b to bounds of window of desktop
    set _width to item 3 of _b
    set _height to item 4 of _b
    set _kittyTabHeight to 25
end tell
tell application "System Events"
    if exists (window 1 of process "Firefox") then
        tell application "Firefox"
            set bounds of front window to { _width / 2, 0, _width, _height / 2}
        end tell
    else
        --tell application "Firefox" to activate
        --display dialog "no windows"
        tell application "System Events" to keystroke "n" using command down
--        private browser window
--        tell application "System Events" to keystroke "p" using { shift down, command down }
        tell application "Firefox"
            set bounds of window 1 to { _width / 2, 0, _width, _height / 2}
        end tell
    end if
end tell

tell application "System Events" to tell process "kitty"
    activate
    -- relative position
    set _newHeight to (_height / 2)
    set position of window 1 to { _width / 2, _newHeight + _kittyTabHeight }
    set size of window 1 to {_width / 2 , _newHeight - _kittyTabHeight }
end tell

