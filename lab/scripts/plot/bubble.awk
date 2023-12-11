#!/usr/bin/awk -f

function debugOutput(debugType, printOutput) {
    if ((debugType == DEBUG) || (-1 == DEBUG)) {
        sprintf("> %s", printOutput)
    }
}

function display() {
	print "<?xml version='1.0'?>"
    print "<svg version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='1300' height='1300' viewBox='0 0 4000 4000'>"
    print " <title>Venn diagram</title>"
#    print " <defs>"
    for (i=0; i < length(CIRCLE_ARRAY); i++) {
        printf " <g id='sets%s'><use xlink:href='#set%d' fill='%s'/></g>\n", i, i, color[i]
    }
    for (i=0; i < length(CIRCLE_ARRAY); i++) {
        print CIRCLE_ARRAY[i]
    }
#    print " </defs>"
    printf " <circle cx='2000' cy='2000' r='%s' fill='#ffffff'/>\n", CENTER_RADIUS
    for (i=0; i < length(REF_ARRAY); i++) {
        print REF_ARRAY[i]
    }
    printf " <g font-size='%s' font-weight='bold'>\n", FONT_SIZE
    for (i=0; i < length(TEXT_ARRAY); i++) {
        print TEXT_ARRAY[i]
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
    return getDistance(0, 0, x, y) <= CENTER_RADIUS
}

function findBoundary(x, y, rad, x2, y2) {
    # find distance between 2 centers
    dis = getDistance(x, y, x2, y2)
    debugOutput(1, sprintf("findBoundry %s", dis))
    # first stab at radius
    nRadius = dis - rad
    if (nRadius < 0) {
        return nRadius * -1
    }
    return nRadius
}

function drawAll() {
    debugOutput(1, sprintf("size %s %s %s", length(BUBBLE_ARRAY), length(BIGGER_ARRAY), length(SMALLER_ARRAY)))
    biggerSize = length(BIGGER_ARRAY)
    for (i=0; i <= biggerSize; i++) {
        currentBiggestIndex = -1
        #printf "bigger term %s %s", i, length(BIGGER_ARRAY)
        for ( i2=0; i2 <= BUBBLE_SIZE; i2++) {
            #printf "iterating through index %s radius %s term %s", i2, BUBBLE_ARRAY[i2,3], BUBBLE_ARRAY[i2,4]
            # check to see if it has a text already
            if (BUBBLE_ARRAY[i2,B_INDEX_TEXT] == "") {
                if ( currentBiggestIndex == -1 ) {
                    #printf "1 changing radius %s for %s", BUBBLE_ARRAY[i2,3], BUBBLE_ARRAY[currentBiggestIndex,3]
                    currentBiggestIndex = i2
                }
                else {
                    if (BUBBLE_ARRAY[i2, B_INDEX_RADIUS] >= BUBBLE_ARRAY[currentBiggestIndex, B_INDEX_RADIUS]) {
                        #printf "2 changing radius %s for %s", BUBBLE_ARRAY[i2,3], BUBBLE_ARRAY[currentBiggestIndex,3]
                        currentBiggestIndex = i2
                    }
                }
            }
        }
        BUBBLE_ARRAY[currentBiggestIndex, B_INDEX_TEXT] = BIGGER_ARRAY[i]
    }
    smallerSize = length(SMALLER_ARRAY)
    for (i=0; i <= smallerSize; i++) {
        currentBiggestIndex = -1
        #printf "bigger term %s %s\n", i, length(BIGGER_ARRAY)
        for ( i2=0; i2 <= BUBBLE_SIZE; i2++) {
            #printf "iterating through index %s radius %s term %s\n", i2, BUBBLE_ARRAY[i2,3], BUBBLE_ARRAY[i2,4]
            # check to see if it has a text already
            if (BUBBLE_ARRAY[i2, B_INDEX_TEXT] == "") {
                if ( currentBiggestIndex == -1 ) {
                    #printf "1 changing radius %s for %s\n", BUBBLE_ARRAY[i2,3], BUBBLE_ARRAY[currentBiggestIndex,3]
                    currentBiggestIndex = i2
                }
                else {
                    if (BUBBLE_ARRAY[i2, B_INDEX_RADIUS] >= BUBBLE_ARRAY[currentBiggestIndex, B_INDEX_RADIUS]) {
                        #printf "2 changing radius %s for %s\n", BUBBLE_ARRAY[i2,3], BUBBLE_ARRAY[currentBiggestIndex,3]
                        currentBiggestIndex = i2
                    }
                }
            }
        }
        BUBBLE_ARRAY[currentBiggestIndex, B_INDEX_TEXT] = SMALLER_ARRAY[i]
    }
    for (i=0; i < BUBBLE_SIZE; i++) {
        debugOutput(1, sprintf("drawall %s %s %s %s %s", SHIFT_X + BUBBLE_ARRAY[i, B_INDEX_X], SHIFT_Y + BUBBLE_ARRAY[i, B_INDEX_Y], BUBBLE_ARRAY[i, B_INDEX_RADIUS_CENTER], BUBBLE_ARRAY[i, B_INDEX_RADIUS], BUBBLE_ARRAY[i, B_INDEX_TEXT]))
        CIRCLE_ARRAY[i] = drawCircle(SHIFT_X + BUBBLE_ARRAY[i, B_INDEX_X], SHIFT_Y + BUBBLE_ARRAY[i, B_INDEX_Y], BUBBLE_ARRAY[i, B_INDEX_RADIUS], tSide, i)
        #TEXT_ARRAY[i] = drawText(BUBBLE_ARRAY[i, B_INDEX_X], BUBBLE_ARRAY[i, B_INDEX_Y], tSide, BUBBLE_ARRAY[i, B_INDEX_TEXT]  "_"  BUBBLE_ARRAY[i, B_INDEX_RADIUS] "_" BUBBLE_ARRAY[i, B_INDEX_DEFAULT_RADIUS], "false")
        TEXT_ARRAY[i] = drawText(SHIFT_X + BUBBLE_ARRAY[i, B_INDEX_X], SHIFT_Y + BUBBLE_ARRAY[i, B_INDEX_Y], tSide, BUBBLE_ARRAY[i, B_INDEX_TEXT], "false")
        REF_ARRAY[i] = drawReference(i)
    }
}

function insertIntoList(x, y, r) {
    BUBBLE_ARRAY[BUBBLE_SIZE, B_INDEX_X] = x
    BUBBLE_ARRAY[BUBBLE_SIZE, B_INDEX_Y] = y
    TEMP_VECTOR_ARRAY[BUBBLE_SIZE, B_INDEX_X] = x
    TEMP_VECTOR_ARRAY[BUBBLE_SIZE, B_INDEX_Y] = y
    BUBBLE_ARRAY[BUBBLE_SIZE, B_INDEX_RADIUS_CENTER] = getDistance(0, 0, x, y)
    BUBBLE_ARRAY[BUBBLE_SIZE, B_INDEX_RADIUS] = -1
    BUBBLE_ARRAY[BUBBLE_SIZE, B_INDEX_DEFAULT_RADIUS] = r
    BUBBLE_ARRAY[BUBBLE_SIZE, B_INDEX_FINAL_RADIUS] = -1
    debugOutput(1, sprintf("insert %s %s %s %s", BUBBLE_ARRAY[BUBBLE_SIZE, B_INDEX_X], BUBBLE_ARRAY[BUBBLE_SIZE, B_INDEX_Y], BUBBLE_ARRAY[BUBBLE_SIZE, B_INDEX_RADIUS_CENTER], BUBBLE_ARRAY[BUBBLE_SIZE, B_INDEX_RADIUS]))
    BUBBLE_SIZE++
}

function cleanSlopeArray() {
    CONVEX_SIZE = 4
    for (currentIndex = 0; currentIndex < CONVEX_SIZE; currentIndex++) {
        TEMP_SLOPE_ARRAY[currentIndex, B_INDEX_CONVEX_X] = 999
        TEMP_SLOPE_ARRAY[currentIndex, B_INDEX_CONVEX_Y] = 999
        TEMP_SLOPE_ARRAY[currentIndex, B_INDEX_CONVEX_DISTANCE] = 999
    }
}

function cleanVectorArray() {
    for (currentIndex = 0; currentIndex < BUBBLE_SIZE; currentIndex++) {
        TEMP_VECTOR_ARRAY[currentIndex, B_INDEX_X] = -999
        TEMP_VECTOR_ARRAY[currentIndex, B_INDEX_Y] = -999
    }
}

function findConvexHull( argIndex, argX, argY, argRadius) {
    cleanConvexHull()
    tempIndex = 0
    Q_NP_X = 0
    Q_NP_Y = 0
    Q_NP_DISTANCE = 999

    Q_PP_X = 0
    Q_PP_Y = 0
    Q_PP_DISTANCE = 999

    Q_PN_X = 0
    Q_PN_Y = 0
    Q_PN_DISTANCE = 999

    Q_NN_X = 0
    Q_NN_Y = 0
    Q_NN_DISTANCE = 999

    for (currentIndex = 0; currentIndex < BUBBLE_SIZE; currentIndex++) {
        if (argIndex != currentIndex) {
            distance = getDistance(argX, argY, BUBBLE_ARRAY[currentIndex, B_INDEX_X], BUBBLE_ARRAY[currentIndex, B_INDEX_Y])

        }
    }
}

function recordDistance( argIndex) {
    cleanVectorArray()
    tempIndex = 0
    argX = BUBBLE_ARRAY[argIndex, B_INDEX_X]
    argY = BUBBLE_ARRAY[argIndex, B_INDEX_Y]
    argRadius = BUBBLE_ARRAY[argIndex, B_INDEX_RADIUS]
    for (currentIndex = 0; currentIndex < BUBBLE_SIZE; currentIndex++) {
        # skip if the same
        TEMP_VECTOR_ARRAY[tempIndex, B_INDEX_X] = BUBBLE_ARRAY[currentIndex, B_INDEX_X]
        TEMP_VECTOR_ARRAY[tempIndex, B_INDEX_Y] = BUBBLE_ARRAY[currentIndex, B_INDEX_Y]
        distanceDifference = -999
        if (argIndex != currentIndex) {
            currentRadius = BUBBLE_ARRAY[currentIndex, B_INDEX_RADIUS]
            distance = getDistance(argX, argY, BUBBLE_ARRAY[currentIndex, B_INDEX_X], BUBBLE_ARRAY[currentIndex, B_INDEX_Y])
            totalRadius = currentRadius + argRadius
            distanceDifference = totalRadius - distance
            # find absolute difference
            if (distanceDifference < 0) {
                distanceDifference = -1 * distanceDifference
            }
        }
        TEMP_VECTOR_ARRAY[tempIndex, B_INDEX_RADIUS] = distanceDifference
        tempIndex++
    }
}

function findFleeSlope() {
    cleanSlopeArray()
    for (currentIndex = 0; currentIndex < BUBBLE_SIZE; currentIndex++) {
    }
}

function findGrowthTouched( argIndex, argX, argY, argRadius) {
    cleanVectorArray()
    for (currentIndex = 0; currentIndex < BUBBLE_SIZE; currentIndex++) {
        # skip if it's similar
        if (argIndex != currentIndex) {
            currentRadius = BUBBLE_ARRAY[currentIndex, B_INDEX_RADIUS]
            # has no radius
            if (currentRadius == -1) {
                currentRadius = argRadius
            }
            distance = getDistance(argX, argY, BUBBLE_ARRAY[currentIndex, B_INDEX_X], BUBBLE_ARRAY[currentIndex, B_INDEX_Y])
            totalRadius = currentRadius + argRadius
            distanceDifference = totalRadius - distance
            if (distanceDifference < 0) {
                distanceDifference = -1 * distanceDifference
            }
            debugOutput(1, sprintf("touch currentIndex:%s distance:%s totalRadius:%s difference:%s radiusIncrement:%s", currentIndex, distance, totalRadius, distanceDifference, RADIUS_INCREMENT))
            # arguement touched someone!
            if ((distanceDifference >= 0) && (distanceDifference <= RADIUS_INCREMENT_TOLERANCE)) {
                debugOutput(1, sprintf("touch return 1"))
                return 1
            }
        }
    }
    # touched no parimeters
    debugOutput(1, sprintf("touch return 0"))
    return 0
}

# Move xy coordinates until the radius does not expand anymore
function maximizeAllRadius() {
#    return
    # have tangent of an angle
    # split by 2
    # Add it to the current angle
    # using 5 or 10 as base to the hypotnoses of the triangle
    # figure out the sin

    # iterate through all radius to find out final size
    # based on vectors and radius increase size
    for (iBubble = 0; iBubble < BUBBLE_SIZE; iBubble++) {

        # loop until you find all matches
        while (1 == 1) {
            lastRadius = BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS]

            # find slope
            recordDistance(iBubble)
            findFleeSlope()
            # loop through and dead to the edge of circle
            # record all x, y, closest distance
            # find longest distance.  That's the new coordinates
            #touchedObject = findAnyParameterTouched(iBubble, BUBBLE_ARRAY[iBubble, B_INDEX_X], BUBBLE_ARRAY[iBubble, B_INDEX_Y], lastRadius)
            #debugOutput(2, sprintf("track index:%s x:%s y:%s radius:%s", iBubble, BUBBLE_ARRAY[iBubble, B_INDEX_X], BUBBLE_ARRAY[iBubble, B_INDEX_Y], lastRadius))

#            # find all touches
#            # put them in list
#            slopeRun = BUBBLE_ARRAY[iBubble, B_INDEX_X]
#            slopeRise = BUBBLE_ARRAY[iBubble, B_INDEX_Y]
#            for (iBubble2 = 0; iBubble2 < BUBBLE_SIZE; iBubble2++) {
#
#                # ending all vector treatment
#                debugOutput(2, sprintf("iBubble2 %s %s %s", iBubble2, TEMP_VECTOR_ARRAY[iBubble2, B_INDEX_X], TEMP_VECTOR_ARRAY[iBubble2, B_INDEX_Y]))
#                if ((-999 == TEMP_VECTOR_ARRAY[iBubble2, B_INDEX_X]) && (-999 == TEMP_VECTOR_ARRAY[iBubble2, B_INDEX_Y])) {
#                    break
#                }
#                slopeRun = slopeRun - TEMP_VECTOR_ARRAY[iBubble2, B_INDEX_X]
#                slopeRise = slopeRise - TEMP_VECTOR_ARRAY[iBubble2, B_INDEX_Y]
#
#                debugOutput(2, sprintf("new slope %s %s %s %s", slopeRise, slopeRun, TEMP_VECTOR_ARRAY[iBubble2, B_INDEX_Y], TEMP_VECTOR_ARRAY[iBubble2, B_INDEX_X]))
#                debugOutput(2, sprintf("blah new slope %s %s", slopeRise, slopeRun))
#                debugOutput(2, sprintf("BubbleIndex %s", iBubble2))
#            }
#            debugOutput(2, sprintf("Touched objects %s", touchedObject))
#            # not touching anything.  Can keep growing
#            if (0 == touchedObject) {
#                if (findAnyParameterTouched(iBubble, BUBBLE_ARRAY[iBubble, B_INDEX_X], BUBBLE_ARRAY[iBubble, B_INDEX_Y], lastRadius + RADIUS_INCREMENT)) {
#                    BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS] = BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS] + RADIUS_INCREMENT
#                }
#                debugOutput(2, sprintf("keep growing %s %s %s %s", slopeRun, slopeRise, lastRadius, BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS]))
#            }
#            # You have slopes
#            else {
#                if (1 == touchedObject) {
#                    # find slope and move that way ...
#                }
#                else if (2 == touchedObject) {
#                    # find angle / divide in half and figure out new plot
#                }
#                else if (3 >= touchedObject) {
#                    # I don't know what to do lol
#                }
#                # slop intercept form y = mx + b
#                # find b
#                debugOutput(2, sprintf("blah blah %s %s", slopeRise, slopeRun))
#                slope = slopeRise / slopeRun
#                magnitude = sqrt((slopeRise * slopeRise) + (slopeRun * slopRun))
#                pointY = BUBBLE_ARRAY[iBubble, B_INDEX_Y]
#                debugOutput(2, sprintf("magnitude %s", magnitude))
##                if (magnitude > 50) {
#                    pointX = BUBBLE_ARRAY[iBubble, B_INDEX_X]
#                    pointB = BUBBLE_ARRAY[iBubble, B_INDEX_Y] - (slope * BUBBLE_ARRAY[iBubble, B_INDEX_X])
#                    debugOutput(2, sprintf("working1 %s %s", BUBBLE_ARRAY[iBubble, B_INDEX_X], BUBBLE_ARRAY[iBubble, B_INDEX_Y]))
#
#                    newX = BUBBLE_ARRAY[iBubble, B_INDEX_X] + RADIUS_INCREMENT
#                    if (slopeRun < 0) {
#                        debugOutput(2, sprintf("%s", "go left"))
#                        newX = BUBBLE_ARRAY[iBubble, B_INDEX_X] - RADIUS_INCREMENT
#                    }
#                    newY = ((slope * newX) + pointB)
#
#                    # does not hit anything
#                    outcome1 = findAnyParameterTouched(iBubble, newX, newY, BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS])
#                    debugOutput(2, sprintf("outcome1 %s %s %s %s %s", iBubble, newX, newY, BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS], outcome1))
#                    if (0 == outcome1) {
#                        # does not touch anything with new radius expoint radius with new x, y
#                        outcome2 = findAnyParameterTouched(iBubble, newX, newY, BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS] + RADIUS_INCREMENT)
#                        debugOutput(2, sprintf("outcome2 %s %s %s %s %s", iBubble, newX, newY, BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS] + RADIUS_INCREMENT_TOUCHED, outcome2))
#                        if (0 == outcome2) {
#                            BUBBLE_ARRAY[iBubble, B_INDEX_X] = newX
#                            BUBBLE_ARRAY[iBubble, B_INDEX_Y] = newY
#                            BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS] = BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS] + RADIUS_INCREMENT
#                            BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS_CENTER] = getDistance(0, 0, newX, newY)
#                        }
#                    }
#                    debugOutput(2, sprintf("working %s, %d %d, %s %s, %s, %s %s", slope, BUBBLE_ARRAY[iBubble, B_INDEX_X], BUBBLE_ARRAY[iBubble, B_INDEX_Y], slopeRun, slopeRise, iBubble, newX, newY))
#                    debugOutput(2, sprintf("working %s %s", BUBBLE_ARRAY[iBubble, B_INDEX_X], BUBBLE_ARRAY[iBubble, B_INDEX_Y]))
##                }
#            }
            # ## else keep new radius and repeat loop
            # 1. if lastRadius is less than or equal to current
            # 2. if both distance from center to point and current radius are greater than the center radius
            # 3. if current radius is greater than center radius
            if ( (lastRadius >= BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS]) ||
                 (CENTER_RADIUS < (BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS_CENTER] + BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS])) ||
                 (CENTER_RADIUS < BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS])) {
                debugOutput(2, sprintf("%s", "breaking"))
                break
            }
        }
    }
}

