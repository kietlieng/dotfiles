alias bal="Y bal"
alias rot="yrot"
alias rotf="ycheckrot off; rot"
alias rotn="ycheckrot topdown"
alias rotshow="cat ~/.yrotate"
alias w1="yo t l"
alias w2="yo t r"
alias w3="yo b l"
alias w4="yo b r"
alias yH="Y 3"
alias yanchorbot="yanchor bot"
alias yanchoroff="yanchor off"
alias yanchorshow="cat ~/.yanchor"
alias yanchortop="yanchor top"
alias ybal="Y bal"
alias ydisplay="yabai -m query --displays"
alias yf="Y f"
alias yfb="Y f bal"
alias yff="Y f; ycheckrot off; rot 2"
alias yfire="Y fire"
alias yfn="Y f; ycheckrot topdown"
alias yh="Y h"
alias yhf="Y h; ycheckrot off; rot 2"
alias yhn="Y h; ycheckrot topdown"
alias yoL="yo 3 l"
alias yoR="yo 3 r"
alias yoa="Y spa"
alias yob="yo b"
alias yobl="yo b l"
alias yobr="yo b r"
alias yoc="yo center"
alias yoh="Y sph"
alias yol="yo l"
alias yoll="yo l"
alias yor="yo r"
alias yorr="yo r"
alias yot="yo t"
alias yotl="yo t l"
alias yotr="yo t r"
alias yov="Y spv"
alias ypadding="Y padding"
alias yrestart="Y restart"
alias yrules="Y rlist"
alias yspd="Y sp-"
alias yspi="Y sp+"
alias ytail="tail -f /tmp/yabai_*.err.log /tmp/yabai_*.out.log"
alias ytdecrease="yspd"
alias ytincrease="yspi"


set -gx width_size "100"

function ycte

    yt "$argv"
    exit

end

# move windows
function yWindowMove

    set yDisplays $(yabai -m query --displays | jq '.[].index' | grep -i -o '[0-9]' | wc -l)

    # echo "list display $yDisplays"
    if test $yDisplays -lt 2
        return;
    end

    set yQuery ".[] | select(.title | contains(\"yl\"))";
    set yDirection "east"
    set key ''

    while test (count $argv) -gt 0
        set key "$argv[1]"
        switch  $key 
            case '-d'

                set yDirection "$argv[2]"
                set argv $argv[2..-1]
                set argv $argv[2..-1]

            case '-a' # app

                set yQuery ".[] | select(.app | test(\"$argv[2]\"; \"i\"))";
                set argv $argv[2..-1]
                set argv $argv[2..-1]

            case '*'

                set yQuery ".[] | select(.title | test(\"$key\"; \"i\"))";
                set argv $argv[2..-1]

        end
    end

    set yWindowIDs $(yabai -m query --windows | jq "$yQuery" | jq '.id')
    set yCurrentDisplay $(yabai -m query --windows | jq "$yQuery" | jq '.display')
    set yMainWindow $(yabai -m query --displays | jq '.[] | select(.frame.x == 0 and .frame.y == 0)' | jq '.index')
    set lastResult ''
    #echo "mainWindow $yMainWindow"
    #echo "query is $yQuery"
    #echo "windowsID $yWindowIDs"
    #echo "yCurrentDisplay $yCurrentDisplay"

    for yWindowID in $yWindowIDs; do

        #echo "target window: $yWindowID"
        yabai -m window "$yWindowID" --display "$yDirection" 2> /dev/null
        set lastResult "$status"

        #echo "last command $lastResult | $results| $yDirection"
        #echo "yabai -m window $yWindowID --display $yDirection"
        # command failed
        if [ "$lastResult" = "1" ]
            yabai -m window "$yWindowID" --display "$yMainWindow"
        end
        #set yNewDisplay $(yabai -m query --windows | jq ".[] | select(.id == $yWindowID)" | jq '.display')
        #echo "new display $yNewDisplay"

    end

end


function yfull
    Y f left
    yrot "$argv"
end

function yhalf
    Y f right
    yrot "$argv"
end

