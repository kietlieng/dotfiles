# after kreative font  (AK)
# https://www.kreativekorp.com/charset/font/KreativeSquare/
# http://www.kreativekorp.com/software/fonts/ksquare/
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

## avant-garde emoji designer
## other
#'(⌐▨ʭ▨)' '(/// -)' '(✖ ‿ ✖)' '𐂠  𐂠 ' '(◔ ‿◔)' '(°‿°)' # Kanye emo up-for-anything double rainbow
#'(ᴗ_ ᴗ。)' # sad
#'1⌐ࠏ෴ࠏ' '໒2▀෴▀ࠒ' '4t▀෴▀J' '4␦▀෴▀'
#'4t▀෴▀J' # kanye west
#'(⌐󱪶 Ⲻ󱪶 )' # Kanye west
#'᯾  ᷄♩⌡ ᷄|' '⺰ ᷄♩⌡ ᷄|' 'ᱭ  ᷄♩ ᷄|' '᱉  ᷄♩ ᷄|' '᱑  ᷄♩ ᷄|' '␦ ᷄♩ ᷄|'
#'0_0꧞' # ex-convict

# batman
#'/l- -l' 'ᄼ__ᄾ' #'🭋- -🭀' '🭋𓆩︹𓆪🭀' # batman
#'🭋- -🭀' # batman

#'⎩O_O⎭' # Lego
#'(⌐〇_〇)' # Harry potter Lego
#'〇丷⟦ ⟧) 9K?!' '⟦ ⟧ 9000?!' '⟦ ⟧) 9K?!' # dragonballz scouter
#'⟦ ⟧) 9000?!' # dragonballz scouter
#'⟦󿃥 ⟧) 9000?!' # dragonballz scouter

#'(󰹞󰹞-󰽤 )' '(󰹫 -𝧿 )' # transmetropolitan glasses 
#'🬋🬋-𝧿 ' # transmetropolitan glasses 

# ╭╮◝◜◝◜ ◞◟
# ⟈⟉

# '𜸪 𜸲 𜸸'

# animals
#'>++(º>' '><  º>' '彡:⊑>' 'ϵ('Θ')϶' '彡:D' #fish fish-bone squid blowfish jelly fish
#'ࡄࡄࡄɅࡄ' #shark fish squid
#'~~( )ᢄ:>' '('v')' '\\_O<' # mouse chick duck
#',≘,e' '(｀(●●)´)' # turtle pig
#'{O ٧ O}' '@..@' '@ᓆ ' '^. .^' # owl frog snail cat
#'Oᨐ O' '@('.')@' '-<(|)O=' 'C@@@ö' # alligator monkey bee caterpiller
#'( ;,;)' # spider peacock
#'꧁ ⸢꧂' # peacock
#'◝◜◝◜ ◞◟' # bats

## Games
#'[+..••]' '(✜..᠅)' '(+[_]᠅)' # nes, snes, vita
#'[+..••]' # nes
#'⊒⟮⑉⑉)﹚୦୦୦' # megaman 
#"<(-''-)>" # kirby sonic
#'𐤔ᜠᜰ_ᯓࡄ󰄰 ' '𐤔ᜠᜰ_ᯓࡄ ' '𐤔ᜠᜰ_ᯓࡄ  ' # sonic
#'𐤔ᜠᜰ_ᯓࡄ ' # sonic
#' ⦿๏ ᯓ㋨' # metroid morph ball

# metroids
#'ଳ ଲ (ˎ ꓹꡳ' 'ଳ ଲ (ˎ󰴗 ꓹꡳ' 'ଳ ଲ (ˎ󱔝 ˏꡳ' 'p( )ꝯ' '.󱆨󱎷 󱆨.' # metroids 
#'ଲଳ.󱆨󰗣󱆨.' # metroids 

#'♠ ♥ ♦ ♣' '[♠][♥][♦][♣]' # Cards
#'󰣎 󰣏 󰣐 󰣑 '

#'󱈸' # metal gear
#'[ ][ ][ ][][ ][󰄻 ]' # ninja guiden
#'█▄▄▀█▄▀▀▀▀▄█▄ ██'  # tetris
#'⭣⭨ ⭢ Ⓗ ' '⭢ ⭨ ⭢ Ⓛ ' '⭣⭩ ⭠ Ⓗ  󰠬 ' # fireball hurricane kick
#'⭣⭨ ⭢ Ⓗ   ' # street fighter fireball
#'⭡⭡⭣⭣ ⭠ ⭢ ⭠ ⭢ Ⓑ Ⓐ ' # contra
#'⮅ ⮇ ⭾ ⭾ Ⓑ Ⓐ ' # contra
#'󰡗 󰡘 󰡙 󰡚 󰡛 󰡜' # chess
#'󱙜 ᯓ󰮯 ● ᯓ󱙝 ' '󱙜 ᯓ󰮯 ● ᯓ󱙝 ᯓ ' '󱙜 ᯓ󰮯 ● ᯓ󱙝 ᯓ󰊠 ' '󱙜 ᯓ󰮯 ● ᯓ󱙝 ᯓ󰊠 ' '󱙜 󰧵 ᯓ󰮯 ●ᯓ󱙝 ᯓ󰊠 ' # pacman
#'󱙜 󰧵 ᯓ󰮯 ●ᯓ󱙝 ᯓ󰊠 ' # pacman
#'󱠡   ' '󱠢   ' # rock paper scissors
#'󱠢   ' # rock paper scissors
#'󱃏 󰓥    ' # zelda
#'󱃏 󰓥    ' # zelda
#'󱩁  ' # strider
#'ᯓ〛ⱃ⳻)' # mario bullet
#'ᯓ〚 ⱃ⳻)' # mario bullet
#'▂▄▆█ ᛩ 凸' '▂▄▆█ ᛩ ▗▆▖' # mario castle
#'▂▄▆█ ᛩ ⛫ ' # mario castle
#'󰮭 ' # mario mushroom
#' ⟭ᕲৡࡇ -𒊹𖣇' # r-type
#' ⟭ᕲৡࡇ -⨊ ' # r-type

