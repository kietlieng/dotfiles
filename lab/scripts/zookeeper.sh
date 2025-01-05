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

  local query="$1"
  shift

  local actualQuery=""

  if echo "$query" | grep -i "/$env/"; then
    actualQuery="$query"
  else
    actualQuery="/${env}${query}"
  fi

  pecho "zkfetchvalue $server \"get $actualQuery\""
  local zkoutput=$(zkfetchvalue $server get "$actualQuery" | grep -A 1 -i "response::" | tail -n 1)

  echo "$zkoutput"
  echo -n "$zkoutput" | pbcopy
}

zoostart() {
  CURRENT_DIRECTORY=$(pwd)
  cd ~/lab/repos/kafka/kafka_2.12-2.2.0
  # cd ~/lab/zookeeper-3.4.14
  bash bin/zookeeper-server-start.sh config/zookeeper.properties &!
  cd $CURRENT_DIRECTORY
}

zoostop() {
  CURRENT_DIRECTORY=$(pwd)
  cd ~/lab/repos/kafka/kafka_2.12-2.2.0
  # cd ~/lab/zookeeper-3.4.14
  bash bin/zookeeper-server-stop.sh
  cd $CURRENT_DIRECTORY
}