# move window
function yl

    if test (count $argv) -gt 0
        yWindowMove -a "$argv[1]" -d "west"
    else
        yWindowMove "yl" -d "west"
    end

end

# move window
function ym

    if test (count $argv) -gt 0
        yWindowMove -a "$argv[1]" -d "east"
    else
        yWindowMove "yr" -d "east"
    end
    exit

end

# yabai change window padding aka yabai orient
function yo

    if [ "$yison" = "off" ]
      return 
    end

    #y f
    set yPositionAbbr 'r'
    set yPositionChange "f"

    #set yContext $(yabai -m query --windows | jq ".[] | select(.title | contains(\"$targetWindow\"))" | jq '.display' )
    set yContext $(yabai -m query --windows | jq '.[] | select(."has-focus") | .display')
    set yWidth $(yabai -m query --displays | jq ".[] | select(.index==$yContext)" | jq '.frame.w' )
    set yHeight $(yabai -m query --displays | jq ".[] | select(.index==$yContext)" | jq '.frame.h' )

    set yHHalf (math $yHeight / 2)
    set yHHalf (string split '.' $yHHalf)[1] # need int cast 
    set yWHalf (math $yWidth / 2)
    set yWHalf (string split '.' $yWHalf)[1] # need int cast 

    # we want the third only
    set yWHalf3 (math $yWidth / 3)
    set yWHalf3 (string split '.' $yWHalf3)[1] # need int cast 

    set yBPadding 0
    set yLPadding 0
    set yRPadding 0
    set yTPadding 0

    while test (count $argv) -gt 0
      set key "$argv[1]"
      set argv $argv[2..-1]

      switch  "$key" 

        case 'center'

            set yWHalf $yWHalf3
            set yLPadding $yWHalf3
            set yRPadding $yWHalf3

        case '3'

            set yWHalf $yWHalf3

        case 'top' 't'

            set yPositionAbbr 't'
            set yPositionChange "t"
            set yBPadding $yHHalf

        case 'right' 'r'

            set yPositionAbbr 'r'
            set yPositionChange "t"
            set yLPadding $yWHalf
            yabai -m config window_placement second_child
#            yabai -m config window_placement first_child

        case 'left' 'l'

            set yPositionAbbr 'l'
            set yPositionChange "t"
            set yRPadding $yWHalf
            yabai -m config window_placement first_child
#            yabai -m config window_placement second_child

        case 'bottom' 'b'

            set yPositionAbbr 'b'
            set yPositionChange "t"
            set yTPadding $yHHalf

      end
    end

    if [ $yPositionChange = "t" ]

      echo "$yPositionAbbr" > ~/.yposition

    end

    #echo "yContext $yContext"
    #echo "yDisplays $yDisplays"
    #echo "yWidth $yWidth"
    #echo "half $yHalf"

    yabai -m space --padding abs:0:0:0:0
    # padding goes like this TOP:BOTTOM:LEFT:RIGHT
    yabai -m space --padding "abs:$yTPadding:$yBPadding:$yLPadding:$yRPadding"

end


function yissingle

    set yTargetInstances $(yabai -m query --windows | jq '.[] | select(.app | contains("kitty") or contains("Ghostty")) | select(."is-visible") | select(."is-minimized"|not) | .display' | wc -l)
#    becho "$yTargetInstances"
    if test $yTargetInstances -lt 2
      echo -n "yes"
    end

end

# yision
function yison

    set yMessage $(yabai -m query --displays 2>&1)
    pecho "message $yMessage"
    if string match -iq "*failed to connect to socket*" $yMessage

      echo -n "off"
      #https://stackoverflow.com/questions/11141120/exit-function-stack-without-exiting-shell
      #kill -INT $$
    end

end

