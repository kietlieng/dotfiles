function dreflast() {

  local sOutput=$(ls -1tr $DOWNLOAD_DIRECTORY | tail -n 1)

  if [[ $sOutput ]]; then

    ref -f "$DOWNLOAD_DIRECTORY/$sOutput"

    pecho "ref -f \"$DOWNLOAD_DIRECTORY/$sOutput\""

  fi

}

