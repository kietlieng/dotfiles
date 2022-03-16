function idotsave() {
    dot -Tpng -O $1
    icat ${1}.png
}

function vsin() {
    seq 0 0.01 8.28 | awk '{ print sin($1), sin($1+1), sin($1+2), sin($1+3), sin($1+4), sin($1+5) }' | plot.awk | isvg
}

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
                centerText=$(echo "$2" | sed "s/ /_/g")
                shift    
                shift
                ;;
            * )
                searchTerm="$searchTerm $key"
                shift
                ;;
        esac
    done  
    echo "${radius} \"${centerText}\" ${searchTerm}" 
    if [[ "$output" == "x" ]]; then
        echo "${radius} ${centerText} ${searchTerm}" | venn.awk 
    else
        echo "${radius} ${centerText} ${searchTerm}" | venn.awk | isvg
    fi
}