# move to other monitor
function yt

    # find the displays that you need
    # show me the highest number display
    set yDisplays (yabai -m query --displays | jq '.[].index' | grep -i -o '[0-9]')
    echo "displays $yDisplays"
    set yWindowID (yabai -m query --windows | jq '.[] | select(.title | contains("yt"))' | jq '.id')
    echo "windowID $yWindowID"
    set yCurrentDisplay (yabai -m query --windows | jq '.[] | select(.title | contains("yt"))' | jq '.display' | tail -n 1)
    # set yCurrentDisplay ${yCurrentDisplay//[$'\t\r\n']}
    set nextDisplay (math $yCurrentDisplay + 1)

    if test (count $argv) -gt 0
        set nextDisplay "$argv[1]"
        set argv $argv[2..-1]
    end

    set displayExists 'f'
    for display in $yDisplays
        echo "|$display| $yCurrentDisplay $nextDisplay"
        if test $nextDisplay -eq $display
            set displayExists 't'
        end
    end

    if [ "$displayExists" != 't' ]
        set nextDisplay 1
    end
    yabai -m window "$yWindowID" --display "$nextDisplay"
    yabai -m window "$yWindowID" --focus
    # yabai -m display --focus "$nextDisplay"

end

# if we want the windows managed or not
function ymanage

    set isFloat (yabai -m query --spaces | grep -i "\"type\":\"float\"")
    set kittyWidth ''
    set totalWidth ''
    set managedFirefox ''
    set fireWidth ''
    #echo "$isFloat"
    # if your currently in float mode turn into manage mode
    if [ $isFloat ]
        Y 'bsp'

        # have to wait for the window resize to figure out width of kitty
        sleep .2

        # get width of kitty
        set kittyWidth $(yabai -m query --windows  | jq '.[] | select(.app | contains("kitty") or contains("Ghostty"))' | jq '.frame.w' | awk '{sum += $1} END {print sum}')
        set totalWidth $kittyWidth
        set managedFirefox $(yabai -m rule --list | grep -i firefox)
        set fireWidth ''
        if [ $managedFirefox ]
            set fireWidth $(yabai -m query --windows | jq '.[] | select(.app | contains("Firefox"))' | jq '.frame.w' | awk '{sum += $1} END {print sum}')
            set totalWidth (math $fireWidth + $kittyWidth)
        end

        # enforce padding if it's full width
        # use greater than because some windows are not spaced absolute horizontal to each other
        if test $totalWidth -gt 2050
            Y 'f'
        end
    else

        # kitty width
        set kittyWidth $(yabai -m query --windows | jq '.[] | select(.app | contains("kitty") or contains("Ghostty"))' | jq '.frame.w' | awk '{sum += $1} END {print sum}')
        set totalWidth $kittyWidth

        set managedFirefox $(yabai -m rule --list | grep -i firefox)
        if [ $managedFirefox ]
            set fireWidth $(yabai -m query --windows | jq '.[] | select(.app | contains("Firefox"))' | jq '.frame.w' | awk '{sum += $1} END {print sum}')
            set totalWidth (math $fireWidth + $kittyWidth)
        end
        # enforcing padding should be full width
        # balance option doesn't work correctly on float layout
        # We have to make it full then balance it
        if test $totalWidth -lt 2050
            Y 'f' 'bal'
        end
        Y 'float'

    end
end