function findAllRadius() {

    # increase radius
    for (growRadius=0; growRadius < CENTER_RADIUS; growRadius = growRadius + RADIUS_INCREMENT) {
        debugOutput(1, sprintf("growRadius %s", growRadius))

        # each bubble use the new increased bubble
        for (iBubble = 0; iBubble < BUBBLE_SIZE; iBubble++) {
            currentRadius = BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS]
            debugOutput(1, sprintf("bIndex %s %s %s %s %s", iBubble, BUBBLE_ARRAY[iBubble, B_INDEX_X], BUBBLE_ARRAY[iBubble, B_INDEX_Y], BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS_CENTER], BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS]))

            # radius found skip
            if (currentRadius > -1) {
                debugOutput(1, sprintf("found1 %s skipping", currentRadius))
                continue
            }

            # growing beyond the assigned drow radius mark radius as found and skip
            if (growRadius > BUBBLE_ARRAY[iBubble, B_INDEX_DEFAULT_RADIUS]) {
                debugOutput(1, sprintf("found0 %s setting for default radius", currentRadius))
                BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS] = BUBBLE_ARRAY[iBubble, B_INDEX_DEFAULT_RADIUS]
                growRadius = growRadius - RADIUS_INCREMENT
                continue
            }

            # find out if the radius hits the parent radius parimeter
            currentDistance = BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS_CENTER] + growRadius
            distanceDifference = CENTER_RADIUS - currentDistance

            # if the difference is within acceptable tolerance
            if ((distanceDifference >= 0) && (distanceDifference <= RADIUS_INCREMENT_TOLERANCE)) {

                # found and recorded
                BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS] = findBoundary(0, 0, CENTER_RADIUS, BUBBLE_ARRAY[iBubble, B_INDEX_X], BUBBLE_ARRAY[iBubble, B_INDEX_Y])
                debugOutput(1, sprintf("!!!!!!!!!!!found distance %s %s %s %s", currentRadius, BUBBLE_ARRAY[iBubble, B_INDEX_X], BUBBLE_ARRAY[iBubble, B_INDEX_Y], BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS]))

                # reset the radius so it can go through the rest of the set
                growRadius = growRadius - RADIUS_INCREMENT
                break
            }
            # this means it didn't hit the parent parimeter so we have to match this with all
            # other distances to see if it will touch
            else {
                parimeterTouched = findGrowthTouched( iBubble, BUBBLE_ARRAY[iBubble, B_INDEX_X], BUBBLE_ARRAY[iBubble, B_INDEX_Y], growRadius)

                # if touched.  Radius is found, mark radius as found
                if (parimeterTouched == 1) {
                    debugOutput(1, sprintf("!!!!!parimeterTouched %s", growRadius))
                    BUBBLE_ARRAY[iBubble, B_INDEX_RADIUS] = growRadius
                    growRadius = growRadius - RADIUS_INCREMENT
                    break
                }
            }
        }
    }
}

