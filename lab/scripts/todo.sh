alias don="dsetting on"
alias ddone="d -done"
alias doff="dsetting off"

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
  local modeLast=''
  local modeSave=''
  local modeSub='+'
  local modeTag=''
  local targetSearch=''
  local targetString=''

  local dateValue=''
  local lastDateChangeValue=''
#  echo "$currentDate"

  local key=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in

      '-move') modeMove='t' ;;
      '-done') currentToDo=$FILE_TODO_DONE ;;
      '-tag') modeTag=$(echo "$1 " |  tr '[:lower:]' '[:upper:]'); shift ;;
      '-add') modeAdd='t';;
      '-date') currentDate="$1"; shift ;;
      '-save' ) modeSave='t';;
      '-l' ) modeLast='t';;
      '-sub') modeSub='-';;
      '-abs') modeAbsolute='t';;

      # single
      '-1' | '-2' | '-3' | '-4' | '-5' | '-6' | '-7' | '-8' | '-9' | '-10' | '-11' | '-12' | '-13' | '-14' | '-15' | '-16' | '-17' | '-18' | '-19' | '-20' | '-21' | '-22' | '-23' | '-24' | '-25' | '-26' | '-27' | '-28' | '-29' | '-30' | '-31')
        dateValue=$(echo "$key" | cut -c2-)
        lastDateChangeValue="${modeSub}${dateValue}d" 
        echo "dgetdate \"$lastDateChangeValue\" \"$currentDate\""
        currentDate=$(dgetdate "$lastDateChangeValue" "$currentDate")
        echo "current Date $currentDate"
        ;;

      # single
      '-w' | '-m' | '-y' ) 
        dateValue=$(echo "$key" | cut -c2-)
        lastDateChangeValue="${modeSub}1${dateValue}" 
        currentDate=$(dgetdate "$lastDateChangeValue" "$currentDate")
        ;;

      # dates
      '-1d' | '-2d' | '-3d' | '-4d' | '-5d' | '-6d' | '-1w' | '-2w' | '-3w' | '-4w' | '-5w' | '-1m' | '-2m' | '-3m' | '-4m' | '-5m' | '-6m' | '-7m' | '-8m' | '-9m' | '-10m' | '-11m' | '-1y' | '-2y' | '-3y' | '-4y' | '-5y') 
        dateValue=$(echo "$key" | cut -c2-)
        lastDateChangeValue="${modeSub}${dateValue}" 
        currentDate=$(dgetdate "$lastDateChangeValue" "$currentDate")
        ;;
      '-delete') echo "figure out delete later" ;;
      *) 
        targetString="$targetString$key " 
      ;;

    esac

  done

  # populate search string
  targetSearch=$(echo "$targetString" | xargs | sed 's/ /.*/g')

  if [[ $modeSave ]]; then
    echo "$targetString" > $FILE_TODOSAVED
    echo "Saved: $targetString"
    return
  fi

  if [[ $modeLast ]]; then
    lastSave=$(cat $FILE_TODOSAVED |  tr '[:lower:]' '[:upper:]')
  fi

  local doDate=""
  # not add but search search
  if [[ ! $modeAdd ]] && [[ $targetSearch ]]; then

#    becho "searching |$targetSearch|"
    grep -hi "$targetSearch" $currentToDo

    if [[ "$currentDate" != "$currentDateStatic" ]]; then
      
      grep -hi "$targetSearch" $currentToDo > $FILE_TODO_OUTPUT

      local noDate=""
      while read line; do
        doDate=$(echo "$line" | awk '{print $1 }')

#        echo "1 current line $line"
        noDate=$(echo "$line" | awk '{for(i=2; i<=NF; i++) printf $i (i==NF ? "\n" : OFS)}')
#        echo "2 current line $noDate"

        # remove value 
#        sed -i '' "/$noDate/d" $currentToDo
#        echo "sed -i '' \"/$line/d\" $currentToDo"
        sed -i '' "/$line/d" $currentToDo

        # if relative date find relative date
        if [[ ! $modeAbsolute ]]; then
