#!/opt/homebrew/opt/python@3.11/libexec/bin/python

import os, sys, getopt, math, pprint, cv2
import numpy as np
import matplotlib.pyplot as plt
from scipy.spatial import Voronoi, voronoi_plot_2d
from types import NoneType


class vBubble:
    # global variables that can be accessed when needed

    # Bang Wong's colour-safe palette, https://www.nature.com/articles/nmeth.1618
    # (using just the last five colours)
    COLOR = []

    BUBBLE_SIZE                = 0
    INDEX_X                    = 0
    INDEX_Y                    = 1
    INDEX_RADIUS_CENTER        = 2
    INDEX_RADIUS               = 3
    INDEX_DEFAULT_RADIUS       = 4
    INDEX_TEXT                 = 5
    INDEX_POINTS_ARRAY         = 6
#    CENTER_RADIUS              = 2000
    CENTER_RADIUS              = 500
#    RADIUS_INCREMENT_TOLERANCE = 10
    RADIUS_INCREMENT_TOLERANCE = 2
    OVERLAP_TOLERANCE          = 7
#    RADIUS_INCREMENT           = 6
    RADIUS_INCREMENT           = 3
#    SHIFT_X                    = 2000
#    SHIFT_Y                    = 2000
    SHIFT_X                    = 1000
    SHIFT_Y                    = 1000

    # declare an empty circle_arrayay via delete statement
    BIGGER_ARRAY          = []
    BUBBLE_ARRAY          = []
    CIRCLE_ARRAY          = []
    REF_ARRAY             = []
    SMALLER_ARRAY         = []
    TEXT_ARRAY            = []
    PARENT_POINTS_ARRAY   = []

    # venn diagram position depending on number of text
    # top left
#    FONT_SIZE = 125
    FONT_SIZE = 62

    #print "num of fields %s | %s", NF, $0
#    G_RADIUS = 1500
    G_RADIUS = 750
