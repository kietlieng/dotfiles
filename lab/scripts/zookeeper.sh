function zkcon() {
    $DRECTORY_ZK_CLI/bin/zkCli.sh -server "$1:2181"
}

function zkfetchvalue() {
    local server="$1"
    shift
    $DRECTORY_ZK_CLI/bin/zkCli.sh -server "$server:2181" $@
}

function zkvimfetch() {

  local env=$(cat ~/.pacenv)
  local server=$(cat $DIRECTORY_MAPPING_SERVER | grep "${env}-.*zk" | head -n 1 | awk -F'^' '{print $2}')

  pecho "zkfetchvalue $server \"get /${env}${1}\""
  local zkoutput=$(zkfetchvalue $server get "/${env}${1}" | grep -A 1 -i "response::" | tail -n 1)

  echo "$zkoutput"
  echo -n "$zkoutput" | pbcopy
}
