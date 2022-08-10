#!/usr/bin/awk -f

function display() {
	print "<?xml version='1.0'?>"
    print "<svg version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='1300' height='1300' viewBox='0 0 4000 4000'>"
    print " <title>Venn diagram</title>"
#    print " <defs>"
    for (i=0; i < length(circle_array); i++) {
        printf " <g id='sets%s'><use xlink:href='#set%d' fill='%s'/></g>\n", i, i, color[i]
    }
    for (i=0; i < length(circle_array); i++) {
        print circle_array[i]
    }
#    print " </defs>"
    printf " <circle cx='2000' cy='2000' r='%s' fill='#ffffff'/>\n", center_radius
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
    return sprintf(" <circle id='set%s' cx='%s' cy='%s' r='%f' stroke='orange' stroke-width='5' />", argReference, argXCordinates, argYCordinates, argRadius)
    #return output
}

function drawReference( argReference) {
    return sprintf(" <g font-family='Helvetica,Arial,sans-serif' text-anchor='middle' stroke='none'>\n  <use xlink:href='#sets%s' fill-opacity='0.3'/>\n  <use xlink:href='#sets%s' fill-opacity='0' opacity='0.5' stroke='#000000' stroke-width='6'/>\n </g>", argReference, argReference)
}

function drawText( argXCordinates, argYCordinates, argSide, argText, center) {
   #printf("length of text %f", (length(argText)/2) * 300)
   if (center == "true") {
      return sprintf("   <text transform='translate(  %f, %f) scale(1,1)' x='0' y='0' dominant-baseline='middle' text-anchor='middle'>%s</text>", argXCordinates, argYCordinates, argText)
  }
  else {
      return sprintf("   <text transform='translate(  %f, %f) scale(1,1)' x='0' y='0'>%s</text>", argXCordinates - (length(argText) / 2 ) * (FONT_SIZE / 2), argYCordinates, argText)
  }
}

function getDistance(x, y, x2, y2) {
    return sqrt( (x - x2) ^2 + (y - y2) ^ 2)
}

function inCircle(x, y, radius) {
    return getDistance(0, 0, x, y) <= center_radius
}

function findBoundary(x, y, rad, x2, y2) {
    # find distance between 2 centers
    dis = getDistance(x, y, x2, y2)
    if ( debug == 1) {
        printf "findBoundry %s\n", dis
    }
    # first stab at radius
    nRadius = dis - rad
    if (nRadius < 0) {
        return nRadius * -1
    }
    return nRadius
}

function newBubble(x, y) {
    # figure out mountdaries from the center to limit inial radius
    currentRad = findBoundary(0, 0, center_radius, x, y)
    if ( debug == 1) {
        printf "findboundary1 %s %s %s\n", x, y, currentRad
    }
    for (i=0; i < countIndex; i++) {
        dis = findBoundary(bubble_array[i,0], bubble_array[i,1], bubble_array[i,2], x, y)
        if ( debug == 1) {
            printf "findboundary2 %s %s %s %s %s\n", x, y, currentRad, bubble_array[i,0], bubble_array[i,1], dis
        }
        if (dis < currentRad) {
            currentRad = dis
        }
    }
    if (currentRad > 0) {
        #printf "create entry %s %s  %s\n", x, y, currentRad
        bubble_array[countIndex,0] = x
        bubble_array[countIndex,1] = y
        bubble_array[countIndex,2] = currentRad
        countIndex++
    }
}

