//
//  Wall.swift
//  FireInTheWhole
//
//  Created by dikkini on 15/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//
import Foundation
import SpriteKit

class Wall: Tile {
    override init(type: TileType, action: TileAction, direction: TileDirection? = nil, imagePrefix: String? = nil, canMove: Bool? = false) {
        super.init(type: type, action: action, direction: direction, imagePrefix: imagePrefix, canMove: canMove)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