# base command for yabai
function Y

  set noCommands "true"
  set key ''
  set position ''
  set fireIndexList ''

  while test (count $argv) -gt 0
    set noCommands "false"

    set key "$argv[1]"
    set argv $argv[2..-1]
    switch  $key 

      case 'stack'; yabai -m config layout stack
      case 'bsp'; yabai -m config layout bsp
      case 'float'; yabai -m config layout float
      case 'bal'; yabai -m space --balance
      case 'padding'; yabai -m space --toggle padding
      case 'f' # full.  Don't toggle
        yabai -m space --padding abs:0:0:0:0
      case 'h' # half
        set position $(cat ~/.yposition)
        #                echo "position $position"
        yo "$position" -title "yh"
        pecho "yo \"$position\" -title \"yh\""
      case 'sp+'; yabai -m window --ratio rel:0.2
      case 'sp-'; yabai -m window --ratio rel:-0.2
      case '3' # half
        set position $(cat ~/.yposition)
        #                echo "position $position"
        yo 3 "$position" -title "yh"

      case 'sph' # split horizontal
        yabai -m config split_type horizontal
      case 'spv' # split vertical
        yabai -m config split_type vertical
      case 'spa' # split auto
        yabai -m config split_type auto
      case 'first'; yabai -m config window_placement first_child
      case 'topleft'; yabai -m config window_placement first_child
      case 'left'; yabai -m config window_placement first_child
      case 'right'; yabai -m config window_placement second_child
      case 'bottomright'; yabai -m config window_placement second_child
      case 'second'; yabai -m config window_placement second_child
      case 'fire' # manage fire windows also

        set fireIndexList $(yabai -m rule --list | grep -i "firefox")

        # if there is a manage index for fire that means it's managed
        # unmanage it
        if [ $fireIndexList ]

            #echo "unmanage"

            # unmanage firefox
            yabai -m rule --add app='^Firefox$' manage=off

            # get all indexes we need to delete but in reverse order because the indexs moves when you start deleting indexes
            set fireIndexList $(yabai -m rule --list | jq '.[] | select(.app | contains("Firefox")) | .index' | sort -r)
            for fireIndex in $($fireIndexList); do
              #echo "index is $fireIndex"
              yabai -m rule --remove "$fireIndex"
            end

          else

            #echo "manage"
            # manage it
            yabai -m rule --add app='^Firefox$' manage=on

        end

        set argv $argv[2..-1]

      case 'rlist'; yabai -m rule --list
      case 'stick'; yabai -m window --toggle sticky
      case 'start'
        #brew services start yabai
        yabai --start-service

      case 'stop'
        #brew services stop yabai
        yabai --stop-service
      case 'status'
        #brew services info yabai
        echo "no more brew services info yabai.  yabai doesn't have a status check"
      case 'restart'
        #brew services stop yabai && brew services start yabai
        yabai --stop-service && yabai --start-service
      case 'load'
        yabai -m signal --add event=dock_did_restart action=\"sudo yabai --load-sa\"
      case 'sa'; sudo yabai --load-sa
      case 'unmanage'; yabai -m rule --add app="*" manage=off
      case '*'; echo "unknown option $key"

    end

  end


  if [ "$noCommands" = "true" ]

    yabai --help

  end
end

# find a windown and output the display
function ywin

    set grepTerm ""
    if test (count $argv) -gt 0
        set grepTerm "$argv[1]"
    end
    yabai -m query --windows | grep -i "$grepTerm"

end

function yistop

#  echo "isTop"

  set yTargetDisplays $(yabai -m query --windows | jq '.[] | select(.app | contains("kitty") or contains("Ghostty")) | select(."is-visible") | select(."is-minimized"|not)')
  set yDisplayIndex $(echo "$yTargetDisplays" | jq '.display' | head -n 1) 
  set yHeight $(yabai -m query --displays | jq ".[] | select(.index==$yDisplayIndex) | .frame.h")
  set yHeight (string split '.' $yHeight)[1]
  # set yHeight $((yHeight))
  set yHeight (math $yHeight / 2)
  set yHeight (math $yHeight - 50)
#  set yHeightTolerance $((yHeight + 50))
  set yYValue $(yabai -m query --windows | jq '.[] | select(."has-focus") | .frame.y') 
#  echo "yYValue |$yYValue| |$yHeight|"

  if test $yYValue -lt $yHeight
    echo "t"
  else 
    echo "f"
  end

end

function yanchor

  set yOrientation $(cat ~/.yrotate) 

  # don't try to anchor anything if it's not top down.  I don't have the logic for left right yet :D 
  if [ "$yOrientation" != "topdown" ] 
    return
  end

  #echo "yanchor"
  set yTargetDisplays $(yabai -m query --windows | jq '.[] | select(.app | contains("kitty") or contains("Ghostty")) | select(."is-visible") | select(."is-minimized"|not)')
  set yInstanceCount $(echo "$yTargetDisplays" | jq ".frame | .h" | wc -l)
  # set yInstanceCount $((yInstanceCount)) # sting to int cast
  set yInstanceLimit 10
  #echo "yTargetDisplays $yTargetDisplays"
  # don't rotate if only 1 window or more than 5 windows 
  if test $yInstanceCount -lt 2 
    or test $yInstanceCount -gt $yInstanceLimit

    echo "counts $yInstanceCount returning"
    return

  end

  set yCurrentDisplay $(yabai -m query --windows | jq '.[] | select(."has-focus")')
  set yYValue $(yabai -m query --windows | jq '.[] | select(."has-focus") | .frame.y')
  set yYValue (string split '.' $yYValue)[1]
  # whatever value throw it in there 
  while test (count $argv) -gt 0

    echo "$argv[1]" > ~/.yanchor
    set argv $argv[2..-1]

  end

  #echo $yCurrentDisplay
  set yAnchorValue $(cat ~/.yanchor) 

  #echo "anchor value $yAnchorValue"
