alias htail="tail -f /tmp/skhd_klieng.err.log /tmp/skhd_klieng.out.log" 

function hot() {
    while [[ $# -gt 0 ]]; do
        key="$1"
        case $key in

            'start' )
                skhd --start-service
                shift
                ;;
            'stop' )
                skhd --stop-service
                shift
                ;;
            'reload' )
                skhd -r
                shift
                ;;
            'restart' )
                skhd --restart-service
                shift
                ;;
            * )
                echo "unknown option $key"
                shift
                ;;
        esac
    done
}