#    G_TSIDESCALE = .62
    G_TSIDESCALE = .31
    G_TSIDE = G_RADIUS * G_TSIDESCALE
    DEBUG = 0
    pp = pprint.PrettyPrinter(indent=4)

    def __init__(self, arg_name = 'marker'):
        self.COLOR.append("#0072B2")
        self.COLOR.append("#F0E442")
        self.COLOR.append("#009E73")
        self.COLOR.append("#D55E00")
        self.COLOR.append("#99CCFF")
        self.COLOR.append("#E69F00")
        self.COLOR.append("#56b4e9")
        self.COLOR.append("#FF6699")

        self.COLOR.append("#FB4934")
        self.COLOR.append("#B8BB26")
        self.COLOR.append("#FABD2F")
        self.COLOR.append("#83A598")
        self.COLOR.append("#D3869B")
        self.COLOR.append("#8EC07C")
        self.COLOR.append("#EBDBB2")
        self.COLOR.append("#FE8019")

        self.COLOR.append("#FFED00")
        self.COLOR.append("#FF8860")
        self.COLOR.append("#D6E8D9")
        self.COLOR.append("#F1C9C2")
        self.COLOR.append("#FF3747")
        self.COLOR.append("#4FCBBB")
        self.COLOR.append("#EF39A7")
        self.COLOR.append("#ECF7DD")

        self.COLOR.append("#FDF2B8")
        self.COLOR.append("#E88200")
        self.COLOR.append("#CB2800")
        self.COLOR.append("#F9BB13")
        self.COLOR.append("#7D8B11")
        self.COLOR.append("#C1D92E")
        self.COLOR.append("#F3E0C2")
        self.COLOR.append("#484E10")

    def getColor(self, argIndex):
        return self.COLOR[argIndex % len(self.COLOR)]

    def writeTo(self, argPath, argOutput):
        fwrite = open(argPath, "w")
        fwrite.write(argOutput)
        fwrite.close()

    def readAndLoad(self):
        fhand = open("/tmp/bub.txt")
        index = 0
        for line in fhand:
            line = line.strip()
            #self.debugOutput(3, "|%s|" % (line))
            results = line.split()
            index += 1
            if index == 1:
                line = line.strip()
                self.DEBUG = int(line)
            elif index == 2:
                self.CENTER_RADIUS = math.sin(45) * int(results[0])
                self.G_TSIDE = int(results[0]) * self.G_TSIDESCALE
            elif index == 3:
                for i in results:
                    self.BIGGER_ARRAY.append(i)
            elif index == 4:
                for i in results:
                    self.SMALLER_ARRAY.append(i)
            elif index > 4:
                if len(results) > 1:
                    self.insertIntoList(int(results[0]), int(results[1]), int(results[2]))

    def debugOutput(self, debugType, printOutput):
        #print("debug type |%s| %s", self.DEBUG, type(self.DEBUG))
        if (debugType == self.DEBUG) or (-1 == debugType):
            print("> %s", printOutput)

    def getDistance(self, argX, argY, argX2, argY2):
        xCombine = argX - argX2
        xCombine = xCombine ** 2
        yCombine = argY - argY2
        yCombine = yCombine ** 2
        return math.sqrt(xCombine + yCombine)

    def insertIntoList(self, argX, argY, argR):

        #INDEX_X                  = 0
        #INDEX_Y                  = 1
        #INDEX_RADIUS_CENTER      = 2
        #INDEX_RADIUS             = 3
        #INDEX_DEFAULT_RADIUS     = 4
        #INDEX_TEXT               = 5
        #INDEX_POINTS_ARRAY       = 6

        distanceToCenter = self.getDistance(0, 0, argX, argY)
        self.BUBBLE_ARRAY.append([argX, argY, distanceToCenter, -1, argR, "", []])
        self.BUBBLE_SIZE = len(self.BUBBLE_ARRAY)
        self.CIRCLE_ARRAY.append("")
        self.TEXT_ARRAY.append("")
        self.REF_ARRAY.append("")
        #print(self.INDEX_X, self.INDEX_Y, self.INDEX_RADIUS_CENTER, self.INDEX_RADIUS, self.INDEX_DEFAULT_RADIUS, self.INDEX_FINAL_RADIUS)
        self.debugOutput(1, "insert %s %s %s" % (argX, argY, distanceToCenter))

    def findGrowthTouched(self, argBubble, argX, argY, argRadius):
        self.debugOutput(2, "findGrowthTouched")
        iBubbleIndex = 0
        for iBubble in self.BUBBLE_ARRAY:
            if argBubble != iBubble:
                currentRadius = iBubble[self.INDEX_RADIUS]
                if currentRadius == -1:
                    currentRadius = argRadius
                distance = self.getDistance(argX, argY, iBubble[self.INDEX_X], iBubble[self.INDEX_Y])
                totalRadius = currentRadius + argRadius
                distanceDifference = distance - totalRadius
                #if distanceDifference < 0:
                #    distanceDifference = -1 * distanceDifference

                self.debugOutput(2, "in loop findGrowthTouched index %s distance %s difference %s totalRadius %s argRadius %s currentRadius %s increment tolerance %s" % (iBubbleIndex, distance, distanceDifference, totalRadius, argRadius, currentRadius, self.RADIUS_INCREMENT_TOLERANCE))
                if (distanceDifference < 0) or ((distanceDifference >= 0) and (distanceDifference <= self.RADIUS_INCREMENT_TOLERANCE)):
                    self.debugOutput(2, "in loop FOUND BREAKING")
                    return 1
            iBubbleIndex += 1
        self.debugOutput(2, "NOT FOUND")
        return 0


    def findBoundary(self, x, y, rad, x2, y2):
        # find distance between 2 centers
        dis = self.getDistance(x, y, x2, y2)
        # first stab at radius
        nRadius = dis - rad
        if nRadius < 0:
            return nRadius * -1
        return nRadius


    def increaseAllRadius(self):
        #print(self.BUBBLE_ARRAY)
        #print("working")

        growRadius = 0
        while growRadius < self.CENTER_RADIUS:
            growRadius = growRadius + self.RADIUS_INCREMENT
            #print("growRadius", growRadius)
            for iBubble in self.BUBBLE_ARRAY:
                currentRadius = iBubble[self.INDEX_RADIUS]
                if currentRadius > -1:
                    #print("continue 1", growRadius)
                    continue

                #print("growRadius", growRadius, iBubble[self.INDEX_DEFAULT_RADIUS])
                if growRadius > iBubble[self.INDEX_DEFAULT_RADIUS]:
                    iBubble[self.INDEX_RADIUS] = iBubble[self.INDEX_DEFAULT_RADIUS]
                    growRadius -= self.RADIUS_INCREMENT
                    #print("continue 2", growRadius)
                    continue

                currentDistance = iBubble[self.INDEX_RADIUS_CENTER] + growRadius
                distanceDifference = self.CENTER_RADIUS - currentDistance

                if (distanceDifference >= 0) and (distanceDifference <= self.RADIUS_INCREMENT_TOLERANCE):
                    iBubble[self.INDEX_RADIUS] = self.findBoundary(0, 0, self.CENTER_RADIUS, iBubble[self.INDEX_X], iBubble[self.INDEX_Y])
                    growRadius -= self.RADIUS_INCREMENT
                    break
                else:
                    parimeterTouched = self.findGrowthTouched(iBubble, iBubble[self.INDEX_X], iBubble[self.INDEX_Y], growRadius)
                    # if touched.  Radius is found, mark radius as found
                    if parimeterTouched == 1:
                        iBubble[self.INDEX_RADIUS] = growRadius
                        growRadius -= self.RADIUS_INCREMENT
                        break

    # generate all points
    def generatePoints(self):
        # generate Parent Points
        self.PARENT_POINTS_ARRAY = self.pointsInCircle(0, 0, self.CENTER_RADIUS)
        # generate all points
        for iBubble in self.BUBBLE_ARRAY:
            iBubble[self.INDEX_POINTS_ARRAY] = self.pointsInCircle(iBubble[self.INDEX_X], iBubble[self.INDEX_Y], iBubble[self.INDEX_RADIUS])
           #iBubble[self.INDEX_POINTS_ARRAY].append([iBubble[self.INDEX_X], iBubble[self.INDEX_Y]])

    def drawCircle(self, argXCordinates, argYCordinates, argRadius, argSide, argReference):
        #printf "radius %f", argRadius
        return " <circle id='set%s' cx='%s' cy='%s' r='%f' stroke='orange' stroke-width='5' />" % (argReference, argXCordinates, argYCordinates, argRadius)


    def drawText(self, argXCordinates, argYCordinates, argSide, argText, center):
        if (center == "true"):
            return "   <text transform='translate(  %f, %f) scale(1,1)' x='0' y='0' dominant-baseline='middle' text-anchor='middle'>%s</text>" % (argXCordinates, argYCordinates, argText)
        else:
            return "   <text transform='translate(  %f, %f) scale(1,1)' x='0' y='0'>%s</text>" % ((argXCordinates - (len(argText) / 2 ) * (self.FONT_SIZE / 2)), argYCordinates, argText)

    def drawReference(self, argReference):
        return " <g font-family='Helvetica,Arial,sans-serif' text-anchor='middle' stroke='none'>\n  <use xlink:href='#sets%s' fill-opacity='0.3'/>\n  <use xlink:href='#sets%s' fill-opacity='0' opacity='0.5' stroke='#000000' stroke-width='6'/>\n </g>" % (argReference, argReference)

    def drawAll(self):

        #        # reset text
        #        for iBubble in self.BUBBLE_ARRAY:
        #            iBubble[self.INDEX_TEXT] = ""

        # get bigger
        for iBig in self.BIGGER_ARRAY:
            buggestIndex = -1
            isEmpty = False
            for iBubble in range(len(self.BUBBLE_ARRAY)):
                currentBubble = self.BUBBLE_ARRAY[iBubble]
                if currentBubble[self.INDEX_TEXT] == "":
                    isEmpty = True
                    if buggestIndex == -1:
                        buggestIndex = iBubble
                    elif currentBubble[self.INDEX_RADIUS] >= self.BUBBLE_ARRAY[buggestIndex][self.INDEX_RADIUS]:
                        buggestIndex = iBubble
            if isEmpty:
                self.BUBBLE_ARRAY[buggestIndex][self.INDEX_TEXT] = iBig

        # get smaller
        for iSmall in self.SMALLER_ARRAY:
            smallestIndex = -1
            isEmpty = False
            for iBubble in range(len(self.BUBBLE_ARRAY)):
                currentBubble = self.BUBBLE_ARRAY[iBubble]
                if currentBubble[self.INDEX_TEXT] == "":
                    isEmpty = True
                    if smallestIndex == -1:
                        smallestIndex = iBubble
                    elif currentBubble[self.INDEX_RADIUS] >= self.BUBBLE_ARRAY[smallestIndex][self.INDEX_RADIUS]:
                        smallestIndex = iBubble
            if isEmpty:
                self.BUBBLE_ARRAY[smallestIndex][self.INDEX_TEXT] = iSmall

        iBubbleIndex = 0
        for iBubble in self.BUBBLE_ARRAY:
            self.CIRCLE_ARRAY[iBubbleIndex] = self.drawCircle(self.SHIFT_X + iBubble[self.INDEX_X], self.SHIFT_Y + iBubble[self.INDEX_Y], iBubble[self.INDEX_RADIUS], self.G_TSIDE, iBubbleIndex)
            self.TEXT_ARRAY[iBubbleIndex] = self.drawText(self.SHIFT_X + iBubble[self.INDEX_X], self.SHIFT_Y + iBubble[self.INDEX_Y], self.G_TSIDE, iBubble[self.INDEX_TEXT], "false")
            self.REF_ARRAY[iBubbleIndex] = self.drawReference(iBubbleIndex)
            iBubbleIndex += 1

    def display(self):
        output = ""
        output += "<?xml version='1.0'?>"
        output += "<svg version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='650' height='650' viewBox='0 0 2000 2000'>"
        output += " <title>Venn diagram</title>"
