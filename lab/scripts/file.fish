alias refassemble='frfile -f "/tmp/assemble-dependencies.csv"'
alias rreact='frfile -react'
alias cfiles="cat /tmp/swiftprep.txt"

# wipe out referenc and only get screenshots less that 1 minute
alias frc="frtime 1 0"

alias creset="frtime -s 10 -d 60"

function frtime
  
  set downloadTime $(cat $DOWNLOAD_TIME_FILE)
  set screenshotTime $(cat $SCREENSHOT_TIME_FILE)
  set setScreenshot 't'
  
  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch  "$key" 

      case '-d' 

        echo -n "$argv[1]" > $DOWNLOAD_TIME_FILE
        set argv $argv[2..-1]
        

      case '-s'

        echo -n "$argv[1]" > $SCREENSHOT_TIME_FILE
        set argv $argv[2..-1]
        

      case '*'

        pecho "pass"
        if [ "$setScreenshot" = 't' ]
          
          echo -n "$key" > $SCREENSHOT_TIME_FILE
          set setScreenshot 'f'

        else

          echo -n "$key" > $DOWNLOAD_TIME_FILE

        end
        

    end

  end

  echo -n "screenshots: ($(cat $SCREENSHOT_TIME_FILE)) / "
  echo "downloads: ($(cat $DOWNLOAD_TIME_FILE)) "

end

function runosa
  osascript -e "$argv[1]"
end

function frinspect
  osascript -e 'the clipboard as record'
end

function rreact

  set filePath $(/bin/ls -1 $DIR_REACTION/$argv[1]* | head -n 1)

  # Use osascript to copy the file reference with metadata to the clipboard
  osascript -e "
  tell application \"Finder\"
      set theFile to POSIX file \"$filePath\" as alias
      set the clipboard to (theFile as «class furl»)
  end tell"

end

# reference a file
function frfile

  set currentLocation $(pwd)
  # Define the file path you want to copy

  set filePath "$currentLocation/$argv[1]"  # Replace this with the actual file path
  set key ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch  "$key" 
      case '-f' 
        set filePath "$argv[1]"
        set argv $argv[2..-1]
        
      case '-react'
        set filePath $(/bin/ls -1 $DIR_REACTION/$argv[1]* | head -n 1)
        set argv $argv[2..-1]
        
      case '*'
        pecho "set current value"
        set filePath "$currentLocation/$key"  # Replace this with the actual file path
        
    end

  end

  # Use osascript to copy the file reference with metadata to the clipboard
  osascript -e "
  tell application \"Finder\"
      set theFile to POSIX file \"$filePath\" as alias
      set the clipboard to (theFile as «class furl»)
  end tell"

end

function frprepfiles

  # Define the file path you want to copy

  set key ''
  set optionDir ''
  set optionGrabLastIfNone 'f'
  set optionTime '5'
  set optionSeconds (math $optionTime x 60)
  set swiftPrepFile "/tmp/swiftprep.txt"
  set hasAny 'f'

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch  "$key" 

      case '-t' # time in minutes
        set optionTime "$argv[1]"
        set optionSeconds (math $optionTime x 60)
        set argv $argv[2..-1]

      case '-d' # directory
        set optionDir "$argv[1]"
        set argv $argv[2..-1]

      case '-c' # clear directory
        echo -e -n "" > $swiftPrepFile

      case '-l' # get at least 1
        set optionGrabLastIfNone 't'

      case '*'
        pecho "set current value"

    end

  end

  # cd "$optionDir"

  set swiftContent ""

  # set lastFile $(find $optionDir -mmin "-$optionTime" | tail -n 1)

  # find /path/to/dir -type f -exec stat -f "%B %N" {} \; | awk -v now="$(date +%s)" '$1 > now - 1800'
  # find $optionDir -type f -mmin "-$optionTime" | while read currentFile
  # find $optionDir -type f -exec stat -f "%B %N" {} \; | awk -v now="$(date +%s)" -v interval="$optionSeconds" '$1 > now - interval' | while read currentFile
  # echo "before"

  find $optionDir -type f -mmin "-$optionTime" | while read currentFile
    echo "$optionTime referencing $currentFile"
    if string match -ivq "*.DS_Store*" $currentFile
      echo -e "$optionTime $currentFile"
      set swiftContent "$swiftContent\n \"$currentFile\","
      set hasAny 't'
    end

  end
  # echo "before"

  # echo  "$optionGrabLastIfNone $hasAny"
  # if we want at least 1 reference.  Check to see if any references was made in last loop
  # if there isn't get last modified file
  if [ "$optionGrabLastIfNone" = 't' ]
    and [ "$hasAny" = 'f' ]

    set sOutput $(/bin/ls -1tr $optionDir | tail -n 1)

    if [ $sOutput ]

      set swiftContent "$swiftContent\n \"$optionDir/$sOutput\","

    end

  end

  if [ $swiftContent ]
    echo -e -n "$swiftContent" >> $swiftPrepFile
  end

