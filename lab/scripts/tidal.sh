# start supercollider
function startsuper() {

  SuperCollider ~/lab/whiteboard/tidal/start.scd &!
  exit

}

# start tidal
function stidal() {

  # ssupercollider

  set -euf -o pipefail

  GHCI=${GHCI:-"ghci"}
  TIDAL_DATA_DIR=$($GHCI -e Paths_tidal.getDataDir | sed 's/"//g')
  TIDAL_BOOT_PATH=${TIDAL_BOOT_PATH:-"$TIDAL_DATA_DIR/BootTidal.hs"}

  # Run GHCI and load Tidal bootstrap file
  $GHCI -ghci-script $TIDAL_BOOT_PATH "$@" 

  # ghci -ghci-script /Users/klieng/.cabal/store/ghc-9.12.2-ea3d/tdl-1.10.1-4eb6dedf/share/BootTidal.hs "$@"

}