# tron lightcycle
#'██▇(〇⪧ᐊ〇)' '██▇(〇⪧ᐊ〇)' '██▇( ⪧ᐊ)' '██▇▄  ⪧' '██▇▄   ' '██▇▄▁  ⪧ ' '██▇▄▁  ⪧︺⦅ ' 
#'█▄▁  ⪧乛𐌂' '█▄▁  ⪧ 󰥽 ' '█▄▁  ⪧乛󰨂 󰽧' '█▄▁  ⪧︺󱫯 󰽧' '█▄▁  l⪧︺󱫯 󰽧' '██▇▄( 𐪕︶󱫯 󰽧' '██▇▄( ︶󱫯 )' 
#'██▇▄( ︶󱫯 ' '██▇▄ ︶󱫯 ' '██▇▄ ︺Ɀ󰽥󰽧 ' '██▇▄ ︺Ɀ󰽥𛰨' '██▇▄ ︺Ɀ󰽥 ' '██▇▄ ︺Ɀ󰽥 ' '██▇▄ ﹀Ɀ󰽥 '
#'██▇▄ 𘠗Ɀ󰽥 ' '██▇▄ 𘠛Ɀ󰽥 ' '██▇▄ 𘠫Ɀ󰽥 ' '██▇▄ 𝋅Ɀ󰽥 ' '██▇▄ 𝋊Ɀ󰽥 ' '██▇▄ ︺Ɀ' '██▇▄ ︺Ɀ󰽧 '
#'██▇▄ ︺Ɀ '
#'██▇▄ ︺ⵢ '
#'██▇▄ ꩰᐊꓛ' Tron lightcycle

#'࿐󰇆 ' '╭╮󰇆 ' # predator

#'C-c' # face hugger
#'C-c' # xenomorph

#'\ ⏷ ⏶ ⏷ /' ' ◣ ⏷ ⏶ ⏷ ◢' ' ◣ ▼ ⏶ ▼ ◢' ' ◣◥◤◢◣◥◤◢' '\ ◥◤ ◢◣ ◥◤ /' '⟍ ◥◤ ◢◣ ◥◤⟋ ' ' \ ◥◤ ◢◣ ◥◤/' 
#'' '◹◸◿◺◹◸' '    ' weyland-yutani
# '   ' weyland-yutani

# terminator neural chip 
#'𐄧𐄧|=' '⁝⁝⁝⁝⁝|=' '⁝|=' '  |=' '󰠵󰠵󰠵󰠵󰠵|=' '󰒋 󰒋 󰒋 󰒋 󰒋|=' '     ' ' '
#'|' '|ⵎ' '󰒋󰒋󰒋󰒋󰒋𝩸=' '▐ⵎ' '▐ⵎ' '▐ⵎ' '▐[' '⦋⣶⣶⡆⦀ⵎ'
#'⦋ⵗⵗⵗⵗⵗ⦀ᄃ' '▐[' '⦀[' '[|['
#'[▐['
#'▐▐🬐'
#'▐▐🬐'
#'|𜹥𜹥𜹥𜹥𜹥|='

#'🭇🮋🬃' '𐙾🬃' '🭇🬛' blame toha heavy industries
#'🭇🬛' blame toha heavy industries

#'(┯┯┯)' '𐧂''CH𝍣AM' 'CH◖𝍣◗AM' dune choam 
#'CH𛰙𝍣𛰚AM'
#'CH𓐯𓏼𓍺AM'
#'󱇄 𓏼󱇂 '
#'󱇄 𝍢󱇂 '
#'󱇄 𐦤󱇂 '
#'󱇄 𐧃󱇂 '
#'󱇄 𐭛󱇂 '
#'󱇄 ꔖ󱇂 '
#'󱇄 ꠲󱇂 '
#'󱇄 🬦🬦󱇂 '
# 🬦🬦🬦 

# '༼⚻༽'  Darth Vader
# 'ᅔᚃᅕ'  Darth Vader
#
# '   ' sauron 

# angler fish
#'⛷ ᢵᶱ' '><  ' '⦆⦅ 𐆒 ' '⦆⦅ 𐇡 ' '⦆⦅ 𐎓 ' '⦆⦅ 𐙠 ' '⦆⦅ 𐘟 ' '⦆⦅ 𐠑 ' '⦆⦅ 𐠛 ' 
#'𐠷 𐠛 ' '𐿉⦅ 𐠛 ' '𐿉⦅ 𡿨 ' '𐿉⦅ 𬼂' '𐿉⦅ 𑖕 ' '𐿉⦅ 𑖒 ' '𐿉⦅ 𑣲 ' '𐿉⦅ 𒌋 ' '𐿉⦅ 𒑋 ' 
#'𐿉⦅ 𒐴 ' '⛷⦅ 𒑩 ' '⛷⦅ O𐠛 ' '⛷⦅ ㇣𐠛 ' '⛷⦅ ㈇𐠛 ' '⛷⦅ ꔌ𐠛 ' '⛷⦅  𐠛 ' '⛷⦅ 𐠛 ' 
#'⛷⦅ 𖫩𐠛 ' '⛷⦅ 𞋰𐠛 ' '⛷⦅ 𞠧𐠛 ' '⛷⦅ 🄎 𐠛 ' '⛷⦅ 󰍚 𐠛 ' '⛷⦅ 󰍷 𐠛 ' '⛷⦅ 󰓏 𐠛 ' '⛷⦅ 󰜞 𐠛 '
#'⛷∡  𐝆 ' '⛷∡  𑋸 ' '⛷∡  󰥽  ' '⛷𝈽  𐠛 ' '⛷𝉀  𐠛 ' '⛷   𐠛 ' 'Ⲁ⎇   𐠛 ' 'Ⲁ𝈽   𐠛 ' 
#'䀘𝈽   𐠛 ' '䀘𐕕   𐠛 ' '𐢄𐕕   𐠛 ' '꧈𐕕   𐠛 ' '𝈳𝈴𝋅  𐠛 ' '꧈∡𝋊  𐠛 ' '꧈∡𝋅▔  𐠛 '
#'꧈∡𝋅▔  𐠛 ' '꧈∡𝋅▔  𞋉 ' '꧈∡𝋅▔  𞓳 ' '꧈∡𝋅▔  󰤷 ' '꧈∡𝋅▔ 󰹻 󰤷 ' '꧈∡𝋅▔ 󰹻 𐠛 ' '꧈ ▔ 󰹻 𐠛 ' 
#'꧈𝋅 ▔ 󰹻 𐠛 ' '꧈෴𝋅 ▔󰹻 𐠛 ' '꧈⟋𝋅 ▔󰹻 𐠛 ' '꧈⤹ ▔󰹻 𐠛 ' '꧈⟋𝋅▔󰐾 𐠛 ' '꧈󰃕 ▔󰐾 𐠛 ' '꧈󰧻 ▔󰐾 𐠛 ' 
#'꧈󰧻 ▔󱡊 𐠛 ' '꧈󰧻 ▔ ዖ𐠛 ' '꧈󰧻 ⎺▔ዖ𐠛 ' '꧈⭜▔ ዖ𐠛 ' '꧈⭜▔ ዖ𐠛 ' '꧈󰧻 ▔ዖ𐠛 ' '꧈󰃕 ▔󱡊 𐠛 '
#'꧈⭜ 󱡊 𐠛 ' '꧈⭜ 󰐾 𐠛 ' '꧈࠼ 󰻃 𐠛 ' '꧈୵ 󰻃 𐠛 ' '꧈⭜ 󰻃 ࠋ ' 
#'꧈⭜ 󰻃 𒍦 ' # angler fish
#'꧈⭜ 󰻃 𖥉 ' # angler fish
#'꧈⭜ 󰻃 𐠛 ' # angler fish

