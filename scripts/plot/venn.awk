#!/usr/bin/awk -f

function display() {
	print "<?xml version='1.0'?>"
    print "<svg version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='1300' height='1300' viewBox='-2000 -2000 4000 4000'>"

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
    print " <circle cx='0' cy='0' r='99999' fill='#ffffff'/>"
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

function drawText( argXCordinates, argYCordinates, argSide, argText, center) {
   #printf("length of text %f", (length(argText)/2) * 300)
   if (center == "true") { 
      return sprintf(" <text transform='translate(  %f, %f) scale(0.9,1)' x='0' y='0.7ex' dominant-baseline='middle' text-anchor='middle'>%s</text>", argXCordinates, argYCordinates * argSide, argText)
  }
  else {
      return sprintf(" <text transform='translate(  %f, %f) scale(0.9,1)' x='0' y='0.7ex'>%s</text>", (argXCordinates * argSide) - (( length(argText) / 2 ) * (FONT_SIZE / 2)), argYCordinates * argSide, argText)
  }
}

BEGIN {
	# Bang Wong's colour-safe palette, https://www.nature.com/articles/nmeth.1618
	# (using just the last five colours)
    arrayIndex = 0
    color[arrayIndex++] = "#0072B2"
	color[arrayIndex++] = "#F0E442"
	color[arrayIndex++] = "#009E73"
	color[arrayIndex++] = "#D55E00"
	color[arrayIndex++] = "#99ccff"
	color[arrayIndex++] = "#e69f00"
	color[arrayIndex++] = "#56b4e9"
	color[arrayIndex++] = "#ff6699"

    # declare an empty cirle_arrayay via delete statement 
    delete center_grid[0]
    delete cirle_array[0]
    delete coord_grid[0]
    delete ref_array[0]
    delete text_array[0]
}

END {

    #print "num of fields %s | %s", NF, $0
    radius = sin(45) * $1
    tSide = $1 * .5
    center_text = $2
    # search and replace properly
    gsub("_", " ", center_text)

    # parameters
    # venn 1 2 3 4 5
    # 1: radius
    # 2,3,4,5,6: text values
    
    # venn diagram position depending on number of text
    # top left
    coord_grid[0,0] = -1 * sin(45)
    coord_grid[0,1] = -1 * sin(45)
    center_grid[0,0] = -1 * sin(45)
    center_grid[0,1] = -1 * sin(45)

    # top right
    coord_grid[1,0] = 1 * sin(45)
    coord_grid[1,1] = -1 * sin(45)
    center_grid[1,0] = -1 * sin(45)
    center_grid[1,1] = -1 * sin(45)

    # bottom 
    coord_grid[2,0] = 0
    coord_grid[2,1] = 1
    center_grid[2,0] = 0
    center_grid[2,1] = -1 

    # bottom left
    coord_grid[3,0] = -1 * sin(45)
    coord_grid[3,1] = 1 * sin(45)
    center_grid[3,0] = 0 * sin(45)
    center_grid[3,1] = 0 * sin(45)

    # bottom right
    coord_grid[4,0] = 1 * sin(45)
    coord_grid[4,1] = 1 * sin(45)
    center_grid[4,0] = 0 * sin(45)
    center_grid[4,1] = 0 * sin(45)

    # top
    coord_grid[5,0] = 0 
    coord_grid[5,1] = -1 
    center_grid[5,0] = 0
    center_grid[5,1] = 0

    coord_grid[6,0] = 1
    coord_grid[6,1] = 0 
    center_grid[6,0] = 0
    center_grid[6,1] = 0

    coord_grid[7,0] = -1
    coord_grid[7,1] = 0 
    center_grid[7,0] = 0
    center_grid[7,1] = 0

    FONT_SIZE = 150
    #printf("%s %s", NR, FNR)
    #if ( FNR == 1) {
    #    printf("first row")
    #}
    #else if ( FNR == 2) {
    #    printf("second row")
    #}
    #printf "%06.2f ", sqrt(tSide)
    #print ""
    #printf "value %s, %s", NF, $0
    #print ""
    #printf "radius %d", radius
    #print ""
    countIndex=3
    currentIndex=countIndex  
    while (countIndex <= NF) {
        currentIndex=(countIndex - 3)
        cirle_array[currentIndex] = drawCircle( coord_grid[currentIndex,0], coord_grid[currentIndex,1], radius, tSide, currentIndex)
        ref_array[currentIndex] = drawReference(currentIndex)
        # NOTE: $countIndex is referencing a field positions NOT a number count.  Variables have no dollar sign ($) in front in awk
        text_array[currentIndex] = drawText(coord_grid[currentIndex, 0], coord_grid[currentIndex, 1], tSide, $countIndex, "false")
        countIndex++
    }
    currentIndex=(countIndex - 3)
    #printf "center is %s", center_text
    if (countIndex >= 3) {
        if ( center_text != "_" ) {
            text_array[currentIndex] = drawText(center_grid[currentIndex, 0], center_grid[currentIndex, 1], tSide, center_text, "true")
        }
    }
	display()
}
