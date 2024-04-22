tell application "System Events"
    set the visible of every process to true
    do shell script "killall -HUP Dock"
end tell