# '󿀭 󿀮 󿀯 ' dragon boat

#'🮲🭰🭵🮳' # portal

# '    ෴' 🭋业🭀 🭁 🭌 🭂 🭍 🭃业🭎 🭄 🭏 🭅 🭐 🭆 🭑 🭒 🭓 🭔 🭕 🭖 🮨🮩 'ᚅᚄᚃᚂᚁᚏᚎᚍᚌᚋ🭋🬲业🬷🭀ᚋᚌᚍᚎᚏᚁᚂᚃᚄᚅ'  game of thrones
# 'ᚅᚄᚃᚂᚁᚏᚎᚍᚌᚋ业ᚋᚌᚍᚎᚏᚁᚂᚃᚄᚅ' game of thrones
# 'ᚅᚌ۩ᚌᚅ' game of thrones

# '𓆩𒿍𓆪' kiss


# ⭖ _⭗ 

# gestures
# '󱟄 🯁🯂🯃' '󰖃 🯁🯂🯃' foam fingers
# '󱅼 🯁🯂🯃' foam finger 
# '󰭥 󱩁 ' punch
# ' 󱅻  ' 
# ' 󱅻  ' 
# ' 󱅻  ' peace
# ' 󱅻  ' peace
# '🮲🮳󰃦 ' megaphone
# '🫸󰋦 🫷' squished 
# '󱌆 󱆊 ' grill
# '󱅼 ☞ ☜ 󱩁 ' point 
# ' 󰋦 🯁🯂🯃' # peace 
# '☜ 󰋦 ☞ ' #
# '󰭥 󱩁 '
# ' 󱅻  '
# '󰜎  ' # good

# '󱙝 _' '⟮o﹏o⟯_' '🭵꠶﹏꠶🭼' '🭵🢭﹏🢭🭼' '🭵🢭𛲗𛲗🢭🭼' '🭵՞﹏՟🭼' '।🢭﹏🢭।_' '🭵॰﹏॰🭼' '🭵ॱ﹏ॱ🭼' ghostty
# '🭵੶﹏੶🭼' '🭵་﹏༌🭼' '🭵੶﹏੶🭼' 'ᒳ﹏ᒶ' '🭵ॱ﹍ॱ🭼' '🭵ﾟ﹏ﾟ🭼' '🭵𐞵﹏𐞵🭼' ghostty
# '𐬰੶﹏੶𐬦_' ghostty


# pre kreative font
#KL_STATUS_SYMBOL_ARRAY=('󰊠 _' '󱙝 _' '󰜎  ' ' 󱅻  ' ' 󱅻  ' ' 󱅻  ' ' 󱅻  ' '󱌆 󱆊 ' ' 󱅻  ' '󰭥 󱩁 ' '󱅼 🯁🯂🯃' '🮲🭰🭵🮳' '꧈⭜ 󰻃 𐠛 ' '   ' '🭇🬛' '𝍣' '⦀[' '   ' '󰇆' '(⌐󱪶 Ⲻ󱪶 )' '/l- -l' '(⌐〇_〇)' '⟦ ⟧) 9000?!' '🬋🬋-𝧿 ' '[+..••]' "<(-''-)>" '𐤔ᜠᜰ_ᯓࡄ ' ' ⦿๏ ᯓ㋨' 'ଲଳ.󱆨󰗣󱆨.' '󰣎 󰣏 󰣐 󰣑 ' '█▄▄▀█▄▀▀▀▀▄█▄ ██' '⭣⭨ ⭢ Ⓗ   ' '⮅ ⮇ ⭾ ⭾ Ⓑ Ⓐ ' '󰡗 󰡘 󰡙 󰡚 󰡛 󰡜' '󱙜 󰧵 ᯓ󰮯 ●ᯓ󱙝 ᯓ󰊠 ' '󱠡   ' '󱃏 󰓥    ' 'ᯓ〛ⱃ⳻)' '▂▄▆█ ᛩ ▗▆▖' ' ⟭ᕲৡࡇ -𒊹𖣇' '██▇▄ ︺ᐊꓛ')

KL_STATUS_SYMBOL_ARRAY=('󿀭 󿀮 󿀯 ' '󰊠 _' '󱙝 _' '󱌆 󱆊 ' '󰭥 󱩁 ' '󱅼 🯁🯂🯃' '🮲🭰🭵🮳' '꧈⭜ 󰻃 𐠛 ' '   ' '🭇🬛' '   ' '󰇆' '(⌐󱪶 Ⲻ󱪶 )' '🭋- -🭀' '(⌐〇_〇)' '🬋🬋-𝧿 ' '[+..••]' "<(-''-)>" '𐤔ᜠᜰ_ᯓࡄ ' 'ଲଳ.󱆨󰗣󱆨.' '󰣎 󰣏 󰣐 󰣑 ' '█▄▄▀█▄▀▀▀▀▄█▄ ██' '⭣⭨ ⭢ Ⓗ   ' '⮅ ⮇ ⭾ ⭾ Ⓑ Ⓐ ' '󰡗 󰡘 󰡙 󰡚 󰡛 󰡜' '󱙜 󰧵 ᯓ󰮯 ●ᯓ󱙝 ᯓ󰊠 ' 'ᯓ〛ⱃ⳻)' '▂▄▆█ ᛩ ▗▆▖' ' ⟭ᕲৡࡇ -𒊹𖣇' '██▇▄ ︺ᐊꓛ')
#KL_STATUS_SYMBOL_ARRAY=('󰊠 _' '󱙝 _' '󱙜 󰧵 ᯓ󰮯 ●ᯓ󱙝 ᯓ󰊠 ') # ghostty
#KL_STATUS_SYMBOL_ARRAY=('󱙝 _' '⟮o﹏o⟯_' '🭵꠶﹏꠶🭼' '🭵🢭﹏🢭🭼' '🭵🢭𛲗𛲗🢭🭼' '🭵՞﹏՟🭼' '।🢭﹏🢭।_' '🭵॰﹏॰🭼' '🭵ॱ﹏ॱ🭼' '🭵੶﹏੶🭼' '🭵་﹏༌🭼' '🭵੶﹏੶🭼' 'ᒳ﹏ᒶ' '🭵ॱ﹍ॱ🭼' '🭵ﾟ﹏ﾟ🭼' '🭵𐞵﹏𐞵🭼' '𐬰੶﹏੶𐬦_')
#KL_STATUS_SYMBOL_ARRAY=('󱙝 _' '⟮o﹏o⟯_' '🭵॰﹏॰🭼' '🭵ॱ﹍ॱ🭼' '🭵𐞵﹏𐞵🭼' '𐬰੶﹏੶𐬦_')

