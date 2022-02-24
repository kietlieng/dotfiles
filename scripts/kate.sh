function idotsave() {
    dot -Tpng -O $1
    icat ${1}.png
}

function vgsin() {
    seq 0 0.01 8.28 | awk '{ print sin($1), sin($1+1), sin($1+2), sin($1+3), sin($1+4), sin($1+5) }' | plot.awk | isvg
}

function vgvenn() {
    radius=1300
    searchTerm=""

    while [[ $# -gt 0 ]]
    do 
        key="$1"
        case $key in
            '-r' )
                radius=$2
                shift
                shift
                ;;
                
            * )
                searchTerm="$searchTerm $key"
                shift
                ;;
        esac
    done  
    echo "${radius} ${searchTerm}" | venn.awk | isvg
}
