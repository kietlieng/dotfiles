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

function refprepfiles() {

  # Define the file path you want to copy

  local key=''
  local optionDir=''
  local optionTime='5'
  local swiftPrepFile="/tmp/swiftprep.txt"

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

      '-c') # clear directory
        echo -n "" > $swiftPrepFile
        ;;

      *) 
        pecho "set current value"
        ;;

    esac

  done

  # cd "$optionDir"

  local swiftContent=""

  # local lastFile=$(find $optionDir -cmin "-$optionTime" | tail -n 1)
    
  find $optionDir -type f -cmin "-$optionTime" | while read currentFile
  do
    echo "$optionTime referencing $currentFile"
    if [[ "$currentFile" != *.DS_Store* ]]; then 
      echo "$optionTime $currentFile"
      swiftContent="$swiftContent\n \"$currentFile\","
    fi

  done

  echo -n "$swiftContent" >> $swiftPrepFile

}


# swift can take a time limit to reference multiple files
function refprepswift() {

  # Define the file path you want to copy

  local key=''
  local optionDir=""
  local optionTime="5"

  local swiftPrepFile="/tmp/swiftprep.txt"
  local swiftRef="/tmp/swiftref.swift"


  echo -n "" > $swiftRep

  local swiftContent="import AppKit;"
  swiftContent="$swiftContent\nlet files = ["

  echo -n "$swiftContent" > $swiftRef
  cat $swiftPrepFile >> $swiftRef

  swiftContent="\n];"
  swiftContent="$swiftContent\nlet urls = files.compactMap { URL(fileURLWithPath: \$0) };"
  swiftContent="$swiftContent\nlet pasteboard = NSPasteboard.general;"
  swiftContent="$swiftContent\npasteboard.clearContents();"
  swiftContent="$swiftContent\npasteboard.writeObjects(urls as [NSPasteboardWriting]);"

  echo -n "$swiftContent" >> $swiftRef

  # Use swift to copy the file reference with metadata to the clipboard
  # swift "$swiftRef"
  swift $swiftRef

}

# swift can take a time limit to reference multiple files
function refswift() {

  # Define the file path you want to copy

  local key=''
  local optionDir=""
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

      *) 
        pecho "set current value"
        ;;
    esac

  done

  # cd "$optionDir"

  echo "find $optionDir -cmin \"-$optionTime\" "

  local swiftContent="import AppKit;"
  swiftContent="$swiftContent\nlet files = ["
  local isFound="0"

  # local lastFile=$(find $optionDir -cmin "-$optionTime" | tail -n 1)
    
  # find $optionDir -type f -cmin "-$optionTime" | while read currentFile
  find $optionDir -type f -cmin "-$optionTime" | while read currentFile
  do
    
    if [[ "$currentFile" != *.DS_Store* ]]; then 
      # echo "referencing $currentFile"
      swiftContent="$swiftContent\n\"$currentFile\",\n"
      isFound="1";
    fi

  done

  # if you can't find any values set to empty and return
  if [[ "$isFound" == "0" ]]; then
    echo -n "" | pbcopy
    return;
  fi

  swiftContent="$swiftContent\n];"
  swiftContent="$swiftContent\nlet urls = files.compactMap { URL(fileURLWithPath: \$0) };"
  swiftContent="$swiftContent\nlet pasteboard = NSPasteboard.general;"
  swiftContent="$swiftContent\npasteboard.clearContents();"
  swiftContent="$swiftContent\npasteboard.writeObjects(urls as [NSPasteboardWriting]);"


  local swiftRef="/tmp/swiftref.swift"

  echo "swift -e '$swiftContent'"
  echo "$swiftContent" > $swiftRef

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
