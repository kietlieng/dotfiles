# runs with pure theme on zsh
# ...
# prompt_pure_preprompt_render() {
#  if [[ $KL_PURE_THEME_ENABLE == "False" ]]; then
#      return
#  fi
#  ...
#  	# Set the colors.
#	typeset -gA prompt_pure_colors_default prompt_pure_colors
#	prompt_pure_colors_default=(
#		execution_time       yellow
#		git:arrow            cyan
#		git:stash            cyan
#		git:branch           242
#		git:branch:cached    red
#		git:action           yellow
#		git:dirty            218
#		host                 242
#		path                 blue
#		prompt:error         red
#		prompt:success       34
#		prompt:continuation  242
#		suspended_jobs       red
#		user                 242
#		user:root            default
#		virtualenv           242
#	)
#	prompt_pure_colors=("${(@kv)prompt_pure_colors_default}")
#
#    if [[ $KL_PURE_THEME_ENABLE == "True" ]]; then
#	    add-zsh-hook precmd prompt_pure_precmd
#    fi
#
#	add-zsh-hook preexec prompt_pure_preexec
#
#	prompt_pure_state_setup
#
#	zle -N prompt_pure_reset_prompt
#	zle -N prompt_pure_update_vim_prompt_widget
#	zle -N prompt_pure_reset_vim_prompt_widget
#	if (( $+functions[add-zle-hook-widget] )); then
#		add-zle-hook-widget zle-line-finish prompt_pure_reset_vim_prompt_widget
#		add-zle-hook-widget zle-keymap-select prompt_pure_update_vim_prompt_widget
#	fi
#
# ... 
#	# If a virtualenv is activated, display it in grey.
#	PROMPT='%(12V.%F{$prompt_pure_colors[virtualenv]}%12v%f .)'
#
#	# Prompt turns red if the previous command didn't exit with 0.
#	#local prompt_indicator='%(?.%F{$prompt_pure_colors[prompt:success]}.%F{$prompt_pure_colors[prompt:error]})${prompt_pure_state[prompt]}%f '
#    local prompt_indicator='%(?.%F{$KL_PURE_EMOJI_SUCCESS_COLOR}.%F{$KL_PURE_EMOJI_ERROR_COLOR}) ${PURE_EMOJI}%f '
#    if [[ $KL_PURE_THEME_ENABLE == "False" ]]; then
#        local prompt_indicator='%(?.%F{$KL_PURE_EMOJI_SUCCESS_COLOR}.%F{$KL_PURE_EMOJI_ERROR_COLOR})${PURE_EMOJI};%f '
#    fi
#
#	PROMPT+=$prompt_indicator
#
#	# Indicate continuation prompt by … and use a darker color for it.
#	# If a virtualenv is activated, display it in grey.
#	PROMPT='%(12V.%F{$prompt_pure_colors[virtualenv]}%12v%f .)'
#
#	# Prompt turns red if the previous command didn't exit with 0.
#	#local prompt_indicator='%(?.%F{$prompt_pure_colors[prompt:success]}.%F{$prompt_pure_colors[prompt:error]})${prompt_pure_state[prompt]}%f '
#    local prompt_indicator='%(?.%F{$KL_PURE_EMOJI_SUCCESS_COLOR}.%F{$KL_PURE_EMOJI_ERROR_COLOR}) ${PURE_EMOJI}%f '
#    if [[ $KL_PURE_THEME_ENABLE == "False" ]]; then
#        local prompt_indicator='%(?.%F{$KL_PURE_EMOJI_SUCCESS_COLOR}.%F{$KL_PURE_EMOJI_ERROR_COLOR})${PURE_EMOJI};%f '
#    fi
#
#	PROMPT+=$prompt_indicator
#	...

alias dat="da t"
alias daf="da f"

KL_STATUS_SYMBOL_ARRAY=()

