tell application "System Events" to tell process "kitty"
    local lCount, lDimensions, blah
    set lCount to 1
    set lDimensions to { 20, 40 }
    set blah to integer 1 of lDimensions

    repeat with aWindow in windows
--        set position of aWindow to {955, 600}
--        set size of aWindow to {1000, 600}
        set blah to integer lCount of lDimensions as text
        do shell script "echo " & quoted form of blah
        do shell script "echo " & quoted form of lCount
        set lCount to lCount + 1
    end repeat
end tell
