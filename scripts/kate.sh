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

function vvenn() {
    radius=1300
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
    if [[ "$output" == "x" ]]; then
        echo "${radius}\n${searchTerm}\n${centerText}\n${subText}" | venn.awk 
    else
        echo "${radius}\n${searchTerm}\n${centerText}\n${subText}" | venn.awk | isvg
    fi
}