# avant-garde emoji designer
# other
#KL_STATUS_SYMBOL_ARRAY+=('(⌐▨ʭ▨)' '(/// -)' '(✖ ‿ ✖)' '𐂠  𐂠 ' '(◔ ‿◔)' '(°‿°)') # Kanye emo up-for-anything double rainbow
#KL_STATUS_SYMBOL_ARRAY+=('(ᴗ_ ᴗ。)') # sad
#KL_STATUS_SYMBOL_ARRAY+=('1⌐ࠏ෴ࠏ' '໒2▀෴▀ࠒ' '4t▀෴▀J' '4␦▀෴▀')
#KL_STATUS_SYMBOL_ARRAY+=('4t▀෴▀J') # kanye west
KL_STATUS_SYMBOL_ARRAY+=('(⌐󱪶 Ⲻ󱪶 )') # Kanye west
#KL_STATUS_SYMBOL_ARRAY+=('᯾  ᷄♩⌡ ᷄|' '⺰ ᷄♩⌡ ᷄|' 'ᱭ  ᷄♩ ᷄|' '᱉  ᷄♩ ᷄|' '᱑  ᷄♩ ᷄|' '␦ ᷄♩ ᷄|')
#KL_STATUS_SYMBOL_ARRAY+=('0_0꧞') # ex-convict
KL_STATUS_SYMBOL_ARRAY+=('/l- -l' '0_0꧞') # Batman ex-convict
#KL_STATUS_SYMBOL_ARRAY+=('⎩O_O⎭') # Lego
KL_STATUS_SYMBOL_ARRAY+=('(⌐〇_〇)') # Harry potter Lego
#KL_STATUS_SYMBOL_ARRAY+=('〇丷⟦ ⟧) 9000?!') # dragonballz scouter
KL_STATUS_SYMBOL_ARRAY+=('⟦ ⟧ 9000󱈸?') # dragonballz scouter
KL_STATUS_SYMBOL_ARRAY+=('(󰹞󰹞-󰽤 )') # transmetropolitan glasses 
#KL_STATUS_SYMBOL_ARRAY+=('󰽤◝ ఎ ◜󰽤 ') # Owen Wilson

# ╭╮◝◜◝◜ ◞◟
# ⟈⟉

# animals
#KL_STATUS_SYMBOL_ARRAY+=('>++(º>' '><  º>' '彡:⊑>' 'ϵ('Θ')϶' '彡:D') #fish fish-bone squid blowfish jelly fish
#KL_STATUS_SYMBOL_ARRAY+=('ࡄࡄࡄɅࡄ') #shark fish squid
#KL_STATUS_SYMBOL_ARRAY+=('~~( )ᢄ:>' '('v')' '\\_O<') # mouse chick duck
#KL_STATUS_SYMBOL_ARRAY+=(',≘,e' '(｀(●●)´)') # turtle pig
#KL_STATUS_SYMBOL_ARRAY+=('{O ٧ O}' '@..@' '@ᓆ ' '^. .^') # owl frog snail cat
#KL_STATUS_SYMBOL_ARRAY+=('Oᨐ O' '@('.')@' '-<(|)O=' 'C@@@ö') # alligator monkey bee caterpiller
#KL_STATUS_SYMBOL_ARRAY+=('( ;,;)' '꧁ ⸢꧂ ') # spider peacock
#KL_STATUS_SYMBOL_ARRAY+=('◝◜◝◜ ◞◟') # bats

