alias refassemble='ref -f "/tmp/assemble-dependencies.csv"'
alias rreact='ref -react'

function runosa() {
  osascript -e "$1"
}

function refinspect() {
  osascript -e 'the clipboard as record'
}

function rreact() {

  filePath=$(/bin/ls -1 $DIR_REACTION/$1* | head -n 1)

  # Use osascript to copy the file reference with metadata to the clipboard
  osascript -e "
  tell application \"Finder\"
      set theFile to POSIX file \"$filePath\" as alias
      set the clipboard to (theFile as «class furl»)
  end tell"

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
      '-react')
        filePath=$(/bin/ls -1 $DIR_REACTION/$1* | head -n 1)
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

function refswift() {

  local currentLocation=$(pwd)
  # Define the file path you want to copy
  # filePath="/Users/klieng/Downloads/Goals.pdf"  # Replace this with the actual file path

  local key=''
  local optionDir="$currentLocation"
  local optionTime="5"

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in

      '-t') # time in minutes
        optionTime="$1"
        shift
        ;;

      '-d') # directory
        optionDir="$1"
        shift
        ;;

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

  # cd "$optionDir"

  echo "find $optionDir -mmin \"-$optionTime\" "

  local swiftContent="import AppKit;"
  local swiftContent="$swiftContent\nlet files = ["
  local isFirst="1"

  # local lastFile=$(find $optionDir -mmin "-$optionTime" | tail -n 1)
    
  find $optionDir -type f -mmin "-$optionTime" | while read currentFile
  do
    
    # echo "referencing $currentFile"
    swiftContent="$swiftContent\n\"$currentFile\""
    if [[ "$currentFile" != "$lastFile" ]]; then
      swiftContent="$swiftContent,\n"
    else
      swiftContent="$swiftContent\n "
    fi

  done
  swiftContent="$swiftContent\n];"
  swiftContent="$swiftContent\nlet urls = files.compactMap { URL(fileURLWithPath: \$0) };"
  swiftContent="$swiftContent\nlet pasteboard = NSPasteboard.general;"
  swiftContent="$swiftContent\npasteboard.clearContents();"
  swiftContent="$swiftContent\npasteboard.writeObjects(urls as [NSPasteboardWriting]);"


  local swiftRef="/tmp/swiftref.swift"

  echo "swift -e '$swiftContent'"
  echo "$swiftContent" > $swiftRef

  # cd "$currentLocation"

  # Use swift to copy the file reference with metadata to the clipboard
  # swift "$swiftRef"
  swift $swiftRef

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

function refdownloads() {

  local sOutput=$(/bin/ls -1tr $DOWNLOAD_DIRECTORY | tail -n 1)

  if [[ $sOutput ]]; then

    # ref -f "$DOWNLOAD_DIRECTORY/$sOutput"
    refswift -d $DOWNLOAD_DIRECTORY -t 60

    pecho "ref -f \"$DOWNLOAD_DIRECTORY/$sOutput\""

  fi

}


# if there is a new file reference
function refscreenshots() {

  rm -rf $SCREENSHOT_DIRECTORY/.DS_Store
  local sOutput=$(/bin/ls -1tr $SCREENSHOT_DIRECTORY | tail -n 1)

  if [[ $sOutput ]]; then

    refswift -d $SCREENSHOT_DIRECTORY 

    # ref -f "$SCREENSHOT_DIRECTORY/$sOutput"

    pecho "ref -f \"$SCREENSHOT_DIRECTORY/$sOutput\""

  fi

}
