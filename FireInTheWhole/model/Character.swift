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
    
    init(type: TileType, action: TileAction, direction: TileDirection, imagePrefix: String? = nil, canMove: Bool? = false) {
        super.init(type: type, action: action, direction: direction, imagePrefix: imagePrefix, canMove: canMove)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let moveStep: CGFloat = 1
    
    /// Move tile to location
    ///
    /// - Parameter location: 2D CGPoint of Tile
    /// - Throws: MoveTileError if tile can't move
//    func move(location: CGPoint) throws {
//        if self.canMove == false {
//            throw FIWError.MoveTileError("Tile " + self.debugDescription + " can't move")
//        }
//        // вычисляем положение тайла относительно движения (куда смотрит)
//        if self.direction != nil {
//            let deltaY = location.y - self.position2D.y
//            let deltaX = location.x - self.position2D.x
//            let degrees = atan2(deltaX, deltaY) * (180.0 / CGFloat(Double.pi))
//            self.compassDirection(degrees: degrees)
//        }
//        
//        print("Move tile " + self.debugDescription + " to " + location.debugDescription)
//        let action25D = SKAction.move(to: point2DTo25D(p: location), duration: 1)
//        self.run(action25D)
//        self.position2D = location
//    }
//    
//    func getPossibleMoveTileIndexList() -> [CGPoint] {
//        var possibleMoveList: [CGPoint] = []
//        
//        var tileTI = point2DToPointTileIndex(point: self.position2D, tileSize: GameLogic.tileSize)
//    
//        var point = CGPoint(x: tileTI.x + self.moveStep, y: tileTI.y + self.moveStep)
//        var movePoint = pointTileIndexToPoint2D(point: point, tileSize: GameLogic.tileSize)
//        possibleMoveList.append(movePoint)
//        point = CGPoint(x: tileTI.x, y: tileTI.y + self.moveStep)
//        movePoint = pointTileIndexToPoint2D(point: point, tileSize: GameLogic.tileSize)
//        //let point = CGPoint(x: ((self.position2D.x + self.moveStep) * CGFloat(GameLogic.tileSize.width)), y: -((self.position2D.x + self.moveStep) * CGFloat(GameLogic.tileSize.height)))
//        
//        possibleMoveList.append(movePoint)
//        
//        return possibleMoveList
//    }
}
