#!/usr/bin/awk -f

function display() {
#    print("<?xml version='1.0'?>")
#    print("<svg version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='1300' height='1300' viewBox='-2000 -2000 4000 4000'>")
#    print(" <title>Venn diagram</title>")
#    print(" <defs>")
#    print("<circle id='set0' cx='-650' cy='-650' r='1106.174582' />")
#    print("  <g id='sets0'>   <use xlink:href='#set0' fill='#0072B2'/>")
#    print("  </g>")
#    print("<circle id='set1' cx='650' cy='-650' r='1106.174582' />")
#    print("  <g id='sets1'>   <use xlink:href='#set1' fill='#F0E442'/>")
#    print("  </g>")
#    print("<circle id='set2' cx='0' cy='650' r='1106.174582' />")
#    print("  <g id='sets2'>   <use xlink:href='#set2' fill='#009E73'/>")
#    print("  </g>")
#    print(" </defs>")
#    print(" <circle cx='0' cy='0' r='2000' fill='#ffffff'/>")
#    print(" <circle cx='0' cy='0' r='50' fill='#00000'/>")
#    print(" <g font-family='Helvetica,Arial,sans-serif' text-anchor='middle' stroke='none'><use xlink:href='#sets0' fill-opacity='0.3'/><use xlink:href='#sets0' fill-opacity='0' opacity='0.5' stroke='#000000' stroke-width='6'/></g>")
#    print(" <g font-family='Helvetica,Arial,sans-serif' text-anchor='middle' stroke='none'><use xlink:href='#sets1' fill-opacity='0.3'/><use xlink:href='#sets1' fill-opacity='0' opacity='0.5' stroke='#000000' stroke-width='6'/></g>")
#    print(" <g font-family='Helvetica,Arial,sans-serif' text-anchor='middle' stroke='none'><use xlink:href='#sets2' fill-opacity='0.3'/><use xlink:href='#sets2' fill-opacity='0' opacity='0.5' stroke='#000000' stroke-width='6'/></g>")
#    print("<g font-size='150' font-weight='bold'> <text transform='translate(  -800.000000, -650.000000) scale(0.9,1)' x='0' y='0.7ex'>flow</text>")
#    print(" <text transform='translate(  500.000000, -650.000000) scale(0.9,1)' x='0' y='0.7ex'>risk</text>")
#    print(" <text transform='translate(  -225.000000, 650.000000) scale(0.9,1)' x='0' y='0.7ex'>reward</text>")
#    print(" </g>")
#    print("</svg>")

    print " <title>Venn diagram</title>"
    print " <defs>"
    for (i=0; i < length(cirle_array); i++) {
        print cirle_array[i]
        printf "  <g id='sets%s'>", i
        printf "   <use xlink:href='#set%d' fill='%s'/>", i, color[i]
        print ""
        print "  </g>"
    }
    print " </defs>"
    print " <circle cx='0' cy='0' r='2000' fill='#ffffff'/>"
    print " <circle cx='0' cy='0' r='50' fill='#00000'/>"
    for (i=0; i < length(ref_array); i++) {
        print ref_array[i]
    }
    #print "<g font-size='300' font-weight='bold'>"
    printf "<g font-size='%s' font-weight='bold'>", FONT_SIZE
    for (i=0; i < length(text_array); i++) {
        print text_array[i]
    }
#    printf "   <text transform='translate(  800, 700) scale(0.9,1)' x='0' y='0.7ex'>%s</text>", $1
#    print ""
#    printf "   <text transform='translate(  2500, 700) scale(0.9,1)' x='0' y='0.7ex'>%s</text>", $2
#    print ""
#    if (NF > 2) {
#        printf "<text transform='translate(  1700, 2000) scale(0.9,1)' x='0' y='0.7ex'>%s</text>", $3
#        print ""
#    }
    print " </g>"
    print "</svg>"
}

function drawCircle( argXCordinates, argYCordinates, argRadius, argSide, argReference) {
    #printf "radius %f", argRadius
    return sprintf("<circle id='set%s' cx='%s' cy='%s' r='%f' />", argReference, (argXCordinates * argSide), (argYCordinates * argSide), argRadius)
    #return output
}    

function drawReference( argReference) {
    return sprintf(" <g font-family='Helvetica,Arial,sans-serif' text-anchor='middle' stroke='none'><use xlink:href='#sets%s' fill-opacity='0.3'/><use xlink:href='#sets%s' fill-opacity='0' opacity='0.5' stroke='#000000' stroke-width='6'/></g>", argReference, argReference)

}

function drawText( argXCordinates, argYCordinates, argSide, argText) {
   #printf("length of text %f", (length(argText)/2) * 300)
   return sprintf(" <text transform='translate(  %f, %f) scale(0.9,1)' x='0' y='0.7ex'>%s</text>", (argXCordinates * argSide) - (( length(argText)/2 ) * (FONT_SIZE / 2)), argYCordinates * argSide, argText)
}

BEGIN {
	fg    = "#eeeeee"

	# Bang Wong's colour-safe palette, https://www.nature.com/articles/nmeth.1618
	# (using just the last five colours)
	color[0] = "#0072B2"
	color[1] = "#F0E442"
	color[2] = "#009E73"
	color[3] = "#CC79A7"
	color[4] = "#D55E00"
	color[5] = fg
}

END {

    #print "num of fields %s | %s", NF, $0
    tSide = $1
    radius = sin(45) * tSide
    tSide = tSide * .5
    # declare an empty cirle_arrayay via delete statement 
    delete cirle_array[0]
    delete ref_array[0]
    delete text_array[0]
    delete coord_grid[0]

    # parameters
    # venn 1 2 3 4 5
    # 1: radius
    # 2,3,4,5,6: text values
    
    # venn diagram position depending on number of text
    # top left
    coord_grid[0,0] = -1
    coord_grid[0,1] = -1
    # top right
    coord_grid[1,0] = 1
    coord_grid[1,1] = -1
    # bottom 
    coord_grid[2,0] = 0
    coord_grid[2,1] = 1
    # bottom left
    coord_grid[3,0] = -1
    coord_grid[3,1] = 1
    # bottom right
    coord_grid[4,0] = 1
    coord_grid[4,1] = 1
    # top
    coord_grid[5,0] = 0
    coord_grid[5,1] = -1

    FONT_SIZE = 150

    #printf "%06.2f ", sqrt(tSide)
    #print ""
    #printf "value %s, %s", NF, $0
    #print ""
    #printf "radius %d", radius
    #print ""
    countIndex=2
    
    while (countIndex <= NF) {
        currentIndex=(countIndex - 2)
#        printf("current index %s countIndex %s", currentIndex, countIndex)
#        print("")
        #printf("radius2 %f", radius)
        #print("")
        #printf("radius2 %s | %s", NF, $0)
        #print("")
        cirle_array[currentIndex] = drawCircle( coord_grid[currentIndex,0], coord_grid[currentIndex,1], radius, tSide, currentIndex)
        ref_array[currentIndex] = drawReference(currentIndex)
        text_array[currentIndex] = drawText(coord_grid[currentIndex, 0], coord_grid[currentIndex, 1], tSide, $countIndex)
        countIndex++
    }
	display()
}
