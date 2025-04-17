alias refassemble='ref -f "/tmp/assemble-dependencies.csv"'
alias rreact='ref -react'
alias cfiles="cat /tmp/swiftprep.txt"
alias refsetc="refset -c"

function reftime() {
  
  local downloadTime=$(cat $DOWNLOAD_TIME_FILE)
  local screenshotTime=$(cat $SCREENSHOT_TIME_FILE)
  local setScreenshot='t'
  
  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in

      '-d') 

        echo -n "$1" > $DOWNLOAD_TIME_FILE
        shift
        ;;

      '-s')

        echo -n "$1" > $SCREENSHOT_TIME_FILE
        shift
        ;;

      *) 

        pecho "pass"
        if [[ $setScreenshot == 't' ]]; then
          
          echo -n "$key" > $SCREENSHOT_TIME_FILE
          setScreenshot='f'

        else

          echo -n "$key" > $DOWNLOAD_TIME_FILE

        fi
        ;;

    esac

  done

  echo -n "screenshots: ($(cat $SCREENSHOT_TIME_FILE)) / "
  echo "downloads: ($(cat $DOWNLOAD_TIME_FILE)) "

}

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
  local optionGrabLastIfNone='f'
  local optionTime='5'
  local optionSeconds=$(($optionTime * 60))
  local swiftPrepFile="/tmp/swiftprep.txt"
  local hasAny='f'

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in

      '-t') # time in minutes
        optionTime="$1"
        optionSeconds=$(($optionTime * 60))
        shift
        ;;

      '-d') # directory
        optionDir="$1"
        shift
        ;;

      '-c') # clear directory
        echo -n "" > $swiftPrepFile
        ;;

      '-l') # get at least 1
        optionGrabLastIfNone='t'
        ;;

      *) 
        pecho "set current value"
        ;;

    esac

  done

  # cd "$optionDir"

  local swiftContent=""

  # local lastFile=$(find $optionDir -mmin "-$optionTime" | tail -n 1)
    
  # find /path/to/dir -type f -exec stat -f "%B %N" {} \; | awk -v now="$(date +%s)" '$1 > now - 1800'
  # find $optionDir -type f -mmin "-$optionTime" | while read currentFile
  # find $optionDir -type f -exec stat -f "%B %N" {} \; | awk -v now="$(date +%s)" -v interval="$optionSeconds" '$1 > now - interval' | while read currentFile
  # echo "before"

  find $optionDir -type f -mmin "-$optionTime" | while read currentFile
  do
    echo "$optionTime referencing $currentFile"
    if [[ "$currentFile" != *.DS_Store* ]]; then 
      echo "$optionTime $currentFile"
      swiftContent="$swiftContent\n \"$currentFile\","
      hasAny='t'
    fi

  done
  # echo "before"

  # echo  "$optionGrabLastIfNone $hasAny"
  # if we want at least 1 reference.  Check to see if any references was made in last loop
  # if there isn't get last modified file
  if [[ "$optionGrabLastIfNone" == 't' && "$hasAny" == 'f' ]]; then
   
    local sOutput=$(/bin/ls -1tr $optionDir | tail -n 1)
  
    if [[ $sOutput ]]; then

      swiftContent="$swiftContent\n \"$optionDir/$sOutput\","

    fi

  fi

  if [[ $swiftContent ]]; then
    echo -n "$swiftContent" >> $swiftPrepFile
  fi

}


# swift can take a time limit to reference multiple files
function refprepswift() {

  # Define the file path you want to copy

  local key=''
  local optionDir=""
  local optionTime="5"

  local swiftPrepFile="/tmp/swiftprep.txt"
  local swiftRef="/tmp/swiftref.swift"

  local preppedContent=$(cat $swiftPrepFile)

  # if you can't find any values set to empty and return
  if [[ "$preppedContent" == "" ]]; then
    echo -n "" | pbcopy
    return;
  fi

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

  echo "find $optionDir -mmin \"-$optionTime\" "

  local swiftContent="import AppKit;"
  swiftContent="$swiftContent\nlet files = ["
  local isFound="0"

  # local lastFile=$(find $optionDir -mmin "-$optionTime" | tail -n 1)
    
  # find $optionDir -type f -mmin "-$optionTime" | while read currentFile
  find $optionDir -type f -mmin "-$optionTime" | while read currentFile
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

function refsetprep() {

  local optionDir="$SCREENSHOT_DIRECTORY"
  local optionResults="$REF_RESULTS"
  local optionResultsTmp="$REF_RESULTS_TMP"
  local optionTime='1'

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in

      '-d') # directory
        optionDir="$1"
        shift
        ;;

      '-t') # clear directory
        optionTime="$1"
        shift
        ;;

      '-c') # get at least 1
        echo -n "" > $optionResults
        echo -n "" > $optionResultsTmp
        ;;

      *) 
        pecho "set current value"
        ;;

    esac

  done

  find $optionDir -type f -mtime "-$optionTime" | while read file; do

    mod_time=$(stat -f "%m" "$file")
    now=$(date +%s)
    diff_min=$(( (now - mod_time) / 60 ))
    # echo "$diff_min $file"
    printf "%05d \"%s\"\n" "$diff_min" "$file" 

  done >> $optionResultsTmp

  # cat $optionResultsTmp

}

function refset() {

  local optionResults="$REF_RESULTS"
  local optionResultsTmp="$REF_RESULTS_TMP"
  local currentMinute=''
  local currentDirectory=''
  local foundDownload=''
  local timeDownload="$(cat $DOWNLOAD_TIME_FILE)"
  local foundScreenshot=''
  local timeScreenshot="$(cat $SCREENSHOT_TIME_FILE)"
  local refsetClear=''
  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in

      '-c') # clear
        timeDownload='0'
        timeScreenshot='0'
        refsetClear='t'
        ;;

      *) 
        pecho "set current value"
        ;;

    esac

  done

  refsetprep -c && refsetprep -d $DOWNLOAD_DIRECTORY -t 7
  cat $optionResultsTmp | sort > $optionResults

  cat $optionResults | fzf --multi | while read currentFile; do 

    currentMinute=$(echo "$currentFile" | awk '{print $1 }')
    currentDirectory=$(echo "$currentFile" | awk '{print $2 }')
    # echo "currentFile $currentFile | $currentMinute | $currentDirectory"

    if [[ "$currentFile" = *$DOWNLOAD_DIRECTORY* ]]; then
      echo "is download"

      if [[ -z "$foundDownload" ]]; then
        timeDownload=$currentMinute
        foundDownload='t'
      fi

    elif [[ "$currentFile" = *$SCREENSHOT_DIRECTORY* ]]; then
      echo "is screenshot"

      if [[ -z "$foundScreenshot" ]]; then
        timeScreenshot=$currentMinute
        foundScreenshot='t'
      fi

    fi

  done

  # if it's not set to clear then increment
  if [[ -z "$refsetClear" ]]; then
    echo "increment"

    # only increment went found
    if [[ -n "$foundDownload" ]]; then
      timeDownload="${timeDownload#"${timeDownload%%[!0]*}"}"
      ((timeDownload++))
    fi

    # only increment when found
    if [[ -n "$foundScreenshot" ]]; then
      timeScreenshot="${timeScreenshot#"${timeScreenshot%%[!0]*}"}"
      ((timeScreenshot++))
    fi

  fi

  echo "timeDownload: $timeDownload screenshot: $timeScreenshot"
  reftime -d $timeDownload -s $timeScreenshot

}