# Games
#KL_STATUS_SYMBOL_ARRAY+=('[+..••]' '(✜..᠅)' '(+[_]᠅)') # nes, snes, vita
KL_STATUS_SYMBOL_ARRAY+=('[+..••]') # nes
#KL_STATUS_SYMBOL_ARRAY+=('⊒⟮⑉⑉)﹚୦୦୦') # megaman 
KL_STATUS_SYMBOL_ARRAY+=("<(-''-)>") # kirby sonic
#KL_STATUS_SYMBOL_ARRAY+=('𐤔ᜠᜰ_ᯓࡄ󰄰 ' '𐤔ᜠᜰ_ᯓࡄ ' '𐤔ᜠᜰ_ᯓࡄ  ') # sonic
KL_STATUS_SYMBOL_ARRAY+=('𐤔ᜠᜰ_ᯓࡄ ') # sonic
KL_STATUS_SYMBOL_ARRAY+=(' ⦿๏ ᯓ㋨') # metroid morph ball
#KL_STATUS_SYMBOL_ARRAY+=('ଳ ଲ (ˎ ꓹꡳ' 'ଳ ଲ (ˎ󰴗 ꓹꡳ' 'ଳ ଲ (ˎ󱔝 ˏꡳ') # metroids 
KL_STATUS_SYMBOL_ARRAY+=('p( )ꝯ') # metroids 
KL_STATUS_SYMBOL_ARRAY+=('♠ ♥ ♦ ♣') # Cards
#KL_STATUS_SYMBOL_ARRAY+=('󱈸') # metal gear
#KL_STATUS_SYMBOL_ARRAY+=('[ ][ ][ ][][ ][󰄻 ]') # ninja guiden
KL_STATUS_SYMBOL_ARRAY+=('█▄▄▀█▄▀▀▀▀▄█▄ ██' ) # tetris
#KL_STATUS_SYMBOL_ARRAY+=('⭣⭨ ⭢ Ⓗ ' '⭢ ⭨ ⭢ Ⓛ ' '⭣⭩ ⭠ Ⓗ  󰠬 ') # fireball hurricane kick
KL_STATUS_SYMBOL_ARRAY+=('⭣⭨ ⭢ Ⓗ   ') # street fighter fireball
KL_STATUS_SYMBOL_ARRAY+=('⭡⭡⭣⭣ ⭠ ⭢ ⭠ ⭢ Ⓑ Ⓐ ') # contra
KL_STATUS_SYMBOL_ARRAY+=('󰡗 󰡘 󰡙 󰡚 󰡛 󰡜') # chess
KL_STATUS_SYMBOL_ARRAY+=('󱙜 ᯓ󰮯 ● ᯓ󱙝 ') # pacman
KL_STATUS_SYMBOL_ARRAY+=('󱠡   ') # rock paper scissors
KL_STATUS_SYMBOL_ARRAY+=('󱃏 ⸸    ') # zelda
KL_STATUS_SYMBOL_ARRAY+=('󱩁  ') # strider
KL_STATUS_SYMBOL_ARRAY+=('ᯓ〛ⱃ⳻)') # mario bullet
#KL_STATUS_SYMBOL_ARRAY+=('▂▄▆█ ᛩ 凸') # mario castle
KL_STATUS_SYMBOL_ARRAY+=('▂▄▆█ ᛩ ▗▆▖') # mario castle
#KL_STATUS_SYMBOL_ARRAY+=('󰮭 ') # mario mushroom
KL_STATUS_SYMBOL_ARRAY+=(' ⟭ᕲৡࡇ -𒊹𖣇') # r-type
#KL_STATUS_SYMBOL_ARRAY+=('██▇(〇⪧ ᐊ〇)' '██▇(ᑕl⪧ᐊᑐ)' '██▇(〇⪧ᐊ〇)' '██▇(󱦎 ⪧󱌬 〇)' '██▇(󱈷 ⪧󱌬󰍟〇)' '██▇( ⪧󱌬󰍟 )' '██▇( ⪧ᐊ)')
#KL_STATUS_SYMBOL_ARRAY+=('██▇▄  ⪧' '██▇▄  ⪧ ' '██▇▄    ' '██▇▄  ⪧ ' '██▇▄   ' '██▇▄▁  ⪧ ' '██▇▄▁ 󱦎  ᐊ ')
#KL_STATUS_SYMBOL_ARRAY+=('██▇▄▁  ⪧︺⦅ ' '██▇▄▁ ◖ꩺ⪧꜠⦅ ' '█▄▁  ⪧꜠⦅' '█▄▁  ⪧꜠⦅ ' '█▄▁  ⪧꜠⦅ ' '█▄▁  ⪧ꛢ ' '█▄▁  ⪧꜃꜇⦅ ')
#KL_STATUS_SYMBOL_ARRAY+=('█▄▁  ⪧乛⦅ ' '█▄▁  ⪧乛⦅ ' '█▄▁  ⪧ ⸋⦅⏾' '█▄▁  ⪧乛⦅⏾' '█▄▁  ⪧乙⏾' '██▇▄▁  ⪧< ' '██▇▄▁  ⪧𐏓 ')
#KL_STATUS_SYMBOL_ARRAY+=('█▄▁  ⪧ꣻ꣼⦅ ' '█▄▁  ⪧龴⦅⏾') # Tron lightcycle
KL_STATUS_SYMBOL_ARRAY+=('█▄▁  l▷乀龴𐌂𝇋') # Tron lightcycle
#KL_STATUS_SYMBOL_ARRAY+=('ᚍᚎᚏ◝◜ᚏ◝◜ᚏᚏᚏ') # bats



