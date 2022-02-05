function copz() {
  cop $@ --
}

function copx() {
  cop $@ -
}

function cop() {
  if [ "$1" = "test" ]; then
    export SSHPASS=""
    # always copy
    echo -n $SSHPASS | pbcopy
  fi

}

function lscreen() {
  SCREEN_VALUE=`ls -ltr1 $SCREENSHOT_DIRECTORY | tail -n 1`
  echo "${SCREENSHOT_DIRECTORY}/${SCREEN_VALUE}" | pbcopy
}
