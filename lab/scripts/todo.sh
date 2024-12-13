alias don="dsetting on"
alias ddone="d -editdone"
alias doff="dsetting off"
alias dx="d -done"
alias de="d -edit"
alias dchange="d -change"

export DATE_FORMAT_TODO='%y-%m-%d'

function dgetdate() {

  # date -j -v +1d -f "%y/%m/%d" "$currentDate" "+%Y-%m-%d"

  if [[ $# -eq 0 ]]; then
    date  "+$DATE_FORMAT_TODO"
    return
  fi

  local targetChange="$1"
  local targetDate="$2"

  # tranform date based on current
  #echo "date -j -v \"$1\" -f \"$DATE_FORMAT_TODO\" \"$2\" \"+$DATE_FORMAT_TODO\""
  date -j -v "$targetChange" -f "$DATE_FORMAT_TODO" "$targetDate" "+$DATE_FORMAT_TODO"

}

# todo
function d() {

  local currentDateStatic=$(dgetdate)
  local currentDate=$currentDateStatic

  local currentToDo=$FILE_TODO
  local lastSave=''
  local modeAbsolute=''
  local modeAdd=''
  local modeUseTag=''
  local modeSaveTag=''
  local modeSub='+'
  local modeTag=''
  local modeAnswer=''
  local targetAnswer=''
  local targetSearch=''
  local targetString=''
  local modeFuzzy=''
  local fuzzyResults=''
  local fileDoEdit=/tmp/todo/do-edit.tcl

  declare -a dateChanges=()

  local dateValue=''
  local lastDateChangeValue=''
#  echo "$currentDate"

  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in

      '-edit' | '-done' | '-change' ) 
        modeFuzzy="$key"
        ;;
      '-move') modeMove='t' ;;
      '-a' | '-answer') modeAnswer='t' ;;
      '-editdone') currentToDo=$FILE_TODO_DONE ;;
      '-tag') modeTag=$(echo "$1 " |  tr '[:lower:]' '[:upper:]'); shift ;;
      '-add') modeAdd='t';;
      '-date') currentDate="$1"; shift ;;
      '-tag' ) modeSaveTag='t';;
      '-usetag' ) modeUseTag='t';;
      '-sub' | '--') modeSub='-';;
      '-abs') modeAbsolute='t';;

      # single
      '-1' | '-2' | '-3' | '-4' | '-5' | '-6' | '-7' | '-8' | '-9' | '-10' | '-11' | '-12' | '-13' | '-14' | '-15' | '-16' | '-17' | '-18' | '-19' | '-20' | '-21' | '-22' | '-23' | '-24' | '-25' | '-26' | '-27' | '-28' | '-29' | '-30' | '-31')
        dateValue=$(echo "$key" | cut -c2-)
        lastDateChangeValue="${modeSub}${dateValue}d" 
        dateChanges+=($lastDateChangeValue)
        ;;

      # single
      '-w' | '-m' | '-y' ) 
        dateValue=$(echo "$key" | cut -c2-)
        lastDateChangeValue="${modeSub}1${dateValue}" 
        dateChanges+=($lastDateChangeValue)
        ;;

      # dates
      '-1d' | '-2d' | '-3d' | '-4d' | '-5d' | '-6d' | '-1w' | '-2w' | '-3w' | '-4w' | '-5w' | '-1m' | '-2m' | '-3m' | '-4m' | '-5m' | '-6m' | '-7m' | '-8m' | '-9m' | '-10m' | '-11m' | '-1y' | '-2y' | '-3y' | '-4y' | '-5y') 
        dateValue=$(echo "$key" | cut -c2-)
        lastDateChangeValue="${modeSub}${dateValue}" 
        dateChanges+=($lastDateChangeValue)
        ;;
      '-delete') echo "figure out delete later" ;;
      *) 
        if [[ $modeAnswer ]]; then
          targetAnswer="$targetAnswer$key " 
        else
          targetString="$targetString$key " 
        fi
      ;;

    esac

  done

  local dateSize=${#dateChanges[@]}

  for (( i=1; i <= ${dateSize[@]}; i++ )); do
    currentDate=$(dgetdate "${dateChanges[$i]}" "$currentDate")
  done

  # populate search string
  targetSearch=$(echo "$targetString" | xargs | sed 's/ /.*/g')

  if [[ $modeSaveTag ]]; then
    echo "$targetString" > $FILE_TODOSAVED
    echo "Saved: $targetString"
    return
  fi

  if [[ $modeUseTag ]]; then
    lastSave=$(cat $FILE_TODOSAVED |  tr '[:lower:]' '[:upper:]')
  fi

  if [[ $modeFuzzy ]]; then

    fuzzyResults=$(dfuzzy)

    local sedLine='' 
    while read line; do
    
      if [[ ! $line ]]; then
        continue
      fi

      dueDate=$(echo "$line" | awk '{print $1 }')
      sedLine=$(echo "$line" | sed 's/\//\\\//g')

      noDate=$(echo "$line" | awk '{for(i=2; i<=NF; i++) printf $i (i==NF ? "\n" : OFS)}')


      # always delete
      sed -i '' "/$sedLine/d" $currentToDo

      # if done move to done list
      if [[ $modeFuzzy == '-done' ]]; then
        echo "$fuzzyResults" >> $FILE_TODO_DONE

      # if edit save to file and edit 
      elif [[ $modeFuzzy == '-edit' ]]; then
        echo "$line" > $fileDoEdit
        vim $fileDoEdit
        cat $fileDoEdit >> $currentToDo

      elif [[ $modeFuzzy == '-change' ]]; then

        # if relative date find relative date
        if [[ ! $modeAbsolute ]]; then

#          echo "dDate operation |$lastDateChangeValue|"
#          echo "dgetdate \"$lastDateChangeValue\" $dueDate"

          if [[ $lastDateChangeValue ]]; then
#            currentDate=$(dgetdate "$lastDateChangeValue" $dueDate)

            for (( i=1; i <= ${dateSize[@]}; i++ )); do
              dueDate=$(dgetdate "${dateChanges[$i]}" "$dueDate")
              echo "dueDate $dueDate"
            done
          fi
          currentDate="$dueDate"

        fi
        echo "INSERTING $currentDate ${modeTag}${lastSave}${noDate}"
        echo "$currentDate ${modeTag}${lastSave}${noDate}" >> $currentToDo

      fi

    done < $FILE_TODO_OUTPUT

    sort -o $FILE_TODO $FILE_TODO

    return 
  fi

  local dueDate=""
  # not add but search search
  if [[ ! $modeAdd && $targetSearch ]]; then

    becho "searching |$targetSearch|"
    grep -hi "$targetSearch" $currentToDo

    if [[ ("$currentDate" != "$currentDateStatic") || $modeAnswer ]]; then
      
      grep -hi "$targetSearch" $currentToDo > $FILE_TODO_OUTPUT

      local noDate=''
      local sedLine=''

      while read line; do
        dueDate=$(echo "$line" | awk '{print $1 }')
        sedLine=$(echo "$line" | sed 's/\//\\\//g')

#        echo "1 current line $line"
        noDate=$(echo "$line" | awk '{for(i=2; i<=NF; i++) printf $i (i==NF ? "\n" : OFS)}')
#        echo "2 current line $noDate"

        if [[ $modeAnswer ]]; then

          echo "Appending answer2"
          noDate=$(echo "$noDate" | sed "s/ANSWER.*//g")
          noDate="$noDate ANSWER $targetAnswer"

        fi

#        echo "sedLine $sedLine"
        # remove value 
#        sed -i '' "/$line/d" $currentToDo
        sed -i '' "/$sedLine/d" $currentToDo

        # if relative date find relative date
        if [[ ! $modeAbsolute ]]; then

#          echo "dDate operation |$lastDateChangeValue|"
#          echo "dgetdate \"$lastDateChangeValue\" $dueDate"

          if [[ $lastDateChangeValue ]]; then
#            currentDate=$(dgetdate "$lastDateChangeValue" $dueDate)

            for (( i=1; i <= ${dateSize[@]}; i++ )); do
              dueDate=$(dgetdate "${dateChanges[$i]}" "$dueDate")
              echo "dueDate $dueDate"
            done

          fi
          currentDate="$dueDate"

        fi
        echo "INSERTING $currentDate ${modeTag}${lastSave}${noDate}"
        echo "$currentDate ${modeTag}${lastSave}${noDate}" >> $currentToDo

      done < $FILE_TODO_OUTPUT

      sort -o $currentToDo $currentToDo

    fi

    echo ""
#    return

  elif [[ $targetString ]]; then

    echo "$currentDate ${modeTag}${lastSave}${targetString}" >> $currentToDo
    sort -o $currentToDo $currentToDo

  fi

  dlist "$currentDateStatic" $currentToDo

}