# ⸸
# 🮫🮪 ￣▔⎺⎻‐‑‒–—―  ⦚ ⸏⸐⸑ ━┯━ 
# ⌎⌏⌌⌍ ⎡⎤ ⎣⎦  ⚟⚞ ﴾ ﴿
# ╚═╦═╬╗   𐀍𐀟𐁈𐂲
# noses Ո Ս ఎ  ໑ ꔽ ꗅ ꗆ
#  ⛛ ⛰ ᧘ ⊱⊰ ⍙ ⍞ ⍠ ⎆ ⥶⥸ ⫑⫒ ⫎ ⫍ ᚜᚛
# ⺡ ⌡⌠ ⎇ ༅ ༆ ༄ ᯢ 󰵄 ꣺⳿ ⮁ꕸ ꚜꧦ 
# ኑ
# 󱀑 󰾋 󰷝 󰾋 󰫠 󱃏  
# 󱙳 󱙴 ﹏΅
# 󰼁 󰼂 󰹢 󰹣  _    󰨙 󰨚
# 𐠑           
#  ۵۵۵ ﹆ ᧘ ⧽⧼ Ⲁ ⲁ
# 匚匚匚凸凸凸 凹凹凹 凵凵凵 口口口 冖冂冎
# ꪶꗃ_ꗃꪶ ꗄ ꩹ Ꝫ ꝫ Ꝭ- -ꝭ Ꝯ ꝯ  ears
#  󱞖 󰿠 󰩫  󱪿󱪿 󰅹󰅹
# 󱂩 󰹫  󱙺 󰛲  
# ⏿⏿⏿⏿ ꯴꯴꯴꯴ ꚸ ΅΅΅΅ ࿐ ࿙࿚ ᝦ \\ᣃᣄ/
# ᚁᚂᚃᚄᚅ ᚆᚇᚈᚉᚊ ᚋᚌᚍᚎᚏ ෴ 灬
# ᝐᝢᝥᝦ  Ჰ Ჱ ◥█◤ ଠ಄_ರ ಃ_಄ ௸  ௹  ௺ 
# උ ງ   ೨ ౽ ౾           
#  ¦   ࢷ  Ϡ ך ߚߚߚߚ  P ᵜںᵜ ᤙ
# ᵜᤙᵜ ⏌⏋⎺⎸⎻ ⎼ ⎽ ⎝◄ ◅⎞ ⩘⩗ ▾ ▿ ◀ ◁ ◂ ◃ ◄ ◅ 乛
# ᛑ ᛒ ᛓ ᛔ ᛕ ᛖ ᛗ ᛘ ᛙ ᛚ ᛛ ᛜ ᚷ ᚸ ᛝ ᛞ ᛟ ᛃ
# 匚匚匚凸凸凸 凹凹凹 凵凵凵 口口口 冖冂冎
# ꪶꗃ_ꗃꪶ ꗄ ꩹ Ꝫ ꝫ Ꝭ- -ꝭ Ꝯ ꝯ  ears
# ဩ 扌扌扌氵 灬  ⸝⺣⸜ 灬 ⸔⺣⸕ 灬 ⸽⸾
# 罒|罒|罒訁訁訁 ꀯꚰ ꇚ㇍ ㇏)㇎
# ꤰꤱꤲꤳꤴꤵ ꤶꤷꤸꤹꤺꤻꤼꤽꤾꤿꥀꥁꥂꥃꥄꥅꥆ
# 龴 龸 ⸙o丷o

