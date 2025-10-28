# THEME PURE #
set fish_function_path ~/.config/fish/functions/theme-pure/functions/ $fish_function_path
set fish_add_path "/opt/homebrew/bin"

# setup for pure
set pure_symbol_prompt ""

# marked directory position
set lastJump $(cat ~/.jumplast)
cd "$lastJump"

source ~/lab/scripts/core.fish
set tokenFile $(uncoverTokens)

# echo "tokenFile $tokenFile"

if [ -f $tokenFile ];
  # echo "sourcing file $tokenFile"
  source $tokenFile
end

for f in $(find ~/lab/scripts -type f -iname "*.fish" | sort);
  source $f
end

source ~/.config/fish/functions/theme-pure/conf.d/pure.fish
# set pure_color_current_directory brcyan 
set pure_color_current_directory brcyan 
