function pxo() {
  currentDir=`pwd`
  j screen
  open .
  cd $currentDir
}

function mpx() {
    echo "mpx $@" > /tmp/debugcommand
#    local fileNameDate=$(date +"%y%m%d%H%M")
    local fileNameDate=$(date +"%y%m%d")
    local fileName=""
    local fileNameFull=$fileName
    local targetDirectory="$MARKDOWN_MEETING_DIRECTORY"
    echo "screen directory $SCREENSHOT_DIRECTORY"
    local screenValue=`lsd -tr1 --classic $SCREENSHOT_DIRECTORY | tail -n 1`
    local modeDate=''
    echo "screen value $screenValue"

    while [[ $# -gt 0 ]]
    do
        key="$1"
        case $key in
            '-notes' )
                targetDirectory="$MARKDOWN_NOTE_DIRECTORY"
                shift
                ;;
            '-d' ) # do not use date
                modeDate='t'
                shift
                ;;
            '-h' )
                targetDirectory=$(pwd)
                shift
                ;;
            '-v' )
                targetDirectory="$2"
                shift
                shift
                ;;
            * )
                # fileName="$fileName${1%.*}-"
                # fileNameFull="$fileNameFull${1%.*}-"
                # need to sort out the paths because vim will include full paths
                # if you're editing from a different directory
                # but the references should always been relative.
                dummyName=$(lastBreadcrumb "$1" "\/" " ")
                fileName="$fileName${dummyName}-"
                fileNameFull="$fileNameFull${dummyName}-"
                shift
                ;;
        esac
    done

    fileName=${fileName%"-"}
    fileNameFull=${fileNameFull%"-"}
    if [[ $modeDate ]]; then
        fileNameFull="${fileNameDate}-${fileNameFull}"
        fileName="${fileNameDate}-${fileName}"
    fi
    fileNameFull="$fileNameFull.png"
    echo "full filename $fileNameFull"
    cp "$SCREENSHOT_DIRECTORY/$screenValue" "${targetDirectory}/${fileNameFull}"
    echo "${SCREENSHOT_DIRECTORY}/${screenValue} => ${targetDirectory}/${fileNameFull}" > /tmp/debug
    echo "cp ./$screenValue => ${targetDirectory}/${fileNameFull}"
    #echo "![${fileName}](${targetDirectory}/${fileNameFull})" | pbcopy
    echo -n "![${fileName}](./${fileNameFull})" | pbcopy
}

function mnote() {

  local fileNameDate=$(date +"%y%m%d")
  local fileName=""
  local modeDate=''
  local targetDirectory="$MARKDOWN_MEETING_DIRECTORY"
  local modeCreateOnly=''

  while [[ $# -gt 0 ]]
  do
    key="$1"
    shift
    case $key in
      '-d' ) # do not use date
        modeDate='t'
        ;;
      '-notes' )
        targetDirectory="$MARKDOWN_NOTE_DIRECTORY"
        ;;
      '-here' )
        targetDirectory=$(pwd)
        ;;
      '-createonly' )
        fileNameDate=$(date +"%y%m%d%H%M")
        modeCreateOnly='t'
        ;;
      * )
        fileName="${fileName}${key}-"
        ;;
    esac
  done

  fileName=${fileName%-}

  pecho "$fileName"
#  echo "$fileName"

  # add date if needed
  if [[ $modeDate ]]; then
      fileName="${fileNameDate}-${fileName}"
  fi
  fileName="${fileName}.md"

  full_file_path="${targetDirectory}/${fileName}"
  pecho $full_file_path
  touch $full_file_path

  if [[ $modeCreateOnly ]]; then
    echo $full_file_path
  else
    nvim $full_file_path
  fi

}

function msearch() {

    fFileSearch=""
    fGrepSearch=""
    fPath=(~/lab/meetings ~/lab/notes ~/lab/presentation)
    oGrepExact=false
    oGrepVerbose=false
    oOpenFile=false
    oOpenFile=false
    oOpenOption=false

    while [[ $# -gt 0 ]]
    do
        key="$1"
        case $key in
            '-o')
                oOpenFile=true
                oOpenOption=true
                shift
                ;;
            '-g')
                oOpenFile=true
                oOpenOption=true
                shift
                ;;
                # exact match
            '-e')
                oGrepExact=true
                shift
                ;;
            '-v')
                oGrepVerbose=true
                shift
                ;;
            * )
                fGrepSearch="$fGrepSearch.*$1"
                fFileSearch="$fFileSearch*$1"
                shift
                ;;
        esac
    done


    if [[ "$oGrepExact" == 'true' ]] ; then
      fFileSearch="${fFileSearch:1}"
    else
      fFileSearch="$fFileSearch*"
    fi
    fGrepSearch="$fGrepSearch.*"


    if [[ "$oOpenOption" == 'false' ]] || [[ "$oOpenOption" == 'true' && "$oOpenFile" == 'true' ]] ; then
        echo "GREP_SEARCH $fGrepSearch FILE_SEARCH $fFileSearch"
        echo "FILES with expression $fFileSearch"
        echo "----------------------------------"
        find $fPath -type f -iname "$fFileSearch"
        echo "----------------------------------\n\n"
        file_results=$(find $fPath -type f -iname "$fFileSearch")
        if [[ "$oOpenFile" = 'true' ]] ; then
          find $fPath -type f -iname "$fFileSearch" | while read single_file; do
              echo "single file \"$single_file\""
              #/usr/bin/open $single_file
              which nvim
              #nvim -R -- "$single_file"
              echo "$single_file" | xargs -o nvim
          done
        fi
    fi


    #if [[ "$oOpenOption" == 'false' ]] || [[ "$oOpenOption" == 'true' && "$oOpenFile" == 'true' ]] ; then
    if [[ "$oGrepVerbose" == 'true' ]] ; then
        echo "GREP with expression"
        echo "----------------------------------"
#        if [[ "$oGrepVerbose" == 'true' ]] ; then
            /usr/bin/grep -ir "$fGrepSearch" $fPath
#        else
#            /usr/bin/grep -irl "$fGrepSearch" $fPath
#        fi
        echo "----------------------------------"

        if [[ "$oOpenFile" == 'true' ]] ; then
          /usr/bin/grep -irl "$fGrepSearch" $fPath | while read single_file; do
              echo "single files nvim $single_file"
              #/usr/bin/open $single_file
              which nvim
              #nvim -R -- "$single_file"
              echo "$single_file" | xargs -o nvim
          done
        fi
    fi
}

function mbrowse() {
    cd ~/lab/meetings
    fzfList=$(fzf --preview="cat {}" --preview-window=right:70%:wrap)
    if (( ${#fzfList[@]} != 0 )); then
       nvim $fzfList
    fi
}

function medit() {
    osascript ~/lab/scripts/applescript/md.scpt
    nvim $1
}