function drawAll() {
    if ( debug == 1) {
        printf "size %s %s %s\n", length(bubble_array), length(bigger_array), length(smaller_array)
    }
    biggerSize = length(bigger_array)
    for (i=0; i <= biggerSize; i++) {
        currentBiggestIndex = -1
        #printf "bigger term %s %s\n", i, length(bigger_array)
        for ( i2=0; i2 <= bubbleIndex; i2++) {
            #printf "iterating through index %s radius %s term %s\n", i2, bubble_array[i2,3], bubble_array[i2,4]
            # check to see if it has a text already
            if (bubble_array[i2,C_TEXT] == "") {
                if ( currentBiggestIndex == -1 ) {
                    #printf "1 changing radius %s for %s\n", bubble_array[i2,3], bubble_array[currentBiggestIndex,3]
                    currentBiggestIndex = i2
                }
                else {
                    if (bubble_array[i2, C_RADIUS] >= bubble_array[currentBiggestIndex, C_RADIUS]) {
                        #printf "2 changing radius %s for %s\n", bubble_array[i2,3], bubble_array[currentBiggestIndex,3]
                        currentBiggestIndex = i2
                    }
                }
            }
        }
        bubble_array[currentBiggestIndex, C_TEXT] = bigger_array[i]
    }
    smallerSize = length(smaller_array)
    for (i=0; i <= smallerSize; i++) {
        currentBiggestIndex = -1
        #printf "bigger term %s %s\n", i, length(bigger_array)
        for ( i2=0; i2 <= bubbleIndex; i2++) {
            #printf "iterating through index %s radius %s term %s\n", i2, bubble_array[i2,3], bubble_array[i2,4]
            # check to see if it has a text already
            if (bubble_array[i2, C_TEXT] == "") {
                if ( currentBiggestIndex == -1 ) {
                    #printf "1 changing radius %s for %s\n", bubble_array[i2,3], bubble_array[currentBiggestIndex,3]
                    currentBiggestIndex = i2
                }
                else {
                    if (bubble_array[i2, C_RADIUS] >= bubble_array[currentBiggestIndex, C_RADIUS]) {
                        #printf "2 changing radius %s for %s\n", bubble_array[i2,3], bubble_array[currentBiggestIndex,3]
                        currentBiggestIndex = i2
                    }
                }
            }
        }
        bubble_array[currentBiggestIndex, C_TEXT] = smaller_array[i]
    }
    for (i=0; i < bubbleIndex; i++) {
        if ( debug == 1) {
            printf "drawall %s %s %s %s %s\n", SHIFT_X + bubble_array[i, C_X], SHIFT_Y + bubble_array[i, C_Y], bubble_array[i, C_RADIUS_TO_CENTER], bubble_array[i, C_RADIUS], bubble_array[i, C_TEXT]
        }
        circle_array[i] = drawCircle(SHIFT_X + bubble_array[i, C_X], SHIFT_Y + bubble_array[i, C_Y], bubble_array[i, C_RADIUS], tSide, i)
        #text_array[i] = drawText(bubble_array[i, C_X], bubble_array[i, C_Y], tSide, bubble_array[i, C_TEXT]  "_"  bubble_array[i, C_RADIUS] "_" bubble_array[i, C_DEFAULT_RADIUS], "false")
        text_array[i] = drawText(SHIFT_X + bubble_array[i, C_X], SHIFT_Y + bubble_array[i, C_Y], tSide, bubble_array[i, C_TEXT], "false")
        ref_array[i] = drawReference(i)
    }
}

function insertIntoList(x, y, r) {
    bubble_array[bubbleIndex, C_X] = x
    bubble_array[bubbleIndex, C_Y] = y
    bubble_array[bubbleIndex, C_RADIUS_TO_CENTER] = getDistance(0, 0, x, y)
    bubble_array[bubbleIndex, C_RADIUS] = -1
    bubble_array[bubbleIndex, C_DEFAULT_RADIUS] = r
    bubble_array[bubbleIndex, C_TOUCHED] = 0
    bubble_array[bubbleIndex, C_FINAL_RADIUS] = -1
    if ( debug == 1) {
        printf "insert %s %s %s %s\n", bubble_array[bubbleIndex, C_X], bubble_array[bubbleIndex, C_Y], bubble_array[bubbleIndex, C_RADIUS_TO_CENTER], bubble_array[bubbleIndex, C_RADIUS]
    }
    bubbleIndex++
}

function findParimeterTouched( argIndex, argX, argY, argRadius) {
    for (currentIndex = 0; currentIndex < bubbleIndex; currentIndex++) {
        # skip if it's similar
        if (argIndex != currentIndex) {
            currentRadius = bubble_array[currentIndex,3]
            # has no radius
            if (currentRadius == -1) {
                currentRadius = argRadius
            }
            distance = getDistance(argX, argY, bubble_array[currentIndex, 0], bubble_array[currentIndex, 1])
            totalRadius = currentRadius + argRadius
            differenceDistance = totalRadius - distance
            if (differenceDistance < 0) {
                differenceDistance = -1 * differenceDistance
            }
            if ( debug == 1) {
                printf "touch currentIndex:%s distance:%s totalRadius:%s difference:%s radiusIncrement:%s\n", currentIndex, distance, totalRadius, differenceDistance, radius_increment
            }
            # arguement touched someone!
            if ((differenceDistance >= 0) && (differenceDistance <= radius_increment)) {
               if ( debug == 1) {
                   printf "touch return 1\n"
               }
               return 1
            }
        }
    }
    # touched no parimeters
    if ( debug == 1) {
        #printf "touch return 0\n"
    }
    return 0
}

