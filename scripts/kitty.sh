function kterm() {
    kitty +kitten ssh $1
}

function kbuild() {
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin installer=nightly
}
