function runosa() {
  osascript -e "$1"
}

function cpinspect() {
  osascript -e 'the clipboard as record'
}

# working
function cpfile() {

  local currentLocation=$(pwd)
  # Define the file path you want to copy
  # filePath="/Users/klieng/Downloads/Goals.pdf"  # Replace this with the actual file path

  local filePath="$currentLocation/$1"  # Replace this with the actual file path
  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      '-f') 
        filePath="$1"
        shift
        ;;
      *) 
        pecho "set current value"
        filePath="$currentLocation/$key"  # Replace this with the actual file path
        ;;
    esac

  done

  # Use osascript to copy the file reference with metadata to the clipboard
  osascript -e "
  tell application \"Finder\"
      set theFile to POSIX file \"$filePath\" as alias
      set the clipboard to (theFile as «class furl»)
  end tell"

}

# not working
function cpmulti() {
  
  # Define the file paths you want to simulate copying
  file_paths=(
      "/Users/klieng/Downloads/Goals.pdf"
      "/Users/klieng/Downloads/image.png"
  )  # Replace these paths with the actual file paths you want to copy
  
  # Build the AppleScript command to copy multiple files via Finder
  script="
  tell application \"Finder\"
      set fileList to {}"
  
  # Add each file path to the AppleScript command as Finder items
  for file in "${file_paths[@]}"; do
      script+="
      set end of fileList to (POSIX file \"$file\" as alias)
      set the clipboard to (fileList as «class furl»)"
  done
  
  script+="
    set the clipboard to fileList
  end tell
  "

#  # Set the clipboard to the list of Finder file references
#  script+="
#      set the clipboard to (fileList as «class furl»)
#  end tell
#  "
  
  # Execute the constructed AppleScript command using osascript
  osascript -e "$script"
  
}

# not working
function cptest() {

  local script=''
  script+="
  tell application \"Finder\""
  script+="
  set filePath1 to POSIX file \"/Users/klieng/Downloads/image.png\" as alias"
  script+="
  set filePath2 to POSIX file \"/Users/klieng/Downloads/Goals.pdf\" as alias"
  script+="
  set fileReferences to {filePath1, filePath2}"
  script+="
  set the clipboard to fileReferences"
  script+="
  end tell"

#  script+="
#  set utf16String to \"test1.png\""
#  script+="
#  set the clipboard to (utf16String as «class ut16»)"

  osascript -e "$script"

}