# boxes
# 󰿦 󰿦   󰿠  󱂩 󰹫 󰛲 ⊑⊒ ⊏⊐⁅⁆  ◻ ◼ ⍞ ⍠ ▛▜ 匚匚匚凸凸凸 凹凹凹 凵凵凵 口口囗
# 🭽🭿 🭼🭿 🭿🭽🭾🭼
#
# 🮂🮃🮄

# animation
# ㅏ ﹇ ﹈ 

# grass:
# ᚁᚂᚃᚄᚅ ᚆᚇᚈᚉᚊ ᚋᚌᚍᚎᚏ ෴ 灬 

# fences
# ߚߚߚߚ 󱪿󱪿 

# three
# 󰕶 󰒋   𐬺 𐬻 𐬼 𐬽 𐬾 𐬿

# sets
#   _      ╚═╦═╬╗ 𐄢 𐄣 𐄤 𐄥 𐄦 𐄧 𐄨 𐄩 𐄪 𐄫 𐄬 𐄭 𐄮 𐄯 𐄰 𐄱 𐄲 𐄳 
#    𐃚 ⪛⪜ ꓚꓛ
# 🬒🬡  🬡🬒🬂🬭🬰

# pairs
# ɾɿ ୧୨  ⋐⋑ 𓂁𓂄
# 𝈴 𝈳 𝈮𝈬  𞓶𞓷𞓸𞓹 𓉖-_-𓉕
# 𖭰𖭱 𖭱𖭰 𖬮𖬯𖬮 𖬂𖬀 𖬐𖬆 𖼲𖼪
# 󰮺 󰮹  󰮺 󰮹  󰮼 󰮻  󰮻 _󰮼   󰮵 󰮶 󰮵  󰞔 󰞓  󰞘 󰞗  󰞓 󰞔  󰞘 󰞗  
# 🮘🮙🮘     ⎡⎤ ⎣⎦ ⚟⚞ ﴾﴿ ⥶⥸ ⫑⫒ ⫎ ⫍ ᚜᚛ ⊱⊰ ⹑⹐ 𓆩𓆪 𖩣𖩤 𖩂𖩁 𖩇𖩉 𖩎𖩐 𖭱𖭰 𝈳 𝈴       
# 𝈶 𝈷 𝈸 𝈹 𝈺 𝈻 𝈼 𝈽 𝈾  𝉀 𝉁 ⎬⎨ ⎨⎬ ⟓⟔ 𐝢𐝥  𓐯𓍺 𖩤𖩣 𛰿𛰾 𛰾𛰿 𖼑𖼅 𓉙𓉜 𓉚𓉛 𓉘𓉝 ͼͽ ߓߔ ꫠꫡ  ﹄﹃ 
# 󰽥 󰽦 󰽧 󰽣󰽡  ⌿⍀ ⍁⍂ ⍃⍄ ⍅⍆ ⍇⍈ ⌈⌉ ⌊⌋ ◨◧  ⟗ ⮘ ⮚ ⮙ ⮛ ⮜  ⮞ ⮝ ⮟ ⮠ ⮡ ⮢ ⮣ ⮤⮥ ⮦⮧ 
# ⮨ ⮩ ⮪ ⮫ ⮬⮭ ⮮⮯ ⮰ ⮱ ⮲ ⮳ ⮴ ⮵ ⮶ ⮷     ￆￂ ￃￄ ￅ   𓏩𓏩𓏩 𓏩𓏨𓏩 𓏨𓏨𓏨
# 𓌸𓌺 𝆲 𝆱 🢔🢖  󱦶 󱦷 󱦶  ༼༽ ꤄꤅  𐅁𐅀 
# 𑪸𑪺 𑪹𑪻 𑪲𑪴 𑪳𑪵 𑪾𑪿 𑪽𑪼 

# stairs
# ᝐ ᝃ ᝄ

# dots
# ˸:։׃܃ ܄ ܆ ܇ ܈ ܉ ࠱᎓

# chair
# 𝆶 𝆷

# oval
# ╭╮╰╯ 󱑹 ᢾᢿ ᣅ ᣢᣡ ᣧᣦ ⊄⊅ ⊆⊇ ⊈⊉ ⊊⊋ ⋨⋩  ⋰ ⋱ 

# diamonds
#  

# triangles
#  ◹◸ ◿◺ ⛛ ⛰ ᧘ ⍙ ⎆ 

# noses
# Ո Ս ఎ  ໑ ꔽ ꗅ ꗆ 𠃑𠄌 𠄍 𠄎 𠄏 𠃌 𠦜 𘃙 𐮊 𐮋 𐮭 𐰞 𐰸 𐰲 𐰴 𐴆 𐺡 𐺠 𐼌 𐾼 𐽂 𑀉 𑀊 𑀑 
# 𑁬 𑃒 𑃓 𑃔 𑃕 𑃖 𑃗 𑃘 𑃙 𑃚 𑇧 𑖪 𑙧 𑢴 𑢺 𑣧 𑣝 𑣪 𑤮 𑧁 𑱒 𑱗 𑻣 𑽗 𑽘 𑽙 𒇺 𒾾 𒾿 𒿀 𒿁 𒿟 𓂆 𓆭 𖩸
# 𖪥 𖪪 𖩰 𖪯 𖪰 𖪾 𖬖 𖬁 𖬉 𖭔 𖭟 𖹨 𖹩 𖺂𖺃 𖽅 𛁳 𛆈 𛆓𝋒 𝕱 𝖅 𝕵 𞅄 𞅈 ᖱᖲ  Ꝇ

