import Foundation

let appleScript = """
tell application "System Events"
    tell application process "kitty"
        try
            tell window 1
                click button 2 -- button 2 is usually the green maximize button
            end tell
        end try
    end tell
end tell
"""

if let script = NSAppleScript(source: appleScript) {
    var errorDict: NSDictionary?
    script.executeAndReturnError(&errorDict)
    if let error = errorDict {
        print("AppleScript error: \\(error)")
    } else {
        print("Clicked maximize button.")
    }
} else {
    print("Failed to compile AppleScript.")
}

