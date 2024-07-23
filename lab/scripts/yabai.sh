alias bal="y bal"
alias rot="yrot"
alias rotf="ycheckrot off; rot"
alias rotn="ycheckrot topdown"
alias rotshow="cat ~/.yrotate"
alias w1="yo t l"
alias w2="yo t r"
alias w3="yo b l"
alias w4="yo b r"
alias yH="y 3"
alias yanchorbot="yanchor bot"
alias yanchoroff="yanchor off"
alias yanchorshow="cat ~/.yanchor"
alias yanchortop="yanchor top"
alias ybal="y bal"
alias ydisplay="yabai -m query --displays"
alias yf="y f"
alias yfb="y f bal"
alias yff="y f; ycheckrot off; rot 2"
alias yfire="y fire"
alias yfn="y f; ycheckrot topdown"
alias yh="y h"
alias yhf="y h; ycheckrot off; rot 2"
alias yhn="y h; ycheckrot topdown"
alias yoL="yo 3 l"
alias yoR="yo 3 r"
alias yoa="y spa"
alias yob="yo b"
alias yobl="yo b l"
alias yobr="yo b r"
alias yoc="yo center"
alias yoh="y sph"
alias yol="yo l"
alias yoll="yo l"
alias yor="yo r"
alias yorr="yo r"
alias yot="yo t"
alias yotl="yo t l"
alias yotr="yo t r"
alias yov="y spv"
alias ypadding="y padding"
alias yrestart="y restart"
alias yspd="y sp-"
alias yspi="y sp+"
alias ytail="tail -f /tmp/yabai_klieng.err.log /tmp/yabai_klieng.out.log"
alias ytdebug="yspi"
alias yteven="yspd"

export width_size="100"

function ycte() {

    yt "$@"
    exit

}

# move windows
function yWindowMove() {

    local yDisplays=$(yabai -m query --displays | jq '.[].index' | grep -i -o '[0-9]' | wc -l)

    # echo "list display $yDisplays"
    if [[ $yDisplays -lt 2 ]]; then
        return;
    fi

    local yQuery=".[] | select(.title | contains(\"yl\"))";
    local yDirection="east"
    local key=''

    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in
            '-d' )

                yDirection="$2"
                shift
                shift
                ;;

            '-a' ) # app

                yQuery=".[] | select(.app | test(\"$2\"; \"i\"))";
                shift
                shift
                ;;

            * )

                yQuery=".[] | select(.title | test(\"$key\"; \"i\"))";
                shift
                ;;

        esac
    done

    local yWindowIDs=$(yabai -m query --windows | jq "$yQuery" | jq '.id')
    local yCurrentDisplay=$(yabai -m query --windows | jq "$yQuery" | jq '.display')
    local yMainWindow=$(yabai -m query --displays | jq '.[] | select(.frame.x == 0 and .frame.y == 0)' | jq '.index')
    local lastResult=''
    #echo "mainWindow $yMainWindow"
    #echo "query is $yQuery"
    #echo "windowsID $yWindowIDs"
    #echo "yCurrentDisplay $yCurrentDisplay"

    for yWindowID in $yWindowIDs; do

        #echo "target window: $yWindowID"
        yabai -m window "$yWindowID" --display "$yDirection" 2> /dev/null
        lastResult="$?"
        #echo "last command $lastResult | $results| $yDirection"
        #echo "yabai -m window $yWindowID --display $yDirection"
        # command failed
        if [[ "$lastResult" == "1" ]]; then
            yabai -m window "$yWindowID" --display "$yMainWindow"
        fi
        #yNewDisplay=$(yabai -m query --windows | jq ".[] | select(.id == $yWindowID)" | jq '.display')
        #echo "new display $yNewDisplay"

    done

}


function yfull() {
    y f left
    yrot "$@"
}

function yhalf() {
    y f right
    yrot "$@"
}

