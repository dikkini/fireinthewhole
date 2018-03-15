//
//  Tile.swift
//  FireInTheWhole
//
//  Created by dikkini on 15/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//
import Foundation
import SpriteKit

class Tile {
    var sprite2D:SKSpriteNode!
    var spriteIso:SKSpriteNode!
    
    var properties: TileProperties
    
    init(properties: TileProperties) {
        self.properties = properties
    }
    
    func changeAction(action: TileAction) {
        self.properties.action = action
    }
    
    func changeDirection(direction: TileDirection) {
        self.properties.direction = direction
    }
    
    func turnLeft() {
        // TODO изменить направление и вместе с этим изменить изображение тайла с новым направлением
    }
    
    func turnRight() {
        // TODO изменить направление и вместе с этим изменить изображение тайла с новым направлением
    }
    
    private func turn() {
        // TODO общий метод для поворотов тайла
    }
    
    // метод обновления тайла
    func update() {
        if (self.sprite2D != nil) {
            self.sprite2D.texture =  SKTexture(imageNamed: self.properties.image())
        }
        if (self.spriteIso != nil) {
            self.spriteIso.texture = SKTexture(imageNamed: "iso_3d_" + self.properties.image())
        }
    }
}

struct TileProperties {
    internal var type: TileType
    internal var direction: TileDirection?
    internal var action: TileAction?
    
    init(type: TileType, direction: TileDirection? = nil, action: TileAction? = nil) {
        self.type = type
        self.direction = direction
        self.action = action
    }
    
    func image() -> String {
        var image = self.type.name
        if self.direction != nil {
            image += "_" + self.direction!.name
        }
        return image
    }
}
