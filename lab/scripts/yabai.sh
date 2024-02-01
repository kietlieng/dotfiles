alias bal="y bal"
alias rot="yrot"
alias rotf="ycheckrot off"
alias rotn="ycheckrot topdown"
alias rotshow="cat ~/.yrotate"
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
alias yob="yo b"
alias yol="yo l"
alias yor="yo r"
alias yot="yo t"
alias yrestart="y restart"

export width_size="100"

function ycte() {

    yt $@
    exit

}

# move windows
function yWindowMove() {

    yDisplays=$(yabai -m query --displays | jq '.[].index' | grep -i -o '[0-9]' | wc -l)

    # echo "list display $yDisplays"
    if [[ $yDisplays -lt 2 ]]; then
        return;
    fi

    yQuery=".[] | select(.title | contains(\"yl\"))";
    yDirection="east"

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

    yWindowIDs=$(yabai -m query --windows | jq "$yQuery" | jq '.id')
    yCurrentDisplay=$(yabai -m query --windows | jq "$yQuery" | jq '.display')
    yMainWindow=$(yabai -m query --displays | jq '.[] | select(.frame.x == 0 and .frame.y == 0)' | jq '.index')
    #echo "mainWindow $yMainWindow"
    #echo "query is $yQuery"
    #echo "windowsID $yWindowIDs"
    #echo "yCurrentDisplay $yCurrentDisplay"

    for yWindowID in $(echo "$yWindowIDs"); do

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

# yabai change window padding
function yo() {

    if [[ $(yison) == "off" ]]; then return; fi

    #y f
    yPosition='right'
    yPositionAbbr='r'
    targetWindow="y$yPosition"
    yPositionChange="f"

    while [[ $# -gt 0 ]]; do
      key="$1"

      case "$key" in

        'top' )

            yPosition='top'
            targetWindow="y$yPosition"
            yPositionAbbr='t'
            yPositionChange="t"

            shift
            ;;

        't' )

            yPosition='top'
            targetWindow="yot"
            yPositionAbbr='t'
            yPositionChange="t"

            shift
            ;;

        'right' )

            yPosition='right'
            targetWindow="y$yPosition"
            yPositionAbbr='r'
            yPositionChange="t"

            shift
            ;;

        'r' )

            yPosition='right'
            targetWindow="yor"
            yPositionAbbr='r'
            yPositionChange="t"

            shift
            ;;

        'left' )

            yPosition='left'
            targetWindow="y$yPosition"
            yPositionAbbr='l'
            yPositionChange="t"

            shift
            ;;

        'l' )

            yPosition='left'
            targetWindow="yol"
            yPositionAbbr='l'
            yPositionChange="t"

            shift
            ;;

        'bottom' )

            yPosition='bottom'
            targetWindow="y$yPosition"
            yPositionAbbr='b'
            yPositionChange="t"

            shift
            ;;

        'b' )

            yPosition='bottom'
            targetWindow="yob"
            yPositionAbbr='b'
            yPositionChange="t"

            shift
            ;;

        '-title' )

            targetWindow="$2"
            shift
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

    yContext=$(yabai -m query --windows | jq ".[] | select(.title | contains(\"$targetWindow\"))" | jq '.display' )
    yWidth=$(yabai -m query --displays | jq ".[] | select(.index==$yContext)" | jq '.frame.w' )
    yHeight=$(yabai -m query --displays | jq ".[] | select(.index==$yContext)" | jq '.frame.h' )

    yHHalf=$((yHeight / 2))
    yHHalf=${yHHalf%.*} # need int cast 
    yWHalf=$((yWidth / 2))
    yWHalf=${yWHalf%.*} # need int cast 

    #echo "yContext $yContext"
    #echo "yDisplays $yDisplays"
    #echo "yWidth $yWidth"
    #echo "half $yHalf"

    yabai -m space --padding abs:0:0:0:0
    # padding goes like this TOP:BOTTOM:LEFT:RIGHT
    if [[ $yPosition == 'top' ]]; then
      yabai -m space --padding abs:0:$yHHalf:0:0
    elif [[ $yPosition == 'bottom' ]]; then
      yabai -m space --padding abs:$yHHalf:0:0:0
    elif [[ $yPosition == 'right' ]]; then
      yabai -m space --padding abs:0:0:$yWHalf:0
    elif [[ $yPosition == 'left' ]]; then
      yabai -m space --padding abs:0:0:0:$yWHalf
    fi

}