# move window
function yl() {

    if [[ $# -gt 0 ]]; then
        yWindowMove -a "$1" -d "west"
    else
        yWindowMove "yl" -d "west"
    fi

}

# move window
function ym() {

    if [[ $# -gt 0 ]]; then
        yWindowMove -a "$1" -d "east"
    else
        yWindowMove "yr" -d "east"
    fi
    exit

}

# yabai change window padding aka yabai orient
function yo() {

    if [[ $(yison) == "off" ]]; then return; fi

    #y f
    local yPositionAbbr='r'
    local yPositionChange="f"

    #local yContext=$(yabai -m query --windows | jq ".[] | select(.title | contains(\"$targetWindow\"))" | jq '.display' )
    local yContext=$(yabai -m query --windows | jq '.[] | select(."has-focus") | .display')
    local yWidth=$(yabai -m query --displays | jq ".[] | select(.index==$yContext)" | jq '.frame.w' )
    local yHeight=$(yabai -m query --displays | jq ".[] | select(.index==$yContext)" | jq '.frame.h' )

    local yHHalf=$((yHeight / 2))
    local yHHalf=${yHHalf%.*} # need int cast 
    local yWHalf=$((yWidth / 2))
    local yWHalf=${yWHalf%.*} # need int cast 

    # we want the third only
    local yWHalf3=$((yWidth / 3))
    local yWHalf3=${yWHalf3%.*} # need int cast 

    local yBPadding=0
    local yLPadding=0
    local yRPadding=0
    local yTPadding=0

    while [[ $# -gt 0 ]]; do
      key="$1"

      case "$key" in
        
        'center' )

            yWHalf=$yWHalf3
            yLPadding=$yWHalf3
            yRPadding=$yWHalf3

            shift
            ;;
        '3' )

            yWHalf=$yWHalf3

            shift
            ;;
        
        'top' | 't' )

            yPositionAbbr='t'
            yPositionChange="t"
            yBPadding=$yHHalf

            shift
            ;;

        'right' | 'r' )

            yPositionAbbr='r'
            yPositionChange="t"
            yLPadding=$yWHalf
            yabai -m config window_placement second_child
#            yabai -m config window_placement first_child
            shift
            ;;

        'left' | 'l' )

            yPositionAbbr='l'
            yPositionChange="t"
            yRPadding=$yWHalf
            yabai -m config window_placement first_child
#            yabai -m config window_placement second_child
            shift
            ;;

        'bottom' | 'b' )

            yPositionAbbr='b'
            yPositionChange="t"
            yTPadding=$yHHalf

            shift
            ;;

          *) # do nothing?
            echo "$key"
            shift
          ;;

      esac
    done
  
    if [[ $yPositionChange == "t" ]]; then
      
      echo "$yPositionAbbr" > ~/.yposition

    fi

    #echo "yContext $yContext"
    #echo "yDisplays $yDisplays"
    #echo "yWidth $yWidth"
    #echo "half $yHalf"

    yabai -m space --padding abs:0:0:0:0
    # padding goes like this TOP:BOTTOM:LEFT:RIGHT
    yabai -m space --padding "abs:$yTPadding:$yBPadding:$yLPadding:$yRPadding"

}

# yision
function yison() {

    local yMessage=$(yabai -m query --displays 2>&1)
    #echo "message $yMessage"
    if [[ "$yMessage" = *"failed to connect to socket"* ]]; then
      echo -n "off"
      #https://stackoverflow.com/questions/11141120/exit-function-stack-without-exiting-shell
      #kill -INT $$
    fi

}