# owen wilson
# '-Ꮘ-' ' 𛆈 ' '^𛆈^ ' 'ʻ𛆈ʼ' 'ʻ𖽅ʼ' 'ʻ𑃙ʼ' 'ʹ𑃙ʹ' 'ᖰ𑃙ᖳ'
# '܋𑃙܋' '𐝈 ⏿'

# mouth
# ꭍꭙ ꭟ〲 ︹ 𐑤𐑮 𐑧𐑨 𐑩𐑪 𐑱𐑲 
# ᖰ︹ᖳ

# ears
# ꪶꗃ_ꗃꪶ ꗄ ꩹ Ꝫ ꝫ Ꝭ- -ꝭ Ꝯ ꝯ 
#  𛰰  𛰱 ᖰ︹ᖳ  ᖳ-︹-ᖰ 𐝈𐘟𐤢 𐚞 𐘲 𐘳
# 𑗅  󱇃  󱇄 󱇂  Ͼ Ͽ
# 󱫮

# spiral
# 𑗑 𑗒 𑗓 𑗔 -(> =(> <)- 𜲀 𜲁 𜲂 𜲃
# 󱕲 󱕳

# hex
# |꣼꣼|

# ᖹ ᖺ ᖻ ᖼ  ᖽᖾ ᖿᖼ ᗀᗁ ᗂᗃ 𐅁𐅀 Ⳛⳛ ꣺ꙿ󰿈 ⸒
# 󰾻 󰾼
#'ᚍᚎᚏ◝◜ᚏ◝◜ᚏᚏᚏ' # bats
# 󱆧 󱆨 
# 𑜿 ⼚ㄟ Ⲵ ⲵ # ᕘ ᗄ ᕚ ⌎⌏⌌⌍ ᎘      𐀍 𐀟 𐁈 𐂲
# ⸸ 𐃗 ㆑ 🮫🮪 ￣▔⎺⎻‐‑‒–—―  ⦚ ⸏⸐⸑ ━┯━ 
#   ᶘᶅ
# ꣻ꣼
#   ꤚ

# ramp
# ⵰ ꮧ ୵ 

# corner
# ⛠ ⛡  ⎖ ⟀ ◿  ◞◟◞◟ ⦜ ⦝ ꣺ ⴿ   ᆚ ᆜ
#  ﹰ ﹲ ﹶ ﹼ𐹼


# waves
# ◠ ◡◠◡◡◠◠◡◠◡
# ⑂⑃⑂⑃⑂⑃⑂⑃⑂⑃
# ⌇⌇⌇
# ╱╳╲

# ground
# ـــــ ＿＿＿

# excite bike
# 🭊🬹🬿 󱂜 🭈🬭🬽
# 🭊🬿 🭈🬽󱄟
# 🭊🬿 🭈🬽󱖺 
# 🭊🬿 🭈🬽󱖷 
# 🭊🬿 🭈🬽󱖸 
# 🭊🬿 🭈🬽󰂣
# 🭊🬹🬿＿＿🭈🮏🬽󱄟
# 🭊🬹🬿  🭈🬽󱄟

# heart
# 󱃠 >

# icons
# '󰐂 󰐃 󰐅 󰐉 󰙱 󰏉 🮹🮺󱕬 󰂒

# maze
#
#                            
#                            
#                           
#                                                  

# multistory
# 𜲦 𜲧 𜲨 𜲩 
# 𜲪 𜲫 𜲬 𜲭 𜲮 𜲯 𜲰 𜲱 
# 𜲲 𜲳 𜲶 𜲷 𜲺 𜲻 𜲾 𜲿 𜳂 𜳃 𜳆 𜳇 𜳊 𜳋 𜳎 𜳏 𜳒 𜳓 
# 𜲴 𜲵 𜲸 𜲹 𜲼 𜲽 𜳀 𜳁 𜳄 𜳅 𜳈 𜳉 𜳌 𜳍 𜳐 𜳑 𜳔 𜳕 


# odd
#     𜰸 𜰹 𜰺     𜲦 𜲧 𖭅 𞡽 𑪝𓏵 𝄖 𝄗 𝄘 𝄙 𝄚 𝄛 𛱳𛱴𛱵 𛱰𛱱𛱲
#(⨀ _⨀ ) #𛰲𛰵 𛰳𛰴  𛰹𛰶 𛰸𛰷 𛰿𛰾 𛱀𛰽 #  ⨅_⨅_⨅_⨅ ⨅⨆ 𖣺𖧠
# 〖〗〖⯘ 〗 ⯘  (_)  ⯘  ౯౬ ౭ಽ ꧳꧴ ꧴꧳  ꜠ ꜡  
# ꤰ ꤱ ꤲ ꤳ ꤴ ꤵ ꤶ ꤷ ꤸ ꤹ ꤺ ꤻ ꤼ ꤽ ꤾ ꤿ ꥀ ꥁ ꥂꥃ ꥄ ꥅ ꥆ ꥇ꥟ 🮹🮺 
# ꟿꟿꟿꟿꟿ ʕʔ ʖ 𓇽 𓈍 ଽ ཥཤ  ᚢᚣᚤᚥ ᚷᛜ ⁁ ⁄ 🮲🮳 ᚲᛈᛊ ㇝ ꘍꘍꘍ ꔖ 
# 𝈄 𝈠  𝈠𝈄 󰷻 ⍜ o 󰽫 󰽬 󰽭 󰽮 󰽯 󰽰 󰽱 󰽲 󰽳 󰽴 󰽵 󰽶 󰽷 󰽸 󰽹 󰽺 󰽻 󰽼 
# 🭬🮚🭮 𬼆𬼆𬼆 󱗗 󱒄 󰿘 ᪦ ▗▖ ⅏  ϔ ה ۩ ꛕ 𐧄 𐧈 𐰥 𐰤 󱩅 󱩅  
#  ߂߃߄߅߆߇߈߉ߊߋߌߍߎߏ 𒑲𒑳𒑈𒑴 𐋦𐋧 𔖷𔖶𔖷 ꔗ  ꔿ ꛞꛖ 󰾞 󰾞 󰞍 󰞍  󰋟 
#    ﴾ ﴿ ဩ ႟ ꧶꧵ 
# ﾤ𐒇 ＿𐆋 𓃇  𓉔 𓉖 𓉕 𓉗 󱌨 󱌰 Ⅎ ༗ ༆ 𝄔 𝄕 𑍝   𪛙     
# ﴾ ﴿ # NOT parenthesis need to uncomment to see
# 𪛙 𪛚 𪛛 𪛜 𪛝 𬺰 𬺱 𬺲 𬺳 𬺴 弓 弔 引 弖 弗
# 曰 𡿜 𡿦 𡿧 𡿨 𡿪 𣦶 𠓛 𠓜 𠓝 𠓞 𠘧 𠘨 𠚳 𡘋
# 𡭯 𢁝 𣁬 𣱾 𰀰 𰀱 𠀈 𠁥 𬻿 𬼀 𬼁 𬼂 𬼃 𬼄 內 
# 再 𠕋 冗 冤 仌 冬 况 𩇟 凵 ⺡ ⌠⌡ 󰿈  ⎇  ༅  ༆ ༄ 
# ᯢ  󰵄 ꣺⳿  ⮁  ꕸ  ꚜ ꧦ ኑ 𠄎 ⎇  𠁼         𛱹 
# 🝥 🝶 🞋    ⅏  ⯙

