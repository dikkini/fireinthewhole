//
//  PathService.swift
//  FireInTheWhole
//
//  Created by dikkini on 12/04/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//

import UIKit
import SpriteKit

class PathFinder {
    
    let moveCostHorizontalOrVertical = 10
    let moveCostDiagonal = 14
    
    var iniX: Int
    var iniY: Int
    var finX: Int
    var finY: Int
    var level: [[Int]]
    var openList: [String: PathNode]
    var closedList: [String: PathNode]
    var path = [CGPoint]()
    
    init(xIni: Int, yIni: Int, xFin: Int, yFin: Int, lvlData: [[Int]]) {
        
        iniX = xIni
        iniY = yIni
        finX = xFin
        finY = yFin
        level = lvlData
        openList = [String: PathNode]()
        closedList = [String: PathNode]()
        path = [CGPoint]()
        
        // invert y coordinates - pre conversion (spriteKit inverted coordinate system).
        // This PathFnding code ONLY works with positive (absolute) values
        
        iniY = -iniY
        finY = -finY
        
        //first node is the starting point
        
        let node: PathNode = PathNode(xPos: iniX, yPos: iniY, gVal: 0, hVal: 0, link: nil)
        
        //use the x and y values as a string for the dictionary key
        
        openList[String(iniX) + " " + String(iniY)] = node
        
    }
    
    func findPath() -> [CGPoint] {
        
        searchLevel()
        
        //invert y cordinates - post conversion
        
        var pathWithYInversionRestored = path.map({ i in i * CGPoint(x: 1, y: -1) })
        pathWithYInversionRestored.reverse()
        return pathWithYInversionRestored
    }
    
    func searchLevel() {
        
        var curNode: PathNode?
        var endNode: PathNode?
        var lowF = 100000
        var finished: Bool = false
        
        for obj in openList {
            
            let curF = obj.1.g + obj.1.h
            
            //currently this is just a brute force loop through every item in the list
            //can be sped up using a sorted list or binary heap,
            //described http://www.policyalmanac.org/games/binaryHeaps.htm
            //example http://www.gotoandplay.it/_articles/2005/04/mazeChaser.php
            
            if (lowF > curF) {
                lowF = curF
                curNode = obj.1
            }
            
        }
        
        
        if (curNode == nil) {
            
            //no path exists!
            return
            
        } else {
            
            //move selected node from open to closed list
            
            let listKey = String(curNode!.x) + " " + String(curNode!.y)
            
            openList[listKey] = nil
            closedList[listKey] = curNode
            
            //check target
            
            if ((curNode!.x == finX) && (curNode!.y == finY)) {
                endNode = curNode!
                finished = true
            }
            
            //check each of the 8 adjacent squares
            
            for i in -1..<2 {
                for j in -1..<2 {
                    
                    let col = curNode!.x + i
                    let row = curNode!.y + j
                    
                    //make sure on the grid and not current node
                    
                    if ((col >= 0 && col < level[0].count)
                        && (row >= 0 && row < level.count)
                        && (i != 0 || j != 0)) {
                        
                        //if traversable, not on closed list, and not already on open list - add to open list
                        
                        let listKey = String(col) + " " + String(row)
                        
                        if ((level[row][col] == Global.tilePath.traversable)
                            && (closedList[listKey] == nil)
                            && (openList[listKey] == nil)) {
                            
                            //prevent cutting corners on diagonal movement
                            
                            var moveIsAllowed = true
                            
                            if ((i != 0) && (j != 0)) {
                                //is diagonal move
                                
                                if ((i == -1) && (j == -1)) {
                                    //is top-left, check left and top nodes
                                    if (level[row][col + 1] != Global.tilePath.traversable //top
                                        || level[row + 1][col] != Global.tilePath.traversable //left
                                        ) {
                                        moveIsAllowed = false
                                    }
                                    
                                } else if ((i == 1) && (j == -1)) {
                                    //is top-right, check top and right nodes
                                    if (level[row][col - 1] != Global.tilePath.traversable //top
                                        || level[row + 1][col] != Global.tilePath.traversable //right
                                        ) {
                                        moveIsAllowed = false
                                    }
                                } else if ((i == -1) && (j == 1)) {
                                    //is bottom-left,check bottom and left nodes
                                    if (level[row][col + 1] != Global.tilePath.traversable //bottom
                                        || level[row - 1][col] != Global.tilePath.traversable //left
                                        ) {
                                        moveIsAllowed = false
                                    }
                                } else if ((i == 1) && (j == 1)) {
                                    //is bottom-right, check bottom and right nodes
                                    if (level[row][col - 1] != Global.tilePath.traversable //bottom
                                        || level[row - 1][col] != Global.tilePath.traversable //right
                                        ) {
                                        moveIsAllowed = false
                                    }
                                }
                                
                            }
                            
                            if (moveIsAllowed) {
                                
                                //determine g
                                var g: Int
                                if ((i != 0) && (j != 0)) {
                                    //is diagonal move
                                    g = moveCostDiagonal
                                    
                                } else {
                                    //is horizontal or vertical move
                                    g = moveCostHorizontalOrVertical
                                }
                                
                                //calculate h (heuristic)
                                let h = heuristic(row: row, col: col)
                                
                                //create node and add to openList
                                openList[listKey] = PathNode(xPos: col, yPos: row, gVal: g, hVal: h, link: curNode)
                                
                            }
                        }
                        
                    }
                }
            }
            
            if (finished == false) {
                searchLevel()
            } else {
                retracePath(node: endNode!)
            }
            
        }
    }
    
    // Calculate heuristic
    
    //Diagonal Shortcut method (slightly more expensive but more accurate than Manhattan method)
    //Read more on heuristics here: http://www.policyalmanac.org/games/heuristics.htm
    
    func heuristic(row: Int, col: Int) -> Int {
        let xDistance = abs(col - finX)
        let yDistance = abs(row - finY)
        if (xDistance > yDistance) {
            return moveCostDiagonal * yDistance + moveCostHorizontalOrVertical * (xDistance - yDistance)
        } else {
            return moveCostDiagonal * xDistance + moveCostHorizontalOrVertical * (yDistance - xDistance)
        }
    }
    
    func retracePath(node: PathNode) {
        
        let step = CGPoint(x: node.x, y: node.y)
        path.append(step)
        
        if (node.g > 0) {
            retracePath(node: node.parentNode!)
        }
    }
    
}

class PathNode {
    
    let x: Int
    let y: Int
    let g: Int
    let h: Int
    let parentNode: PathNode?
    
    init(xPos: Int, yPos: Int, gVal: Int, hVal: Int, link: PathNode?) {
        
        self.x = xPos
        self.y = yPos
        self.g = gVal
        self.h = hVal
        
        if (link != nil) {
            self.parentNode = link!
        } else {
            self.parentNode = nil
        }
    }
}
