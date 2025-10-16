function syncmovies

  set targetX '*'
  set key ''

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    set targetX "$targetX$key*" ;;

  end

  if [[ $targetX == '*' ]]
    echo "none"
    return
  else
    pwd
#    which rsync
    set modeCommand "rsync -av $targetX ~/lab/movies/." 
    echo "$modeCommand" | pbcopy
    echo "rsync -av $targetX ~/lab/movies/." | pbcopy
    rsync -av $targetX ~/lab/movies/.
  end


end

function synctolast
    echo "parameters $argv pwd"
    set targetpath $(pwd)
    set targetpath (string split '/' $targetpath)[1]
    if test (count $argv) -gt 1
        echo "param $argv[1]"
        echo "rsync -avp $(pwd)/$argv[1] lastcomp:$targetpath/$argv[1]"
        rsync -avp $(pwd)/$argv[1] lastcomp:$targetpath/$argv[1]
    else
        echo "rsync -avp $(pwd) lastcomp:$targetpath"
        rsync -avp $(pwd) lastcomp:$targetpath
    end
end

function syncfromlast
    echo "parameters $argv pwd"
    set targetpath (string split '/' $targetpath)[1]
    echo "rsync -avp lastcomp:$(pwd) $targetpath"
    rsync -avp lastcomp:$(pwd) $targetpath
end

function cpdot

    # setopt localoptions rmstarsilent

    set sourceScript ~/lab/scripts
    set destinationDir ~/lab/repos/dotfiles

    set dBatDir $destinationDir/bat
    set dBrewDir $destinationDir/brew
    set dConfigDir $destinationDir/config
    set dDirenvDir $destinationDir/direnv
    set dFileDir $destinationDir/dotfiles
    set dYaziDir $destinationDir/yazi
    set dYaziDir $destinationDir/znosource
    set fishOMFDir $destinationDir/.local/share/omf 
    set fishConfigDir $destinationDir/.config/fish
    set fishConfigFunctionDir $destinationDir/.config/fish/functions

    # lab
    set dLabDir $destinationDir/lab
    set dScriptDir $dLabDir/scripts

    # puretheme
    set dPure $destinationDir/.oh-my-zsh/themes/pure/

    rm -rf $destinationDir/*

    # create directories
    mkdir -p $dConfigDir $dFileDir $dScriptDir $dBrewDir $dPure $dYaziDir $dDirenvDir $dBatDir $fishOMFDir $fishConfigFunctionDir
  
    cd $dBrewDir
    brew bundle dump

    cp ~/.gitconfig $dFileDir/.
    cp ~/.yabairc $dFileDir/.
    cp ~/.zshrc $dFileDir/.
#    cp ~/.tmux.conf $dFileDir/.

    # copy init

    cp -rf ~/.config/kitty $dConfigDir/.
    cp -rf ~/.config/tmux $dConfigDir/.
    cp -rf ~/.config/nvim $dConfigDir/.
    cp -rf ~/.config/skhd $dConfigDir/.
    cp -rf ~/.config/yazi $dConfigDir/.
    cp -rf ~/.config/direnv $dConfigDir/.
    cp -rf ~/.config/bat $dConfigDir/.

    cp -rf ~/lab/scripts/calls $dScriptDir/.
    cp -rf ~/lab/scripts/tmuxp $dScriptDir/.
    cp -rf ~/lab/scripts/applescript $dScriptDir/.
    cp -rf ~/lab/scripts/plot $dScriptDir/.
    cp -rf ~/lab/scripts/python $dScriptDir/.
    cp -rf ~/lab/scripts/zlast $dScriptDir/.
    cp -rf ~/lab/scripts/ruby $dScriptDir/.
    cp -rf ~/lab/scripts/swift $dScriptDir/.
    cp -rf ~/lab/scripts/znosource $dScriptDir/.
#    cp -rf ~/lab/scripts/deprecated $dScriptDir/.

    cp ~/.oh-my-zsh/themes/pure/pure.zsh $dPure/.

    cp ~/.local/share/omf/init.fish $fishOMFDir/. 
    cp ~/.config/fish/config.fish $fishConfigDir/. 
    cp ~/.config/fish/functions/fish_prompt.fish $fishConfigFunctionDir/.


    # rm $dConfigDir/nvim/init.lua.*
    rm $dConfigDir/kitty/kitty.conf.*
    rm $dConfigDir/kitty/kitty.*.conf

    find $sourceScript -maxdepth 1 -type f  -iname "*.sh" -exec cp {} $dScriptDir/. \;
    find $sourceScript -maxdepth 1 -type f  -iname "*.fish" -exec cp {} $dScriptDir/. \;

    cd $destinationDir

end