# objects
#KL_STATUS_SYMBOL_ARRAY+=('/7\\' '(◍_ᑢᑝ_◍)') # tent austin martin
#KL_STATUS_SYMBOL_ARRAY+=('(◍_ᑢᑝ_◍)') # austin martin
#KL_STATUS_SYMBOL_ARRAY+=('[̲̅$̲̅(̲̅1)̲̅$̲̅]' '[̲̅$̲̅(̲̅2ο̲̅̅)̲̅$̲̅]') # money
#KL_STATUS_SYMBOL_ARRAY+=('༽v༼' 'ࡄ' '-᮵ - ⟁' '-[]-࠽' 'ᝑഽட৲')
#KL_STATUS_SYMBOL_ARRAY+=('၇ ဨ ၆ ၎')
#KL_STATUS_SYMBOL_ARRAY+=('❰⬡ ❱(᪥)❱' 'ᓭTա Tᓮ')
#KL_STATUS_SYMBOL_ARRAY+=('⎇ ⌥' '⋢⋣ ' ' ᱑ ፲፲ᗍ Ꮬ ෴  ߸߸ ' ' உ =<< -_')
#KL_STATUS_SYMBOL_ARRAY+=(' ᷄𓂏  ᷄' '|🝙|' '⌡' 'Ⳏ' '◍𓂏 ◍' '|🝙|' '⌡' 'Ⳏ')
#KL_STATUS_SYMBOL_ARRAY+=('ᑕ||ᑐ') # spam masubi?

# MISC
#KL_STATUS_SYMBOL_ARRAY+=('8[+]' '>(///)<' '(::[]::)' '⋢⋣') # present candy bandaide battery

# emoji support

KL_STATUS_COLOR_SUCCESS_ARRAY=()
KL_STATUS_COLOR_SUCCESS_ARRAY+=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 55 56 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 247 248 249 250 251 252 253 254 255 255)
#KL_STATUS_COLOR_SUCCESS_ARRAY=(10 85 114 193)
KL_STATUS_COLOR_SUCCESS_ARRAY=(48)
KL_STATUS_COLOR_ERROR_ARRAY=()
KL_STATUS_COLOR_ERROR_ARRAY+=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 55 56 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 247 248 249 250 251 252 253 254 255 255)
KL_STATUS_COLOR_ERROR_ARRAY=(red)
#KL_STATUS_COLOR_ERROR_ARRAY+=("magenta" "green" "cyan" "red" "white" "blue")

PURE_EMOJI="◄(^_^)►"
KL_PURE_EMOJI_ERROR_COLOR="red"
KL_PURE_EMOJI_ERROR_COLOR_INDEX=0
# orange color 166
# green 48 83
KL_PURE_EMOJI_SUCCESS_COLOR=48
KL_PURE_EMOJI_SUCCESS_COLOR_INDEX=0
KL_PURE_EMOJI_COLOR_ERROR_SPACING=""
KL_PURE_EMOJI_COLOR_SUCCESS_SPACING=""

# shrink the terminal
function termcollapse() {
    termexpand f
}