# wars
# 󱁧 󰣘 󰣙 󰢱

# buildings
# 󰃦   
# 󱦫 󱦬 󱩟         󰅄 󰅆 󱟋 󱟌 󱟍 󱟎 󱟏 󱟐 
# 󱟑 󱟒 󱟓 󱠧 󱣁 󱣂 󱣃 󱣄 󱣅 󱣆 󱣇 󱣈 󱣉 󱣊 󱣋 󱣌 󱣍 󱣎 󱣏 
# 󱣐 󱣑 󱣒 󱣓 󱣔 󱣕 󱕫 󱕬 󱄔 󱄕 󱅗 󱅘 󱔖 󱟹 󱟺 󱟻 󱟼 󰽖 󰾁 
# 󰿐 󰿑 󱁏 󱁈 󱁫 󱁬 󱃁 󱃎 󱃯 󱃰 󰺆 󰺇 󰺈 󰺉 󰺊 󰺋 󰺌 󰺍 󰺺 
# 󰻺 󰻻 󰻼 󰮧 󰴕 󰴖 󰴾 󰶀 󰶁 󰶂 󰶃 󰶄 󰶅 󰶆 󰸮 󰸯 󱋓 󱋔 󱋕 
# 󰛙 󰛚 󱪾 󱪿 󱫀 󰄚 󰅄 󰅆 󰟐 󰟑 󰟒 󰒹 󰢠 󰓍 󰓜 󰓝 󰚁 󰚂 󰚆 
# 󰡢 󰡆 󰣝󰤜 󰤝 󰤞 󰣫 󰣬 󰦚 󰦠 󰦡 󰦫 󰧿󰨀 󰨛 󰨜 󰨧 󰨨 󰨩 󰨶 
# 󰨷 󰫗 󰫘 󰭉 󰭎 

# eanimals
# 
#              󱖉 󱖊 󱜿 󱀆 󱢴 󱢺 
# 󱩡 󱩢 󱙷 󱙸 󱙹 󱜛 󱙷 󱔎 󱕘 󱍢 󱇪 󱇫 󱗆 󰄛 󰈄 󰈺 󰕄 󰟂 󰤇 
# 󰭟 󰴻 󰼁 󰼂 󰐁 󰩃 󰩄 󰾡 󰾢          

# food 
# 󰁳 󰥚  
#                    
#              󱅾 󱤞 󱥰    
#         󰢺 󰉚 󰩰 󰪯 󰮣 󱡊 󱡋 󱐟 󱐠 󱛜 󱜜 
# 󱝶 󱝹 󱄎 󱄏 󰼾 󱤖 󱐩 󱍗 󱍘 󰃪 󰃫 󰄊 󰄏󰄐 󰄑 󰉜 󰊎 󰊏 󰊐 󰊑 
# 󰊒 󰊥󰊦 󰊧󰊨󰌪 󰒣 󰒤 󰒥 󰒦 󰖌 󰛊 󰠤 󰟈 󰥚 󰦌 󰦥 󰧰 󰧱 󰧲 󰧻 
# 󰪰 󰮭 󰹅 󰻽 󱂟 󱅠 󱆊 󱆉 󱊹 󱌌 󱌍 󱌎 󱌏 󱌐 󱌗 󱌘 󱌙 󱌚 󱌛 
# 󱌜 󰃩 󰃪 󰃫 󰆳 󰆴 󰚅 󰟇 󰟪 󰠪 󰐉 󰉛 󰮿 󰳮 󰳯 󰲄 󰼾 󱁂 󱁃 
# 󱁄 󱁅 󱁆 󱁇 󱛜 󱥗
# 🥋 🥐 🥑 🥒 🥓 🥔 🥕 🥖 🥗 🥘 🥙 🥚 🥛 
# 🥜 🥝 🥞 🥟 🥠 🥡 🥢 🥣 🥤 🥥 🥦 🥧 🥨
# 🥩 🥪 🥫 🥬 🥭 🥮 🥯 🧀 🧁 🧂 🧃 🧄 🧅 
# 🧆 🧇 🧈 🧉 🧊 🧋 

# hands
# 󱢏 󱢐  🖎 🖏 🖐🖑 🖒 🖓 🖔 🖕🖖🖗 🖘 🖙 🖚 🖛 🖜 🖝 
# 🖞 🖟 🖠 🖡 🖢 🖣       󱖡 󰱏 󰵶 󰵷 󰹆 󰹇 󱃱 
# 󱈘 󱈛 󱉘 󱎟 󱕾 󱕿 󱖀 󱢶 󱢷 󱥋 󱩂 󰆽 󰔑 󰔒 󰔓 󰔔 󰔕 󰕹 󰜼 
# 󰜽 󰜾 󰜿 󰝀 󰝁 󰝂 󰝃 󰩏 󰩑 󰩒 󰩓 󰩔 󰩕 󰭥 󱠫 󱠬 󱠭 󱠮 󱠯 
# 󱠰 󱠱 󱠲 󱠳 󱠡 󱠢 󰽒 ☚ ☛ ☜ ☝ ☞ ☟ 󰋇 󰩐 🤌🤏🤘🤙
# 🤚🤛🤜🤝🤞🤟🤲🥊🦵🦶🦻🫰🫱🫲🫳🫴🫵🫶🫷
# 🫸✊✋✌✍