function yison() {
    yMessage=$(yabai -m query --displays 2>&1)
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
    yDisplays=$(yabai -m query --displays | jq '.[].index' | grep -i -o '[0-9]')
    echo "displays $yDisplays"
    yWindowID=$(yabai -m query --windows | jq '.[] | select(.title | contains("yt"))' | jq '.id')
    echo "windowID $yWindowID"
    yCurrentDisplay=$(yabai -m query --windows | jq '.[] | select(.title | contains("yt"))' | jq '.display' | tail -n 1)
    yCurrentDisplay=${yCurrentDisplay//[$'\t\r\n']}
    nextDisplay=$((yCurrentDisplay+1))

    if [[ $# -gt 0 ]]; then
        nextDisplay="$1"
        shift
    fi

    displayExists='f'
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
    isFloat=$(yabai -m query --spaces | grep -i "\"type\":\"float\"")
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

    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in

            'stack' )
                yabai -m config layout stack
                shift
                ;;
            'bsp' )
                yabai -m config layout bsp
                shift
                ;;
            'float' )
                yabai -m config layout float
                shift
                ;;
            'bal' )
                yabai -m space --balance
                shift
                ;;
            'f' ) # full.  Don't toggle
                #yabai -m space --toggle padding
                yabai -m space --padding abs:0:0:0:0
                shift
                ;;
            'h' ) # half

                position=$(cat ~/.yposition)
#                echo "position $position"
                yo "$position" -title "yh"
                shift

                ;;
            'first' )

                yabai -m config window_placement first_child
                shift

                ;;
            'topleft' )

                yabai -m config window_placement first_child
                shift

                ;;
            'left' )

                yabai -m config window_placement first_child
                shift

                ;;
            'right' )

                yabai -m config window_placement second_child
                shift

                ;;
            'bottomright' )

                yabai -m config window_placement second_child
                shift

                ;;
            'second' )

                yabai -m config window_placement second_child
                shift

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

                shift
                ;;

            'stick' )
                yabai -m window --toggle sticky
                shift
                ;;
            'start' )
                #brew services start yabai
                yabai --start-service
                shift
                ;;
            'stop' )
                #brew services stop yabai
                yabai --stop-service
                shift
                ;;
            'status' )
                #brew services info yabai
                echo "no more brew services info yabai.  yabai doesn't have a status check"
                shift
                ;;
            'restart' )
                #brew services stop yabai && brew services start yabai
                yabai --stop-service && yabai --start-service
                shift
                ;;
            'load' )
                yabai -m signal --add event=dock_did_restart action=\"sudo yabai --load-sa\"
                shift
                ;;
            'sa' )
                sudo yabai --load-sa
                shift
                ;;
            * )
                echo "unknown option $key"
                shift
                ;;
        esac
    done
}