function maximizeAllRadius() {
    foundIndex = 0
    newIndex = 0
    dis = 0

    # increase radius
    for (growRadius=0; growRadius < center_radius; growRadius = growRadius + radius_increment) {
        if ( debug == 1) {
            printf "growRadius %s \n", growRadius
        }
        # each bubble use the new increased bubble
        for (currentH = 0; currentH < bubbleIndex; currentH++) {
            currentRadius = bubble_array[currentH, C_FINAL_RADIUS]
            if ( debug == 1) {
                printf "bIndex %s %s %s %s %s\n", currentH, bubble_array[currentH, C_X], bubble_array[currentH, C_Y], bubble_array[currentH, C_RADIUS_TO_CENTER], bubble_array[currentH, C_FINAL_RADIUS]
            }

            # that means it's been found out.  Move on
            if (currentRadius > -1) {
                if ( debug == 1) {
                    printf "found1 %s skipping\n", currentRadius
                }
                continue
            }

            # find closest point
                # find if it's touching
                    # if it touches move away
            # if it's -2 that means it touched the edge
            if (growRadius > bubble_array[currentH, C_DEFAULT_RADIUS]) {
                if ( debug == 1) {
                    printf "found0 %s setting for default radius\n", currentRadius
                }
                bubble_array[currentH, C_RADIUS] = bubble_array[currentH, C_DEFAULT_RADIUS]
                growRadius = growRadius - radius_increment
                continue
            }
            # else you have an empty radius so use that to figure out your radius

            # find out if the radius hits the parent radius parimeter
            currentDistance = bubble_array[currentH, C_RADIUS_TO_CENTER] + growRadius
            differenceDistance = center_radius - currentDistance
            # if the total difference is less than the amount incrementsed that means it's touched
            # the paremeter
            if ((differenceDistance >= 0) && (differenceDistance <= radius_increment)) {
                bubble_array[currentH, C_RADIUS] = findBoundary(0, 0, center_radius, bubble_array[currentH, C_X], bubble_array[currentH, C_Y])
                if ( debug == 1) {
                    printf "!!!!!!!!!!!found distance %s %s %s %s\n", currentRadius, bubble_array[currentH, C_X], bubble_array[currentH, C_Y], bubble_array[currentH, C_RADIUS]
                }
                # reset the radius so it can go through other values
                growRadius = growRadius - radius_increment
                break
            }
            # this means it didn't hit the parent parimeter so we have to match this with all
            # other distances to see if it will match up properly
            else {
                parimeterTouched = findParimeterTouched( currentH, bubble_array[currentH, C_X], bubble_array[currentH, C_Y], growRadius)
                if (parimeterTouched == 1) {
                    if ( debug == 1) {
                        printf "!!!!!parimeterTouched %s\n", growRadius
                    }
                    bubble_array[currentH, C_RADIUS] = growRadius
                    growRadius = growRadius - radius_increment
                    break
                }
            }
        }
    }
}

