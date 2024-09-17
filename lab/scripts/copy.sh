alias refassemble='ref -f "/tmp/assemble-dependencies.csv"'

function runosa() {
  osascript -e "$1"
}

function refinspect() {
  osascript -e 'the clipboard as record'
}

# reference a file
function ref() {

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
function refmulti() {
  
  # Define the file paths you want to simulate copying
  file_paths=(
      "/Users/klieng/Downloads/test1.png"
      "/Users/klieng/Downloads/test2.png"
  )  # Replace these paths with the actual file paths you want to copy
  
  # Build the AppleScript command to copy multiple files via Finder
  script="
  tell application \"Finder\"
      set fileList to {}"
  
  # Add each file path to the AppleScript command as Finder items
  for file in "${file_paths[@]}"; do
      script+="
      set end of fileList to (POSIX file \"$file\" as alias)
      set the clipboard to fileList
      "
#      set the clipboard to fileList"
#      set the clipboard to (fileList as «class furl»)"
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

function reftext() {

  # Define the directory where your files are located
  local appleScript="tell application \"Finder\"
	set pathFile to selection as text
	set pathFile to get POSIX path of pathFile
	set the clipboard to pathFile
end tell"
  
  # Execute the AppleScript
  echo -e "$appleScript" | osascript

}


function reftext2() {
  # Get paths of files from the clipboard
  file_paths=$(osascript -e 'tell app "Finder" to get selection as alias list')
  echo "$file_paths" | pbcopy

}

function reftest() {
osascript -e 'tell application "Finder"
    set filePaths to ""
    set theSelection to selection
    repeat with aFile in theSelection
        set filePaths to filePaths & POSIX path of (aFile as text) & "\n"
    end repeat
    set the clipboard to filePaths
end tell'
}
