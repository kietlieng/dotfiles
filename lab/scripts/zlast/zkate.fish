function idotsave

    dot -Tpng -O $argv[1]
    icat $argv[1].png

end

function vsin
    seq 0 0.01 8.28 | awk '{ print sin($1), sin($1+1), sin($1+2), sin($1+3), sin($1+4), sin($1+5) }' | plot.awk | isvg
end

# WIP doesn't actually work right now
function vsubset
    set radius 1300
    set searchTerm ""
    set output ""

    while test (count $argv) -gt 0
        set key "$argv[1]"
        set argv $argv[2..-1]

        switch  $key 
            case '-r'
                set radius $argv[1]
                set argv $argv[2..-1]
                
            case '-o'
                set output "x"
                
            case '*'
                set searchTerm "$searchTerm $key"
                
        end
    end
    if [ "$output" = "x" ]
        echo "$radius $searchTerm" | subset.awk
    else
        echo "$radius $searchTerm" | subset.awk | isvg
    end
end

function vbub

  #    set radius 2000

  set radius 1000
  set plotRange (math ceil $radius / 2)
  set radiusRange (math ceil $radius x (math 3/7))
  set minimumRadius 200
  set isBigger "T"
  set biggerTerm ""
  set smallerTerm ""
  set points ""
  set debug "0"
  set output ""
  set centerText "_"
  set subText "_"

  while test (count $argv) -gt 0 

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch  $key 

      case '-r'

        set radius $argv[1]
        set plotRange (math ceil $radius * 1/2)
        set radiusRange (math ceil $radius * 1/7)
        set argv $argv[2..-1]

      case '-last'
        set output "last"

      case '-d'
        set output "x"
        set debug "-1"

      case '-d2'
        set output "x"
        set debug "$argv[1]"
        set argv $argv[2..-1]

      case '-v'
        set output "x"
        set debug "$argv[1]"
        set argv $argv[2..-1]

      case '-o'
        set output "x"

      case '-c'
        set centerText "$argv[1]"
        set argv $argv[2..-1]

      case '-fake'
        #set points "161 763 543\n-294 -49 596\n-775 -620 558\n-228 -961 604"
        set points "161 763 543\n-294 -49 596"

      case '-s'
        set isBigger "F"

      case '*'
        if [ "$subText" != "_" ]
          set subText "$subText $key"
        else
          set currentTerm $(echo "$key" | sed "s/ /_/g")

          if [ "$isBigger" = "T" ]
            set biggerTerm "$biggerTerm $currentTerm"
          else
            set smallerTerm "$smallerTerm $currentTerm"
          end
          
          # echo "plotRange $plotRange"
          # set combineIt (/opt/homebrew/opt/python@3.11/libexec/bin/python -c "import random; print(str(random.randint(-$plotRange,$plotRange)) + ' ' + str(random.randint(-$plotRange,$plotRange)) + ' ' + str(random.randint($minimumRadius,$radiusRange)))")
          set combineIt (/Users/klieng/.pyenv/shims/python -c "import random; print(str(random.randint(-$plotRange,$plotRange)) + ' ' + str(random.randint(-$plotRange,$plotRange)) + ' ' + str(random.randint($minimumRadius,$radiusRange)))")

          set points "$points $combineIt\n"
        end

    end

  end

  set totalOutput "$debug\n$radius\n$biggerTerm\n$smallerTerm\n$points"

  if [ "$output" != "last" ]
    echo -e "$totalOutput"
  end

  if [ "$output" = "x" ]

    #echo $totalOutput | bubble.awk
    pecho $totalOutput
    echo -e "$totalOutput" > /tmp/bub.txt

    /Users/klieng/.pyenv/shims/python ~/lab/scripts/plot/bubble.py
    # ~/lab/scripts/plot/bubble.py

  else if [ "$output" = "last" ]

    #echo $totalOutput | bubble.awk
    cat /tmp/bubble1.svg | isvg
    cat /tmp/bubble2.svg | isvg

  else

    echo -e "$totalOutput" > /tmp/bub.txt
    #echo $totalOutput | bubble.awk | isvg
    pecho $totalOutput
    /Users/klieng/.pyenv/shims/python ~/lab/scripts/plot/bubble.py
    # ~/lab/scripts/plot/bubble.py
    cat /tmp/bubble1.svg | isvg
    cat /tmp/bubble2.svg | isvg

  end

end

function vgraph

  set --local key ''
  set --local modeGraphFile /tmp/charts.svg
  set --local modeX ''
  set --local modeY ''
  
  cat $VCHART_TEMPLATE > $modeGraphFile

  while test (count $argv) -gt 0 

    set key "$argv[1]"
    set argv $argv[2..-1]
    
    if [ -z $modeY ]
      set modeY $key
    else
      set modeX $key
    end

  end

  echo " <text class=\"label\" x=\"35\" y=\"310\">$modeX</text>\"" >> $modeGraphFile
  echo " <text class=\"label\" x=\"5\" y=\"150\" transform=\"translate(-130, 280) rotate(-90)\" text-anchor=\"left\">$modeY</text>" >> $modeGraphFile
  echo "</svg> " >> $modeGraphFile
  
  cat $modeGraphFile | isvg

end

function vvenn

  #set radius 1300
  set radius 500
  set searchTerm ""
  set output ""
  set centerText "_"
  set subText "_"

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch  $key 

      case '-r'
        set radius $argv[1]
        set argv $argv[2..-1]
        
      case '-o' set output "x" 
      case '-c'
        set centerText "$argv[1]"
        set argv $argv[2..-1]
        
      case '-s'
        set subText $(echo "$argv[1]" | sed "s/ /_/g")
        set argv $argv[2..-1]
        
      case '*'

        if [ "$subText" != "_" ]
          set subText "$subText $key"
        else
          set currentTerm $(echo "$key" | sed "s/ /_/g")
          set searchTerm "$searchTerm $currentTerm"
        end
        
    end
  end

  echo -e "$radius\n$searchTerm\n$centerText\n$subText"
  
  set vennFile /tmp/ven-output
  # echo -e "$radius\n$searchTerm\n$centerText\n$subText" | venn.awk
  echo -e "$radius\n$searchTerm\n$centerText\n$subText" | venn.awk > $vennFile
  cat $vennFile | isvg
end