# get rid of prompt
function termexpand() {
    if [[ $# -gt 0 ]]; then
        if [[ "$1" == "f" ]];
        then
            export KL_PURE_ENABLE="False"
            export PROMPT='%(12V.%F{$prompt_pure_colors[virtualenv]}%12v%f .)%(?.%F{$KL_PURE_EMOJI_SUCCESS_COLOR}.%F{$KL_PURE_EMOJI_ERROR_COLOR})${PURE_EMOJI};%f '
            sed -i '' -e 's/export KL_PURE_THEME_ENABLE="True"/export KL_PURE_THEME_ENABLE="False"/g' ~/lab/scripts/pvalue.sh
        fi
    else
        export KL_PURE_ENABLE="True"
        export PROMPT='%(12V.%F{$prompt_pure_colors[virtualenv]}%12v%f .)%(?.%F{$KL_PURE_EMOJI_SUCCESS_COLOR}.%F{$KL_PURE_EMOJI_ERROR_COLOR})${KL_PURE_EMOJI_COLOR_SUCCESS_SPACING}${KL_PURE_EMOJI_SUCCESS_COLOR}:${KL_PURE_EMOJI_COLOR_ERROR_SPACING}${KL_PURE_EMOJI_ERROR_COLOR} ${PURE_EMOJI}%f '
        sed -i '' -e 's/export KL_PURE_THEME_ENABLE="False"/export KL_PURE_THEME_ENABLE="True"/g' ~/lab/scripts/pvalue.sh
    fi

    #gr
    echo "$KL_PURE_EMOJI_SUCCESS_COLOR:$KL_PURE_EMOJI_ERROR_COLOR $PURE_EMOJI"

}

generate_color() {
    generate_emoji x
}

generate_emoji() {
    KL_STATUS_SYMBOL_ARRAY_SIZE=${#KL_STATUS_SYMBOL_ARRAY[@]}
    if [[ $KL_STATUS_SYMBOL_ARRAY_SIZE -gt 0 ]] && [[ "$KL_STATUS_ARRAY_ROTATE" == 'true' ]]; then

        ## Get random emoji value
        if [[ $# -eq 0 ]];
        then
            KL_STATUS_SYMBOL_ARRAY_INDEX=$((($RANDOM % $KL_STATUS_SYMBOL_ARRAY_SIZE) + 1))
            export PURE_EMOJI=${KL_STATUS_SYMBOL_ARRAY[$KL_STATUS_SYMBOL_ARRAY_INDEX]}
        fi

        KL_STATUS_COLOR_SUCCESS_ARRAY_SIZE=${#KL_STATUS_COLOR_SUCCESS_ARRAY[@]}
        if [[ $KL_STATUS_COLOR_SUCCESS_ARRAY_SIZE -gt 0 ]] && [[ "$KL_STATUS_ARRAY_ROTATE" == 'true' ]]; then
            export KL_PURE_EMOJI_SUCCESS_COLOR_INDEX=$((($RANDOM % $KL_STATUS_COLOR_SUCCESS_ARRAY_SIZE) + 1))
            export KL_PURE_EMOJI_SUCCESS_COLOR=${KL_STATUS_COLOR_SUCCESS_ARRAY[$KL_PURE_EMOJI_SUCCESS_COLOR_INDEX]}
            if [[ KL_PURE_EMOJI_SUCCESS_COLOR -lt 10 ]]; then
                export KL_PURE_EMOJI_COLOR_SUCCESS_SPACING="00"
            elif [[ KL_PURE_EMOJI_SUCCESS_COLOR -lt 100 ]]; then
                export KL_PURE_EMOJI_COLOR_SUCCESS_SPACING="0"
            fi
        fi

        KL_STATUS_COLOR_ERROR_ARRAY_SIZE=${#KL_STATUS_COLOR_ERROR_ARRAY[@]}
        if [[ $KL_STATUS_COLOR_ERROR_ARRAY_SIZE -gt 0 ]] && [[ "$KL_STATUS_ARRAY_ROTATE" == 'true' ]]; then
            export KL_PURE_EMOJI_ERROR_COLOR_INDEX=$((($RANDOM % $KL_STATUS_COLOR_ERROR_ARRAY_SIZE) + 1))
            export KL_PURE_EMOJI_ERROR_COLOR=${KL_STATUS_COLOR_ERROR_ARRAY[$KL_PURE_EMOJI_ERROR_COLOR_INDEX]}
            if [[ KL_PURE_EMOJI_ERROR_COLOR -lt 10 ]]; then
                export KL_PURE_EMOJI_COLOR_ERROR_SPACING="00"
            elif [[ KL_PURE_EMOJI_ERROR_COLOR -lt 100 ]]; then
                export KL_PURE_EMOJI_COLOR_ERROR_SPACING="0"
            fi
        fi

    fi
}

termicon() {
    generate_emoji
}

termcolors() {
    echo "$KL_PURE_EMOJI_SUCCESS_COLOR:$KL_PURE_EMOJI_ERROR_COLOR $PURE_EMOJI"
}

generate_emoji
