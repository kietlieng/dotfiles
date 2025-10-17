# start supercollider
function startsuper

  SuperCollider ~/lab/whiteboard/tidal/start.scd &
  exit

end

# start tidal
function stidal

  # ssupercollider

  set -euf -o pipefail

  if not set -q GHCI
    set GHCI "ghci"
  end
  
  set TIDAL_DATA_DIR $($GHCI -e Paths_tidal.getDataDir | sed 's/"//g')

  if not set -q TIDAL_BOOT_PATH
    set TIDAL_BOOT_PATH "$TIDAL_DATA_DIR/BootTidal.hs"
  end

  # Run GHCI and load Tidal bootstrap file
  $GHCI -ghci-script $TIDAL_BOOT_PATH "$argv" 

  # ghci -ghci-script /Users/klieng/.cabal/store/ghc-9.12.2-ea3d/tdl-1.10.1-4eb6dedf/share/BootTidal.hs "$@"

end