function dlist() {

  local currentDateStatic="$1"
  local currentToDo="$FILE_TODO"
  
  if [[ $2 ]]; then
    currentToDo="$2"
  fi

  local modeDayOfWeek=$(date -j -f "$DATE_FORMAT_TODO" "$currentDateStatic" "+%A" | cut -c-3)

  # do listing
  local currentPointer='t'
  local pastDue=''
  while read line; do
    dueDate=$(echo "$line" | awk '{print $1 }')
    doContent=$(echo "$line" | awk '{for(i=2; i<=NF; i++) printf $i (i==NF ? "\n" : OFS)}')
    
    pastDue='t'
    if [[ ("$dueDate" == "$currentDateStatic") || ("$dueDate" > "$currentDateStatic") ]]; then 

      if [[ $currentPointer ]]; then
        dprint "$currentDateStatic" "\e[0;32m󱅼 🯁🯂🯃 $modeDayOfWeek >>>>>>>> $currentDateStatic <<<<<<<< 󰭥 󱩁 \e[0m" "print"
#        echo "\e[0;32m󱅼 🯁🯂🯃    $modeDayOfWeek >>>>>>>> $currentDateStatic <<<<<<<<  󰭥 󱩁 \e[0m"
      fi
      currentPointer=''
      pastDue=''
    fi
    dprint "$dueDate" "$doContent" "" "$pastDue"
#    echo "$line"

  done < $currentToDo

}