# human
# 🮲🮳🤷🤸🤺🤼🤽🤾󰚩 󱥵    󱌄 󱌅 󱌆 󱌇 󰳅 󰶇 󰴡
#        󱎋 󱎌 󱎍 󱖁 󱝄 󱝅 󱝆 󱟄 󱠕 󱠖 󱠣 󱢘 
# 󱢙 󱢚 󱢛 󱦀 󱦁 󱥷 󱄛 󱅝 󱅞 󱅟 󱅻 󱅼 󱌄 󱌅 󱌆 󱌇 󱌈 󱌉 󰮖 
# 󰺛 󰽒 󰽓 󰾣 󰿖 󰿗 󰿻 󱀓 󰯩 󰲈󰳩 󰵿 󰶇 󰶑 󰸔 󰹼 󰹽 󰱶 󰱷 
# 󰱸 󰱹 󰱻 󰱨 󰱩 󰱪 󰱫 󰱬 󰱭 󰱮 󰱯 󰱰 󰱱 󰱲 󰱳 󰱴 󰱵 󱨟 󱨠 
# 󱨡 󱩲 󱪇 󱪌 󰀙 󰁬 󰂣 󰋦 󰋧 󰋨 󰐛 󰑮 󰑻 󰑼 󰑽 󰑾 󰑿 󰒀 󰒁 
# 󰒂 󰒷 󰓋 󰒶 󰓣 󰔁 󰖤 󰗋 󰗏 󰗓 󰖵 󰖃 󰘰 󰘱 󰙃 󰙄 󰙉 󰙊 󰙋 
# 󰙌 󰙍 󰚼 󰜎 󰠃 󰠨  󰢙 󰢚 󰢯 󰩂 󰩈 󰩙 󰩚 󰩛 󰩜 󰩝 󰩞 󰪭 󰫁 
# 󰭐 󰭑 󰭒 󰭓 󱗉 󱗻 󱨟 󱨠 󱨡 󱪌 󱃞 󱃟 󰠬 󱩁

# travel
#   󱀒 󱀓 󱀔 󱀕 󱀖    󱖲 󱖳 󱖴 󱖵 󱖶 󱖷 󱖸 󱖹 󱖺 󱖻 
# 󱖼 󱖽 󱖾 󱖿 󱗀  󱗁 󱗂 󱗃 󱠪 󱠔 󱢑 󱣠 󱦭 󱦮 󱦯 󱧞 󱧟 󱙯 
# 󱙰 󱂜 󱂝 󱄟 󱊽 󱊾 󱊿 󱓄 󱓂 󱓞 󱓟 󱗇 󱗈 󱘏 󰺞 󰺸 󰺼 󰺽 󰻈 
# 󰻝 󰼻 󰼿 󰼽 󰿥 󰿧 󱀒 󰳔 󰴫 󰴬 󰴺 󰵤 󰵦 󰵧 󰵨 󰵩 󰵹 󰶓 󰷃 
# 󰷄 󰷅 󱫯 󰄋 󰄌 󰄍 󰄎 󰅅 󰇿 󰓟 󰓿 󰔫 󰔬 󰔭 󰔽 󰔾 󰗔 󰗕 󰚏 
# 󰛝 󰞜 󰞝 󰞈 󰞁 󰞞 󰞟 󰞠 󰞧 󰞨 󰞩 󰞪 󰞫 󰞬 󰞭 󰟉 󰟊 󰟺 󰟻 
# 󰢫 󰣊 󰣍 󰫂 󰭇 󰭈 󰬢 󰭬 󰭭 󰭮 

# 󰞭 󰟺  
# 󰑮 
# 󰖃  

#bars
#󰕫 󰕬 󰕭 󰕮 󰕯 󰕰 󰕱 󰕲 󰕳 󰕴 󰕵
# 󰕮 󰕮 󰕮 󰕮

# trees
#     𐅉     𓐨 𓐩 𓐪 𓐫 ɻ ɻ ༗ 󰔱 󰎏 󰎎 󰹦 
# 󰹧 󰹩 󱁕 󱔐 󱢗    󰧰 󰧱 󰧲 

#   coral

# scene
# 󱣔 󰎏   󰔱

# 𛅷𘃙𛅶
# 𛅷𠀃𛅶
# 󱀑 󰾋 󰷝  󰫠 󱃏  
# pics
# 󱙳 󱙴 ﹏΅ 󰼁 󰼂 󰹢 󰹣 

# circle
#  𜲟 𜲞
# 🞅 🞆 🞇 🞈 🞉 🞊 🞋 
#                 﫜
# 󱡝 󱡞 󱢖 󱨄 󱨅 󱨆 󱨧 󱨸 󱪂            
# 󱔫 󱔬 󱖏 󱖐 󱖑 󱖒 󱖓 󱖔 󱖕 󱖖 󱖗 󱖘 󱖙 󱖚 󱜠 󱟜 󱟝 󱠋 󱡭 󱡓
# 󰺖 󰹻 󰻂 󰻃 󰽣󰽡󰽢 󰽤 󰽥 󰽧 󰽦 󰽗 󰽚 󰿡 󰿢 󰿣 󰿤 󱔛 󱔜 󱔝 󱔞 
# 󰪞 󰪟 󰪠 󰪡 󰪢 󰪣 󰪤 󰪥 󰬦 󰬧 󰬨 󰬩 󰬪 󰬫 󰬬 󰬭 󰬸 󰭍 󰭃 󰮮
# 󰤁 󰤂 󰤅 󰤆 󰥋 󰦴 󰦤 󰦛 󰦕 󰦖 󰦗 󰦘 󰧞 󰧟 󰦔 󰩁 󰯚 󰸥 󰸦 󰺕  
# 󰞯 󰞰 󰞾 󰟃 󰟄 󰟍 󰟞 󰞯 󰞰 󰠠 󰠰 󰠳 󰡂 󰡳 󰡴 󰡵 󰡾 󰢓 󰣉 󰣿 
# 󰜘 󰜙 󰜚 󰜛 󰜜 󰜝 󰜞 󰝥 󰝦 󰝴 󰝬 󰝭 󰝸 󰝹 󰝺 󰝻 󰝼 󰝽 󰝾 󰝿 
# 󰐽 _󰐾  󰗝 _⭗  ⭖ _⭗  󰗮  󰘻  󰘼  󰙦 󰙧  󰜍
# 𛰙𛰚 𛰝𛰞 𛰡𛰢 𛰧𛰨 𛰫𛰬 𛅷𛅶    𓍹𓍺 𓍹𓍻 𝧿 𝨀 𝨁ዐ
# ⋋ ⋌ ⯖ ⯖  _    󰨚 󰨙  𑿞𑿟 𑿟 𑿞 ᖰ_ᖳ ◝◜◝◜ ⏿ ךּ כּ לּ 
# ﯎ ﯏  ෧ ෮  ᑬ ᑫ    ꄱꄲꅂꆪ Ꝺ ꝺ Ꝋ ꝋ Ꝍ ꝍ ꠶ ꠷ ꤀ 
# 𓊙𓊘  ꜗ ꜘ  ꜙ_ꜙ ꜚ ꜛ

