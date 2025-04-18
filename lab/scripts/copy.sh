alias refassemble='cpfile -f "/tmp/assemble-dependencies.csv"'
alias rreact='cpfile -react'
alias cfiles="cat /tmp/swiftprep.txt"
alias cprc="cpr -c"
alias cpreset="cptime -d 60 -s 10"

function cptime() {
  
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

function cpinspect() {
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
function cpfile() {

  local currentLocation=$(pwd)
  # Define the file path you want to copy

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

function cpprepfiles() {

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
function cpprepswift() {

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

  echo -n "" > $swiftRef

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
function cpswift() {

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

function cpdownloads() {

  local sOutput=$(/bin/ls -1tr $DOWNLOAD_DIRECTORY | tail -n 1)

  if [[ $sOutput ]]; then

    # ref -f "$DOWNLOAD_DIRECTORY/$sOutput"
    cpswift -d $DOWNLOAD_DIRECTORY -t 60

    pecho "cpfile -f \"$DOWNLOAD_DIRECTORY/$sOutput\""

  fi

}

# if there is a new file reference
function cpscreenshots() {

  rm -rf $SCREENSHOT_DIRECTORY/.DS_Store
  local sOutput=$(/bin/ls -1tr $SCREENSHOT_DIRECTORY | tail -n 1)

  if [[ $sOutput ]]; then

    cpswift -d $SCREENSHOT_DIRECTORY 

    # cpfile -f "$SCREENSHOT_DIRECTORY/$sOutput"

    pecho "cpfile -f \"$SCREENSHOT_DIRECTORY/$sOutput\""

  fi

}

function cprprep() {

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

function cpr() {

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

  cprprep -c && cprprep -d $DOWNLOAD_DIRECTORY -t 7
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
        echo "is screenshot"
        timeScreenshot=$currentMinute
        foundScreenshot='t'
      fi

    fi

  done

  # only increment went found
  if [[ -n "$foundDownload" ]]; then
    timeDownload="${timeDownload#"${timeDownload%%[!0]*}"}"
    ((timeDownload++))
  fi

  # only increment when found
  if [[ -n "$foundScreenshot" ]]; then
    echo "blah screenshot"
    timeScreenshot="${timeScreenshot#"${timeScreenshot%%[!0]*}"}"
    ((timeScreenshot++))
  fi

  echo "screenshots: $timeScreenshot download: $timeDownload"
  cptime -d $timeDownload -s $timeScreenshot

}
