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
    internal var direction: TileDirection?
    internal var action: TileAction
    internal var imagePrefix: String?
    internal var canMove: Bool?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(type: TileType, direction: TileDirection? = nil, action: TileAction = TileAction.Idle, imagePrefix: String? = nil, canMove: Bool? = false) {
        self.type = type
        self.direction = direction
        self.action = action
        self.imagePrefix = imagePrefix
        self.canMove = canMove
        super.init(texture: self.getTileTexture(), color: .clear, size: self.getTileTexture().size())
    }
    
    func changeDirection(direction: TileDirection) {
        self.direction = direction
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
        image += ".png"
        return SKTexture(imageNamed: image)
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

extension TileLocation: CustomDebugStringConvertible {
    var debugDescription: String {
        return "TileLocation(point2D: \(self.point2D), pointIso: \(self.point25D))"
    }
}
