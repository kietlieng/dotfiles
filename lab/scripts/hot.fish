alias htail="tail -f /tmp/skhd_*.err.log /tmp/skhd_*.out.log" 

function hot

  while test (count $argv) -gt 0

    set key "$argv[1]"
    set argv $argv[2..-1]

    switch  $key 

      case 'start'; skhd --start-service
      case 'stop'; skhd --stop-service
      case 'reload'; skhd -r
      case 'restart'; skhd --restart-service
            
    end

  end

end