end


# swift can take a time limit to reference multiple files
function frprepswift

  # Define the file path you want to copy

  set key ''
  set optionDir ""
  set optionTime "5"

  set swiftPrepFile "/tmp/swiftprep.txt"
  set swiftRef "/tmp/swiftref.swift"

  set preppedContent $(cat $swiftPrepFile)

  # if you can't find any values set to empty and return
  if [ "$preppedContent" = "" ]
    echo -n "" | pbcopy
    return
  end

  echo -n "" > $swiftRef

  set swiftContent "import AppKit;"
  set swiftContent "$swiftContent\nlet files = [\n"

  echo -e -n "$swiftContent" > $swiftRef
  cat $swiftPrepFile >> $swiftRef

  #kl here
  set swiftContent "\n];"
  set swiftContent "$swiftContent\nlet urls = files.compactMap { URL(fileURLWithPath: \$0) };"
  set swiftContent "$swiftContent\nlet pasteboard = NSPasteboard.general;"
  set swiftContent "$swiftContent\npasteboard.clearContents();"
  set swiftContent "$swiftContent\npasteboard.writeObjects(urls as [NSPasteboardWriting]);"

  echo -e -n "$swiftContent" >> $swiftRef

  # Use swift to copy the file reference with metadata to the clipboard
  # swift "$swiftRef"
  swift $swiftRef

end

# swift can take a time limit to reference multiple files
function frswift

  # Define the file path you want to copy

  set key ''
  set optionDir ""
  set optionTime "5"

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch  "$key" 

      case '-t' # time in minutes
        set optionTime "$argv[1]"
        set argv $argv[2..-1]
        

      case '-d' # directory
        set optionDir "$argv[1]"
        set argv $argv[2..-1]
        

      case '*'
        pecho "set current value"
        
    end

  end

  # cd "$optionDir"

  echo "find $optionDir -mmin \"-$optionTime\" "

  set swiftContent "import AppKit;"
  set swiftContent "$swiftContent\nlet files = ["
  set isFound "0"

  # set lastFile $(find $optionDir -mmin "-$optionTime" | tail -n 1)
    
  # find $optionDir -type f -mmin "-$optionTime" | while read currentFile
  find $optionDir -type f -mmin "-$optionTime" | while read currentFile
    
    if string match -ivq "*.DS_stare*" $currentFile
      # echo "referencing $currentFile"
      set swiftContent "$swiftContent\n\"$currentFile\",\n"
      set isFound "1"
    end

  end

  # if you can't find any values set to empty and return
  if [ "$isFound" = "0" ]
    echo -n "" | pbcopy
    return
  end

  set swiftContent "$swiftContent\n];"
  set swiftContent "$swiftContent\nlet urls = files.compactMap { URL(fileURLWithPath: \$0) };"
  set swiftContent "$swiftContent\nlet pasteboard = NSPasteboard.general;"
  set swiftContent "$swiftContent\npasteboard.clearContents();"
  set swiftContent "$swiftContent\npasteboard.writeObjects(urls as [NSPasteboardWriting]);"


  set swiftRef "/tmp/swiftref.swift"

  echo -e "swift -e '$swiftContent'"
  echo -e "$swiftContent" > $swiftRef

  # Use swift to copy the file reference with metadata to the clipboard
  # swift "$swiftRef"
  swift $swiftRef

end