#  echo "yYValue $yYValue"
  #echo "yInstanceCount |$yInstanceCount|"

  # if it's not either we don't want to look at this.
  if [ "$yAnchorValue" != "top" ] 
    and test [ $yAnchorValue != "bot" ] 
    return
  end

  set yRotationLimit 3
  set yRotationCount 0
  set isTop ''

  if [ "$yAnchorValue" = "bot" ]

#    echo "bot"

    if test $yYValue -lt 50

      # only rotate 2 times if count is > 2
      # otherwise a single rotation will work
      set isTop $(yistop)
#      echo "yistop |$isTop|"

      # if equal true then keep rotating
      while [ "$isTop" = "t" ]

        rot 
        set isTop $(yistop)
#        echo "isTop $isTop"
        # infinite loop pervention
        set yRotationCount (math $yRotationCount + 1)
        if test $yRotationCount -gt $yRotationLimit
          break
        end

      end

    end

  elif [ "$yAnchorValue" = "top" ]

    echo "top"

    # only rotate 2 times if count is > 2
    # otherwise a single rotation will work
    set isTop $(yistop)
#      echo "yistop |$isTop|"

    # if equal false then keep rotating
    while [ "$isTop" = "f" ]
      rot 
      set isTop $(yistop)
#      echo "isTop $isTop"

      # infinite loop pervention
      set yRotationCount (math $yRotationCount + 1)
      if test $yRotationCount -gt $yRotationLimit 
        break
      end

    end

  end

end

# check and then rotate
function ycheckrot

  while test (count $argv) -gt 0 # whatever value throw it in there 

    echo "$argv[1]" > ~/.yrotate
    set argv $argv[2..-1]

  end

  set yIsSingle $(yissingle)
  if [ $yIsSingle ]
    pecho "yissingle"
    return 
  else 
    pecho "not single"
  end # quit if there is a single window

  if [ "$yison" = "off" ] 
    return 
  end 
  # return if off

  if [ $(cat ~/.yrotate) != "topdown" ] 
    return 
  end # only handle topdown

  set yOutput $(yabai -m query --windows)
  set yTargetDisplays $(echo "$yOutput" | jq '.[] | select(.app | contains("kitty") or contains("Ghostty")) | select(."is-visible") | select(."is-minimized"|not)')
  set yTargetDisplay $(echo "$yOutput" | jq '.[] | select(.app | contains("kitty") or contains("Ghostty")) | select(."is-visible") | select(."is-minimized"|not) | .display' | head -n 1)
  set yHeight $(yabai -m query --displays | jq ".[] | select(.index==$yTargetDisplay)" | jq '.frame.h' )
  set yHeight $(awk -v v="$yHeight" 'BEGIN{printf "%d", v}')
  set yHeightTolerance 50
  pecho "$yTargetDisplay $yWidth"


  set yAllHeights $(echo "$yTargetDisplays" | jq ".frame | .h")
  set yRotated "f"
  pecho "$yAllHeights"
  set yHeightBot ''
  set yHeightTop ''
  set yHeightBot (math $yHeight - yHeightTolerance)
  set yHeightTop (math $yHeight + yHeightTolerance)

  for eachHeight in $(echo "$yAllHeights" | sed 's/ /\n/g'); do

    set eachHeight $(awk -v v="$eachHeight" 'BEGIN{printf "%d", v}')
    # ((set eachHeight eachHeight))

    pecho "$yHeightBot < |$eachHeight| < |$yHeightTop| |$yHeight|"

    if test $yHeightBot -lt $eachHeight 
      and test $eachHeight -lt $yHeightTop # try to match height

      pecho "shifting"
      set yRotated "t"
      rot
      break

    end

  end

  # we only want to check for anchor when we rotate
  if [ "$yRotated" = "t" ]
