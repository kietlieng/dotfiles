function pxo

  set currentDir $PWD
  j screen
  open .
  cd $currentDir

end

function mpx

  pecho "mpx $argv"
#    set --local fileNameDate $(date +"%y%m%d%H%M")
  set --local fileNameDate $(date +"%y%m%d")
  set --local fileName ""
  set --local fileNameFull $fileName
  set --local targetDirectory "$MARKDOWN_MEETING_DIRECTORY"
  # echo "screen directory $SCREENSHOT_DIRECTORY"
  set --local screenValue (ls -1tr $SCREENSHOT_DIRECTORY | tail -n 1 | sed "s/'//g")

  set --local modeDate 't'
  # echo "screen value $screenValue"

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch  $key 
      case '-notes'
        set targetDirectory "$MARKDOWN_NOTE_DIRECTORY"

      case '-d' # do not use date
        set modeDate ''

      case '-h'
        set targetDirectory $(pwd)

      case '-v'
        set targetDirectory "$argv[1]"
        set argv $argv[2..-1]

      case '*'
        # set fileName "$fileName${1%.*}-"
        # set fileNameFull "$fileNameFull${1%.*}-"
        # need to sort out the paths because vim will include full paths
        # if you're editing from a different directory
        # but the references should always been relative.
        # echo "key |$key|"
        set dummyName (lastBreadcrumb "$key" "\/" " ")
        # echo "fullname |$fileName|"
        # echo "dummyName |$dummyName|"
        # echo "fullnamefull |$fileNameFull|"
        set fileName "$fileName$dummyName-"
        set fileNameFull "$fileNameFull$dummyName-"

    end
  end

  set fileName (string trim -r '-' $fileName)

  # echo "2fileName |$fileName|"
  # echo "2fileNameFull |$fileNameFull|"

  set fileNameFull (string trim -c '-' $fileNameFull)

  # echo "3fullNameFull |$fileNameFull|"

  if [ $modeDate ]
    set fileNameFull "$fileNameDate-$fileNameFull"
    set fileName "$fileNameDate-$fileName"
  end

  set fileNameFull "$fileNameFull.png"
  # echo "full filename $fileNameFull"
  pecho "$SCREENSHOT_DIRECTORY/$screenValue => $targetDirectory/$fileNameFull"
  echo "$SCREENSHOT_DIRECTORY/$screenValue => $targetDirectory/$fileNameFull"
  cp "$SCREENSHOT_DIRECTORY/$screenValue" "$targetDirectory/$fileNameFull"
  #echo "![$fileName]($targetDirectory/$fileNameFull)" | pbcopy
  echo -n "![$fileName](./$fileNameFull)" | pbcopy

end

function mnote

  set --local fileNameDate $(date +"%y%m%d")
  set --local fileName ""
  set --local modeDate 't'
  set --local targetDirectory "$MARKDOWN_MEETING_DIRECTORY"
  set --local modeCreateOnly ''

  while test (count $argv) -gt 0
    set key "$argv[1]"
    set argv $argv[2..-1]
    switch  $key 
      case '-d' # do not use date
        set modeDate ''
        
      case '-notes'
        set targetDirectory "$MARKDOWN_NOTE_DIRECTORY"
        
      case '-here'
        set targetDirectory $(pwd)
        
      case '-createonly'
        set fileNameDate $(date +"%y%m%d%H%M")
        set modeCreateOnly 't'
        
      case '*'
        set fileName "$fileName$key-"
        
    end
  end

  set fileName (string trim -r '-' $fileName)

  pecho "$fileName"
#  echo "$fileName"

  # add date if needed
  if [[ $modeDate ]]; then
      set fileName "$fileNameDate-$fileName"
  end
  set fileName "$fileName.md"

  set full_file_path "$targetDirectory/$fileName"
  pecho "$full_file_path"

  if [[ $modeCreateOnly ]]; then # only echo it out without creating a file
    echo "$full_file_path"
  else
    nvim "$full_file_path" # only edit do not create ahead of time
  end

end

function msearch

  set fFileSearch ""
  set fGrepSearch ""
  set fPath (~/lab/meetings ~/lab/notes ~/lab/presentation)
  set oGrepExact false
  set oGrepVerbose false
  set oOpenFile false
  set oOpenFile false
  set oOpenOption false

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch  $key 
      case '-o'
        set oOpenFile true
        set oOpenOption true
      case '-g'
        set oOpenFile true
        set oOpenOption true
        # exact match
      case '-e'
        set oGrepExact true

      case '-v'
        set oGrepVerbose true

      case '*'
        set fGrepSearch "$fGrepSearch.*$argv[1]"
        set fFileSearch "$fFileSearch*$argv[1]"

    end
  end


    if [ "$oGrepExact" == 'true' ]
      set fFileSearch $fFileSearch[2..-1]
    else
      set fFileSearch "$fFileSearch*"
    end
    set fGrepSearch "$fGrepSearch.*"


    if [ "$oOpenOption" = 'false' ] 
      or [ "$oOpenOption" == 'true' ] and [ "$oOpenFile" == 'true' ]
        echo "GREP_SEARCH $fGrepSearch FILE_SEARCH $fFileSearch"
        echo "FILES with expression $fFileSearch"
        echo "----------------------------------"
        find $fPath -type f -iname "$fFileSearch"
        echo "----------------------------------\n\n"
        set file_results $(find $fPath -type f -iname "$fFileSearch")
        if [[ "$oOpenFile" = 'true' ]] ; then
          find $fPath -type f -iname "$fFileSearch" | while read single_file; do
            echo "single file \"$single_file\""
            #/usr/bin/open $single_file
            which nvim
            #nvim -R -- "$single_file"
            echo "$single_file" | xargs -o nvim
          end
        end
    end


    #if [[ "$oOpenOption" == 'false' ]] || [[ "$oOpenOption" == 'true' && "$oOpenFile" == 'true' ]] ; then
    if [ "$oGrepVerbose" == 'true' ]
      echo "GREP with expression"
      echo "----------------------------------"
      #        if [ "$oGrepVerbose" == 'true' ]
      /usr/bin/grep -ir "$fGrepSearch" $fPath
      #        else
      #            /usr/bin/grep -irl "$fGrepSearch" $fPath
      #        end
      echo "----------------------------------"

      if [ "$oOpenFile" = 'true' ]
        /usr/bin/grep -irl "$fGrepSearch" $fPath | while read single_file; do
        echo "single files nvim $single_file"
        #/usr/bin/open $single_file
        which nvim
        #nvim -R -- "$single_file"
        echo "$single_file" | xargs -o nvim
      end
    end
  end

end

function mbrowse

    cd ~/lab/meetings
    set fzfList $(fzf --preview="cat {}" --preview-window=right:70%:wrap)
    if test (count $fzfList) -nq 0
       nvim $fzfList
    end

end

function medit

    osascript ~/lab/scripts/applescript/md.scpt
    nvim $argv[1]

end
