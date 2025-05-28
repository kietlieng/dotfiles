alias wh="w -here"
alias wm="w -no"
alias wset="w -set"

function w() {

  local modeNone=''
  local modeSetTo=''
  local modeSpecial=''
  local modeHere=''

  local currentWallpaper=''
  local currentDirectory=''

  local key=''


  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in

      '-here') modeHere='t' ;;

      '-no') modeNone='t' ;;

      '-set') 
        modeSetTo="$1"
        shift
        ;;

      *) 

        modeSpecial='t'
        currentDirectory=$(pwd)
        currentWallpaper="$key" 
        ;;

    esac

  done

  if [[ $modeNone ]]; then
    
    kitten @ set-background-image none
    # echo "Reset"
    return

  fi
  
  local modeExists=''
  local optExtensions=".jpg\|\.png\|\.jpeg\|\.webp\|\.gif\|\.bmp"

  if [[ $modeSetTo ]]; then

    if [[ -f $modeSetTo  ]]; then

      currentWallpaper=$(basename "$modeSetTo")
      currentDirectory=$(dirname "$modeSetTo")
      echo "last working basename $currentDirectory fileName $currentWallpaper"

    else

      currentWallpaper=$modeSetTo
      currentDirectory=$(pwd)

    fi 

  elif [[ $modeSpecial == '' ]]; then

    if [[ $modeHere ]]; then

      ls -1 * | grep -i "$optExtensions" | sort -R | tail -n 1 | while read wallpaperFile; do

        echo "exists"
        # echo "$wallpaperFile"
        currentWallpaper=$wallpaperFile
        currentDirectory="$(pwd)"
        modeExists='t'

      done

    fi

    # if current directory does not have anything
    if [[ $modeExists == '' ]]; then

      # echo "does not exists"
      ls -1 $WALLPAPER_ANIME_DIRECTORY | grep -i "$optExtensions" | sort -R | tail -n 1 | while read wallpaperFile; do

        # echo "wallpaperfile $wallpaperFile"
        currentWallpaper=$wallpaperFile
        currentDirectory="$WALLPAPER_ANIME_DIRECTORY"

      done

    fi

  fi

  # wn -off
  echo -n "$currentDirectory/$currentWallpaper" | pbcopy
  echo "wallpaper: $currentWallpaper"
  kitty @ set-background-image --configured --layout configured "$currentDirectory/$currentWallpaper"
  # kitten @ set-background-opacity

}

function wrm() {

  local wpLink=$(pbpaste)
  echo "Deleting $wpLink"
  rm "$wpLink" 

  wm
  w

}

function wn() {

  local wpLink=$(pbpaste)

  local modeOff=''

  while [[ $# -gt 0 ]]; do

    key="$1"
    shift

    case "$key" in
      '-off') modeOff='t' ;;
      *) ;;
    esac

  done

  echo "moving $wpLink >"
  echo "$WALLPAPER_NOT_DIRECTORY"
  mv "$wpLink" "$WALLPAPER_NOT_DIRECTORY/."

  wm

  if [[ $modeOff ]]; then
    return
  fi
  w

}

function wy() {

  local wpLink=$(pbpaste)
  echo "saving $wpLink into $WALLPAPER_SAVES_DIRECTORY"
  mv "$wpLink" "$WALLPAPER_SAVES_DIRECTORY/."

  w

}

function wfetch() {

  local wallpaperdir=~/lab/Wallpaper/anime
  local outputdir=/tmp
  local wallpaperOutput="$outputdir/wallpaperoutput.html"
  local wallpaperPayload="$outputdir/wallpaperpayload.txt"
  local url=$(echo "$1" | sed "s/\/tree.*//g")
  url=$(echo "$url" | sed "s/github.com/raw.githubusercontent.com/g")
  local urlpath="refs/heads/main"
  local sanitizedFilename=''
  local fullURL=''

  mkdir -p $wallpaperdir

  curl $1 > $wallpaperOutput
  grep -i "\<script type=\"application\/json\" data-target=\"react-.*payload" $wallpaperOutput | sed -e 's/<[^>]*>//g' > $wallpaperPayload

  local jquery=".[] .tree .items .[] .path"

  if grep -i "initialPayload" $wallpaperPayload; then

    echo "has initialPayload"
    jquery=".[] .initialPayload .tree .items .[] .path"

  fi

  echo "jquery $jquery"

  cat $wallpaperPayload | jq "$jquery" | while read filename; do
    
    sanitizedFilename=$(echo "$filename" | sed -e 's/"//g')
    fullURL="$url/$urlpath/$sanitizedFilename"
    echo "$fullURL"
    wget -nc -P $wallpaperdir $fullURL

  done

}