#    bonsai

#    echo "yanchor call"
    yanchor "$argv"

  end

end

# rotate the window orientation
function yrot

    set rotateAngle "270"
    set rotateTime "0"

    if test (count $argv) -gt 0
        set rotateTime "$argv[1]"
        set argv $argv[2..-1]
    end

    while test $rotateTime -gt 0
      set rotateAngle (math $rotateAngle - 90)
      set rotateTime (math $rotateTime - 1)
    end

    yabai -m space --rotate $rotateAngle

end

# change margin
function ymargin

    set sizeAmount "3"
    set sizeIncrement "1"

    if test (count $argv) -gt 0
        set sizeAmount "$argv[1]"
        set argv $argv[2..-1]
    end

    if test $sizeAmount -lt 0
        set sizeIncrement "-1"
    end

    while test $sizeAmount -ne 0 

        if test $sizeIncrement -eq 1
            yabai -m window --resize left:"-$width_size":0;
            set sizeAmount (math $sizeAmount - 1)
        else
            yabai -m window --resize left:"$width_size":0;
            set sizeAmount (math $sizeAmount + 1)
        end

    end

end

# change screen width
function yw

    set sizeAmount "3"
    set sizeIncrement "1"
    if test (count $argv) -gt 0
        set sizeAmount "$argv[1]"
        set argv $argv[2..-1]
    end

    if test $sizeAmount -lt 0
        set sizeIncrement "-1"
    end

    while test $sizeAmount -ne 0

        if test $sizeIncrement -eq 1
            yabai -m window --resize left:"-$width_size":0;
            set sizeAmount (math $sizeAmount - 1)
        else
            yabai -m window --resize left:"$width_size":0;
            set sizeAmount (math $sizeAmount + 1)
        end

    end

end

# switch positions with pane based on position
# recently using yy / xx better
function ytake

  set yDirection "east"
  set hasWidth "f"
  set increaseWidth "0"
  set argDirection ""
  set key ""
  set re '^-*[0-9]+$'

  while test (count $argv) -gt 0

      set key "$argv[1]"
      set argv $argv[2..-1]

      if string match -iq "$re" $key
          set hasWidth "t"
          set increaseWidth "$key"
      else
          set argDirection "$key"
          switch  $argDirection 
              case 'e'; set yDirection "east"
              case 'w'; set yDirection "west"
              case 's'; set yDirection "south"
              case 'n'; set yDirection "north"
          end
      end
  end

  yabai -m window --swap $yDirection
  if [ "$hasWidth" = "t" ]
      echo "grow $increaseWidth"
      yw "$increaseWidth"
  end

end

# flip with pane on x axis
function xx

    yabai -m space --mirror y-axis
    if test (count $argv) -gt 0
        yw "$argv[1]"
    end

end

# flip with pane on y axis
function yy

    yabai -m space --mirror x-axis
    if test (count $argv) -gt 0
        yw "$argv[1]"
    end

end

# shift windows
function ysh
    #!/bin/bash

  set win $(yabai -m query --windows --window last | jq '.id')

  while true
    yabai -m window "$win" --swap prev &> /dev/null
    if test $status -eq 1
        break
    end
  end

end

function yshift

  set shouldFocus "f"
  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]
    switch  "$key" 
      case '-f' set shouldFocus "t"
    end

  end

  set yCurrentApp $(yabai -m query --windows | jq '.[] | select(."has-focus") | .app')

  echo "$yCurrentApp" >> /tmp/yContext

  set leftPadding $(yabai -m config --space 1 left_padding)
  set rightPadding $(yabai -m config --space 1 right_padding)

  set rightShift "t"
  set win ''
  set output ''

  # anchored on left side
  if test $leftPadding -eq 0 
    and test $rightPadding -gt 0
    set rightShift "f"