BEGIN {
    # global variables that can be accessed when needed

	# Bang Wong's colour-safe palette, https://www.nature.com/articles/nmeth.1618
	# (using just the last five colours)
    iArray = 0

    color[iArray++] = "#0072B2"
	color[iArray++] = "#F0E442"
	color[iArray++] = "#009E73"
	color[iArray++] = "#D55E00"
	color[iArray++] = "#99CCFF"
	color[iArray++] = "#E69F00"
	color[iArray++] = "#56b4e9"
	color[iArray++] = "#FF6699"

    color[iArray++] = "#FB4934"
	color[iArray++] = "#B8BB26"
	color[iArray++] = "#FABD2F"
	color[iArray++] = "#83A598"
	color[iArray++] = "#D3869B"
	color[iArray++] = "#8EC07C"
	color[iArray++] = "#EBDBB2"
	color[iArray++] = "#FE8019"

    color[iArray++] = "#FFED00"
	color[iArray++] = "#FF8860"
	color[iArray++] = "#D6E8D9"
	color[iArray++] = "#F1C9C2"
	color[iArray++] = "#FF3747"
	color[iArray++] = "#4FCBBB"
	color[iArray++] = "#EF39A7"
	color[iArray++] = "#ECF7DD"

    color[iArray++] = "#FDF2B8"
	color[iArray++] = "#E88200"
	color[iArray++] = "#CB2800"
	color[iArray++] = "#F9BB13"
	color[iArray++] = "#7D8B11"
	color[iArray++] = "#C1D92E"
	color[iArray++] = "#F3E0C2"
	color[iArray++] = "#484E10"

    BUBBLE_SIZE = 0
    B_INDEX_CONVEX_NN = 0
    B_INDEX_CONVEX_NP = 1
    B_INDEX_CONVEX_PN = 2
    B_INDEX_CONVEX_PP = 3
    B_INDEX_CONVEX_X = 0
    B_INDEX_CONVEX_Y = 1
    B_INDEX_CONVEX_DISTANCE = 2

    B_INDEX_DEFAULT_RADIUS = 5
    B_INDEX_FINAL_RADIUS = 7
    B_INDEX_RADIUS = 3
    B_INDEX_RADIUS_CENTER = 2
    B_INDEX_TEXT = 4
    B_INDEX_X = 0
    B_INDEX_Y = 1

    CENTER_RADIUS = 2000
    RADIUS_INCREMENT = 6
    RADIUS_INCREMENT_TOLERANCE = 10
    RADIUS_INCREMENT_TOUCHED = 3
    SHIFT_X = 2000
    SHIFT_Y = 2000

    # declare an empty circle_arrayay via delete statement
    delete BIGGER_ARRAY[0]
    delete BUBBLE_ARRAY[0]
    delete CIRCLE_ARRAY[0]
    delete REF_ARRAY[0]
    delete SMALLER_ARRAY[0]
    delete TEXT_ARRAY[0]
    delete TEMP_VECTOR_ARRAY[0]
    delete TEMP_CONVEXHULL_ARRAY[0]
    delete TEMP_SLOPE_ARRAY[0]

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
    DEBUG = 0
}

NR == 1 {
    DEBUG = $1
}

# radius
NR == 2 {
    CENTER_RADIUS = sin(45) * $1
    tSide = $1 * tSideScale
}

# insert text into bubbly array
NR == 3 {
    for (i = 0; i <= NF; i++) {
        debugOutput(1, sprintf("biggertext |%s|", $(i + 1)))
        if ( $(i + 1) != "" ) {
            BIGGER_ARRAY[i] = $(i + 1)
        }
    }
}

# insert text into bubbly array
NR == 4 {
    for (i = 0; i <= NF; i++) {
        debugOutput(1, sprintf("smallertext |%s|", $(i + 1)))
        if ( $(i + 1) != "" ) {
            SMALLER_ARRAY[i] = $(i + 1)
        }
    }
}

# circle
NR > 4 {
    if (NF > 0) {
        #printf "insert into list %s", $0
        insertIntoList($1, $2, $3)
    }
}

END {
    findAllRadius()
    maximizeAllRadius()
    drawAll()
	display()
}
