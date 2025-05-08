import Foundation

func toggleFunctionKeys() {
    let domain = "NSGlobalDomain"
    let key = "com.apple.keyboard.fnState"
    
    let currentValue = UserDefaults.standard.bool(forKey: key)
    let newValue = !currentValue

    let task = Process()
    task.launchPath = "/usr/bin/defaults"
    task.arguments = ["write", domain, key, "-bool", "\(newValue)"]
    task.launch()
    task.waitUntilExit()

    print("Toggled function keys to \(newValue ? "F1–F12" : "media keys")")
}

