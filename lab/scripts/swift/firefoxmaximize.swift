import Foundation

let script = """
tell application "Firefox"
    activate
    try
        repeat with w in windows
            if miniaturized of w is true then
                set miniaturized of w to false
                exit repeat
            end if
        end repeat
    end try
end tell
"""

if let appleScript = NSAppleScript(source: script) {
    var error: NSDictionary?
    appleScript.executeAndReturnError(&error)
    if let error = error {
        print("AppleScript Error: \(error)")
    } else {
        print("One Firefox window unminimized.")
    }
}