#        print " <defs>"
        for iCircle in range(len(self.CIRCLE_ARRAY)):
            output += " <g id='sets%s'><use xlink:href='#set%d' fill='%s'/></g>\n" % (iCircle, iCircle, self.getColor(iCircle))

        for iCircle in self.CIRCLE_ARRAY:
            output += iCircle

#        output += " <circle cx='2000' cy='2000' r='%s' fill='#ffffff'/>\n" % (self.CENTER_RADIUS)
        output += " <circle cx='1000' cy='1000' r='%s' fill='#ffffff'/>\n" % (self.CENTER_RADIUS)

        for iRef in self.REF_ARRAY:
            output += iRef
        output += " <g font-size='%s' font-weight='bold'>\n" % (self.FONT_SIZE)

        for iText in self.TEXT_ARRAY:
            output += iText
        output += " </g>"
        output += "</svg>"
        #print(output)
        return output

    #def pointsInCircle(self, argRadius, argX, argY, draw = False):
    def pointsInCircle(self, argX, argY, argRadius, draw = False):
        xc = argX #x-co of circle (center)
        yc = argY #y-co of circle (center)
        r = argRadius #radius of circle
        arr=[]
        xArr = []
        yArr = []
        for i in range(0, 360, 10):
            y = yc + r*math.sin(i)
            x = xc + r*math.cos(i)
            x=int(x)
            y=int(y)
            #Create array with all the x-co and y-co of the circle
            arr.append([x,y])
            xArr.append(x)
            yArr.append(y)
        if draw:
            return xArr, yArr
        return arr

    def displayCircle(self, radius, x0=0, y0=0):
        #xArray, yArray = self.get_x_y_co([0, 0, 2000])
        xArray, yArray = self.pointsInCircle(x0, y0, radius, True)
        plt.scatter(xArray, yArray)
        plt.show()

    def closestNode(self, node, nodes):
        nodes = np.asarray(nodes)
        deltas = nodes - node
        dist = np.linalg.norm(deltas, axis=1)
        min_idx = np.argmin(dist)
        return dist[min_idx]
    #return nodes[min_idx], dist[min_idx], deltas[min_idx][1]/deltas[min_idx][0]  # point, distance, slope

    def findNewCircle(self, argBubble, argX, argY, argPoints):
        max_d = 0
        max_v = None
        if len(argPoints) >= 4:
            vor = Voronoi(argPoints)
            for v in vor.vertices:
                d = self.closestNode(v, argPoints)
                #if (d > max_d) and (self.getDistance(argX, argY, v[0], v[1]) <= d):
                # if the distance is greater than currently
                # and to outside the bounds of the parent circle size cause there are points outside
                if (d > max_d) and (v[0] <= 1000) and (v[0] >= -1000) and (v[1] <= 1000) and (v[1] >= -1000) and (self.CENTER_RADIUS >= (d + self.getDistance(0, 0, v[0], v[1]))):
                    outside = True
                    passThrough = False
                    overLap = False
                    # iterate through all bubbles and make sure it's not within any current circles
                    for iBubble in self.BUBBLE_ARRAY:
                        if iBubble != argBubble:
                            # if within a circle we can flag as false and call it quits
                            passThrough = True
                            pointDistance = self.getDistance(iBubble[self.INDEX_X], iBubble[self.INDEX_Y], v[0], v[1])
                            # does not exists in the circle
                            if pointDistance <= iBubble[self.INDEX_RADIUS]:
                                outside = False
                            # does not overlap
                            if pointDistance < (d + iBubble[self.INDEX_RADIUS] - self.OVERLAP_TOLERANCE):
                                overLap = True

                    if outside and passThrough and not overLap:
                        #if outside and passThrough:
                        max_d = d
                        max_v = v

        return max_d, max_v

    def fleeToMaximize(self):
        for iBubble in self.BUBBLE_ARRAY:
            allPoints = self.PARENT_POINTS_ARRAY
            #print("parentOnly", allPoints)

            # find all points
            for iBubble2 in self.BUBBLE_ARRAY:
                if iBubble != iBubble2:
                    allPoints += iBubble2[self.INDEX_POINTS_ARRAY]
                    #print("bubble", allPoints)
            #        print(iBubble[self.INDEX_POINTS_ARRAY])

            # find new circle
            d, v = self.findNewCircle(iBubble, iBubble[self.INDEX_X], iBubble[self.INDEX_Y], allPoints)
            #print(allPoints)
            #print("x %s y %s r %s" % (iBubble[self.INDEX_X], iBubble[self.INDEX_Y], iBubble[self.INDEX_RADIUS]))
            #print(v, d)
            #self.displayCircle(iBubble[self.INDEX_RADIUS], iBubble[self.INDEX_X], iBubble[self.INDEX_Y])
            if type(v) != NoneType:
                iBubble[self.INDEX_X] = v[0]
                iBubble[self.INDEX_Y] = v[1]
                iBubble[self.INDEX_RADIUS] = d
                iBubble[self.INDEX_POINTS_ARRAY] = self.pointsInCircle(v[0], v[1], d)
            #iBubble[self.INDEX_POINTS_ARRAY].append([iBubble[self.INDEX_X], iBubble[self.INDEX_Y]])

            #self.displayCircle(iBubble[self.INDEX_RADIUS], iBubble[self.INDEX_X], iBubble[self.INDEX_Y])
            #print("x %s y%s r%s" % (iBubble[self.INDEX_X], iBubble[self.INDEX_Y], iBubble[self.INDEX_RADIUS]))
            #print(d, v)
            #break

    def test(self):
        argPoints = [[0,10], [10,0], [-10, 0], [0, -10], [0, 5]]
        vor = Voronoi(argPoints)
        max_d = 0
        max_v = None
        for v in vor.vertices:
            print(v)
        return 0

        allPoints = self.PARENT_POINTS_ARRAY
        allPoints.append([-1000, -1000])
        allPoints.append([0, 0])
        allPoints.append([-1000, 1000])
        print(allPoints)

        oldCenterX = 161
        oldCenterY = 763
        d, v = self.findNewCircle(oldCenterX, oldCenterY, allPoints)
        print(d, v)

        plt.axis([-2000, 2000, -2000, 2000])
        c1 = plt.Circle((0,0), radius=2000)
        c2 = plt.Circle(( v[0], v[1]), radius=d, color='red')
        c6 = plt.Circle((oldCenterX, oldCenterY), radius=100, color='green')

        c3 = plt.Circle((0,0), radius=100, color='orange')
        c4 = plt.Circle((-1000, -1000), radius=100, color='orange')
        c5 = plt.Circle((-1000, 1000), radius=100, color='orange')
        plt.gca().add_artist(c1)
        plt.gca().add_artist(c2)
        plt.gca().add_artist(c3)
        plt.gca().add_artist(c4)
        plt.gca().add_artist(c5)
        plt.gca().add_artist(c6)
        plt.show()

vbub = vBubble()
vbub.readAndLoad()
vbub.increaseAllRadius()
vbub.generatePoints()
vbub.drawAll()
output = vbub.display()
vbub.writeTo("/tmp/bubble1.svg", output)
#vbub.test()
vbub.fleeToMaximize()
vbub.drawAll()
output = vbub.display()
vbub.writeTo("/tmp/bubble2.svg", output)
