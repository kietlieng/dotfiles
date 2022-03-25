#!/usr/bin/awk -f

function display() {
	print "<?xml version='1.0'?>"
    print "<svg version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='1300' height='1300' viewBox='-2000 -2000 4000 4000'>"
    print " <title>Venn diagram</title>"
#    print " <defs>"
    for (i=0; i < length(cirle_array); i++) {
        printf " <g id='sets%s'><use xlink:href='#set%d' fill='%s'/></g>\n", i, i, color[i]
    }
    for (i=0; i < length(cirle_array); i++) {
        print cirle_array[i]
    }
#    print " </defs>"
    print " <circle cx='0' cy='0' r='99999' fill='#ffffff'/>"
    for (i=0; i < length(ref_array); i++) {
        print ref_array[i]
    }
    printf " <g font-size='%s' font-weight='bold'>\n", FONT_SIZE
    for (i=0; i < length(text_array); i++) {
        print text_array[i]
    }
    print " </g>"
    print "</svg>"
}

function drawCircle( argXCordinates, argYCordinates, argRadius, argSide, argReference) {
    #printf "radius %f", argRadius
    return sprintf(" <circle id='set%s' cx='%s' cy='%s' r='%f' />", argReference, (argXCordinates * argSide), (argYCordinates * argSide), argRadius)
    #return output
}    

function drawReference( argReference) {
    return sprintf(" <g font-family='Helvetica,Arial,sans-serif' text-anchor='middle' stroke='none'>\n  <use xlink:href='#sets%s' fill-opacity='0.3'/>\n  <use xlink:href='#sets%s' fill-opacity='0' opacity='0.5' stroke='#000000' stroke-width='6'/>\n </g>", argReference, argReference)

}

function drawText( argXCordinates, argYCordinates, argSide, argText, center) {
   #printf("length of text %f", (length(argText)/2) * 300)
   if (center == "true") { 
      return sprintf("   <text transform='translate(  %f, %f) scale(0.9,1)' x='0' y='0.7ex' dominant-baseline='middle' text-anchor='middle'>%s</text>", argXCordinates, argYCordinates * argSide, argText)
  }
  else {
      return sprintf("   <text transform='translate(  %f, %f) scale(0.9,1)' x='0' y='0.7ex'>%s</text>", (argXCordinates * argSide) - (( length(argText) / 2 ) * (FONT_SIZE / 2)), argYCordinates * argSide, argText)
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
    delete subtext_grid[0]
    delete ref_array[0]
    delete text_array[0]

    # venn diagram position depending on number of text
    # top left
    coord_grid[0,0] = -1 * sin(45)
    coord_grid[0,1] = -1 * sin(45)
    center_grid[0,0] = -1 * sin(45)
    center_grid[0,1] = -1 * sin(45)
    subtext_grid[0,0] = 0
    subtext_grid[0,1] = 0

    # top right
    coord_grid[1,0] = 1 * sin(45)
    coord_grid[1,1] = -1 * sin(45)
    center_grid[1,0] = -1 * sin(45)
    center_grid[1,1] = -1 * sin(45)
    subtext_grid[1,0] = 0
    subtext_grid[1,1] = 0

    # bottom 
    coord_grid[2,0] = 0
    coord_grid[2,1] = 1
    center_grid[2,0] = -1 * sin(45)
    center_grid[2,1] = -1 * sin(45)
    subtext_grid[2,0] = 0
    subtext_grid[2,1] = 0

    # bottom left
    coord_grid[3,0] = -1 * sin(45)
    coord_grid[3,1] = 1 * sin(45)
    center_grid[3,0] = 0 * sin(45)
    center_grid[3,1] = -1 * sin(45)
    subtext_grid[3,0] = 0
    subtext_grid[3,1] = 0

    # bottom right
    coord_grid[4,0] = 1 * sin(45)
    coord_grid[4,1] = 1 * sin(45)
    center_grid[4,0] = 0 * sin(45)
    center_grid[4,1] = 0 * sin(45)
    # we have 3 positions
    subtext_grid[4,2] = 0
    subtext_grid[4,3] = -1 * sin(45)
    subtext_grid[4,4] = -1 * sin(45)
    subtext_grid[4,5] = 1 * sin(45)
    subtext_grid[4,6] = 1 * sin(45)
    subtext_grid[4,7] = 1 * sin(45)

    # top
    coord_grid[5,0] = 0 
    coord_grid[5,1] = -1 
    center_grid[5,0] = 0 * sin(45)
    center_grid[5,1] = -1 * sin(45)
    subtext_grid[5,0] = -500
    subtext_grid[5,1] = -500

    coord_grid[6,0] = 1
    coord_grid[6,1] = 0 
    center_grid[6,0] = 0
    center_grid[6,1] = 0
    subtext_grid[6,0] = -500
    subtext_grid[6,1] = -500

    coord_grid[7,0] = -1
    coord_grid[7,1] = 0 
    center_grid[7,0] = 0
    center_grid[7,1] = 0
    subtext_grid[7,0] = -500
    subtext_grid[7,1] = -500

    #FONT_SIZE = 150
    FONT_SIZE = 125

    #print "num of fields %s | %s", NF, $0
    radius = 1500
    tSide = $radius * .5
    countIndex = 1
}

# radius
NR == 1 {
    radius = sin(45) * $1
    tSide = $1 * .5
}
# circle 
NR == 2 {
    #print "num of fields %s | %s", NF, $0
    # search and replace properly
    while (countIndex <= NF) {
        currentIndex=(countIndex - 1)
        cirle_array[currentIndex] = drawCircle( coord_grid[currentIndex,0], coord_grid[currentIndex,1], radius, tSide, currentIndex)
        ref_array[currentIndex] = drawReference(currentIndex)
        gsub("_", " ", $countIndex)
        # NOTE: $countIndex is referencing a field positions NOT a number count.  Variables have no dollar sign ($) in front in awk
        text_array[currentIndex] = drawText(coord_grid[currentIndex, 0], coord_grid[currentIndex, 1], tSide, $countIndex, "false")
        countIndex++
    }
}
# find center text
NR == 3 {
    centerText = $0
    if ( centerText != "_" ) {
        text_array[countIndex] = drawText(center_grid[countIndex, 0], center_grid[countIndex, 1], tSide, centerText, "true")
        countIndex++
    }
}
# subtext
NR == 4 {
    subIndex = 1
    gridIndex = countIndex - 1
    coordIndex = subIndex * 2
    while (subIndex <= NF) {
        coordIndex = subIndex * 2
        if ( $subIndex != "_" ) {
            text_array[countIndex] = drawText(subtext_grid[gridIndex, coordIndex], subtext_grid[gridIndex, (coordIndex + 1)], tSide, $subIndex, "false")
        }
        subIndex++
        countIndex++
    }
}

END {
	display()
}
