#!/usr/bin/awk -f

function display() {
	print "<?xml version='1.0'?>"
    print "<svg version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='1300' height='1300' viewBox='-2000 -2000 4000 4000'>"
    print " <title>Venn diagram</title>"
#    print " <defs>"
    for (i=0; i < length(circle_array); i++) {
        printf " <g id='sets%s'><use xlink:href='#set%d' fill='%s'/></g>\n", i, i, color[i]
    }
    for (i=0; i < length(circle_array); i++) {
        print circle_array[i]
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
      return sprintf("   <text transform='translate(  %f, %f) scale(0.9,1)' x='0' y='0' dominant-baseline='middle' text-anchor='middle'>%s</text>", argXCordinates, argYCordinates * argSide, argText)
  }
  else {
      return sprintf("   <text transform='translate(  %f, %f) scale(0.9,1)' x='0' y='0'>%s</text>", (argXCordinates * argSide) - (( length(argText) / 2 ) * (FONT_SIZE / 2)), argYCordinates * argSide, argText)
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

    # declare an empty circle_arrayay via delete statement 
    delete circle_array[0]
    delete circle_grid[0]
    delete ref_array[0]
    delete subtext_grid[0]
    delete text_array[0]

    sin30 = sin(30)
    sin30n = -1 * sin(30)

    sin45 = sin(45)
    sin45n = -1 * sin(45)

    sin60 = sin(60)
    sin60n = -1 * sin(60)

    # venn diagram position depending on number of text
    # top left
#    circle_grid[0,0] = -1 * sin(45)
#    circle_grid[0,1] = -1 * sin(45)

    # circle grid 
    # 1 circle
    circle_grid[1,0] = 0
    circle_grid[1,1] = 0

    # 2 circles (left / right)
    circle_grid[2,0] = sin45n
    circle_grid[2,1] = 0
    circle_grid[2,2] = sin45
    circle_grid[2,3] = 0

    # 3 circles (2 top / 1 bot)
    circle_grid[3,0] = sin45n
    circle_grid[3,1] = sin45n
    circle_grid[3,2] = sin45
    circle_grid[3,3] = sin45n
    circle_grid[3,4] = 0
    circle_grid[3,5] = sin45

    # 4 circles
    circle_grid[4,0] = -1
    circle_grid[4,1] = 0
    circle_grid[4,2] = 0
    circle_grid[4,3] = -1
    circle_grid[4,4] = 1
    circle_grid[4,5] = 0
    circle_grid[4,6] = 0
    circle_grid[4,7] = 1

    # 5 circles
    circle_grid[5,0] = sin45n
    circle_grid[5,1] = sin45n
    circle_grid[5,2] = 0 
    circle_grid[5,3] = -1 
    circle_grid[5,4] = sin45
    circle_grid[5,5] = sin45n
    circle_grid[5,6] = sin45
    circle_grid[5,7] = sin45
    circle_grid[5,8] = sin45n
    circle_grid[5,9] = sin45

    # 6 circles
    circle_grid[6,0] = sin45n
    circle_grid[6,1] = sin45n
    circle_grid[6,2] = 0 
    circle_grid[6,3] = -1 
    circle_grid[6,4] = sin45
    circle_grid[6,5] = sin45n
    circle_grid[6,6] = sin45
    circle_grid[6,7] = sin45
    circle_grid[6,8] = 0
    circle_grid[6,9] = 1
    circle_grid[6,10] = sin45n
    circle_grid[6,11] = sin45

    # 7 circles
    circle_grid[7,0] = sin45n
    circle_grid[7,1] = sin45n
    circle_grid[7,2] = 0 
    circle_grid[7,3] = -1 
    circle_grid[7,4] = sin45
    circle_grid[7,5] = sin45n
    circle_grid[7,6] = 1
    circle_grid[7,7] = 0
    circle_grid[7,8] = sin45
    circle_grid[7,9] = sin45
    circle_grid[7,10] = 0
    circle_grid[7,11] = 1
    circle_grid[7,12] = sin45n
    circle_grid[7,13] = sin45

    # 8 circles
    circle_grid[8,0] = sin45n
    circle_grid[8,1] = sin45n
    circle_grid[8,2] = 0 
    circle_grid[8,3] = -1 
    circle_grid[8,4] = sin45
    circle_grid[8,5] = sin45n
    circle_grid[8,6] = 1
    circle_grid[8,7] = 0
    circle_grid[8,8] = sin45
    circle_grid[8,9] = sin45
    circle_grid[8,10] = 0
    circle_grid[8,11] = 1
    circle_grid[8,12] = sin45n
    circle_grid[8,13] = sin45
    circle_grid[8,14] = -1
    circle_grid[8,15] = 0

    # subtext
    subtext_grid[1,0] = 0
    subtext_grid[1,1] = 0

    subtext_grid[2,0] = 0
    subtext_grid[2,1] = 0
    subtext_grid[2,2] = 0
    subtext_grid[2,3] = 0
    
    subtext_grid[3,0] = 0
    subtext_grid[3,1] = -1
    subtext_grid[3,2] = 1
    subtext_grid[3,3] = sin60n
    subtext_grid[3,4] = -1
    subtext_grid[3,5] = sin60n

    subtext_grid[4,0] = -1
    subtext_grid[4,1] = -1
    subtext_grid[4,2] = 1
    subtext_grid[4,3] = -1
    subtext_grid[4,4] = 1
    subtext_grid[4,5] = 1
    subtext_grid[4,6] = -1
    subtext_grid[4,7] = 1

    subtext_grid[5,0] = -1
    subtext_grid[5,1] = -1
    subtext_grid[5,2] = 1
    subtext_grid[5,3] = -1
    subtext_grid[5,4] = 1
    subtext_grid[5,5] = 1
    subtext_grid[5,6] = -1
    subtext_grid[5,7] = 1
    subtext_grid[5,8] = 1
    subtext_grid[5,9] = 1

    #FONT_SIZE = 150
    FONT_SIZE = 125

    #print "num of fields %s | %s", NF, $0
    radius = 1500
    tSideScale = .62
    tSide = $radius * tSideScale
    countIndex = 0
}

# radius
NR == 1 {
    radius = sin(45) * $1
    tSide = $1 * tSideScale
}
# circle 
NR == 2 {
    #printf "num of fields %s | %s\n", NF, $0
    # search and replace properly
    while (countIndex < NF) {
        startIndex = countIndex * 2
        xCoordinates = circle_grid[NF, startIndex]
        yCoordinates = circle_grid[NF, (startIndex + 1)]
        #printf "index %s %s %s %s %s\n", NF, countIndex, startIndex, xCoordinates, yCoordinates
        ref_array[countIndex] = drawReference(countIndex)

        # NOTE: $countIndex is referencing a field positions NOT a number count.  Variables have no dollar sign ($) in front in awk
        gsub("_", " ", $countIndex)
        text_array[countIndex] = drawText(xCoordinates, yCoordinates, tSide, $(countIndex + 1), "false")
        circle_array[countIndex] = drawCircle(xCoordinates, yCoordinates, radius, tSide, countIndex)
        countIndex++
    }
}
# find center text
NR == 3 {
    centerText = $0
    centerIndex = countIndex - 1
    if ( centerText != "_" ) {
        text_array[countIndex] = drawText(0, 0, tSide, centerText, "true")
        countIndex++
    }
}
# subtext
NR == 4 {
    textIndex = 0
    textYIndex = 0
    while (textIndex < NF) {
        textYIndex = textIndex * 2
        #printf "subtext index %s %s %s %s %s %s\n", NF, countIndex, textIndex, textYIndex, subtext_grid[NF, textYIndex], subtext_grid[NF, (textYIndex + 1)]
        if ($textIndex != "_") {
            text_array[countIndex] = drawText(subtext_grid[NF, textYIndex], subtext_grid[NF, (textYIndex + 1)], tSide, $(textIndex + 1), "false")
        }
        textIndex++
        countIndex++
    }
}

END {
	display()
}
