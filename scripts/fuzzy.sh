function vx() {
   filesToEdit=$(/usr/local/bin/fzf)
   if (( ${#filesToEdit[@]} != 0 )); then
       vim $filesToEdit
   fi
}
