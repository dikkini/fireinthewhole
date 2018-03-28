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

    private let moveStep: Int = 2

    func getPossibleMoveTileIndexList(tileSize: (width: Int, height: Int), mapCols: Int, mapRows: Int) -> [CGPoint] {
        var possibleMoveList: [CGPoint] = []

        let position = self.position
        let tileTI = point2DToPointTileIndex(point: position, tileSize: tileSize)

        var point: CGPoint = CGPoint(x: tileTI.x, y: tileTI.y)
        for i in -self.moveStep...self.moveStep {
            for k in -self.moveStep...self.moveStep{
                point = CGPoint(x: tileTI.x + CGFloat(i), y: tileTI.y + CGFloat(k))
                possibleMoveList.append(point)
            }
        }

        // TODO убрать мувы за пределы карты с учетом инвертированной осью Y
        for move in possibleMoveList {
            let index = possibleMoveList.index(of: move)
            if move.y > 0 {
                possibleMoveList.remove(at: index!)
            } else if Int(move.y) <= -(mapCols) {
                possibleMoveList.remove(at: index!)
            } else if (move.x < 0) {
                possibleMoveList.remove(at: index!)
            } else if (Int(move.x) >= mapRows) {
                possibleMoveList.remove(at: index!)
            }
        }

        print("Character can MOVE to: ")
        for move in possibleMoveList {
            print("2D point: " + pointTileIndexToPoint2D(point: move, tileSize: tileSize).debugDescription)
            print("25D point: " + point25DTo2D(p: pointTileIndexToPoint2D(point: move, tileSize: tileSize)).debugDescription)
            print("Tile Index: " + move.debugDescription)
            print("------------------------------------------")
        }

        return possibleMoveList
    }
}