# left padding I don't care about as much 
#  elif [[ $leftPadding -eq 0 ]] && [[ $rightPadding -eq 0 ]]
#    set rightShift "f"
  end

  # cycle through counter clockwise
  if [ "$rightShift" = "f" ]

    if test "$yCurrentApp" != '"kitty"' 
      and test "$yCurrentApp" != '"Ghostty"' 
      and test "$shouldFocus" = "t" 

      set win $(yabai -m query --windows --window last | jq '.id')
      echo "last" >> /tmp/yContext
      yabai -m query --windows --window last >> /tmp/yContext
      yabai -m window "$win" --focus
#      echo "not working" >> /tmp/yContext


    else

      set win $(yabai -m query --windows --window first | jq '.id')

      echo "first" >> /tmp/yContext
      yabai -m query --windows --window first >> /tmp/yContext

      while true
          yabai -m window "$win" --swap next &> /dev/null
      #    yabai -m window "$win" --focus mouse

          if test $status -eq 1
              break
          end

#          echo "working" >> /tmp/yContext

      end
      if [ "$shouldFocus" = 't' ]
        yabai -m window "$win" --focus
      end

  #    if test (count $argv) -gt 0
  #      yabai -m window "$win" --focus
  #    end
    end

  else

    if test "$yCurrentApp" != '"kitty"' 
      and test "$yCurrentApp" != '"Ghostty"'
      and test "$shouldFocus" = "t"

      set win $(yabai -m query --windows --window first | jq '.id')
      echo "first2" >> /tmp/yContext
      set output $(yabai -m query --windows --window first)
      echo "$output" >> /tmp/yContext
      yabai -m query --windows --window first | jq '.id' >> /tmp/yContext
      yabai -m window "$win" --focus
#      echo "not working2 $yCurrentApp" >> /tmp/yContext
#      echo "$shouldFocus" >> /tmp/yContext

    else

      # cycle through clockwise
      set win $(yabai -m query --windows --window last | jq '.id')
      echo "last2" >> /tmp/yContext

      while true 

          yabai -m window "$win" --swap prev &> /dev/null
      #    yabai -m window "$win" --focus mouse
          if test $status -eq 1

              break
          end

#          echo "working2" >> /tmp/yContext

      end
      if [ "$shouldFocus" = 't' ]
        yabai -m window "$win" --focus
      end

    end

  end

end

# Not the same as toggling which will turn off padding.  
# Leaves padding on set
function ytoganchor

#  set yContext $(yabai -m query --windows | jq '.[] | select(."has-focus") | .display')
  set yContext $(yabai -m query --windows | jq '.[] | select(.app | contains("kitty") or contains("Ghostty"))' | jq '.display' | head -n 1)

#  echo "$yContext"
#  return

  set yWidth $(yabai -m query --displays | jq ".[] | select(.index==$yContext)" | jq '.frame.w' )

  echo "yWidth is $yWidth"
  # we want the third only
  set yWHalf3 (math $yWidth / 3)
  set yWHalf3 (string split '.' $yWHalf3)[1] # need int cast 

  set leftPadding $(yabai -m config --space 1 left_padding)
  set leftPadding (string split '.' $leftPadding)[1] # need int cast 
  set rightPadding $(yabai -m config --space 1 right_padding)
  set rightPadding (string split '.' $rightPadding)[1] # need int cast 
  set currentAnchor ''
  set currentPadding ''

  echo "$leftPadding $rightPadding"
  # is center do nothing
  if test $leftPadding -gt 0 
    and test $rightPadding -gt 0

    echo "do nothing"

  # if left or right has padding figure out which 
  else if test $leftPadding -gt 0 
    or test $rightPadding -gt 0

    # assume left padding
    set currentAnchor 'r'
    set currentPadding $leftPadding

    # or else right padding
    if test $rightPadding -gt 0 
      set currentAnchor 'l'
      set currentPadding $rightPadding
    end

    # if greater than 1 third, meaning it's half split
    if test $currentPadding -gt $yWHalf3 

      # hugging left side
      if [ $currentAnchor = 'l' ]

        yor
        yabai -m config window_placement second_child

      else

        yol
        yabai -m config window_placement first_child

      end

    # it's about 2 / 3 split
    else 

      # hugging left side
      if [ "$currentAnchor" = 'l' ]

        yoR
        # yabai -m config window_placement second_child

      else

        yoL
        # yabai -m config window_placement first_child

      end

    end

  end

