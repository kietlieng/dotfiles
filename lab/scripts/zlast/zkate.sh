function idotsave() {
    dot -Tpng -O $1
    icat ${1}.png
}

function vsin() {
    seq 0 0.01 8.28 | awk '{ print sin($1), sin($1+1), sin($1+2), sin($1+3), sin($1+4), sin($1+5) }' | plot.awk | isvg
}

# WIP doesn't actually work right now
function vsubset() {
    radius=1300
    searchTerm=""
    output=""

    while [[ $# -gt 0 ]];
    do
        key="$1"
        case $key in
            '-r' )
                radius=$2
                shift
                shift
                ;;
            '-o' )
                output="x"
                shift
                ;;
            * )
                searchTerm="$searchTerm $key"
                shift
                ;;
        esac
    done
    if [[ "$output" == "x" ]]; then
        echo "${radius} ${searchTerm}" | subset.awk
    else
        echo "${radius} ${searchTerm}" | subset.awk | isvg
    fi
}

function vbub() {
#    radius=2000
    radius=1000
    plotRange=$((radius * 1/2))
    radiusRange=$((radius * 3/7))
    same=""
    minimumRadius=200
    isBigger="T"
    biggerTerm=""
    smallerTerm=""
    points=""
    debug="0"
    output=""
    centerText="_"
    subText="_"

    while [[ $# -gt 0 ]]
    do
        key="$1"
        case $key in
            '-r' )
                radius=$2
                plotRange=$((radius * 1/2))
                radiusRange=$((radius * 1/7))
                shift
                shift
                ;;
            '-last' )
                output="last"
                shift
                ;;
            '-d' )
                output="x"
                debug="-1"
                shift
                ;;
            '-d2' )
                output="x"
                debug="$2"
                shift
                shift
                ;;
            '-v' )
                output="x"
                debug="$2"
                shift
                shift
                ;;
            '-o' )
                output="x"
                shift
                ;;
            '-c' )
                centerText="$2"
                shift
                shift
                ;;
            '-fake' )
                #points="161 763 543\n-294 -49 596\n-775 -620 558\n-228 -961 604"
                points="161 763 543\n-294 -49 596"
                shift
                ;;
            '-s' )
                isBigger="F"
                shift
                ;;
            * )
                if [[ "$subText" != "_" ]]; then
                  subText="$subText $key"
                else
                  currentTerm=$(echo "$key" | sed "s/ /_/g")

                  if [[ "$isBigger" == "T" ]]; then
                      biggerTerm="$biggerTerm $currentTerm"
                  else
                      smallerTerm="$smallerTerm $currentTerm"
                  fi

                  combineIt=$(/opt/homebrew/opt/python@3.11/libexec/bin/python -c "import random; print(str(random.randint(-${plotRange},${plotRange})) + ' ' + str(random.randint(-${plotRange},${plotRange})) + ' ' + str(random.randint(${minimumRadius},${radiusRange})))")
                  points="$points ${combineIt}\n"
                fi
                shift
                ;;
        esac
    done

    totalOutput="${debug}\n${radius}\n${biggerTerm}\n${smallerTerm}\n${points}"
    if [[ "$output" != "last" ]]; then
        echo "$totalOutput"
    fi

    if [[ "$output" == "x" ]]; then
        #echo $totalOutput | bubble.awk
        echo $totalOutput > /tmp/bub.txt
        ~/lab/scripts/plot/bubble.py
    elif [[ "$output" == "last" ]]; then
        #echo $totalOutput | bubble.awk
        cat /tmp/bubble1.svg | isvg
        cat /tmp/bubble2.svg | isvg
    else
        #echo $totalOutput | bubble.awk | isvg
        echo $totalOutput > /tmp/bub.txt
        ~/lab/scripts/plot/bubble.py
        cat /tmp/bubble1.svg | isvg
        cat /tmp/bubble2.svg | isvg
    fi

}

function vvenn() {
    #radius=1300
    radius=500
    searchTerm=""
    output=""
    centerText="_"
    subText="_"

    while [[ $# -gt 0 ]]
    do
        key="$1"
        case $key in
            '-r' )
                radius=$2
                shift
                shift
                ;;
            '-o' )
                output="x"
                shift
                ;;
            '-c' )
                centerText="$2"
                shift
                shift
                ;;
            '-s' )
                subText=$(echo "$2" | sed "s/ /_/g")
                shift
                shift
                ;;
            * )
                if [[ "$subText" != "_" ]]; then
                  subText="$subText $key"
                else
                  currentTerm=$(echo "$key" | sed "s/ /_/g")
                  searchTerm="$searchTerm $currentTerm"
                fi
                shift
                ;;
        esac
    done

    echo "${radius}\n${searchTerm}\n${centerText}\n${subText}"
    
    vennFile=/tmp/ven-output
    echo "${radius}\n${searchTerm}\n${centerText}\n${subText}" | venn.awk > $vennFile
    cat $vennFile | isvg
}
