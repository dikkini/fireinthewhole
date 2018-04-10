//
//  Character.swift
//  FireInTheWhole
//
//  Created by dikkini on 15/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//
import Foundation
import SpriteKit

class Character: Tile {

    init(type: TileType, action: TileAction, position2D: CGPoint, direction: TileDirection, imagePrefix: String? = nil, canMove: Bool? = false) {
        super.init(type: type, action: action, position2D: position2D, direction: direction, imagePrefix: imagePrefix, canMove: canMove)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let moveStep: Int = 2

    func move(point25D: CGPoint) -> Bool {

        if !self.canMoveTo(point25D: point25D) {
            print("Character can't move to point")
            print("25D point: " + point25D.debugDescription)
            print("Tile Index: " + point2DToPointTileIndex(point: point25DTo2D(p: point25D), tileSize: GameLogic.tileSize).debugDescription)
            return false
        }

        let point2D = point25DTo2D(p: point25D)
        // вычисляем положение тайла относительно движения (куда смотрит)
        if self.direction != nil {
            let deltaY = point2D.y - self.position2D.y
            let deltaX = point2D.x - self.position2D.x
            let degrees = atan2(deltaX, deltaY) * (180.0 / CGFloat(Double.pi))
            self.compassDirection(degrees: degrees)
        }

        let action25D = SKAction.move(to: point25D, duration: 0.2)
        self.run(action25D) {
            self.position2D = point25DTo2D(p: self.position)
        }
        return true
    }
    
    func canMoveTo (point25D: CGPoint) -> Bool {
        var moves = self.getPossibleMoveTileIndexList(tileSize: GameLogic.tileSize, mapCols: GameLogic.mapCols, mapRows: GameLogic.mapRows)
        
        let pointTI = point2DToPointTileIndex(point: point25DTo2D(p: point25D), tileSize: GameLogic.tileSize)
        var canMove = false
        for move in moves {
            if pointTI == move {
                return true
            }
        }
        
        print("Character can't move to point")
        print("25D point: " + point25D.debugDescription)
        print("Tile Index: " + point2DToPointTileIndex(point: point25DTo2D(p: point25D), tileSize: GameLogic.tileSize).debugDescription)
        return false
        
    }

    func getPossibleMoveTileIndexList(tileSize: (width: Int, height: Int), mapCols: Int, mapRows: Int) -> [CGPoint] {
        var possibleMoveList: [CGPoint] = []

        let position2D = self.position2D
        let tileTI = point2DToPointTileIndex(point: position2D, tileSize: tileSize)

        var point: CGPoint = CGPoint(x: tileTI.x, y: tileTI.y)
        for i in -self.moveStep...self.moveStep {
            for k in -self.moveStep...self.moveStep {
                point = CGPoint(x: tileTI.x + CGFloat(i), y: tileTI.y + CGFloat(k))
                if Int(point.y) <= 0 && Int(point.y) >= -(mapCols) + 1 && Int(point.x) >= 0 && Int(point.x) <= mapRows - 1 {
                    possibleMoveList.append(point)
                }

            }
        }

        return possibleMoveList
    }
}