# face
# ﴼ ﴽ 

# arrows
#  𐠑          

#  
# ۵۵۵ ﹆ ᧘ ⧽⧼ Ⲁ ⲁ
# 冖冂冎
# ꪶꗃ_ꗃꪶ ꗄ ꩹ Ꝫ ꝫ Ꝭ- -ꝭ Ꝯ ꝯ  ears
# 󱞖  󰩫 󰅹  󱙺    
# ⏿⏿⏿⏿ ꯴꯴꯴꯴ ꚸ ΅΅΅΅ ࿐ ࿙࿚ ᝦ \\ᣃᣄ/
#  ¦   ࢷ  Ϡ ך P ᵜںᵜ ᤙ
# ᝐᝢᝥᝦ  Ჰ Ჱ ◥█◤ ଠ ಄ _ರ ಃ_಄ ௸  ௹  ௺ 
# උ ງ   ೨ ౽ ౾           
# ᵜᤙᵜ ⏌ ⏋ ⎺⎸⎻ ⎼ ⎽ ⎝◄ ◅⎞ ⩘⩗ ▾ ▿ ◀ ◁ ◂ ◃ ◄ ◅ 乛
# ᛑ ᛒ ᛓ ᛔ ᛕ ᛖ ᛗ ᛘ ᛙ ᛚ ᛛ ᛜ ᚷ ᚸ ᛝ ᛞ ᛟ ᛃ
# ဩ 扌扌扌氵 灬  ⸝⺣⸜ 灬 ⸔⺣⸕ 灬 ⸽⸾
# 罒|罒|罒訁訁訁 ꀯꚰ ꇚ㇍ ㇏)㇎
# ꤰꤱꤲꤳꤴꤵ ꤶꤷꤸꤹꤺꤻꤼꤽꤾꤿꥀꥁꥂꥃꥄꥅꥆ
# 龴 龸 ⸙o丷o

# objects
#'/7\\' '(◍_ᑢᑝ_◍)' # tent austin martin
#'(◍_ᑢᑝ_◍)' # austin martin
#'[̲̅$̲̅(̲̅1)̲̅$̲̅]' '[̲̅$̲̅(̲̅2ο̲̅̅)̲̅$̲̅]' # money
#'༽v༼' 'ࡄ' '-᮵ - ⟁ ' '-[]-࠽' 'ᝑഽட৲'
#'၇ ဨ ၆ ၎'
#'❰⬡ ❱(᪥ )❱' 'ᓭTա Tᓮ'
#'⎇ ⌥' '⋢⋣ ' ' ᱑ ፲፲ᗍ Ꮬ ෴  ߸߸ ' ' உ =<< -_'
#' ᷄𓂏  ᷄' '|🝙|' '⌡' 'Ⳏ' '◍𓂏 ◍' '|🝙|' '⌡' 'Ⳏ'
#'ᑕ||ᑐ' # spam masubi?

# MISC
#KL_STATUS_SYMBOL_ARRAY+=('8[+]' '>(///)<' '(::[]::)' '⋢⋣' # present candy bandaide battery

# emoji support

#KL_STATUS_COLOR_SUCCESS_ARRAY=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 55 56 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 247 248 249 250 251 252 253 254 255 255)
#KL_STATUS_COLOR_SUCCESS_ARRAY=(10 85 114 193)
KL_STATUS_COLOR_SUCCESS_ARRAY=(48)
#KL_STATUS_COLOR_ERROR_ARRAY=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 55 56 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 247 248 249 250 251 252 253 254 255 255)
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

KL_RANDOM=0

kl_genrandom() {
  KL_RANDOM=$(openssl rand 4 | od -DAn | xargs)
}

generate_emoji() {
    kl_genrandom
    KL_STATUS_SYMBOL_ARRAY_SIZE=${#KL_STATUS_SYMBOL_ARRAY[@]}
#    if [[ $KL_STATUS_SYMBOL_ARRAY_SIZE -gt 0 ]] && [[ "$KL_STATUS_ARRAY_ROTATE" == 'true' ]]; then
    if [[ "$KL_STATUS_ARRAY_ROTATE" == 'true' ]]; then

        ## Get random emoji value
        if [[ $# -eq 0 ]];
        then
            KL_STATUS_SYMBOL_ARRAY_INDEX=$((($KL_RANDOM % $KL_STATUS_SYMBOL_ARRAY_SIZE) + 1))
            export PURE_EMOJI=${KL_STATUS_SYMBOL_ARRAY[$KL_STATUS_SYMBOL_ARRAY_INDEX]}
        fi

        KL_STATUS_COLOR_SUCCESS_ARRAY_SIZE=${#KL_STATUS_COLOR_SUCCESS_ARRAY[@]}
        if [[ $KL_STATUS_COLOR_SUCCESS_ARRAY_SIZE -gt 0 ]] && [[ "$KL_STATUS_ARRAY_ROTATE" == 'true' ]]; then
            export KL_PURE_EMOJI_SUCCESS_COLOR_INDEX=$((($KL_RANDOM % $KL_STATUS_COLOR_SUCCESS_ARRAY_SIZE) + 1))
            export KL_PURE_EMOJI_SUCCESS_COLOR=${KL_STATUS_COLOR_SUCCESS_ARRAY[$KL_PURE_EMOJI_SUCCESS_COLOR_INDEX]}
            if [[ KL_PURE_EMOJI_SUCCESS_COLOR -lt 10 ]]; then
                export KL_PURE_EMOJI_COLOR_SUCCESS_SPACING="00"
            elif [[ KL_PURE_EMOJI_SUCCESS_COLOR -lt 100 ]]; then
                export KL_PURE_EMOJI_COLOR_SUCCESS_SPACING="0"
            fi
        fi

        KL_STATUS_COLOR_ERROR_ARRAY_SIZE=${#KL_STATUS_COLOR_ERROR_ARRAY[@]}
        if [[ $KL_STATUS_COLOR_ERROR_ARRAY_SIZE -gt 0 ]] && [[ "$KL_STATUS_ARRAY_ROTATE" == 'true' ]]; then
            export KL_PURE_EMOJI_ERROR_COLOR_INDEX=$((($KL_RANDOM % $KL_STATUS_COLOR_ERROR_ARRAY_SIZE) + 1))
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
