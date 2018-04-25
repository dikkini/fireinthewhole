//
//  Tile.swift
//  FireInTheWhole
//
//  Created by dikkini on 15/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//

import Foundation
import SpriteKit

class Tile: SKSpriteNode {
    internal var type: TileType
    internal var action: TileAction
    internal var direction: TileDirection?
    internal var imagePrefix: String?
    internal var position2D: CGPoint

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(type: TileType, action: TileAction = TileAction.Idle, position2D: CGPoint, direction: TileDirection? = nil,
         imagePrefix: String? = nil) {
        self.type = type
        self.direction = direction
        self.action = action
        self.position2D = position2D
        self.imagePrefix = imagePrefix

        var image: String
        if self.imagePrefix != nil {
            image = self.imagePrefix! + self.type.name
        } else {
            image = self.type.name
        }

        if self.direction != nil {
            image += "_" + self.direction!.name
        }

        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .clear, size: texture.size())
    }

    func changeDirection(direction: TileDirection) {
        self.direction = direction
        self.update()
    }

    func changeDirection(newPoint2D: CGPoint, prevPoint2D: CGPoint) {
        self.direction = self.compassDirection(newPoint2D: newPoint2D, prevPoint2D: prevPoint2D)
        self.update()
    }

    // метод обновления тайла
    func update() {
        self.texture = self.getTileTexture()
    }

    func getTileTexture() -> SKTexture {
        var image: String
        if self.imagePrefix != nil {
            image = self.imagePrefix! + self.type.name
        } else {
            image = self.type.name
        }

        if self.direction != nil {
            image += "_" + self.direction!.name
        }

        return SKTexture(imageNamed: image)
    }

    func compassDirection(newPoint2D: CGPoint, prevPoint2D: CGPoint) -> TileDirection {
        let deltaX = newPoint2D.x - prevPoint2D.x
        let deltaY = newPoint2D.y - prevPoint2D.y
        var degrees = atan2(deltaX, deltaY) * (180.0 / CGFloat(Double.pi))

        if degrees < 0 {
            degrees += 360
        }

        let directions = [TileDirection.N, TileDirection.NE, TileDirection.E, TileDirection.SE, TileDirection.S,
                          TileDirection.SW, TileDirection.W, TileDirection.NW]
        let index = Int((degrees + 22.5) / 45.0) & 7
        let d = directions[index]
        return d
    }
}

struct TileLocation {
    var point2D: CGPoint
    var point25D: CGPoint

    init(point2D: CGPoint, pointIso: CGPoint) {
        self.point2D = point2D
        self.point25D = pointIso
    }
}