# find a windown and output the display
function ywin() {

    grepTerm=""
    if [[ $# -gt 0 ]]; then
        grepTerm="$1"
    fi
    yabai -m query --windows | grep -i "$grepTerm"

}

function yistop() {

#  echo "isTop"

  yTargetDisplays=$(yabai -m query --windows | jq '.[] | select(.app | contains("kitty")) | select(."is-visible") | select(."is-minimized"|not)')
  yDisplayIndex=$(echo "$yTargetDisplays" | jq '.display' | head -n 1) 
  yHeight=$(yabai -m query --displays | jq ".[] | select(.index==$yDisplayIndex) | .frame.h")
  yHeight=${yHeight%.*}
  yHeight=$((yHeight))
  yHeight=$((yHeight / 2))
  yHeight=$((yHeight - 50))
#  yHeightTolerance=$((yHeight + 50))
  yYValue=$(yabai -m query --windows | jq '.[] | select(."has-focus") | .frame.y')
#  echo "yYValue |$yYValue| |$yHeight|"
  
  if [[ $yYValue -lt $yHeight ]]; then
    echo "t"
  else 
    echo "f"
  fi

}

function yanchor() {
  #echo "yanchor"

  yCurrentDisplay=$(yabai -m query --windows | jq '.[] | select(."has-focus")')
  yYValue=$(yabai -m query --windows | jq '.[] | select(."has-focus") | .frame.y')
  yYValue=${yYValue%.*} 
  yTargetDisplays=$(yabai -m query --windows | jq '.[] | select(.app | contains("kitty")) | select(."is-visible") | select(."is-minimized"|not)')
  yInstanceCount=$(echo $yTargetDisplays | jq ".frame | .h" | wc -l)
  yInstanceCount=$((yInstanceCount)) # sting to int cast
  yInstanceLimit=10
  yOrientation=$(cat ~/.yrotate) 
  
  # don't try to anchor anything if it's not top down.  I don't have the logic for left right yet :D 
  if [[ $yOrientation != "topdown" ]]; then
    
    return 

  fi

  #echo "yTargetDisplays $yTargetDisplays"
  # don't rotate if only 1 window or more than 5 windows 
  if [[ $yInstanceCount -lt 2 ]] || [[ $yInstanceCount -gt $yInstanceLimit ]]; then

    echo "counts $yInstanceCount returning"
    return

  fi
  # whatever value throw it in there 
  while [[ $# -gt 0 ]]; do

    echo "$1" > ~/.yanchor
    shift

  done

  #echo $yCurrentDisplay
  yAnchorValue=$(cat ~/.yanchor) 
  
  #echo "anchor value $yAnchorValue"
#  echo "yYValue $yYValue"
  #echo "yInstanceCount |$yInstanceCount|"

  # if it's not either we don't want to look at this.
  if [[ $yAnchorValue != "top" ]] && [[ $yAnchorValue != "bot" ]]; then
    
    echo "returning"
    return 

  fi


  yRotationLimit=3
  yRotationCount=0
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
      if [[ $yRotationCount -gt $yRotationLimit ]]; then
        break
      fi

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

  yOrientation=$(cat ~/.yrotate) 
  
  if [[ $yOrientation != "topdown" ]]; then
    
    return 

  fi

  yTargetDisplays=$(yabai -m query --windows | jq '.[] | select(.app | contains("kitty")) | select(."is-visible") | select(."is-minimized"|not)')
  yDisplayIndex=$(echo "$yTargetDisplays" | jq '.display' | head -n 1) 
  yHeight=$(yabai -m query --displays | jq ".[] | select(.index==$yDisplayIndex) | .frame.h")
  yHeight=${yHeight%.*} # need int cast
  yHeightTolerance=$((yHeight - 50))
  yHeightTolerance=${yHeightTolerance%.*} # need int cast
  yAllHeights=$(echo $yTargetDisplays | jq ".frame | .h")
  yInstanceCount=$(echo $yTargetDisplays | jq ".frame | .h" | wc -l)
  yInstanceCount=$((yInstanceCount)) # string to int cast
  yRotated="f"

  if [[ $yInstanceCount -lt 2 ]]; then

    return

  fi

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
    yanchor

  fi

}

# rotate the window orientation
function yrot() {

    rotateAngle="270"
    rotateTime="0"
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

    sizeAmount="3"
    sizeIncrement="1"
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

    sizeAmount="3"
    sizeIncrement="1"
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

    yDirection="east"
    hasWidth="f"
    increaseWidth="0"
    argDirection=""
    key=""

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

    win=$(yabai -m query --windows --window first | jq '.id')

    while : ; do
        yabai -m window "$win" --swap next &> /dev/null
        if [[ $? -eq 1 ]]; then
            break
        fi
    done
}
