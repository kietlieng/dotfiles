alias don="dsetting on"
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

      '-move') modeMove='t';;
      '-tag') modeTag=$(echo "$1 " |  tr '[:lower:]' '[:upper:]'); shift ;;
      '-add') modeAdd='t';;
      '-date') currentDate="$1"; shift ;;
      '-save' ) modeSave='t';;
      '-l' ) modeLast='t';;
      '-sub') modeSub='-';;
      '-abs') modeAbsolute='t';;

      # single
      '-1' ) 
        lastDateChangeValue="${modeSub}1" 
        currentDate=$(dgetdate "$lastDateChangeValue" "$currentDate")
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
    grep -hi "$targetSearch" $FILE_TODO

    if [[ "$currentDate" != "$currentDateStatic" ]]; then
      
      grep -hi "$targetSearch" $FILE_TODO > $FILE_TODO_OUTPUT

      local noDate=""
      while read line; do
        doDate=$(echo "$line" | awk '{print $1 }')

#        echo "1 current line $line"
        noDate=$(echo "$line" | awk '{for(i=2; i<=NF; i++) printf $i (i==NF ? "\n" : OFS)}')
#        echo "2 current line $noDate"

        # remove value 
#        sed -i '' "/$noDate/d" $FILE_TODO
#        echo "sed -i '' \"/$line/d\" $FILE_TODO"
        sed -i '' "/$line/d" $FILE_TODO

        # if relative date find relative date
        if [[ ! $modeAbsolute ]]; then
#          echo "dDate operation |$lastDateChangeValue|"
#          echo "dgetdate \"$lastDateChangeValue\" $doDate"
          currentDate=$(dgetdate "$lastDateChangeValue" $doDate)
        fi
        echo "$currentDate ${modeTag}${lastSave}${noDate}" >> $FILE_TODO

      done < $FILE_TODO_OUTPUT

      sort -o $FILE_TODO $FILE_TODO

    fi

    echo ""
#    return

  elif [[ $targetString ]]; then

    echo "$currentDate ${modeTag}${lastSave}${targetString}" >> $FILE_TODO
    sort -o $FILE_TODO $FILE_TODO

  fi

  dlist "$currentDateStatic"

}

function dlist() {

  local currentDateStatic="$1"
  local modeDayOfWeek=$(date -j -f "$DATE_FORMAT_TODO" "$currentDateStatic" "+%A" | cut -c-3)

  # do listing
  local currentPointer='t'
  while read line; do
    doDate=$(echo "$line" | awk '{print $1 }')
    doContent=$(echo "$line" | awk '{for(i=2; i<=NF; i++) printf $i (i==NF ? "\n" : OFS)}')
    
    if [[ ("$doDate" == "$currentDateStatic") || ("$doDate" > "$currentDateStatic") ]]; then 

      if [[ $currentPointer ]]; then
        dprint "$currentDateStatic" "\033[0;32m󱅼 🯁🯂🯃 $modeDayOfWeek >>>>>>>> $currentDateStatic <<<<<<<< 󰭥 󱩁 \033[0m" "print"
#        echo "\033[0;32m󱅼 🯁🯂🯃    $modeDayOfWeek >>>>>>>> $currentDateStatic <<<<<<<<  󰭥 󱩁 \033[0m"
      fi
      currentPointer=''
    fi
    dprint "$doDate" "$doContent"
#    echo "$line"

  done < $FILE_TODO

}

# 
function dprint() {
  
  local modeDate="$1"
  local modeContent="$2"
  local modeJustPrint="$3"

#  echo "date -j -f \"$DATE_FORMAT_TODO\" \"$modeDate\" \"+%A\" | cut -c-3"
  local modeDayOfWeek=$(date -j -f "$DATE_FORMAT_TODO" "$modeDate" "+%A" | cut -c-3)
#  return;
  

  local modeColor=''
  local key=''

  declare -A dColors

  dColors=( 
    ["black"]="\033[0;30m"
    ["red"]="\033[0;31m" 
    ["green"]="\033[0;32m"
    ["yellow"]="\033[1;33m"
    ["blue"]="\033[0;34m"
    ["magenta"]="\033[0;35m"
    ["cyan"]="\033[0;36m"
    ["white"]="\033[1;37m"
    ["lblack"]="1;90m"
    ["lred"]="\033[1;91m"
    ["lgreen"]="\033[1;92m"
    ["lyellow"]="\033[0;93m"
    ["lblue"]="\033[1;94m"
    ["lmagenta"]="\033[1;95m"
    ["lcyan"]="\033[1;96m"
    ["white"]="\033[1;97m"
    ["clear"]="\033[0m"
  )


  # eisenhower-matrix
  #                urgent      Not urgent
  #                          |
  # important      DO        |   SCHEDULE
  #               -----------|----------
  # not important  DELEGATE  |   DELETE
  #                          | 

  messageOutput="$modeDate [$modeDayOfWeek] "

  if [[ $modeJustPrint ]]; then
    messageOutput="${messageOutput}" # have to be here and have to go 
  elif [[ $(dgrep "TASK" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[red]}" # have to be here and have to go 
  elif [[ $(dgrep "MED" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[lred]}" # immediate attention
  elif [[ $(dgrep "BDAY" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[yellow]}" # secondary attention
  elif [[ $(dgrep "TAX\|TRIP" "$modeContent") ]]; then 
    messageOutput="${messageOutput}${dColors[magenta]}" # firm dates that can't be moved
  elif [[ $(dgrep "ASK" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[lcyan]}" # mundane logistics that need to take care of immediately
  elif [[ $(dgrep "CAR" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[blue]}" # mundane logistics but need to take care of
  elif [[ $(dgrep "PLAN\|PLACE\|PAUSE\|FYI" "$modeContent") ]]; then
    messageOutput="${messageOutput}${dColors[green]}" # Need to attend but somewhat optional
  fi
  messageOutput="${messageOutput}${modeContent}${dColors[clear]}"
  echo "$messageOutput"

}

function dgrep() {
  echo "$2" | grep -m 1 "$1"
}

function da() {

  echo "d -add $@"
  d -add $@

}


# todo done and move
function dx() {

  local hashDir=$(md5 -q -s $(pwd)) 
	local queryFile="/tmp/do-$hashDir" 
	local defaultQuery='' 

	if [[ -f $queryFile ]]; then
		defaultQuery=$(cat $queryFile) 
	fi

	if [[ $# -gt 0 ]]; then
		defaultQuery=$1 
		shift
	fi

  local doValues=$(cat $FILE_TODO | fzf -m --ansi --color fg:-1,bg:-1,hl:46,fg+:40,bg+:233,hl+:46 --color prompt:166,border:46 --height 75%  --border=sharp --prompt="➤  " --pointer="➤ " --marker="➤ " --bind "change:execute(echo {q} > $queryFile)" --query "$defaultQuery")

  echo "$doValues" >> $FILE_TODO_OUTPUT
  echo "$doValues" > $FILE_TODO_DONE
  
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