#          echo "dDate operation |$lastDateChangeValue|"
#          echo "dgetdate \"$lastDateChangeValue\" $doDate"
          currentDate=$(dgetdate "$lastDateChangeValue" $doDate)
        fi
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
    doDate=$(echo "$line" | awk '{print $1 }')
    doContent=$(echo "$line" | awk '{for(i=2; i<=NF; i++) printf $i (i==NF ? "\n" : OFS)}')
    
    pastDue='t'
    if [[ ("$doDate" == "$currentDateStatic") || ("$doDate" > "$currentDateStatic") ]]; then 

      if [[ $currentPointer ]]; then
        dprint "$currentDateStatic" "\e[0;32m󱅼 🯁🯂🯃 $modeDayOfWeek >>>>>>>> $currentDateStatic <<<<<<<< 󰭥 󱩁 \e[0m" "print"
#        echo "\e[0;32m󱅼 🯁🯂🯃    $modeDayOfWeek >>>>>>>> $currentDateStatic <<<<<<<<  󰭥 󱩁 \e[0m"
      fi
      currentPointer=''
      pastDue=''
    fi
    dprint "$doDate" "$doContent" "" "$pastDue"
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

  modeContent=$(echo "$modeContent" | sed "s/ANSWER/ANSWER${dSedColors[lcyan]}${dSedBackgroundColors[black]}/g")
  messageOutput="[$modeDayOfWeek] $modeDate "
#  echo "blah $modePastDue"

  if [[ $modeJustPrint ]]; then
    messageOutput="${messageOutput}" # have to be here and have to go 
  elif [[ $(dgrep "TASK" "$modeContent") || $modePastDue ]]; then
    messageOutput="${messageOutput}${dColors[red]}" # have to be here and have to go 
  elif [[ $(dgrep "MED" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[lred]}" # immediate attention
  elif [[ $(dgrep "BDAY" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[lyellow]}" # secondary attention
  elif [[ $(dgrep "TAX\|TRIP" "$modeContent") ]]; then 
    messageOutput="${messageOutput}${dColors[lmagenta]}" # firm dates that can't be moved
  elif [[ $(dgrep "ASK" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[lcyan]}" # mundane logistics that need to take care of immediately
  elif [[ $(dgrep "CAR\|MON" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[lblue]}" # mundane logistics but need to take care of
  elif [[ $(dgrep "FOOD\|BUY" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[white]}" 
  elif [[ $(dgrep "PLAN\|PLACE\|PAUSE\|FYI" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[lgreen]}" # Need to attend but somewhat optional
  fi
  messageOutput="${messageOutput}${modeContent}${dColors[clear]}"
  echo "$messageOutput"

}

function dgrep() {
  echo "$2" | grep -m 1 "$1"
}

function da() {

  d -add $@

}


# todo done and move
function dx() {

#  local hashDir=$(md5 -q -s $(pwd)) 
#	local queryFile="/tmp/do-$hashDir" 
	local defaultQuery='' 

#	if [[ -f $queryFile ]]; then
#		defaultQuery=$(cat $queryFile) 
#	fi

	if [[ $# -gt 0 ]]; then
		defaultQuery=$1 
		shift
	fi

  local doValues=$(cat $FILE_TODO | fzf -m --ansi --color fg:-1,bg:-1,hl:46,fg+:40,bg+:233,hl+:46 --color prompt:166,border:46 --height 75%  --border=sharp --prompt="➤  " --pointer="➤ " --marker="➤ " --bind "change:execute(echo {q} > $queryFile)" --query "$defaultQuery")

  echo "$doValues" >> $FILE_TODO_DONE
  echo "$doValues" > $FILE_TODO_OUTPUT
  
  while read line; do
    echo "$line"
    sed -i '' "/$line/d" $FILE_TODO
  done < $FILE_TODO_OUTPUT

#  if [[ -n $doValues ]]; then
##		echo "has doValues $doValues"
#		for doIndex in "$doValues"; do
##			kill $doIndex
#			echo "x $doIndex"
#		done
#	fi

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
    if [[ onVideo -gt 1 ]]; then 
      echo "Zoom / MS Teams detected."
      return
    else
      if [[ $# -gt 0 ]]; then
        d
        return 
      fi

      if [[ ! -f $fileDo ]]; then
        d

        if [[ ! -d "$DIRECTORY_TODO" ]]; then
          mkdir $DIRECTORY_TODO
        fi
        echo "touched $fileDo" > $fileDo
      fi
    fi
  fi

}