end

# Not the same as toggling which will turn off padding.  
# Leaves padding on set
function ytogpadding

  set yContext $(yabai -m query --windows | jq '.[] | select(.app | contains("kitty") or contains("Ghostty"))' | jq '.display' | head -n 1)

#  echo "$yContext"
#  return

  set yWidth $(yabai -m query --displays | jq ".[] | select(.index==$yContext)" | jq '.frame.w' )

  # we want the third only
  set yWHalf3 (math $yWidth / 3)
  set yWHalf3 (string split '.' $yWHalf3)[1] # need int cast 

  set leftPadding $(yabai -m config --space 1 left_padding)
  set leftPadding (string split '.' $leftPadding)[1] # need int cast 
  set rightPadding $(yabai -m config --space 1 right_padding)
  set rightPadding (string split '.' $rightPadding)[1] # need int cast 

  pecho "$leftPadding $rightPadding"

  set currentPadding $leftPadding

  if test $rightPadding -gt 0
    set currentPadding $rightPadding
  end

  # it's half
  if test $currentPadding -gt $yWHalf3
    pecho "half"
    yH
  else if test $currentPadding -gt 0 # it's 1/3 padding
    pecho "full"
    yf
  else
    pecho "half2"
    yh
  end

#  # it's half
#  if [[ $currentPadding -gt $yWHalf3 ]]
#      yh
#  elif [[ $currentPadding -gt 0 ]] # it's 1/3 padding
#      yf
#  else
#      yH
#  end

  # run this at the end and check anyways
#  ycheckrot

end

function yfocus

  set leftPadding ''
  set leftPadding $(yabai -m config --space 1 left_padding)
  set leftPadding (string split '.' $leftPadding)[1] # need int cast 
  set rightPadding ''
  set rightPadding $(yabai -m config --space 1 right_padding)
  set rightPadding (string split '.' $rightPadding)[1] # need int cast 

  set rightShift "t"

  # anchored on left side
  if test $leftPadding -eq 0
    and test $rightPadding -gt 0
    set rightShift "f"
  else if test $leftPadding -eq 0 
    and test $rightPadding -eq 0
    set rightShift "f"
  end

  # cycle through counter clockwise
  if [ "$rightShift" = "f" ]

    yabai -m window --focus east

  else

    yabai -m window --focus west

  end

end

function yfocuswin


  set modeTitle ''
  set targetApp ''
  set yQuery ''
  set yWindows ''

  set key ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch  "$key" 
      case '-title' 
        set modeTitle "$argv[1]"
        set argv $argv[2..-1]
      case '*' set targetApp "$key" 
    end

  end

  if [ $targetApp ]

    set yQuery ".[] | select(.app | test(\"$targetApp\"))"

    if [ $modeTitle ]
      set yQuery "$yQuery | select(.title | test(\"$modeTitle\"))"
    end

    set yWindows $(yabai -m query --windows | jq "$yQuery")
    set yWinID $(yabai -m query --windows | jq "$yQuery | .id" | head -n 1)
    set yWinFocused $(yabai -m query --windows | jq "$yQuery | .\"has-focus\"" | head -n 1)

    # echo "$yWindows"
    # echo "$yWinFocused"

    # if false
    if string match -iq "*false*" $yWinFocused

      yabai -m window --focus $yWinID
      pecho "set focus $yWinID"

    else

      pecho "no need"

    end

  end

  set yWindows ''
#  set yWindows $(yabai -m query --windows)

end

function yswitchmonitor

  set yUnfocused $(yabai -m query --displays | jq ".[] | select(.[\"has-focus\"] == false) | .id")
  pecho "focus is $yUnfocused"

end
