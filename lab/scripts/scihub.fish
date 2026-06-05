function sci

  set modeX ''
  set targetX ''
  set key ''

  while test (count $argv) -gt 0

    set key $argv[1]
    set argv $argv[2..-1]


    switch "$key"
      case '*'; set targetX "$targetX$key+"
    end

  end
  

	set targetX (string trim -c '+' $targetX)

  if test "$targetX" = ''
    echo 'has no value'
    return
  end

	echo "https://sci-hub.st/match/$targetX"
	open -a "Firefox" "https://sci-hub.st/match/$targetX"

end