# don't know what I wanted to do with this
function yt() {
    # find the displays that you need
    # show me the highest number display
    local yDisplays=$(yabai -m query --displays | jq '.[].index' | grep -i -o '[0-9]')
    echo "displays $yDisplays"
    local yWindowID=$(yabai -m query --windows | jq '.[] | select(.title | contains("yt"))' | jq '.id')
    echo "windowID $yWindowID"
    local yCurrentDisplay=$(yabai -m query --windows | jq '.[] | select(.title | contains("yt"))' | jq '.display' | tail -n 1)
    local yCurrentDisplay=${yCurrentDisplay//[$'\t\r\n']}
    local nextDisplay=$((yCurrentDisplay+1))

    if [[ $# -gt 0 ]]; then
        nextDisplay="$1"
        shift
    fi

    local displayExists='f'
    for display in $("$yDisplays"); do
        echo "|$display| $yCurrentDisplay $nextDisplay"
        if [[ $nextDisplay -eq $display ]]; then
            displayExists='t'
        fi
    done

    if [[ $displayExists != 't' ]]; then
        nextDisplay=1
    fi
    yabai -m window "$yWindowID" --display "$nextDisplay"
    yabai -m window "$yWindowID" --focus
    yabai -m display --focus "$nextDisplay"
}

# if we want the windows managed or not
function ymanage() {

    local isFloat=$(yabai -m query --spaces | grep -i "\"type\":\"float\"")
    local kittyWidth=''
    local totalWidth=''
    local managedFirefox=''
    local fireWidth=''
    #echo "$isFloat"
    # if your currently in float mode turn into manage mode
    if [[ $isFloat ]]; then
        y 'bsp'

        # have to wait for the window resize to figure out width of kitty
        sleep .2

        # get width of kitty
        kittyWidth=$(yabai -m query --windows | jq '.[] | select(.app | contains("kitty"))' | jq '.frame.w' | awk '{sum += $1} END {print sum}')
        totalWidth=$kittyWidth
        managedFirefox=$(yabai -m rule --list | grep -i firefox)
        fireWidth=''
        if [[ $managedFirefox ]]; then
            fireWidth=$(yabai -m query --windows | jq '.[] | select(.app | contains("Firefox"))' | jq '.frame.w' | awk '{sum += $1} END {print sum}')
            ((totalWidth=fireWidth+kittyWidth))
        fi

        # enforce padding if it's full width
        # use greater than because some windows are not spaced absolute horizontal to each other
        if [[ $totalWidth -gt 2050 ]]; then
            y 'f'
        fi
    else

        # kitty width
        kittyWidth=$(yabai -m query --windows | jq '.[] | select(.app | contains("kitty"))' | jq '.frame.w' | awk '{sum += $1} END {print sum}')
        totalWidth=$kittyWidth

        managedFirefox=$(yabai -m rule --list | grep -i firefox)
        if [[ $managedFirefox ]]; then
            fireWidth=$(yabai -m query --windows | jq '.[] | select(.app | contains("Firefox"))' | jq '.frame.w' | awk '{sum += $1} END {print sum}')
            ((totalWidth=fireWidth+kittyWidth))
        fi
        # enforcing padding should be full width
        # balance option doesn't work correctly on float layout
        # We have to make it full then balance it
        if ! [[ $totalWidth -gt 2050 ]]; then
            y 'f' 'bal'
        fi
        y 'float'

    fi
}

# base command for yabai
function y() {

  local noCommands="true"
  local key=''
  local position=''
  local fireIndexList=''

  while [[ $# -gt 0 ]]; do
    noCommands="false"

    key="$1"
    shift
    case $key in

      'stack' )
        yabai -m config layout stack
        ;;

      'bsp' )
        yabai -m config layout bsp
        ;;

      'float' )
        yabai -m config layout float
        ;;

      'bal' )
        yabai -m space --balance
        ;;

      'padding' ) 
        yabai -m space --toggle padding
        ;;

      'f' ) # full.  Don't toggle
        yabai -m space --padding abs:0:0:0:0
        ;;

      'h' ) # half

        position=$(cat ~/.yposition)
        #                echo "position $position"
        yo "$position" -title "yh"
        ;;
      
      'sp+' )

        yabai -m window --ratio rel:0.2
        ;;

      'sp-' )

        yabai -m window --ratio rel:-0.2
        ;;

      '3' ) # half

        position=$(cat ~/.yposition)
        #                echo "position $position"
        yo 3 "$position" -title "yh"
        ;;

      'sph' ) # split horizontal
        yabai -m config split_type horizontal
        ;;

      'spv' ) # split vertical
        yabai -m config split_type vertical
        ;;

      'spa' ) # split auto
        yabai -m config split_type auto
        ;;

      'first' )

        yabai -m config window_placement first_child
        ;;

      'topleft' )

        yabai -m config window_placement first_child
        ;;

      'left' )

        yabai -m config window_placement first_child
        ;;

      'right' )

        yabai -m config window_placement second_child
        ;;

      'bottomright' )

        yabai -m config window_placement second_child
        ;;

      'second' )

        yabai -m config window_placement second_child
        ;;

      'fire' ) # manage fire windows also

        fireIndexList=$(yabai -m rule --list | grep -i "firefox")

        # if there is a manage index for fire that means it's managed
        # unmanage it
        if [[ $fireIndexList ]]; then

            #echo "unmanage"

            # unmanage firefox
            yabai -m rule --add app="^Firefox$" manage=off

            # get all indexes we need to delete but in reverse order because the indexs moves when you start deleting indexes
            fireIndexList=$(yabai -m rule --list | jq '.[] | select(.app | contains("Firefox")) | .index' | sort -r)
            for fireIndex in $($fireIndexList); do
              #echo "index is $fireIndex"
              yabai -m rule --remove "$fireIndex"
            done

          else

            #echo "manage"
            # manage it
            yabai -m rule --add app="^Firefox$" manage=on

        fi

        shift
        ;;

      'rlist' )

        yabai -m rule --list
        ;;

      'stick' )

        yabai -m window --toggle sticky
        ;;

      'start' )

        #brew services start yabai
        yabai --start-service
        ;;

      'stop' )

        #brew services stop yabai
        yabai --stop-service
        ;;

      'status' )

        #brew services info yabai
        echo "no more brew services info yabai.  yabai doesn't have a status check"
        ;;

      'restart' )

        #brew services stop yabai && brew services start yabai
        yabai --stop-service && yabai --start-service
        ;;

      'load' )

        yabai -m signal --add event=dock_did_restart action=\"sudo yabai --load-sa\"
        ;;

      'sa' )

        sudo yabai --load-sa
        ;;

      * )

        echo "unknown option $key"
        ;;

    esac

  done


  if [[ $noCommands == "true" ]]; then

    yabai --help
    
  fi
}