function findAllRadius() {
    foundIndex = 0
    newIndex = 0
    dis = 0

    # increase radius
    for (growRadius=0; growRadius < center_radius; growRadius = growRadius + radius_increment) {
        if ( debug == 1) {
            printf "growRadius %s \n", growRadius
        }
        # each bubble use the new increased bubble
        for (currentH = 0; currentH < bubbleIndex; currentH++) {
            currentRadius = bubble_array[currentH, C_RADIUS]
            if ( debug == 1) {
                printf "bIndex %s %s %s %s %s\n", currentH, bubble_array[currentH, C_X], bubble_array[currentH, C_Y], bubble_array[currentH, C_RADIUS_TO_CENTER], bubble_array[currentH, C_RADIUS]
            }

            # that means it's been found out.  Move on
            if (currentRadius > -1) {
                if ( debug == 1) {
                    printf "found1 %s skipping\n", currentRadius
                }
                continue
            }

            if (growRadius > bubble_array[currentH, C_DEFAULT_RADIUS]) {
                if ( debug == 1) {
                    printf "found0 %s setting for default radius\n", currentRadius
                }
                bubble_array[currentH, C_RADIUS] = bubble_array[currentH, C_DEFAULT_RADIUS]
                growRadius = growRadius - radius_increment
                continue
            }
            # else you have an empty radius so use that to figure out your radius

            # find out if the radius hits the parent radius parimeter
            currentDistance = bubble_array[currentH, C_RADIUS_TO_CENTER] + growRadius
            differenceDistance = center_radius - currentDistance
            # if the total difference is less than the amount incrementsed that means it's touched
            # the paremeter
            if ((differenceDistance >= 0) && (differenceDistance <= radius_increment)) {
                bubble_array[currentH, C_RADIUS] = findBoundary(0, 0, center_radius, bubble_array[currentH, C_X], bubble_array[currentH, C_Y])
                if ( debug == 1) {
                    printf "!!!!!!!!!!!found distance %s %s %s %s\n", currentRadius, bubble_array[currentH, C_X], bubble_array[currentH, C_Y], bubble_array[currentH, C_RADIUS]
                }
                # reset the radius so it can go through other values
                growRadius = growRadius - radius_increment
                break
            }
            # this means it didn't hit the parent parimeter so we have to match this with all
            # other distances to see if it will match up properly
            else {
                parimeterTouched = findParimeterTouched( currentH, bubble_array[currentH, C_X], bubble_array[currentH, C_Y], growRadius)
                if (parimeterTouched == 1) {
                    if ( debug == 1) {
                        printf "!!!!!parimeterTouched %s\n", growRadius
                    }
                    bubble_array[currentH, C_RADIUS] = growRadius
                    growRadius = growRadius - radius_increment
                    break
                }
            }
        }
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
	color[arrayIndex++] = "#99CCFF"
	color[arrayIndex++] = "#E69F00"
	color[arrayIndex++] = "#56b4e9"
	color[arrayIndex++] = "#FF6699"

    color[arrayIndex++] = "#FB4934"
	color[arrayIndex++] = "#B8BB26"
	color[arrayIndex++] = "#FABD2F"
	color[arrayIndex++] = "#83A598"
	color[arrayIndex++] = "#D3869B"
	color[arrayIndex++] = "#8EC07C"
	color[arrayIndex++] = "#EBDBB2"
	color[arrayIndex++] = "#FE8019"

    color[arrayIndex++] = "#FFED00"
	color[arrayIndex++] = "#FF8860"
	color[arrayIndex++] = "#D6E8D9"
	color[arrayIndex++] = "#F1C9C2"
	color[arrayIndex++] = "#FF3747"
	color[arrayIndex++] = "#4FCBBB"
	color[arrayIndex++] = "#EF39A7"
	color[arrayIndex++] = "#ECF7DD"

    color[arrayIndex++] = "#FDF2B8"
	color[arrayIndex++] = "#E88200"
	color[arrayIndex++] = "#CB2800"
	color[arrayIndex++] = "#F9BB13"
	color[arrayIndex++] = "#7D8B11"
	color[arrayIndex++] = "#C1D92E"
	color[arrayIndex++] = "#F3E0C2"
	color[arrayIndex++] = "#484E10"

    bubbleIndex = 0
    sortIndex = 0
    center_radius = 2000
    radius_increment = 10
    SHIFT_X = 2000
    SHIFT_Y = 2000
    C_X = 0
    C_Y = 1
    C_RADIUS_TO_CENTER = 2
    C_RADIUS = 3
    C_TEXT = 4
    C_DEFAULT_RADIUS = 5
    C_TOUCHED = 6
    C_FINAL_RADIUS = 7
    TOUCHED_LIMIT = 3

    # declare an empty circle_arrayay via delete statement
    delete bigger_array[0]
    delete bubble_array[0]
    delete circle_array[0]
    delete ref_array[0]
    delete smaller_array[0]
    delete text_array[0]

    sin30 = sin(30)
    sin30n = -1 * sin(30)

    sin45 = sin(45)
    sin45n = -1 * sin(45)

    sin60 = sin(60)
    sin60n = -1 * sin(60)

    # venn diagram position depending on number of text
    # top left

    #FONT_SIZE = 150
    FONT_SIZE = 125

    #print "num of fields %s | %s", NF, $0
    radius = 1500
    tSideScale = .62
    tSide = $radius * tSideScale
    countIndex = 0
    debug = 0
}

NR == 1 {
    debug = $1
}

# radius
NR == 2 {
    center_radius = sin(45) * $1
    tSide = $1 * tSideScale
}

# insert text into bubbly array
NR == 3 {
    for (i = 0; i <= NF; i++) {
        if ( debug == 1) {
            printf "biggertext |%s|\n", $(i + 1)
        }
        if ( $(i + 1) != "" ) {
            bigger_array[i] = $(i + 1)
        }
    }
}

# insert text into bubbly array
NR == 4 {
    for (i = 0; i <= NF; i++) {
        if ( debug == 1) {
            printf "smallertext |%s|\n", $(i + 1)
        }
        if ( $(i + 1) != "" ) {
            smaller_array[i] = $(i + 1)
        }
    }
}

# circle
NR > 4 {
    #newBubble($1, $2)
    if (NF > 0) {
        #printf "insert into list %s\n", $0
        insertIntoList($1, $2, $3)
    }
}

END {
    findAllRadius()
    maximizeAllRadius()
    drawAll()
	display()
}
