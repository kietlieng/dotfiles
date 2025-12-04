# THEME PURE #
set fish_function_path ~/.config/fish/functions/theme-pure/functions/ $fish_function_path
set fish_add_path "/opt/homebrew/bin"

# marked directory position
set lastJump (cat ~/.jumplast)
cd "$lastJump"

source ~/lab/scripts/core.fish
set tokenFile (uncoverfile "tokens" -f)

# echo "tokenFile $tokenFile"

if [ -f $tokenFile ];
  # echo "sourcing file $tokenFile"
  source $tokenFile
end

for f in $(find ~/lab/scripts -type f -iname "*.fish" | sort);
  source $f
end

source ~/.config/fish/functions/theme-pure/conf.d/pure.fish
# setup for pure
set pure_symbol_prompt ""

# set pure_color_current_directory brcyan 
# set pure_color_current_directory 95ffa4 # green third
# set pure_color_current_directory A1F205 # green second
# set pure_color_current_directory 2AFF00 # green
# set pure_color_current_directory FFFB00 # yellow
# set pure_color_current_directory FA6102 # yellow2
# set pure_color_current_directory FA0272 # pink
# set pure_color_current_directory 02EEFA # blue
# set pure_color_current_directory 3093FD # blue2
# set pure_color_current_directory FA5102 # red
set pure_color_current_directory FF930F # orange