# find a windown and output the display
function ywin() {

    local grepTerm=""
    if [[ $# -gt 0 ]]; then
        grepTerm="$1"
    fi
    yabai -m query --windows | grep -i "$grepTerm"

}

function yistop() {

#  echo "isTop"

  local yTargetDisplays=$(yabai -m query --windows | jq '.[] | select(.app | contains("kitty")) | select(."is-visible") | select(."is-minimized"|not)')
  local yDisplayIndex=$(echo "$yTargetDisplays" | jq '.display' | head -n 1) 
  local yHeight=$(yabai -m query --displays | jq ".[] | select(.index==$yDisplayIndex) | .frame.h")
  local yHeight=${yHeight%.*}
  local yHeight=$((yHeight))
  local yHeight=$((yHeight / 2))
  local yHeight=$((yHeight - 50))
#  local yHeightTolerance=$((yHeight + 50))
  local yYValue=$(yabai -m query --windows | jq '.[] | select(."has-focus") | .frame.y')
#  echo "yYValue |$yYValue| |$yHeight|"
  
  if [[ $yYValue -lt $yHeight ]]; then
    echo "t"
  else 
    echo "f"
  fi

}

function yanchor() {

  local yOrientation=$(cat ~/.yrotate) 
  
  # don't try to anchor anything if it's not top down.  I don't have the logic for left right yet :D 
  if [[ $yOrientation != "topdown" ]]; then return; fi

  #echo "yanchor"
  local yTargetDisplays=$(yabai -m query --windows | jq '.[] | select(.app | contains("kitty")) | select(."is-visible") | select(."is-minimized"|not)')
  local yInstanceCount=$(echo "$yTargetDisplays" | jq ".frame | .h" | wc -l)
  local yInstanceCount=$((yInstanceCount)) # sting to int cast
  local yInstanceLimit=10
  #echo "yTargetDisplays $yTargetDisplays"
  # don't rotate if only 1 window or more than 5 windows 
  if [[ $yInstanceCount -lt 2 ]] || [[ $yInstanceCount -gt $yInstanceLimit ]]; then

    echo "counts $yInstanceCount returning"
    return

  fi

  local yCurrentDisplay=$(yabai -m query --windows | jq '.[] | select(."has-focus")')
  local yYValue=$(yabai -m query --windows | jq '.[] | select(."has-focus") | .frame.y')
  local yYValue=${yYValue%.*} 
  # whatever value throw it in there 
  while [[ $# -gt 0 ]]; do

    echo "$1" > ~/.yanchor
    shift

  done

  #echo $yCurrentDisplay
  local yAnchorValue=$(cat ~/.yanchor) 
  
  #echo "anchor value $yAnchorValue"
#  echo "yYValue $yYValue"
  #echo "yInstanceCount |$yInstanceCount|"

  # if it's not either we don't want to look at this.
  if [[ $yAnchorValue != "top" ]] && [[ $yAnchorValue != "bot" ]]; then return; fi


  local yRotationLimit=3
  local yRotationCount=0
  local isTop=''

  if [[ $yAnchorValue == "bot" ]]; then

#    echo "bot"

    if [[ $yYValue -lt 50 ]]; then

      # only rotate 2 times if count is > 2
      # otherwise a single rotation will work
      isTop=$(yistop)
#      echo "yistop |$isTop|"

      # if equal true then keep rotating
      while [[ $isTop == "t" ]]; do

        rot 
        isTop=$(yistop)
#        echo "isTop $isTop"
        # infinite loop pervention
        yRotationCount=$((yRotationCount + 1))
        if [[ $yRotationCount -gt $yRotationLimit ]]; then
          break
        fi

      done

    fi

  elif [[ $yAnchorValue == "top" ]]; then

    echo "top"

    # only rotate 2 times if count is > 2
    # otherwise a single rotation will work
    isTop=$(yistop)
#      echo "yistop |$isTop|"

    # if equal false then keep rotating
    while [[ $isTop == "f" ]]; do
      rot 
      isTop=$(yistop)
#      echo "isTop $isTop"

      # infinite loop pervention
      yRotationCount=$((yRotationCount + 1))
      if [[ $yRotationCount -gt $yRotationLimit ]]; then break; fi

    done

  fi

}

# check and then rotate
function ycheckrot() {

  if [[ $(yison) == "off" ]]; then return; fi

  # whatever value throw it in there 
  while [[ $# -gt 0 ]]; do

    echo "$1" > ~/.yrotate
    shift

  done

  local yOrientation=$(cat ~/.yrotate) 
  
  # only handle topdown
  if [[ $yOrientation != "topdown" ]]; then return; fi

  local yTargetDisplays=$(yabai -m query --windows | jq '.[] | select(.app | contains("kitty")) | select(."is-visible") | select(."is-minimized"|not)')
  local yInstanceCount=$(echo "$yTargetDisplays" | jq ".frame | .h" | wc -l)
  local yInstanceCount=$((yInstanceCount)) # string to int cast
  if [[ $yInstanceCount -lt 2 ]]; then return; fi

  local yDisplayIndex=$(echo "$yTargetDisplays" | jq '.display' | head -n 1) 
  local yHeight=$(yabai -m query --displays | jq ".[] | select(.index==$yDisplayIndex) | .frame.h")
  local yHeight=${yHeight%.*} # need int cast
  local yHeightTolerance=$((yHeight - 50))
  local yHeightTolerance=${yHeightTolerance%.*} # need int cast
  local yAllHeights=$(echo "$yTargetDisplays" | jq ".frame | .h")
  local yRotated="f"


  #echo "$yHeight > $yHeightTolerance. $yTargetDisplays $yAllHeights"
  #for currentIP in $(echo $sCurrentURI | sed 's/:/\n/g')


  for eachHeight in $(echo "$yAllHeights" | sed 's/ /\n/g'); do

    #echo "$yHeightTolerance < |$eachHeight| < $yHeight"
    eachHeight=${eachHeight%.*}
    if [[ $yHeightTolerance -lt $eachHeight ]] && [[ $eachHeight -lt $yHeight ]]; then 

#      echo "rotate"
      rot 
      yRotated="t"
      break

    fi

  done

  # we only want to check for anchor when we rotate
  if [[ $yRotated == "t" ]]; then

#    echo "yanchor call"
    yanchor "$@"

  fi

}

# rotate the window orientation
function yrot() {

    local rotateAngle="270"
    local rotateTime="0"

    if [[ $# -gt 0 ]]; then
        rotateTime="$1"
        shift
    fi

    while [[ $rotateTime -gt 0 ]]; do
        ((rotateAngle=rotateAngle-90))
        ((rotateTime=rotateTime-1))
    done

    yabai -m space --rotate $rotateAngle

}

# change margin
function ymargin() {

    local sizeAmount="3"
    local sizeIncrement="1"

    if [[ $# -gt 0 ]]; then
        sizeAmount="$1"
        shift
    fi

    if [[ $sizeAmount -lt 0 ]]; then
        sizeIncrement="-1"
    fi

    while [[ ! $sizeAmount -eq 0 ]]; do

        if [[ $sizeIncrement -eq 1 ]]; then
            yabai -m window --resize left:"-${width_size}":0;
            ((sizeAmount=sizeAmount-1))
        else
            yabai -m window --resize left:"${width_size}":0;
            ((sizeAmount=sizeAmount+1))
        fi

    done

}

# change screen width
function yw() {

    local sizeAmount="3"
    local sizeIncrement="1"
    if [[ $# -gt 0 ]]; then
        sizeAmount="$1"
        shift
    fi

    if [[ $sizeAmount -lt 0 ]]; then
        sizeIncrement="-1"
    fi

    while [[ ! $sizeAmount -eq 0 ]]; do

        if [[ $sizeIncrement -eq 1 ]]; then
            yabai -m window --resize left:"-${width_size}":0;
            ((sizeAmount=sizeAmount-1))
        else
            yabai -m window --resize left:"${width_size}":0;
            ((sizeAmount=sizeAmount+1))
        fi

    done

}

# switch positions with pane based on position
# recently using yy / xx better
function ytake() {

  local yDirection="east"
  local hasWidth="f"
  local increaseWidth="0"
  local argDirection=""
  local key=""

  while [[ $# -gt 0 ]]; do
      key="$1"
      re='^-*[0-9]+$'
      if [[ $key =~ $re ]] ; then
          hasWidth="t"
          increaseWidth="$key"
      else
          argDirection="$key"
          case $argDirection in
              'e' )
                  yDirection="east"
                  ;;
              'w' )
                  yDirection="west"
                  ;;
              's' )
                  yDirection="south"
                  ;;
              'n' )
                  yDirection="north"
                  ;;
              * ) # do nothing
                  ;;
          esac
      fi
      shift
  done

  yabai -m window --swap $yDirection
  if [[ $hasWidth = "t" ]]; then
      echo "grow $increaseWidth"
      yw "$increaseWidth"
  fi

}

# flip with pane on x axis
function xx() {

    yabai -m space --mirror y-axis
    if [[ $# -gt 0 ]]; then
        yw "$1"
    fi

}

# flip with pane on y axis
function yy() {

    yabai -m space --mirror x-axis
    if [[ $# -gt 0 ]]; then
        yw "$1"
    fi

}

# shift windows
function ysh() {
    #!/bin/bash

    win=$(yabai -m query --windows --window last | jq '.id')

    while : ; do
        yabai -m window "$win" --swap prev &> /dev/null
        if [[ $? -eq 1 ]]; then
            break
        fi
    done
}

function yshift() {

  local shouldFocus="f"
  while [[ $# -gt 0 ]]; do
    
    key="$1"
    shift
    case "$key" in
      '-f' ) shouldFocus="t"
      ;;
      *)
      ;;
    esac

  done

  local yCurrentApp=$(yabai -m query --windows | jq '.[] | select(."has-focus") | .app')

  echo "$yCurrentApp" >> /tmp/yContext
  
  local leftPadding=$(yabai -m config --space 1 left_padding)
  local rightPadding=$(yabai -m config --space 1 right_padding)

  local rightShift="t"
  local win=''
  local output=''

  # anchored on left side
  if [[ $leftPadding -eq 0 ]] && [[ $rightPadding -gt 0 ]]; then
    rightShift="f"
# left padding I don't care about as much 
#  elif [[ $leftPadding -eq 0 ]] && [[ $rightPadding -eq 0 ]]; then
#    rightShift="f"
  fi

  # cycle through counter clockwise
  if [[ $rightShift == "f" ]]; then

    if [[ "$yCurrentApp" != '"kitty"' ]] && [[ "$shouldFocus" == "t" ]]; then

      win=$(yabai -m query --windows --window last | jq '.id')
      echo "last" >> /tmp/yContext
      yabai -m query --windows --window last >> /tmp/yContext
      yabai -m window "$win" --focus
#      echo "not working" >> /tmp/yContext


    else
      win=$(yabai -m query --windows --window first | jq '.id')

      echo "first" >> /tmp/yContext
      yabai -m query --windows --window first >> /tmp/yContext

      while : ; do
          yabai -m window "$win" --swap next &> /dev/null
      #    yabai -m window "$win" --focus mouse
          if [[ $? -eq 1 ]]; then
              break
          fi

#          echo "working" >> /tmp/yContext

      done
      if [[ $shouldFocus == 't' ]]; then
        yabai -m window "$win" --focus
      fi

  #    if [[ $# -gt 0 ]]; then
  #      yabai -m window "$win" --focus
  #    fi
    fi

  else

    if [[ "$yCurrentApp" != '"kitty"' ]] && [[ "$shouldFocus" == "t" ]]; then

      win=$(yabai -m query --windows --window first | jq '.id')
      echo "first2" >> /tmp/yContext
      output=$(yabai -m query --windows --window first)
      echo "$output" >> /tmp/yContext
      yabai -m query --windows --window first | jq '.id' >> /tmp/yContext
      yabai -m window "$win" --focus
#      echo "not working2 $yCurrentApp" >> /tmp/yContext
#      echo "$shouldFocus" >> /tmp/yContext

    else

      # cycle through clockwise
      win=$(yabai -m query --windows --window last | jq '.id')
      echo "last2" >> /tmp/yContext

      while : ; do

          yabai -m window "$win" --swap prev &> /dev/null
      #    yabai -m window "$win" --focus mouse
          if [[ $? -eq 1 ]]; then
              break
          fi

#          echo "working2" >> /tmp/yContext

      done
      if [[ $shouldFocus == 't' ]]; then
        yabai -m window "$win" --focus
      fi

    fi

  fi

}

# Not the same as toggling which will turn off padding.  
# Leaves padding on set
function ytoganchor() {

#  yContext=$(yabai -m query --windows | jq '.[] | select(."has-focus") | .display')
  local yContext=$(yabai -m query --windows | jq '.[] | select(.app | contains("kitty"))' | jq '.display' | head -n 1)

#  echo "$yContext"
#  return

  local yWidth=$(yabai -m query --displays | jq ".[] | select(.index==$yContext)" | jq '.frame.w' )

  echo "yWidth is $yWidth"
  # we want the third only
  local yWHalf3=$((yWidth / 3))
  local yWHalf3=${yWHalf3%.*} # need int cast 

  local leftPadding=$(yabai -m config --space 1 left_padding)
  local leftPadding=${leftPadding%.*} # need int cast 
  local rightPadding=$(yabai -m config --space 1 right_padding)
  local rightPadding=${rightPadding%.*} # need int cast 
  local currentAnchor=''
  local currentPadding=''

  echo "$leftPadding $rightPadding"
  # is center do nothing
  if [[ $leftPadding -gt 0 ]] && [[ $rightPadding -gt 0 ]]; then

    echo "do nothing"

  # if left or right has padding figure out which 
  elif [[ $leftPadding -gt 0 ]] || [[ $rightPadding -gt 0 ]]; then

    # assume left padding
    currentAnchor='r'
    currentPadding=$leftPadding

    # or else right padding
    if [[ $rightPadding -gt 0 ]]; then
      currentAnchor='l'
      currentPadding=$rightPadding
    fi

    # if greater than 1 third, meaning it's half split
    if [[ $currentPadding -gt $yWHalf3 ]]; then

      # hugging left side
      if [[ $currentAnchor == 'l' ]]; then
        yoR
      else
        yoL
      fi

    # it's about 2 / 3 split
    else 

      # hugging left side
      if [[ $currentAnchor == 'l' ]]; then
        yor
      else
        yol
      fi

    fi

  fi

}

# Not the same as toggling which will turn off padding.  
# Leaves padding on set
function ytogpadding() {

#  yContext=$(yabai -m query --windows | jq '.[] | select(."has-focus") | .display')
  local yContext=$(yabai -m query --windows | jq '.[] | select(.app | contains("kitty"))' | jq '.display' | head -n 1)

#  echo "$yContext"
#  return

  local yWidth=$(yabai -m query --displays | jq ".[] | select(.index==$yContext)" | jq '.frame.w' )

  # we want the third only
  local yWHalf3=$((yWidth / 3))
  local yWHalf3=${yWHalf3%.*} # need int cast 

  local leftPadding=$(yabai -m config --space 1 left_padding)
  local leftPadding=${leftPadding%.*} # need int cast 
  local rightPadding=$(yabai -m config --space 1 right_padding)
  local rightPadding=${rightPadding%.*} # need int cast 

  echo "$leftPadding $rightPadding"

  local currentPadding=$leftPadding

  if [[ $rightPadding -gt 0 ]]; then

    currentPadding=$rightPadding

  fi


  # it's half
  if [[ $currentPadding -gt $yWHalf3 ]]; then
      yH
  elif [[ $currentPadding -gt 0 ]]; then # it's 1/3 padding
      yf
  else
      yh
  fi

#  # it's half
#  if [[ $currentPadding -gt $yWHalf3 ]]; then
#      yh
#  elif [[ $currentPadding -gt 0 ]]; then # it's 1/3 padding
#      yf
#  else
#      yH
#  fi

}

function yfocus() {

  local leftPadding=$(yabai -m config --space 1 left_padding)
  local leftPadding=${leftPadding%.*} # need int cast 
  local rightPadding=$(yabai -m config --space 1 right_padding)
  local rightPadding=${rightPadding%.*} # need int cast 

  local rightShift="t"

  # anchored on left side
  if [[ $leftPadding -eq 0 ]] && [[ $rightPadding -gt 0 ]]; then
    rightShift="f"
  elif [[ $leftPadding -eq 0 ]] && [[ $rightPadding -eq 0 ]]; then
    rightShift="f"
  fi

  # cycle through counter clockwise
  if [[ $rightShift == "f" ]]; then

    yabai -m window --focus east

  else

    yabai -m window --focus west

  fi

}