# 
function dprint() {
  
  local modeDate="$1"
  local modeContent="$2"
  local modeJustPrint="$3"
  local modePastDue="$4"

#  echo "date -j -f \"$DATE_FORMAT_TODO\" \"$modeDate\" \"+%A\" | cut -c-3"
  local modeDayOfWeek=$(date -j -f "$DATE_FORMAT_TODO" "$modeDate" "+%A" | cut -c-3)
#  return;
  

  local modeColor=''
  local key=''

  declare -A dColors
  declare -A dSedBackgroundColors
  declare -A dSedColors

  dColors=( 

    ['black']='\e[0;30m'    # -1
    ['red']='\e[0;31m'      # 1
    ['green']='\e[0;32m'    # 4
    ['yellow']='\e[1;33m'   # 3
    ['blue']='\e[0;34m'     # 5
    ['magenta']='\e[0;35m'  # 2
    ['cyan']='\e[0;36m'     # 6
    ['white']='\e[1;37m'    # NA
    ['lblack']='\e[1;90m'        # -1
    ['lred']='\e[1;91m'     # 1
    ['lgreen']='\e[1;92m'   # 4
    ['lyellow']='\e[0;93m'  # 3
    ['lblue']='\e[1;94m'    # 5
    ['lmagenta']='\e[1;95m' # 2
    ['lcyan']='\e[1;96m'    # 6
    ['lwhite']='\e[1;97m'   # na
    ['clear']='\e[0m'       # clear

  )

  dSedColors=( 

    ['black']='\\e\[0;30m'    # -1
    ['red']='\\e\[0;31m'      # 1
    ['green']='\\e\[0;32m'    # 4
    ['yellow']='\\e\[1;33m'   # 3
    ['blue']='\\e\[0;34m'     # 5
    ['magenta']='\\e\[0;35m'  # 2
    ['cyan']='\\e\[0;36m'     # 6
    ['white']='\\e\[1;37m'    # NA
    ['lblack']='\\e[1;90m'        # -1
    ['lred']='\\e\[1;91m'     # 1
    ['lgreen']='\\e\[1;92m'   # 4
    ['lyellow']='\\e\[0;93m'  # 3
    ['lblue']='\\e\[1;94m'    # 5
    ['lmagenta']='\\e\[1;95m' # 2
    ['lcyan']='\\e\[1;96m'    # 6
    ['lwhite']='\\e\[1;97m'   # na
    ['clear']='\\e\[0m'       # clear

  )

  dSedBackgroundColors=( 

    ['black']='\\e\[40m'   # -1
    ['red']='\\e\[41m'      # 1
    ['green']='\\e\[42m'    # 4
    ['yellow']='\\e\[43m'   # 3
    ['blue']='\\e\[44m'     # 5
    ['magenta']='\\e\[45m'  # 2
    ['cyan']='\\e\[46m'     # 6
    ['white']='\\e\[47m'    # NA

  )


  # eisenhower-matrix
  #                urgent      Not urgent
  #                          |
  # important      DO        |   SCHEDULE
  #               -----------|----------
  # not important  DELEGATE  |   DELETE
  #                          | 

  modeContent=$(echo "$modeContent" | sed "s/ANSWER /ANSWER ${dSedColors[lcyan]}${dSedBackgroundColors[black]}/g")
  messageOutput="[$modeDayOfWeek] $modeDate "
#  echo "blah $modePastDue"

  if [[ $modeJustPrint ]]; then
    messageOutput="${messageOutput}" # have to be here and have to go 
  elif [[ $(dgrep "IMP" "$modeContent") || $modePastDue ]]; then
    messageOutput="${messageOutput}${dColors[red]}" # immediate attention
  elif [[ $(dgrep "MED\|EVENT" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[lred]}" # have to be here and have to go 
  elif [[ $(dgrep "BDAY" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[lyellow]}" # secondary attention
  elif [[ $(dgrep "TAX\|TRIP" "$modeContent") ]]; then 
    messageOutput="${messageOutput}${dColors[lmagenta]}" # firm dates that can't be moved
  elif [[ $(dgrep "ASK" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[lcyan]}" # mundane logistics that need to take care of immediately
  elif [[ $(dgrep "CAR\|MON" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[blue]}" # mundane logistics but need to take care of
  elif [[ $(dgrep "TASK" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[lblue]}" # mundane logistics but need to take care of
  elif [[ $(dgrep "FOOD\|BUY" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[white]}" 
  elif [[ $(dgrep "PLAN\|PLACE\|PAUSE\|FYI\|EVENT" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[lgreen]}" # Need to attend but somewhat optional
  fi
  messageOutput="${messageOutput}${modeContent}${dColors[clear]}"
  echo "$messageOutput"

}

function dgrep() {
  echo "$2" | grep -w -m 1 "$1"
}

function da() {

  d -add $@

}

function dfuzzy() {

  local key=''
  local modeInput=$FILE_TODO
  local modeOutput=$FILE_TODO_OUTPUT
  local modePrompt='➤  '
  local modeQuery='' 

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      '-prompt') modePrompt="$1 "; shift ;;
      '-input') modeInput="$1"; shift ;;
      '-output') modeOutput="$1"; shift ;;
      *) modeQuery=$1 ;;
    esac

  done

  local doValues=$(cat $modeInput | fzf -m --ansi --color fg:-1,bg:-1,hl:46,fg+:40,bg+:233,hl+:46 --color prompt:166,border:46 --height 75%  --border=sharp --prompt="$modePrompt" --pointer="➤ " --marker="➤ " --bind "change:execute(echo {q} > $queryFile)" --query "$modeQuery")

  echo "$doValues" > $modeOutput
  echo "$doValues"

}

function dsetting() {

  local modeSetting=''
  local modeDisplay='t'
  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      'on') modeSetting='t'; modeDisplay='' ;;
      'off') modeSetting=''; modeDisplay='' ;;
      *) modeSetting='' ;;
    esac

  done

  if [[ $modeDisplay ]]; then
    cat $FILE_TODO_SETTING
  else
    echo "$modeSetting" > $FILE_TODO_SETTING
  fi

}

function dreminder() {

#  local currentMinute=$(date "+%M")
#  currentMinute=$((currentMinute / 30))
  currentMinute=0

#  echo "currentMinute $currentMinute"
  local today=$(date "+%y%m%d%H")
  today="${today}${currentMinute}"

  local shouldDisplay=$(dsetting)

  if [[ $shouldDisplay ]]; then
    
    local fileDo="$DIRECTORY_TODO/do-$today"
    #  echo "$fileDo"
    local onVideo=$(ps aux | grep -i "zoom.us.app\|Microsoft Teams.app" | wc -l)
    #  echo "shouldDisplay $shouldDisplay"
    if [[ ! -f $fileDo ]]; then

      if [[ onVideo -gt 1 ]]; then 
        echo "Zoom / MS Teams detected. Skipping"
        echo "check in" > $fileDo
        return
      else
        if [[ $# -gt 0 ]]; then
          d
          return 
        fi

        d

        if [[ ! -d "$DIRECTORY_TODO" ]]; then
          mkdir $DIRECTORY_TODO
        fi
        echo "check in" > $fileDo

      fi

    fi
  fi

}
