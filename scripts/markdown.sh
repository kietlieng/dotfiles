SCREENSHOT_DIRECTORY=~/lab/screenshots

function mpx() {
  FILE_NAME=$(date +"%y%m%d%H%M")
  FILE_NAME_FULL=$FILE_NAME
  TARGET_DIRECTORY="$MARKDOWN_MEETING_DIRECTORY"
  SCREEN_VALUE=`ls -ltr1 $SCREENSHOT_DIRECTORY | tail -n 1`
  #echo "$SCREEN_VALUE"

  while [[ $# -gt 0 ]]
  do
    KEY="$1"
    case $KEY in
      '-notes' )
        TARGET_DIRECTORY="$MARKDOWN_NOTE_DIRECTORY"
        shift
        ;;
      '-here' )
        TARGET_DIRECTORY=$(pwd)
        shift
        ;;
      * )
        FILE_NAME="$FILE_NAME-$1"
        FILE_NAME_FULL="$FILE_NAME_FULL-$1"
        shift
        ;;
    esac
  done

  FILE_NAME_FULL="$FILE_NAME_FULL.png"
  cp "$SCREENSHOT_DIRECTORY/$SCREEN_VALUE" "${TARGET_DIRECTORY}/${FILE_NAME_FULL}"
  #echo "${SCREENSHOT_DIRECTORY}/${SCREEN_VALUE} => ${TARGET_DIRECTORY}/${FILE_NAME_FULL}"
  echo "./$SCREEN_VALUE => ${TARGET_DIRECTORY}/${FILE_NAME_FULL}"
  #echo "![${FILE_NAME}](${TARGET_DIRECTORY}/${FILE_NAME_FULL})" | pbcopy
  echo "![${FILE_NAME}](./${FILE_NAME_FULL})" | pbcopy
}

function mnote() {
  FILE_NAME_DATE=$(date +"%y%m%d%H")
  FILE_NAME=""
  USE_DATE=true
  TARGET_DIRECTORY="$MARKDOWN_MEETING_DIRECTORY"

  while [[ $# -gt 0 ]]
  do
    KEY="$1"
    case $KEY in
      '-d' ) # do not use date
        USE_DATE=false
        shift
        ;;
      '-notes' )
        TARGET_DIRECTORY="$MARKDOWN_NOTE_DIRECTORY"
        shift
        ;;
      '-here' )
        TARGET_DIRECTORY=$(pwd)
        shift
        ;;
      * )
        FILE_NAME="${FILE_NAME}${1}-"
        shift
        ;;
    esac
  done

  FILE_NAME=${FILE_NAME%"-"}
  # add date if needed
  if [ $USE_DATE = 'true' ]; then
    FILE_NAME="${FILE_NAME_DATE}-${FILE_NAME}"
  fi
  FILE_NAME="${FILE_NAME}.md"

  full_file_path="${TARGET_DIRECTORY}/${FILE_NAME}"
  echo $full_file_path
  touch $full_file_path
  open $full_file_path

}

function msearch() {

    F_FILE_SEARCH=""
    F_GREP_SEARCH=""
    F_PATH=(/Users/klieng/lab/meetings /Users/klieng/lab/notes /Users/klieng/lab/presentation)
    O_GREP_EXACT=false
    O_GREP_VERBOSE=false
    O_OPEN_FILE=false
    O_OPEN_GREP=false
    O_OPEN_OPTION=false

    while [[ $# -gt 0 ]]
    do
        KEY="$1"
        case $KEY in
            '-o')
                O_OPEN_FILE=true
                O_OPEN_OPTION=true
                shift
                ;;
            '-g')
                O_OPEN_GREP=true
                O_OPEN_OPTION=true
                shift
                ;;
                # exact match
            '-e')
                O_GREP_EXACT=true
                shift
                ;;
            '-v')
                O_GREP_VERBOSE=true
                shift
                ;;
            * )
                F_GREP_SEARCH="$F_GREP_SEARCH.*$1"
                F_FILE_SEARCH="$F_FILE_SEARCH*$1"
                shift
                ;;
        esac
    done


    if [[ "$O_GREP_EXACT" == 'true' ]] ; then
      F_FILE_SEARCH="${F_FILE_SEARCH:1}"
    else
      F_FILE_SEARCH="$F_FILE_SEARCH*"
    fi
    F_GREP_SEARCH="$F_GREP_SEARCH.*"


    if [[ "$O_OPEN_OPTION" == 'false' ]] || [[ "$O_OPEN_OPTION" == 'true' && "$O_OPEN_FILE" == 'true' ]] ; then
        echo "GREP_SEARCH $F_GREP_SEARCH FILE_SEARCH $F_FILE_SEARCH"
        echo "FILES with expression $F_FILE_SEARCH"
        echo "----------------------------------"
        find $F_PATH -type f -iname "$F_FILE_SEARCH"
        echo "----------------------------------\n\n"
        file_results=$(find $F_PATH -type f -iname "$F_FILE_SEARCH")
        if [[ "$O_OPEN_FILE" = 'true' ]] ; then
          find $F_PATH -type f -iname "$F_FILE_SEARCH" | while read single_file; do
              echo "$single_file"
              /usr/bin/open $single_file
          done
        fi
    fi


    #if [[ "$O_OPEN_OPTION" == 'false' ]] || [[ "$O_OPEN_OPTION" == 'true' && "$O_OPEN_GREP" == 'true' ]] ; then
    if [[ "$O_GREP_VERBOSE" == 'true' ]] ; then
        echo "GREP with expression"
        echo "----------------------------------"
#        if [[ "$O_GREP_VERBOSE" == 'true' ]] ; then
            /usr/bin/grep -ir "$F_GREP_SEARCH" $F_PATH
#        else
#            /usr/bin/grep -irl "$F_GREP_SEARCH" $F_PATH
#        fi
        echo "----------------------------------"

        if [[ "$O_OPEN_GREP" == 'true' ]] ; then
          /usr/bin/grep -irl "$F_GREP_SEARCH" $F_PATH | while read single_file; do
              echo "single files $single_file"
              /usr/bin/open $single_file
          done
        fi
    fi
}

function mbrowse() {
    cd ~/lab/meetings
    fzf_list=$(fzf --preview="cat {}" --preview-window=right:70%:wrap)
       if (( ${#fzf_list[@]} != 0 )); then
       vim $fzf_list
   fi
}