function frdownloads

  set sOutput $(/bin/ls -1tr $DOWNLOAD_DIRECTORY | tail -n 1)

  if [ $sOutput ]

    # ref -f "$DOWNLOAD_DIRECTORY/$sOutput"
    frswift -d $DOWNLOAD_DIRECTORY -t 60

    pecho "frfile -f \"$DOWNLOAD_DIRECTORY/$sOutput\""

  end

end

# if there is a new file reference
function frscreenshots

  rm -rf $SCREENSHOT_DIRECTORY/.DS_Store
  set sOutput $(/bin/ls -1tr $SCREENSHOT_DIRECTORY | tail -n 1)

  if [ $sOutput ]

    frswift -d $SCREENSHOT_DIRECTORY 

    # frfile -f "$SCREENSHOT_DIRECTORY/$sOutput"

    pecho "frfile -f \"$SCREENSHOT_DIRECTORY/$sOutput\""

  end

end

function frprep

  set optionDir "$SCREENSHOT_DIRECTORY"
  set optionResults "$REF_RESULTS"
  set optionResultsTmp "$REF_RESULTS_TMP"
  set optionTime '1'

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch  "$key" 

      case '-d' # directory
        set optionDir "$argv[1]"
        set argv $argv[2..-1]
        

      case '-t' # clear directory
        set optionTime "$argv[1]"
        set argv $argv[2..-1]
        

      case '-c' # get at least 1
        echo -n "" > $optionResults
        echo -n "" > $optionResultsTmp
        

      case '*'
        pecho "set current value"
        
    end

  end

  find $optionDir -type f -mtime "-$optionTime" | while read file

    set mod_time $(stat -f "%m" "$file")
    set now $(date +%s)
    set diff_min (math (math now - mod_time) / 60)
    # echo "$diff_min $file"
    printf "%05d \"%s\"\n" "$diff_min" "$file" 

  end >> $optionResultsTmp

  # cat $optionResultsTmp

end

# copy reference
function fr

  set optionResults "$REF_RESULTS"
  set optionResultsTmp "$REF_RESULTS_TMP"
  set currentMinute ''
  set currentDirectory ''
  set foundDownload ''
  set timeDownload "$(cat $DOWNLOAD_TIME_FILE)"
  set foundScreenshot ''
  set timeScreenshot "$(cat $SCREENSHOT_TIME_FILE)"
  set refsetClear ''
  set key ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch  "$key" 

      case '-c' # clear time reference
        set timeDownload '0'
        set timeScreenshot '1'
        set refsetClear 't'

      case '*'
        pecho "set current value"

    end

  end

  frprep -c && frprep -d $DOWNLOAD_DIRECTORY -t 7
  cat $optionResultsTmp | sort > $optionResults

  cat $optionResults | fzf --multi | while read currentFile

    set currentMinute $(echo "$currentFile" | awk '{print $1 }')
    set currentDirectory $(echo "$currentFile" | awk '{print $2 }')
    # echo "currentFile $currentFile | $currentMinute | $currentDirectory"

    if string match -iq "*$DOWNLOAD_DIRECTORY*" $currentFile
      echo "is download"

      if [ $foundDownload ]
        set timeDownload $currentMinute
        set foundDownload 't'
      end

    else if string match -iq "*$SCREENSHOT_DIRECTORY*" $currentFile

      if [ $foundScreenshot ]
        set timeScreenshot $currentMinute
        set foundScreenshot 't'
      end

    end

  end

  # only increment when found
  if [ "$foundDownload" ]
    #set timeDownload "${timeDownload#"${timeDownload%%[!0]*}"}"
    set timeDownload $timeDownload
    set timeDownload (math $timeDownload + 1)
  end

  # only increment when found
  if [ $foundScreenshot ]
    # echo "blah screenshot"
    # kl don't know what to do
    # set timeScreenshot "${timeScreenshot#"${timeScreenshot%%[!0]*}"}"
    set timeScreenshot $timeScreenshot
    set timeScreenshot (math $timeScreenshot + 1)
  end

  echo "screenshots: $timeScreenshot download: $timeDownload"
  frtime -d $timeDownload -s $timeScreenshot

end
