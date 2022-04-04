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
    printf " <circle cx='0' cy='0' r='%s' fill='#ffffff'/>\n", center_radius
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
    return sprintf(" <circle id='set%s' cx='%s' cy='%s' r='%f' />", argReference, argXCordinates, argYCordinates, argRadius)
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
        printf "size %s", length(bubble_array)
    }
    #for (i=0; i < countIndex; i++) {
    #    circle_array[i] = drawCircle(bubble_array[i,0], bubble_array[i,1], bubble_array[i,2], tSide, i)
    #    ref_array[i] = drawReference(i)
    #}
    for (i=0; i < holdIndex; i++) {
        if ( debug == 1) {
            printf "%s %s %s %s\n", bubble_array[i,0], bubble_array[i,1], bubble_array[i,2], bubble_array[i,3]
        }
        circle_array[i] = drawCircle(bubble_array[i,0], bubble_array[i,1], bubble_array[i,3], tSide, i)
        ref_array[i] = drawReference(i)
    }
}

function insertIntoList(x, y) {
    bubble_array[holdIndex,0] = x
    bubble_array[holdIndex,1] = y
    bubble_array[holdIndex,2] = getDistance(0, 0, x, y)
    bubble_array[holdIndex,3] = -1
    if ( debug == 1) {
        printf "insert %s %s %s %s\n", bubble_array[holdIndex,0], bubble_array[holdIndex,1], bubble_array[holdIndex,2], bubble_array[holdIndex, 3]
    }
    holdIndex++
}

function findParimeterTouched( argIndex, argX, argY, argRadius) {
    for (currentIndex = 0; currentIndex < holdIndex; currentIndex++) {
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
        printf "touch return 0\n"
    }
    return 0
}

function findAllRadius() {
    foundIndex = 0
    newIndex = 0
    dis = 0
   
    for (growRadius=0; growRadius < center_radius; growRadius = growRadius + radius_increment) {
        if ( debug == 1) {
            printf "growRadius %s \n", growRadius
        }
        for (currentH = 0; currentH < holdIndex; currentH++) {
            currentRadius = bubble_array[currentH,3]
            if ( debug == 1) {
                printf "bIndex %s %s %s %s %s\n", currentH, bubble_array[currentH,0], bubble_array[currentH,1], bubble_array[currentH,2], bubble_array[currentH,3]
            }
            # that means it's been found out.  Move on
            if (currentRadius > -1) {
                if ( debug == 1) {
                    printf "found1 %s skipping\n", currentRadius
                }
                continue
            }

            # else you have an empty radius so use that to figure out your radius
            
            # find out if the radius hits the parent radius parimeter
            currentDistance = bubble_array[currentH, 2] + growRadius
            differenceDistance = center_radius - currentDistance
            # if the total difference is less than the amount incrementsed that means it's touched 
            # the paremeter
            if ((differenceDistance >= 0) && (differenceDistance <= radius_increment)) {
                bubble_array[currentH, 3] = findBoundary(0, 0, center_radius, bubble_array[currentH, 0], bubble_array[currentH, 1])
                if ( debug == 1) {
                    printf "!!!!!!!!!!!found distance %s %s %s %s\n", currentRadius, bubble_array[currentH,0], bubble_array[currentH, 1], bubble_array[currentH, 3]
                }
                # reset the radius so it can go through other values
                growRadius = growRadius - radius_increment
                break
            }
            # this means it didn't hit the parent parimeter so we have to match this with all 
            # other distances to see if it will match up properly
            else {
                parimeterTouched = findParimeterTouched( currentH, bubble_array[currentH, 0], bubble_array[currentH, 1], growRadius)
                if (parimeterTouched == 1) {
                    if ( debug == 1) {
                        printf "!!!!!parimeterTouched %s\n", growRadius
                    }
                    bubble_array[currentH, 3] = growRadius
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
	color[arrayIndex++] = "#99ccff"
	color[arrayIndex++] = "#e69f00"
	color[arrayIndex++] = "#56b4e9"
	color[arrayIndex++] = "#ff6699"

    holdIndex = 0
    sortIndex = 0
    center_radius = 2000
    radius_increment = 10

    # declare an empty circle_arrayay via delete statement 
    delete new_array[0]
    delete circle_array[0]
    delete bubble_array[0]
    delete sort_array[0]
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
# circle 
NR > 4 {
    #newBubble($1, $2)
    if (NF > 0) {
        insertIntoList($1, $2)
    }
}

END {
    findAllRadius()
    drawAll()
	display()
}
